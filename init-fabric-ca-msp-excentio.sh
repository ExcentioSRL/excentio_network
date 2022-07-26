#FROM HOST MACHINE
#!/bin/bash
export FABRIC_CA_CLIENT_HOME=./excentio-ecert-ca-data/ca/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=../../crypto/ca-cert.pem
./fabric-ca-client enroll -d -u https://excentioecert:excentio@0.0.0.0:7058
./fabric-ca-client register -d --id.name peer1-excentio --id.secret excentio --id.type peer -u https://0.0.0.0:7058
./fabric-ca-client register -d --id.name admin-excentio --id.secret excentio --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:7058