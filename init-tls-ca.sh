#!/bin/bash
export FABRIC_CA_CLIENT_HOME=./staging-tls-ca-data/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=../crypto/ca-cert.pem
./fabric-ca-client enroll -d -u https://tls-ca-admin:excentio@0.0.0.0:7052
./fabric-ca-client register -d --id.name peer1-datainform --id.secret excentio --id.type peer -u https://0.0.0.0:7052
./fabric-ca-client register -d --id.name orderer1-present --id.secret excentio --id.type orderer -u https://0.0.0.0:7052
./fabric-ca-client register -d --id.name peer1-excentio --id.secret excentio --id.type peer -u https://0.0.0.0:7052

mkdir -p ./present-ecert-ca-data/tls-ca/crypto
mkdir -p ./datainform-ecert-ca-data/tls-ca/crypto
mkdir -p ./excentio-ecert-ca-data/tls-ca/crypto

cp ./staging-tls-ca-data/crypto/ca-cert.pem   ./present-ecert-ca-data/tls-ca/crypto/tls-ca-cert.pem
cp ./staging-tls-ca-data/crypto/ca-cert.pem   ./datainform-ecert-ca-data/tls-ca/crypto/tls-ca-cert.pem
cp ./staging-tls-ca-data/crypto/ca-cert.pem   ./excentio-ecert-ca-data/tls-ca/crypto/tls-ca-cert.pem