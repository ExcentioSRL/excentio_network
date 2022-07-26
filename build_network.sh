#!/bin/bash

rm -r ./datainform-ecert-ca-data
rm -r ./datainform-peer1-admin-data
rm -r ./datainform-peer1-data
rm -r ./datainform-peer1-var
rm -r ./present-ecert-ca-data
rm -r ./present-orderer1-admin-data
rm -r ./present-orderer1-data
rm -r ./staging-tls-ca-data
rm -r ./excentio-peer1-data
rm -r ./excentio-ecert-ca-data

mkdir -p present-ecert-ca-data/crypto
mkdir -p datainform-ecert-ca-data/crypto
mkdir -p excentio-ecert-ca-data/crypto

mkdir -p datainform-ecert-ca-data/ca
mkdir -p excentio-ecert-ca-data/ca

# cp fabric-ca-server-config-datainform.yaml datainform-ecert-ca-data/crypto/fabric-ca-server-config.yaml
# cp fabric-ca-server-config-present.yaml present-ecert-ca-data/crypto/fabric-ca-server-config.yaml
# cp fabric-ca-client-config.yaml datainform-ecert-ca-data/ca

docker stop cli-present cli-datainform datainform-ecert-ca present-ecert-ca orderer1-present staging-tls-ca
docker rm cli-present cli-datainform datainform-ecert-ca present-ecert-ca orderer1-present staging-tls-ca


#TLS CA
docker-compose -f docker-compose-tls.yml up -d

sleep 10

./init-tls-ca.sh

#ECERT CA DI

docker-compose -f docker-compose-ecert-datainform.yml up -d

sleep 10

./init-fabric-ca-msp-datainform.sh

#ECERT CA EXCENTIO

docker-compose -f docker-compose-ecert-excentio.yml up -d

sleep 10

./init-fabric-ca-msp-excentio.sh

#ECERT CA PRESENT

docker-compose -f docker-compose-ecert-present.yml up -d

sleep 10

./init-fabric-ca-msp-present.sh

#PEER1 DI
./init-fabric-peer-datainform.sh
docker-compose -f docker-compose-peer1-datainform.yml up -d

#PEER1 EXCENTIO
./init-fabric-peer-excentio.sh
docker-compose -f docker-compose-peer1-excentio.yml up -d

#ORDERER1 PRESENT
./init-fabric-orderer-present.sh
docker-compose -f docker-compose-orderer1-present.yml up -d

#COPY DI PEER ADMIN CERTS UNDER CLI VOLUME, EVERY ORG HAS A CLI
mkdir datainform-netcli-data
cp -r ./datainform-peer1-data/admin ./datainform-netcli-data
cp -r ./datainform-peer1-data/tls-msp ./datainform-netcli-data
cp config.yaml ./datainform-netcli-data/admin/msp
cp core.yaml ./datainform-netcli-data
mkdir -p ./datainform-netcli-data/assets
cp ./present-orderer1-data/channel.tx ./datainform-netcli-data/assets

#COPY EXC PEER ADMIN CERTS UNDER CLI VOLUME
mkdir excentio-netcli-data
cp -r ./excentio-peer1-data/admin ./excentio-netcli-data
cp -r ./excentio-peer1-data/tls-msp ./excentio-netcli-data
cp config.yaml ./excentio-netcli-data/admin/msp
cp core.yaml ./excentio-netcli-data
mkdir -p ./excentio-netcli-data/assets
cp ./present-orderer1-data/channel.tx ./excentio-netcli-data/assets

#COPY ORDERER CONFIG UNDER ORDERER VOLUME
cp config.yaml ./present-orderer1-data/msp
cp orderer.yaml ./present-orderer1-data
cp configtx.yml ./present-orderer1-data

#COPY PEER CONFIG UNDER DI PEER VOLUME
cp config.yaml ./datainform-peer1-data/peer/msp
cp core.yaml ./datainform-peer1-data/peer

#COPY PEER CONFIG UNDER EXC PEER VOLUME
cp config.yaml ./excentio-peer1-data/peer/msp
cp core.yaml ./excentio-peer1-data/peer