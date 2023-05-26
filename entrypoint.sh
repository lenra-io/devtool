#!/bin/bash

/bin/bash -c "/opt/bitnami/scripts/nginx/entrypoint.sh /opt/bitnami/scripts/nginx/run.sh"
/lenra/devtools/rel/dev_tools/bin/dev_tools migrate
/lenra/devtools/rel/dev_tools/bin/dev_tools foreground