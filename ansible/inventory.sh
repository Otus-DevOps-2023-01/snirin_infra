#!/bin/bash

app_external_ip=$(cd ../terraform/stage && terraform output external_ip_address_app)
db_external_ip=$(cd ../terraform/stage && terraform output external_ip_address_db)

cat <<EOF
{
  "app": {
    "hosts": [$app_external_ip]
  },
  "db": {
    "hosts": [$db_external_ip]
  }
}
EOF
