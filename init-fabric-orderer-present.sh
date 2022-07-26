#FROM HOST MACHINE

#!/bin/bash

mkdir -p ./present-orderer1-data/assets/ca

cp ./present-ecert-ca-data/crypto/ca-cert.pem ./present-orderer1-data/assets/ca/present-ca-cert.pem
cp ./staging-tls-ca-data/crypto/ca-cert.pem ./present-orderer1-data/assets/ca/tls-ca-cert.pem

#ECERT ENROLL
export FABRIC_CA_CLIENT_HOME=./present-orderer1-data
export FABRIC_CA_CLIENT_MSPDIR=msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=./assets/ca/present-ca-cert.pem
./fabric-ca-client enroll -d -u https://orderer1-present:excentio@0.0.0.0:7054 #--csr.names "C=IT,ST=Piemonte,O=Present,OU=orderer"

#TLS ENROLL
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=./assets/ca/tls-ca-cert.pem
./fabric-ca-client enroll -d -u https://orderer1-present:excentio@0.0.0.0:7052 --enrollment.profile tls --csr.hosts orderer1-present

#ADMIN ON ECERT ENROLL
export FABRIC_CA_CLIENT_HOME=./present-orderer1-data/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=../assets/ca/present-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
./fabric-ca-client enroll -d -u https://admin-present:excentio@0.0.0.0:7054 #--csr.names "C=IT,ST=Piemonte,O=Present,OU=admin"

#COPY ADMIN CERT FROM CA TO ORDERER
mkdir -p ./present-orderer1-data/msp/admincerts
cp ./present-orderer1-data/admin/msp/signcerts/cert.pem ./present-orderer1-data/msp/admincerts/orderer-admin-cert.pem


#GENESIS BLOCK CREATION
./configtxgen -profile TwoOrgsApplicationGenesis -outputBlock ./present-orderer1-data/genesis.block -channelID syschannel

#./configtxgen -profile SampleSingleMSPSolo -outputBlock ./present-orderer1-data/genesis.block -channelID syschannel

./configtxgen -profile SampleSingleMSPChannel -outputCreateChannelTx ./present-orderer1-data/channel.tx -channelID presentchannel

#./configtxgen -profile SampleSingleMSPSolo -outputBlock ./present-orderer1-data/presentchannel.block -channelID presentchannel
