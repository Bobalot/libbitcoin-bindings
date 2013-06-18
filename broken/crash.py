import bitcoin
tx = bitcoin.genesis_block().transactions[0]
bitcoin.hash_transaction(tx)

