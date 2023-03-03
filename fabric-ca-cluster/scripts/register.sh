
#!/bin/sh
set -e
set -x

export FABRIC_CA_CLIENT_HOME=/etc/ca-client/ca/

fabric-ca-client enroll -d -u "http://admin-1:adminpw-1@intermediate-ca-1:7052"

# USE CA1
fabric-ca-client register -d --id.name "orderer" --id.secret "ordererPW" --id.type orderer -u http://intermediate-ca-1:7052

# USE CA2 - Load balancer simulation
fabric-ca-client register -d --id.name "peer" --id.secret "peerPW" --id.type peer -u http://intermediate-ca-2:7052


