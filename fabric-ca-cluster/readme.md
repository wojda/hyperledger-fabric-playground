# Fabric Certificate Authority cluster

## Run

```bash
./setup-network.sh
```

## Arch

* root CA
* two intermediate CAs
  * enrolled with root CA
  * sharing the same PostgreSQL DB

## Issue

When a client enrolled with intermediate-ca-1 makes a call to intermediate-ca-2,
the intermediate-ca-2 rejects the request with following error:

```
2023/03/03 13:02:53 [DEBUG] Sending request
POST http://intermediate-ca-2:7052/register
{"id":"peer","type":"peer","secret":"peerPW","affiliation":""}
2023/03/03 13:02:53 [DEBUG] Received response
statusCode=401 (401 Unauthorized)
Error: Response from server: Error Code: 20 - Authentication failure
```

Expected behavior:
Both intermediate-cas were signed by root-ca, intermediate-ca-2 should trust the certs signed by intermediate-ca-1.
