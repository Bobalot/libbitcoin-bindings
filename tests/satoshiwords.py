from bitcoin import genesis_block, save_script

genblk = genesis_block()
assert genblk.transactions.size() == 1

coinbase_tx = genblk.transactions[0]
assert coinbase_tx.inputs.size() == 1

coinbase_input = coinbase_tx.inputs[0]

input_script = coinbase_input.input_script
print input_script, input_script.__class__
raw_block_message = save_script(input_script)

print raw_block_message
