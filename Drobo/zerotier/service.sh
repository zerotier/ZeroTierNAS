#!/usr/bin/env sh
#
# Service.sh for zerotier

# import DroboApps framework functions
. /etc/service.subr

framework_version="2.1"
name="zerotier"
version="1.2.4"
description="ZeroTier -- Enrypted P2P Virtual LAN"
depends=""
webui=":1234/zerotier"

prog_dir="$(dirname "$(realpath "${0}")")"
tmp_dir="/tmp/DroboApps/${name}"
pidfile="${tmp_dir}/pid.txt"
logfile="${tmp_dir}/log.txt"
statusfile="${tmp_dir}/status.txt"
errorfile="${tmp_dir}/error.txt"
daemon="${prog_dir}/zerotier-one"

# backwards compatibility
if [ -z "${FRAMEWORK_VERSION:-}" ]; then
  framework_version="2.0"
  . "${prog_dir}/libexec/service.subr"
fi

start() {
  rm -f "${errorfile}"
  echo "Starting ZeroTier" > "${statusfile}"
  ${daemon} -d
  touch "${pidfile}"
  return 0
}

is_running() {
  [ -f "${pidfile}" ]
}

stop() {
  rm -f "${pidfile}"
  return 0
}

force_stop() {
  rm -f "${pidfile}"
  return 0
}

# boilerplate
if [ ! -d "${tmp_dir}" ]; then mkdir -p "${tmp_dir}"; fi
exec 3>&1 4>&2 1>> "${logfile}" 2>&1
STDOUT=">&3"
STDERR=">&4"
echo "$(date +"%Y-%m-%d %H-%M-%S"):" "${0}" "${@}"
set -o errexit  # exit on uncaught error code
set -o nounset  # exit on unset variable
set -o xtrace   # enable script tracing

main "${@}"
