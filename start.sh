# 启动之前需要手工启动bootnode
if [ ! -f bootnode.log ];then
    echo "please run bootnode.sh first"
    exit
fi
# 解析本机的ip地址
ip=$(ifconfig|grep inet|grep -v inet6|grep broadcast|awk '{print $2}')
# 解析bootnode地址
#bootnode_addr=enode://"$(grep enode bootnode.log|tail -n 1|awk -F '://' '{print $2}'|awk -F '@' '{print $1}')""@$ip:30301"
bootnode_addr=enode://"$(tail bootnode.log)""@$ip:30301"
if [ "$1" == "" ];then
    echo "node id is empty, please use: start.sh <node_id>";
    exit
fi
no=$1
datadir=./
mkdir -p $datadir
# 如果启动前需要使用创世块初始化
if [ ! -d "$DIRECTORY" ]; then
    if [ ! -f $datadir/genesis ];then
        echo '{"config": {"chainId": 15, "homesteadBlock": 0, "eip155Block": 0, "eip158Block": 0 }, "coinbase" : "0x0000000000000000000000000000000000000000", "difficulty" : "0x40000", "extraData" : "0x04c13046fefc255d2ce8cb20101646af093d3423ed281423d7897d68967aac75677a5f2d9f9a5a810b9b3e68cb28f80233a0693d9a19d4e92c27f78376ecdd6de0", "gasLimit" : "0xffffffff", "nonce" : "0x0000000000000042", "mixhash" : "0x0000000000000000000000000000000000000000000000000000000000000000", "parentHash" : "0x0000000000000000000000000000000000000000000000000000000000000000", "timestamp" : "0x00", "alloc": { } }' > $datadir/genesis
    fi
    geth --datadir $datadir/$no init $datadir/genesis
fi
# 运行geth，启动console
geth --preload ~/test/autoMine.js --datadir $datadir/$no --networkid 11100 --ipcdisable --port 619$no --rpc --rpcapi "db,eth,net,web3,personal" --rpcaddr $ip --rpccorsdomain "*" --rpcport 81$no --bootnodes $bootnode_addr console
#geth --datadir $datadir/$no --networkid 11100 --ipcdisable --port 619$no --rpc --rpcapi "db,eth,net,web3,personal" --rpcaddr $ip --rpccorsdomain "*" --rpcport 81$no --bootnodes $bootnode_addr console
