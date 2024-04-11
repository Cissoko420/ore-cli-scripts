# @Author: Cissoko420
# @Date:   2024-04-10 05:06:10
# @Last Modified by:   Cissoko420
# @Last Modified time: 2024-04-10 05:06:10
#!/bin/bash

# Keep miners with sol, wallet that funds miners must be in ids/claimed.json or change it accordingly

nr_wallets=10

miner_min_balance=0.01

sol_to_fund=0.02

clear
echo "Checking Wallets..."

while true; do
    for ((i=1;i<=nr_wallets;i++)); do

        receiver_wallet=$(solana address --keypair ~/.config/solana/ids/id$i.json)
        sleep 1
        balance=$(solana --keypair ~/.config/solana/ids/id$i.json balance | grep -oP '^\d+(.\d+)?(?= SOL)')

        if [ ! -z "$balance" ] && [ "$(echo "$balance <= $miner_min_balance" | bc)" -eq 1 ]; then
            echo "ID$i balance: $balance SOL - Starting Funding..."
            solana transfer --from ~/.config/solana/ids/claimed.json $receiver_wallet $sol_to_fund  --allow-unfunded-recipient --fee-payer ~/.config/solana/ids/claimed.json 
            echo ""
            sleep 1
        else
            echo "ID$i balance: $balance SOL - Not needed to fund"
            echo ""
        fi
    done
    echo "Waiting to do next run..."
    sleep 300
    clear
done
