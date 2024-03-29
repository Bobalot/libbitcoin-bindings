namespace libbitcoin {

/*enum block_status
{
    orphan,
    confirmed,
    rejected
};*/

struct block_info
{
    block_status status;
    size_t depth;
};

bool operator==(const block_header_type block_a, const block_header_type& block_b);

uint64_t block_value(size_t depth);
big_number block_work(uint32_t bits);

hash_digest hash_block_header(const block_header_type& block);

index_list block_locator_indexes(int top_depth);

block_type genesis_block();

} // namespace libbitcoin

