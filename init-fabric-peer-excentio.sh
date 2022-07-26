#FROM HOST MACHINE

#!/bin/bash

mkdir -p ./excentio-peer1-data/assets/ca

cp ./excentio-ecert-ca-data/crypto/ca-cert.pem ./excentio-peer1-data/assets/ca/excentio-ca-cert.pem
cp ./staging-tls-ca-data/crypto/ca-cert.pem ./excentio-peer1-data/assets/ca/tls-ca-cert.pem

export FABRIC_CA_CLIENT_TLS_CERTFILES=./assets/ca/excentio-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=./excentio-peer1-data

export FABRIC_CA_CLIENT_MSPDIR=peer/msp
./fabric-ca-client enroll -d -u https://peer1-excentio:excentio@0.0.0.0:7058 #--csr.names "C=IT,ST=Piemonte,O=excentio,OU=peer"

export FABRIC_CA_CLIENT_MSPDIR=admin/msp
./fabric-ca-client enroll -d -u https://admin-excentio:excentio@0.0.0.0:7058 #--csr.names "C=IT,ST=Piemonte,O=excentio,OU=admin"

export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=./assets/ca/tls-ca-cert.pem
./fabric-ca-client enroll -d -u https://peer1-excentio:excentio@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer1-excentio

mkdir -p ./excentio-peer1-data/msp/admincerts/
cp ./excentio-ecert-ca-data/ca/admin/tls-msp/signcerts/cert.pem ./excentio-peer1-data/msp/admincerts/excentio-admin-cert.pem
