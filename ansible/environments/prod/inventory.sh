#!/bin/bash

app_external_ip=$(cd ../terraform/prod && terraform output external_ip_address_app)
db_external_ip=$(cd ../terraform/prod && terraform output external_ip_address_db)
db_internal_ip=$(cd ../terraform/prod && terraform output internal_ip_address_db)

cat <<EOF
{
  "app": {
    "hosts": [$app_external_ip]
  },
  "db": {
    "hosts": [$db_external_ip],
    "internal_ip": $db_internal_ip
  }
}
EOF
