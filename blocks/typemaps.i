
%typemap(in) std::function<void (const std::error_code, const libbitcoin::block_type)> {
    Py_INCREF($input);
    $1 = std::bind(python_block_type_cb_handler, $input, _1, _2);
}

%typemap(in) std::function<void (std::shared_ptr< libbitcoin::channel >)> {
    Py_INCREF($input);
    $1 = std::bind(python_channel_cb_handler, $input, _1);
}


%typemap(in) libbitcoin::blockchain::fetch_handler_block_header {
    Py_INCREF($input);
    $1 = std::bind(python_block_type_cb_handler, $input, _1, _2);
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

