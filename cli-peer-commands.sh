#HOST MACHINE
cp ./present-orderer1-data/channel.tx ./datainform-peer1-data/assets
cp ./present-orderer1-data/channel.tx ./excentio-peer1-data/assets
cp ./present-orderer1-data/channel.tx ./datainform-netcli-data/assets
cp ./present-orderer1-data/channel.tx ./excentio-netcli-data/assets

#INSIDE DI OR EXC CLI CONTAINER, JUST ONE, THEN COPY PRODUCED CHANNEL BLOCK IN THE OTHERS
export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/netcli/admin/msp
peer channel create -c presentchannel -f /tmp/hyperledger/netcli/assets/channel.tx -o orderer1-present:7050 --outputBlock /tmp/hyperledger/netcli/assets/presentchannel.block --tls --cafile /tmp/hyperledger/netcli/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem


#JOIN DI TO PRESENTCHANNEL
export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/netcli/admin/msp
export CORE_PEER_ADDRESS=peer1-datainform:7051
peer channel join -b /tmp/hyperledger/netcli/assets/presentchannel.block

#JOIN EXC TO PRESENTCHANNEL, BEFORE NEEDS TO SWITCH SOME ENV VARIABLES THAT WERE ALREADY DEFINED IN DOCKER COMPOSE
export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/netcli/admin/msp
export CORE_PEER_ADDRESS=peer1-excentio:7051
peer channel join -b /tmp/hyperledger/netcli/assets/presentchannel.block

# ./osnadmin --orderer-address=0.0.0.0:7050 channel join --channelID=presentchannel --config-block=../present-orderer1-data/presentchannel.block

#REMOTE NET COMMANDS
export CORE_PEER_MSPCONFIGPATH=./datainform-netcli-data/admin/msp
export CORE_PEER_ADDRESS=peer1-datainform:7051
export CORE_PEER_TLS_ROOTCERT_FILE=./datainform-netcli-data/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_TLS_ENABLED=true

export CORE_PEER_MSPCONFIGPATH=./datainform-netcli-data/admin/msp
export CORE_PEER_ADDRESS=excentionet01.datainform.it:7051
export CORE_PEER_TLS_ROOTCERT_FILE=../excentio-peer1-data/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_TLS_ENABLED=true