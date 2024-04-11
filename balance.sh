# @Author: Cissoko420
# @Date:   2024-04-10 05:06:10
# @Last Modified by:   Cissoko420
# @Last Modified time: 2024-04-10 05:06:10
#!/bin/bash

csv_file="miners_data.csv"
echo "  Miner,     ORE, Value (Usdc)" > "$csv_file"
echo "Checking unclaimed balances..."

while true; do

    echo "  Miner,     ORE, Value(Usdc)" > "$csv_file"

    total_balance=0
    for i in {1..11}; do
        balance=$(ore --keypair ~/.config/solana/ids/id$i.json rewards | grep -oP '^\d+(.\d+)?(?= ORE)')

        if [ ! -z "$balance" ]; then
            total_balance=$(echo "$total_balance + $balance" | bc)

            echo "    $i, $balance,       -" >> "$csv_file"
        else
            echo "    $i, Not Found,       -" >> "$csv_file"
        fi
    done
    echo "---------,------------, -------------" >> "$csv_file"
    
    price=$(curl --silent -X 'GET' 'https://price.jup.ag/v4/price?ids=oreoN2tQbHXVaZsr3pf66A48miqcBXCDJozganhEJgz' | sed -n 's/.*"price":\([^,}]*\).*/\1/p')
    value=$(echo "$price * $total_balance" | bc)
    
    echo "Unclaimed, 0$total_balance, $value" >> "$csv_file"
    echo "---------,------------, -------------" >> "$csv_file"

    balance2=$(ore --keypair ~/.config/solana/ids/claimed.json balance | grep -oP '^\d+(.\d+)?(?= ORE)')
    value2=$(echo "$price * $balance2" | bc)

    echo " Claimed, $balance2, $value2" >> "$csv_file"
    echo "---------,------------, -------------" >> "$csv_file"

    total=$(echo "$total_balance + $balance2" | bc)
    value3=$(echo "$price * $total" | bc)
    
    echo "  Total, 0$total, $value3" >> "$csv_file"
    
    clear
    csvlook $csv_file
    rm -f "$csv_file"

    sleep 120
done
