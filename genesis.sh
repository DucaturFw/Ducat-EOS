EOS_NODE_ADDR=http://193.93.219.219:8888
DUCAT_TOKEN_OWNER=ducaturtoken
DUCAT_EXCHANGE_OWNER=duccntr
DUCAT_AMOUNT=7000000000.0000
DUCAT_SYMBOL=DUCAT

# upload token contract
cleos -u $EOS_NODE_ADDR set contract $DUCAT_TOKEN_OWNER eos-src/build/contracts/eosio.token -p $DUCAT_TOKEN_OWNER
# create token
cleos -u $EOS_NODE_ADDR push action $DUCAT_TOKEN_OWNER create '["'$DUCAT_TOKEN_OWNER'", "'$DUCAT_AMOUNT $DUCAT_SYMBOL'"]' -p $DUCAT_TOKEN_OWNER
# mint initial token supply for exchange contract
cleos -u $EOS_NODE_ADDR push action $DUCAT_TOKEN_OWNER issue '["'$DUCAT_EXCHANGE_OWNER'", "'$DUCAT_AMOUNT $DUCAT_SYMBOL'"]' -p $DUCAT_TOKEN_OWNER

# check that everything is okay
cleos -u $EOS_NODE_ADDR get currency balance $DUCAT_TOKEN_OWNER $DUCAT_EXCHANGE_OWNER
# 7000000000.0000 DUCAT

# upload exchange contract
cleos -u $EOS_NODE_ADDR set contract $DUCAT_EXCHANGE_OWNER token -p $DUCAT_EXCHANGE_OWNER

# grant permission to self (lol that's necessary)
EOS_PUB_KEY=EOS6GRjeBum8jMgwjS91AMn6QmP6SrazRndhTAY797GbMaEqW7D5W
DUCAT_PERM_ACC=$DUCAT_EXCHANGE_OWNER
cleos -u $EOS_NODE_ADDR push action eosio updateauth '{"account":"'$DUCAT_PERM_ACC'","permission":"active","parent":"owner","auth":{"keys":[{"key":"'${EOS_PUB_KEY}'", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"'$DUCAT_EXCHANGE_OWNER'","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p $DUCAT_PERM_ACC@active
# change DUCAT_PERM_ACC to grant permissions to other users