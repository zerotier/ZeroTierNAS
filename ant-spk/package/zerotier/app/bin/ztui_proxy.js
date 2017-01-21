/*
 * ZeroTier One - Network Virtualization Everywhere
 * Copyright (C) 2011-2015  ZeroTier, Inc.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * --
 *
 * ZeroTier may be used and distributed under the terms of the GPLv3, which
 * are available at: http://www.gnu.org/licenses/gpl-3.0.html
 *
 * If you would like to embed ZeroTier into a commercial application or
 * redistribute it in a modified binary form, please contact ZeroTier Networks
 * LLC. Start here: http://www.zerotier.com/
 */

// Node.js Proxy for ZeroTier UI requests
// This is designed to run locally in the ZeroTier home directory alongside the authtoken.secret file. It
// will listen on port 3090 for /peer /status /network HTTP requests and rebuild a new HTTP request url
// which includes the authtoken and then forward the result back to the external client

var async = require('async');
var XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;

// get authtoken locally
var fs = require('fs')
var authtoken
fs.readFile('authtoken.secret', 'utf8', function(err, data) {
 if (err) {
  return console.log(err);
 }
 // console.log(data);
 authtoken = data
});

var proxy_service_port = 3090
// ZeroTier service address
var addr = 'http://0.0.0.0'
var zt_service_port = 9993

// start proxy routing server
var express = require('express')
var app = express()

// enable CORS
app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

// handle requests from UI
app.get('/peer', function (req, res) {
  httpReqAsync(relay, res, "GET", addr+":"+zt_service_port+"/peer?auth="+authtoken, null);
})

app.get('/network', function (req, res) {
  httpReqAsync(relay, res, "GET", addr+":"+zt_service_port+"/network?auth="+authtoken, null);
})
app.get('/status', function (req, res) {
 httpReqAsync(relay, res, "GET", addr+":"+zt_service_port+"/status?auth="+authtoken, null);
})

app.listen(proxy_service_port, function () {
  console.log('ZeroTier UI proxy router listening on port 3090')
})

function relay(res, msg) {
  console.log(msg)
  res.send(msg)
}

function httpReqAsync(relay, res, method, theUrl, req_msg) {
   console.log(theUrl)
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = (data) => {
       	if(xmlHttp.readyState == 4) { // Only bind on 'DONE' state
       	  relay(res, xmlHttp.responseText)
       	}
    };
    xmlHttp.open(method, theUrl, true);
    xmlHttp.setRequestHeader("Accept", "application/json");
    xmlHttp.setRequestHeader("Content-Type", "application/json");
    xmlHttp.setRequestHeader("X-ZT1-Auth", authtoken);
    if(method == "GET") { xmlHttp.send(); }
    else if (method == "POST") { xmlHttp.send(req_msg); }
    else if (method == "DELETE") { xmlHttp.send(req_msg); }
}