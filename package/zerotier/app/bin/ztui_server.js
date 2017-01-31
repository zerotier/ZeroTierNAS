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

//var http = require('http')
var http = require('http')
var https = require('https')
var url = require('url')
var querystring = require('querystring')
var child_process = require('child_process')
var fs = require('fs')
var path = require('path')
var async = require('async');
var XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;

// --- VARS

var ui_proxy_service_port = 3090
var ui_proxy_addr = 'http://0.0.0.0'
var zt_service_port = 9993
var AUTH_CACHE = {} // cache authorized user ids

// --- Get local zt authtoken

var fs = require('fs')
var authtoken
fs.readFile('authtoken.secret', 'utf8', function(err, data) {
 if (err) {
  return console.log(err);
 }
 authtoken = data
});


// --- HTTP


function handleRequest(request, response) {
    console.log(request.url)
    console.log(request.method)

    var requestParameters = url.parse(request.url)
    var requestPath = requestParameters.pathname
    var options = querystring.parse(requestParameters.query)

    // require user authentication for all handlers below
    var user = auth(request, response, options)

    if(request.method == 'OPTIONS') {
        ok(response, {})
        return null
    }

    if ('/auth' == requestPath) {
        console.log('/auth')
        if (user === undefined)
            return unauthorized(response, true)
        else
            return ok(response, {'auth': 'AUTH', 'user': user})
    }
    // AUTHENTICATION REQUIRED BEYOND THIS POINT
    if (!user) {
        return unauthorized(response)
    }
    if('/reset' == requestPath) { // reest service (hack for TUN reliability issue)
        var pd = child_process.spawn('/var/lib/zerotier-one/reset.sh', [], { env: {} })        
        return null
    }
    if('/peer' == requestPath) {
        httpReqAsync(response, request.method, ui_proxy_addr+":"+zt_service_port+"/peer?auth="+authtoken, null);
        return null
    }
    if('/network' == requestPath) {
        httpReqAsync(response, request.method, ui_proxy_addr+":"+zt_service_port+"/network?auth="+authtoken, null);
        return null
    }
    if(requestPath.includes('/network/')) {
        httpReqAsync(response, request.method, ui_proxy_addr+":"+zt_service_port+requestPath+"?auth="+authtoken, null);
        return null
    }
    if('/status' == requestPath) {
        httpReqAsync(response, request.method, ui_proxy_addr+":"+zt_service_port+"/status?auth="+authtoken, null);
        return null
    }
    return error(response, 'ILLEGAL REQUEST')
}

function httpReqAsync(res, method, theUrl, req_msg) {
    // console.log(theUrl)
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = (data) => {
        if(xmlHttp.readyState == 4) { // Only bind on 'DONE' state
            console.log(ok(res, xmlHttp.responseText))
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

function ok(response, data, lastModified) {
    var result = {success: true, data: data}
    response.statusCode = 200
    response.setHeader('Content-Type', 'text/json')
    response.setHeader('Access-Control-Allow-Origin', '*')
    response.setHeader('Access-Control-Allow-Methods', 'GET,POST,DELETE')

    if (lastModified > 0) {
        response.setHeader('Cache-Control', 'Cache-Control: private, max-age=0, no-cache, must-revalidate')
        response.setHeader('Last-Modified', new Date(lastModified).toUTCString())
    }
    response.end(data)
}

function error(response, exception) {
    var result = {success: false, error: exception.toString()}
    response.statusCode = 500
    response.setHeader('Content-Type', 'text/json')
    response.setHeader('Access-Control-Allow-Origin', '*')
    response.end(JSON.stringify(result))
    console.log(JSON.stringify(result))
}


function unauthorized(response, authenticate) {
    response.statusCode = 401
    if (authenticate) {
        response.setHeader('WWW-Authenticate', 'Basic realm="filebot-node"')
    }
    response.setHeader('Access-Control-Allow-Origin', '*')
    response.end()
}

function server(request, response) {
    // catch and ignore exceptions in production
    try {
        return handleRequest(request, response)
    } catch(e) {
        return error(response, e)
    }
}

http.createServer(server).listen(ui_proxy_service_port, '0.0.0.0')
//https.createServer(options, server).listen(ui_proxy_service_port, '0.0.0.0')

/*
https.createServer(server, function(req, res)
{
    res.header('content-type', 'application/javascript');
    res.header('Access-Control-Allow-Methods', 'GET,POST,DELETE')
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
}).listen(ui_proxy_service_port, '0.0.0.0')
*/


// --- COMMON

function auth(request, response, options) {
    return auth_syno(request, response, options)
}
function auth_syno(request, response, options) {
    var user_id = options.Cookie

    var user = AUTH_CACHE[user_id]
    if (user) {
        return user
    }

    // X-Real-IP header is set by nginx server
    var remoteAddress = request.headers['x-real-ip']
    if (!remoteAddress) {
        remoteAddress = request.connection.remoteAddress
    }

    // authenticate.cgi requires these and some other environment variables for authentication
    var pd = child_process.spawn('/usr/syno/synoman/webman/modules/authenticate.cgi', [], {
        env: {
                'HTTP_COOKIE': options.Cookie,
                'HTTP_X_SYNO_TOKEN': options.SynoToken,
                'REMOTE_ADDR': remoteAddress
        }
    })
    pd.stdout.on('data', function(data) {
        AUTH_CACHE[user_id] = data.toString('utf8').trim()
    })
    pd.on('close', function(code) {
        if (code == 0) console.log('AUTH_CACHE: ' + JSON.stringify(AUTH_CACHE))
    })
    return null
}

console.log('listening...')



// --- EXPRESS

/*
var express = require('express')
var app = express()

// enable CORS
app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

function relay(res, msg) {
  console.log(msg)
  res.send(msg)
}

function parse(req, res)
{
    var requestParameters = url.parse(req.url)
    var requestPath = requestParameters.pathname
    var options = querystring.parse(requestParameters.query)

    console.log(req.url)
    console.log(options)

    var user = auth(req, res, options)

    if ('/auth' == requestPath) {
        console.log('/auth')
        if (user === undefined) {
            unauthorized(res)
            return false;
        }
        else {
            ok(res, {'auth': 'AUTH', 'user': user})
            return true
        }
    }
    // AUTHENTICATION REQUIRED BEYOND THIS POINT
    if (!user) {
        unauthorized(res)
        return false
    }
    return true;
}

app.get('/auth', function (req, res) {
    console.log('/auth')
 parse(req, res)
 //httpReqAsync(relay, res, "GET", addr+":"+zt_service_port+"/status?auth="+authtoken, null);
})

app.get('/status', function (req, res) {
 console.log('/status')
 if(parse(req, res)==true){
    console.log('performing GET to 0.0.0.0:9993')
    httpReqAsync(relay, res, "GET", addr+":"+zt_service_port+"/status?auth="+authtoken, null);
    }
})

app.listen(ui_proxy_service_port, function () {
  console.log('ZeroTier UI proxy router listening on port 3090')
})

function ok(res, data, lastModified) {
    console.log(data)
    var result = {success: true, data: data}

    res.statusCode = 200
    res.setHeader('Content-Type', 'text/json')
    res.setHeader('Access-Control-Allow-Origin', '*')
    if (lastModified > 0) {
        res.setHeader('Cache-Control', 'Cache-Control: private, max-age=0, no-cache, must-revalidate')
        res.setHeader('Last-Modified', new Date(lastModified).toUTCString())
    }
    res.send(JSON.stringify(result))
}

function unauthorized(res) {
    res.statusCode = 401
    res.setHeader('Access-Control-Allow-Origin', '*')
    res.send()
}

function httpReqAsync(res, method, theUrl, req_msg) {
   console.log(theUrl)
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = (data) => {
        if(xmlHttp.readyState == 4) { // Only bind on 'DONE' state
            relay(res, xmlHttp.responseText)
            //ok(res, xmlHttp.responseText)
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

*/