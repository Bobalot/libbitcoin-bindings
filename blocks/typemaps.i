%define CB_BLOCKCHAIN_TYPEMAP(handler, type)
%typemap(in) libbitcoin::blockchain::fetch_handler_ ## handler {
    Py_INCREF($input);
    $1 = std::bind(python_ ## type ## _cb_handler, $input, _1, _2);
}
%enddef

%define CB_TYPEMAP1(handler, type)
%typemap(in) std::function<void (const std::error_code&, const handler&)> {
    Py_INCREF($input);
    $1 = std::bind(python_ ## type ## _cb_handler, $input, _1, _2);
}
%enddef

/* txpool.store */
CB_TYPEMAP1(libbitcoin::index_list, index_list)
/* node.subscribe_transaction
   blockchain.fetch_transaction */
CB_TYPEMAP1(libbitcoin::transaction_type, transaction_type)
/* channel.subscribe_address */
CB_TYPEMAP1(address_type, address_type)
/* channel.subscribe_get_address */
CB_TYPEMAP1(get_address_type, get_address_type)
/* channel.subscribe_version(receive_version_handler */
/* channel.subscribe_veack(receive_version_handler */
CB_TYPEMAP1(version_type, version_type)
CB_TYPEMAP1(verack_type, verack_type)
/* channel.subscribe_inventory */
CB_TYPEMAP1(inventory_type, inventory_type)
/* channel.subscribe_get_data */
CB_TYPEMAP1(get_data_type, get_data_type)
/* channel.subscribe_get_blocks */
CB_TYPEMAP1(get_blocks_type, get_blocks_type)
/* channel.subscribe_block */
CB_TYPEMAP1(block_type, block_type)
/*
 TODO channel.subscribe_raw(receive_raw_handler
*/
/* TODO blockchain.fetch_block_depth */
/* TODO blockchain.fetch_last_depth */
CB_TYPEMAP1(size_t, size_t)


%typemap(in) std::function<void (std::shared_ptr< libbitcoin::channel >)> {
    Py_INCREF($input);
    $1 = std::bind(python_channel_cb_handler, $input, _1);
}

/* Blockchain */
/* blockchain.fetch_block_transaction_hashes */
CB_BLOCKCHAIN_TYPEMAP(block_transaction_hashes, inventory_list)
CB_BLOCKCHAIN_TYPEMAP(block_locator, block_locator)
/* blockchain.fetch_block_header */
CB_BLOCKCHAIN_TYPEMAP(block_header, block_type)
/* blockchain.fetch_spend */
CB_BLOCKCHAIN_TYPEMAP(spend, input_point)
/* blockchain.fetch_outputs */
CB_BLOCKCHAIN_TYPEMAP(outputs, output_point_list)

/* MISSING: */
/* TODO blockchain.fetch_transaction_index */
/* TODO blockchain.subscribe_reorganize */

/* Error codes */
%typemap(in) std::function<void (const std::error_code)> {
    Py_INCREF($input);
    $1 = std::bind(python_cb_handler, $input, _1);
}

%typemap(in) std::function<void (const std::error_code&)> {
    Py_INCREF($input);
    $1 = std::bind(python_cb_handler, $input, _1);
}

/*
%apply unsigned {uint32_t, uint64_t, size_t};
%apply int {libbitcoin::byte};
%apply int {uint8_t};
%apply int *INPUT {uint8_t *};
%apply int &INPUT {uint8_t &};
%apply int OUTPUT {libbitcoin::byte};
%apply int OUTPUT {uint8_t};
%apply int *OUTPUT {uint8_t *};
%apply int &OUTPUT {uint8_t &};
*/

/** hash_digest aka  std::array<uint8_t, 32> **/

/* Convert from Python --> C */
%typemap(in) std::array<uint8_t, 32> {
    char* data_ptr = reinterpret_cast<char*>($1.data());
    Py_ssize_t data_size = $1.size();
    PyString_AsStringAndSize($input, &data_ptr, &data_size);
}

/* Convert from C --> Python */
%typemap(out) std::array<uint8_t, 32> {
    const char* data_ptr = reinterpret_cast<const char*>($1.data());
    $result = PyString_FromStringAndSize(data_ptr, $1.size());
}

/* Convert from Python --> C */
/*%typemap(in) std::vector<byte> {
    char* data_ptr = reinterpret_cast<char*>($1.data());
    Py_ssize_t data_size = $1.size();
    PyString_AsStringAndSize($input, &data_ptr, &data_size);
}*/

/* Convert from C --> Python */
%typemap(out) libbitcoin::data_chunk {
    const char* data_ptr = reinterpret_cast<const char*>(&($1.front()));
    $result = PyBuffer_FromMemory((void*)data_ptr, $1.size());
    Py_INCREF($result);
}

%typemap(out) const libbitcoin::data_chunk & {
    const char* data_ptr = reinterpret_cast<const char*>(&($1->front()));
    $result = PyBuffer_FromMemory((void*)data_ptr, $1->size());
    Py_INCREF($result);
}

/* public data */
%typemap(out) data_chunk {
    const char* data_ptr = reinterpret_cast<const char*>(&($1.front()));
    $result = PyBuffer_FromMemory((void*)data_ptr, $1.size());
    Py_INCREF($result);
}

/* private data */
%typemap(out) libbitcoin::private_data {
    const char* data_ptr = reinterpret_cast<const char*>(&($1.front()));
    $result = PyBuffer_FromMemory((void*)data_ptr, $1.size());
    Py_INCREF($result);
}

