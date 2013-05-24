namespace libbitcoin {

class deterministic_wallet
{
public:
 /*   size_t seed_size = 32;*/
    void new_seed();
    bool set_seed(const std::string& seed);
    const std::string& seed() const;

    bool set_master_public_key(const data_chunk& mpk);
    const data_chunk& master_public_key() const;

    data_chunk generate_public_key(size_t n, bool for_change=false) const;

    secret_parameter generate_secret(size_t n, bool for_change=false) const;
};

} // namespace libbitcoin

