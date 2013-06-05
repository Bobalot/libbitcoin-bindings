namespace std {
    template <typename Type, size_t Size>
    struct array
    {
    };
}

/* primitives.hpp */
%template(py_hash_digest) std::array<uint8_t, 32>;
%template(py_block_locator_type) std::vector<std::array<uint8_t, 32> >;
%template(py_inventory_list) std::vector<libbitcoin::inventory_vector_type>;
%template(py_input_point_list) std::vector<libbitcoin::output_point>;
/* aliased with input_point: %template(py_output_point_list) std::vector<output_point>; */
%template(py_transaction_input_list) std::vector<libbitcoin::transaction_input_type>;
%template(py_transaction_output_list) std::vector<libbitcoin::transaction_output_type>;

%template(py_transaction_list) std::vector<libbitcoin::transaction_type>;

/* through typemap: %template(py_data_chunk) std::vector<libbitcoin::byte>; */
%template(py_network_address_list) std::vector<libbitcoin::network_address_type>;

%template(sh_block_type) std::shared_ptr<block_type>;
%template(py_block_list) std::vector<std::shared_ptr<block_type> >;

/* types.hpp */
%template(py_size_list) std::vector<size_t>;


