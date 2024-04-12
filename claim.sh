# @Author: Cissoko420
# @Date:   2024-04-10 05:06:10
# @Last Modified by:   Cissoko420
# @Last Modified time: 2024-04-10 05:06:10
#!/bin/bash

# Auto-claim miners if balance is over MIN_BALANCE

nr_wallets=11

MIN_BALANCE="0.01"
FEE="100000"
RPC_URL="https://api.mainnet-beta.solana.com/" 

clear
echo "Checking the unclaimed balance..."

while true; do
    for ((i=1;i<=nr_wallets;i++)); do
        balance=$(ore --keypair ~/.config/solana/ids/id$i.json rewards | grep -oP '^\d+(.\d+)?(?= ORE)')

        if [ ! -z "$balance" ] && [ "$(echo "$balance > $MIN_BALANCE" | bc)" -eq 1 ]; then
            echo "ID$i balance: $balance ORE - Eligible for claim"
            ore --keypair ~/.config/solana/ids/id$i.json --rpc "$RPC_URL" --priority-fee ${FEE} claim
        else
            echo "ID$i balance: $balance ORE - Not eligible for claim"
        fi
    done
    echo ""
    echo "Waiting for the next check..."
    sleep 600
    clear
done
