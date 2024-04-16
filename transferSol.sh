# @Author: Cissoko420
# @Date:   2024-04-16 11:27:30
# @Last Modified by:   Cissoko420
# @Last Modified time: 2024-04-16 11:30:15
#!/bin/bash

receiver_wallet="WALLET ADDRESS"

nr_wallets=11

clear

while true; do
    for ((i=1;i<=nr_wallets;i++)); do

        balance=$(solana balance --keypair ~/.config/solana/ids/id$i.json)
        send_balance=$(echo "$balance" | awk '{print $1}')

        if (( $(echo "$send_balance > 0" | bc -l) )); then
            echo "ID$i balance: $balance SOL - To Transfer"
            solana transfer "$receiver_wallet" "$send_balance" --from ~/.config/solana/ids/id$i.json --allow-unfunded-recipient --fee-payer ~/.config/solana/ids/claimed.json
            echo ""
            sleep 2
        else
            echo "ID$i balance: $balance SOL - No balance to send"
            echo ""
        fi
    done
    echo "Waiting to do next run"
    echo ""
    sleep 5
    clear
done
