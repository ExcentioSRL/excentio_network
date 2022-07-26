#!/bin/bash

#FROM HOST MACHINE
export FABRIC_CA_CLIENT_HOME=./present-ecert-ca-data/ca/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=../../crypto/ca-cert.pem
./fabric-ca-client enroll -d -u https://presentecert:excentio@0.0.0.0:7054
./fabric-ca-client register -d --id.name orderer1-present --id.secret excentio --id.type orderer -u https://0.0.0.0:7054
./fabric-ca-client register -d --id.name admin-present --id.secret excentio --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:7054
