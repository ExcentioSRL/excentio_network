#FROM HOST MACHINE

#!/bin/bash

mkdir -p ./datainform-peer1-data/assets/ca

cp ./datainform-ecert-ca-data/crypto/ca-cert.pem ./datainform-peer1-data/assets/ca/datainform-ca-cert.pem
cp ./staging-tls-ca-data/crypto/ca-cert.pem ./datainform-peer1-data/assets/ca/tls-ca-cert.pem


export FABRIC_CA_CLIENT_TLS_CERTFILES=./assets/ca/datainform-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=./datainform-peer1-data

export FABRIC_CA_CLIENT_MSPDIR=peer/msp
./fabric-ca-client enroll -d -u https://peer1-datainform:excentio@0.0.0.0:7053 #--csr.names "C=IT,ST=Piemonte,O=Datainform,OU=peer"

export FABRIC_CA_CLIENT_MSPDIR=admin/msp
./fabric-ca-client enroll -d -u https://admin-datainform:excentio@0.0.0.0:7053 #--csr.names "C=IT,ST=Piemonte,O=Datainform,OU=admin"

export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=./assets/ca/tls-ca-cert.pem
./fabric-ca-client enroll -d -u https://peer1-datainform:excentio@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer1-datainform

mkdir -p ./datainform-peer1-data/msp/admincerts/
cp ./datainform-ecert-ca-data/ca/admin/msp/signcerts/cert.pem ./datainform-peer1-data/msp/admincerts/datainform-admin-cert.pem
