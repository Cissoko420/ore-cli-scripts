#!/bin/bash

nr_wallets=60

clear

for((i=4;i<=nr_wallets;i++)); do
	balance=$(ore --keypair ~/.config/solana/ids/id$i.json balance | grep -oP '^\d+(.\d)?(?= ORE)')
	if [ ! -z "$balance" ] && [ "$(echo "balance == 0" | bc)" -eq 1 ]; then
		echo "ID$i balance: $balance ORE - Close account"
		solana config set --keypair /root/.config/solana/ids/id$i.json
		spl-token close --fee-payer /root/.config/solana/ids/id$i.json oreoN2tQbHXVaZsr3pf66A48miqcBXCDJozganhEJgz --owner /root/.config/solana/ids/id$i.json
		echo ""
		sleep 2
	else
		echo "ID$i balance: $balance ORE - Unable to close account"
		echo ""
	fi
done
