#!/bin/bash
set -e
set -x

./teardown-network.sh

# -----------------------------------------------------------------------------
# Start CA CLIENT
# -----------------------------------------------------------------------------
docker compose --env-file .env up -d ca-client

# -----------------------------------------------------------------------------
# CA DB
# -----------------------------------------------------------------------------
docker compose --env-file .env up -d ca-db
./wait_for_log.sh ca-db "database system is ready to accept connections"

# -----------------------------------------------------------------------------
# Start ROOT CA
# -----------------------------------------------------------------------------
docker compose --env-file .env up -d root-ca
./wait_for_log.sh root-ca "Listening on http://0.0.0.0:7052"

# -----------------------------------------------------------------------------
# Register CA1 & CA2 users
# -----------------------------------------------------------------------------
echo '
#!/bin/sh
set -e
set -x

export FABRIC_CA_CLIENT_HOME=/etc/ca-client/ca-root-admin

fabric-ca-client enroll -d -u "http://root-ca:root-ca-pw@root-ca:7052"

fabric-ca-client register -d --id.name "ca1-enroll" --id.secret "ca1-enroll" --id.attrs "hf.IntermediateCA=true" -u http://root-ca:7052
fabric-ca-client register -d --id.name "ca2-enroll" --id.secret "ca2-enroll" --id.attrs "hf.IntermediateCA=true" -u http://root-ca:7052
' > "./scripts/register-intermediate-cas.sh"
chmod +x ./scripts/register-intermediate-cas.sh
docker exec --env-file .env ca-client /bin/sh -c "/opt/scripts/register-intermediate-cas.sh"

# -----------------------------------------------------------------------------
# Start CA1 & CA2
# -----------------------------------------------------------------------------
docker compose --env-file .env up -d intermediate-ca-1
docker compose --env-file .env up -d intermediate-ca-2
./wait_for_log.sh intermediate-ca-1 "Listening on http://0.0.0.0:7052"
./wait_for_log.sh intermediate-ca-2 "Listening on http://0.0.0.0:7052"

# -----------------------------------------------------------------------------
# Register peer and orderer with CA
# -----------------------------------------------------------------------------
echo '
#!/bin/sh
set -e
set -x

export FABRIC_CA_CLIENT_HOME=/etc/ca-client/ca/

fabric-ca-client enroll -d -u "http://admin-1:adminpw-1@intermediate-ca-1:7052"

# USE CA1
fabric-ca-client register -d --id.name "orderer" --id.secret "ordererPW" --id.type orderer -u http://intermediate-ca-1:7052

# USE CA2 - Load balancer simulation
fabric-ca-client register -d --id.name "peer" --id.secret "peerPW" --id.type peer -u http://intermediate-ca-2:7052

' > "./scripts/register.sh"
chmod +x ./scripts/register.sh
docker exec --env-file .env ca-client /bin/sh -c "/opt/scripts/register.sh"

echo "******* NETWORK SETUP COMPLETED *******"
