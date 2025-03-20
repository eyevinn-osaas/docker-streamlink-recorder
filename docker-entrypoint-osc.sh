#!/bin/bash

# Following environment variables are provided by the OSC platform
# $PORT         : The HTTP port for the service to bind to
# $OSC_HOSTNAME : The hostname an instance of this service is available to.
#                 This can be used when the service requires that a `PUBLIC_URL` is set.

if [[ ! -z "${OSC_HOSTNAME}" ]]; then
  export LOGFLARE_NODE_HOST="${OSC_HOSTNAME}"
fi

export LOGFLARE_SINGLE_TENANT="true"
export PHX_HTTP_PORT="${PORT:-8080}"

# if [[ -z "${POSTGRES_BACKEND_URL}" ]]; then
#   echo "POSTGRES_BACKEND_URL is not set. Exiting..."
#   exit 1
# fi

USER_ID=${uid:-9001}
GROUP_ID=${gid:-9001}

echo "UID: $USER_ID"
echo "GID: $GROUP_ID"
echo "OSC_HOSTNAME: ${OSC_HOSTNAME:-not set}"
echo "PORT: ${PORT:-8080}"

if [[ ! -z "${PORT}" ]]; then
  mkdir -p /tmp/www
  echo "<html><body><h1>Streamlink Recorder OSC Service</h1><p>Status: Running</p></body></html>" > /tmp/www/index.html
  (cd /tmp/www && python -m http.server ${PORT} --bind 0.0.0.0 &)
  echo "HTTP server started on port ${PORT}, bound to 0.0.0.0"
fi

chown -R $USER_ID:$GROUP_ID /home/plugins
chown -R $USER_ID:$GROUP_ID /home/script
chown -R $USER_ID:$GROUP_ID /home/download

exec gosu $USER_ID "$@"