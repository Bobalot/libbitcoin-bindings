/* blockchain.hpp */
typedef libbitcoin::output_point input_point;
#if defined(SWIGWORDSIZE64)
    %template(py_output_value_list) std::vector<long unsigned int>;
    /* disabled */
    /* typedef std::vector<long unsigned int> output_value_list; */
#else
    %template(py_output_value_list) std::vector<long long unsigned int>;
    /* disabled */
    /* typedef std::vector<long long unsigned int> output_value_list; */
#endif
/* primitives.hpp */
%template(py_short_hash) std::array<uint8_t, 20>;
typedef std::array<uint8_t, 20> short_hash;
%template(py_hash_digest) std::array<uint8_t, 32>;
typedef std::array<uint8_t, 32> hash_digest;
%template(py_hash_digest_list) std::vector<std::array<uint8_t, 32> >;
typedef std::vector<std::array<uint8_t, 32> > hash_digest_list;
typedef hash_digest_list block_locator_type;
%template(py_inventory_list) std::vector<libbitcoin::inventory_vector_type>;
typedef std::vector<libbitcoin::inventory_vector_type> inventory_list;
%template(py_input_point_list) std::vector<libbitcoin::output_point>;
typedef std::vector<libbitcoin::output_point> output_point_list;
/* aliased with input_point: %template(py_output_point_list) std::vector<output_point>; */
%template(py_transaction_input_list) std::vector<libbitcoin::transaction_input_type>;
%template(py_transaction_output_list) std::vector<libbitcoin::transaction_output_type>;

%template(py_transaction_list) std::vector<libbitcoin::transaction_type>;

/* through typemap: %template(py_data_chunk) std::vector<libbitcoin::byte>; */
%template(py_network_address_list) std::vector<libbitcoin::network_address_type>;

%template(sh_block_type) std::shared_ptr<block_type>;
%template(py_block_list) std::vector<std::shared_ptr<block_type> >;

%template(sh_channel) std::shared_ptr<channel>;
%template(sh_acceptor) std::shared_ptr<acceptor>;

/* types.hpp */
%template(py_size_list) std::vector<size_t>;


