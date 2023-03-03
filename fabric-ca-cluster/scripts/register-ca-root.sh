
  #!/bin/sh
  set -e
  set -x

  export FABRIC_CA_CLIENT_HOME=/etc/ca-client/ca-root-admin

  fabric-ca-client enroll -d -u "http://admin-root:adminpw-root@ca-root:7052"

  fabric-ca-client register -d --id.name "ca1-enroll" --id.secret "ca1-enroll" --id.attrs "hf.IntermediateCA=true" --id.type admin -u http://ca-root:7052
  fabric-ca-client register -d --id.name "ca2-enroll" --id.secret "ca2-enroll" --id.attrs "hf.IntermediateCA=true" --id.type admin -u http://ca-root:7052
  
