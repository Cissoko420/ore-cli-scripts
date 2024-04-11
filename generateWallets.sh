# @Author: Cissoko420
# @Date:   2024-04-10 05:06:10
# @Last Modified by:   Cissoko420
# @Last Modified time: 2024-04-10 05:06:10

# Generate <num_wallets> wallets, keypairs saved to 'ids/' folder in seperate .json files, private_key.txt is generated with all the privatekeys (Copy privatekeys easier) 

#!/bin/bash

num_wallets=10 #Generates 10 new wallets

private_key_dir="ids" #Name of folder to save ids.json files

concatenated_file="private_keys.txt"

mkdir -p "$private_key_dir"

clear
for ((i=11; i<=$num_wallets; i++)); do
    echo "Generating wallet $i..."
    solana-keygen new --outfile "$private_key_dir/id$i.json" --no-passphrase >/dev/null 2>&1
done

for file in "$private_key_dir"/*.json; do
    cat "$file" | tr -d '\n' >> "$concatenated_file"
    echo "" >> "$concatenated_file"
done
truncate -s-2 "$concatenated_file"
echo "]" >> "$concatenated_file"


echo "Private keys saved to $concatenated_file"
