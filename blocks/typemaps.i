%define CB_BLOCKCHAIN_TYPEMAP(handler, type)
%typemap(in) libbitcoin::blockchain::fetch_handler_ ## handler {
    Py_INCREF($input);
    $1 = std::bind(python_ ## type ## _cb_handler, $input, _1, _2);
}
%enddef

%define CB_BLOCKCHAIN_TYPEMAP0(handler, type)
%typemap(in) libbitcoin::blockchain::fetch_handler_ ## handler {
    Py_INCREF($input);
    $1 = std::bind(python_ ## type ## _cb_handler, $input, _1);
}
%enddef

%define CB_TYPEMAP1(handler, type)
%typemap(in) std::function<void (const std::error_code&, const handler&)> {
    Py_INCREF($input);
    $1 = std::bind(python_ ## type ## _cb_handler, $input, _1, _2);
}
%enddef

%typemap(typecheck) libbitcoin::blockchain::fetch_handler_block_header {
   $1 = PyCallable_Check($input) ? 1 : 0;
}
%typemap(typecheck) libbitcoin::blockchain::fetch_handler_block_transaction_hashes {
   $1 = PyCallable_Check($input) ? 1 : 0;
}

/* txpool.store */
CB_TYPEMAP1(libbitcoin::index_list, index_list)
CB_TYPEMAP1(block_info, block_info)
/* node.subscribe_transaction
   blockchain.fetch_transaction */
CB_TYPEMAP1(libbitcoin::transaction_type, transaction_type)
/* channel.subscribe_address */
CB_TYPEMAP1(libbitcoin::address_type, address_type)
/* channel.subscribe_get_address */
CB_TYPEMAP1(libbitcoin::get_address_type, get_address_type)
/* channel.subscribe_version(receive_version_handler */
/* channel.subscribe_veack(receive_version_handler */
CB_TYPEMAP1(libbitcoin::version_type, version_type)
CB_TYPEMAP1(libbitcoin::verack_type, verack_type)
/* channel.subscribe_inventory */
CB_TYPEMAP1(libbitcoin::inventory_type, inventory_type)
/* channel.subscribe_get_data */
CB_TYPEMAP1(libbitcoin::get_data_type, get_data_type)
/* channel.subscribe_get_blocks */
CB_TYPEMAP1(libbitcoin::get_blocks_type, get_blocks_type)
/* channel.subscribe_block */
CB_TYPEMAP1(block_type, block_type)
CB_TYPEMAP1(libbitcoin::block_type, block_type)

/* composed operations for blockchain */
%typemap(in) libbitcoin::blockchain_fetch_handler_history {
    Py_INCREF($input);
    $1 = std::bind(python_history_cb_handler, $input, _1, _2, _3);
}

%typemap(in) libbitcoin::blockchain_fetch_handler_output_values {
    Py_INCREF($input);
    $1 = std::bind(python_output_value_list_cb_handler, $input, _1, _2);
}
%typemap(in) std::function<void (const std::error_code&, const libbitcoin::block_header_type&)> {
    Py_INCREF($input);
    $1 = std::bind(python_block_header_cb_handler, $input, _1, _2);
}

/*
 TODO channel.subscribe_raw(receive_raw_handler
*/
/* TODO blockchain.fetch_block_depth */
/* TODO blockchain.fetch_last_depth */
/*CB_TYPEMAP0(size_t, size_t)*/

%typemap(in) std::function<void (const std::error_code&, size_t,
            const libbitcoin::blockchain::block_list&, const libbitcoin::blockchain::block_list&)> {
    Py_INCREF($input);
    $1 = std::bind(python_reorganize_cb_handler, $input, _1, _2, _3, _4);
}


%define CB_TYPEMAP_SHAREDPTR(type)
%typemap(in) std::function<void (const std::error_code&, std::shared_ptr< libbitcoin::type >)> {
    Py_INCREF($input);
    $1 = std::bind(python_ ## type ## _cb_handler, $input, _1, _2);
}
%enddef

CB_TYPEMAP_SHAREDPTR(channel)
CB_TYPEMAP_SHAREDPTR(acceptor)

/* Blockchain */
/* blockchain.fetch_block_transaction_hashes */
CB_BLOCKCHAIN_TYPEMAP(block_transaction_hashes, hash_digest_list)
CB_BLOCKCHAIN_TYPEMAP(block_locator, block_locator)
/* blockchain.fetch_block_header */
CB_BLOCKCHAIN_TYPEMAP(block_header, block_header_type)
/* blockchain.fetch_spend */
CB_BLOCKCHAIN_TYPEMAP(spend, input_point)
/* blockchain.fetch_outputs */
CB_BLOCKCHAIN_TYPEMAP(outputs, output_point_list)
/*CB_BLOCKCHAIN_TYPEMAP0(last_depth, size_t)
CB_BLOCKCHAIN_TYPEMAP0(block_depth, size_t)*/

%typemap(in) libbitcoin::blockchain::fetch_handler_transaction_index {
    Py_INCREF($input);
    $1 = std::bind(python_txidx_cb_handler, $input, _1, _2, _3);
}

/* TODO blockchain.subscribe_reorganize */

/* Error codes */
%typemap(in) std::function<void (const std::error_code&, size_t)> {
    Py_INCREF($input);
    $1 = std::bind(python_size_t_err_cb_handler, $input, _1, _2);
}

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

%define HASH_TYPEMAP(hash_type, hash_size)

%typemap(typecheck) const libbitcoin::hash_type& {
   $1 = PyString_Check($input) ? 1 : 0;
}

%typemap(in) const libbitcoin::hash_type& {
    hash_type* digest = new hash_type;
    char* data_ptr;
    Py_ssize_t data_size = hash_size;
    $1 = digest;
    PyString_AsStringAndSize($input, &data_ptr, &data_size);
    memcpy($1->data(), data_ptr, data_size);
}
%typemap(freearg) const libbitcoin::hash_type& {
    delete $1;
}
%typemap(out) const libbitcoin::hash_type& {
    const char* data_ptr = reinterpret_cast<const char*>($1->data());
    $result = PyString_FromStringAndSize(data_ptr, $1->size());
}
%typemap(out) libbitcoin::hash_type {
    const char* data_ptr = reinterpret_cast<const char*>($1.data());
    $result = PyString_FromStringAndSize(data_ptr, $1.size());
}

%enddef

HASH_TYPEMAP(short_hash, 20)
HASH_TYPEMAP(hash_digest, 32)

/*
%typemap(in) std::array<uint8_t, 32> {
    char* data_ptr;
    Py_ssize_t data_size = 32;
    PyString_AsStringAndSize($input, &data_ptr, &data_size);
    memcpy($1.data(), data_ptr, data_size);
}
*/

/* Convert from C --> Python */
/*
%typemap(out) std::array<uint8_t, 32> {
    const char* data_ptr = reinterpret_cast<const char*>($1.data());
    $result = PyString_FromStringAndSize(data_ptr, $1.size());
}
*/

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

