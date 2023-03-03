
#!/bin/sh
set -e
set -x

export FABRIC_CA_CLIENT_HOME=/etc/ca-client/ca-root-admin

fabric-ca-client enroll -d -u "http://root-ca:root-ca-pw@root-ca:7052"

fabric-ca-client register -d --id.name "ca1-enroll" --id.secret "ca1-enroll" --id.attrs "hf.IntermediateCA=true" -u http://root-ca:7052
fabric-ca-client register -d --id.name "ca2-enroll" --id.secret "ca2-enroll" --id.attrs "hf.IntermediateCA=true" -u http://root-ca:7052

