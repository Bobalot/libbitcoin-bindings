#include <vector>

#include <bitcoin/types.hpp>
#include <bitcoin/utility/big_number.hpp>

namespace libbitcoin {

struct transaction_type;

struct operation
{
    opcode code;
    data_chunk data;
};

typedef std::vector<operation> operation_stack;

class script
{
public:
    void join(const script& other);
    void push_operation(operation oper);
    bool run(script input_script, const transaction_type& parent_tx,
        uint32_t input_index, bool bip16_enabled=true);

    payment_type type() const;

    const operation_stack& operations() const;

    static hash_digest generate_signature_hash(
        transaction_type parent_tx, uint32_t input_index,
        const script& script_code, uint32_t hash_type);

private:
    typedef std::vector<data_chunk> data_stack;

    class conditional_stack
    {
    public:
        bool closed() const;
        bool has_failed_branches() const;

        void clear();
        void open(bool value);
        void else_();
        void close();
    private:
        typedef std::vector<bool> bool_stack;
        bool_stack stack_;
    };

    bool run(const transaction_type& parent_tx, uint32_t input_index);
    bool next_step(operation_stack::iterator it,
        const transaction_type& parent_tx, uint32_t input_index);
    bool run_operation(const operation& op, 
        const transaction_type& parent_tx, uint32_t input_index);

    // Used by add, sub, mul, div, mod, lshift, rshift, booland, boolor,
    // numequal, numequalverify, numnotequal, lessthan, greaterthan,
    // lessthanorequal, greaterthanorequal, min, max
    bool arithmetic_start(big_number& number_a, big_number& number_b);

    bool op_negative_1();
    bool op_x(opcode code);
    bool op_if();
    bool op_notif();
    bool op_else();
    bool op_endif();
    bool op_verify();
    bool op_toaltstack();
    bool op_fromaltstack();
    bool op_2drop();
    bool op_2dup();
    bool op_3dup();
    bool op_2over();
    bool op_2rot();
    bool op_2swap();
    bool op_ifdup();
    bool op_depth();
    bool op_drop();
    bool op_dup();
    bool op_nip();
    bool op_over();
    bool op_pick();
    bool op_roll();
    bool op_rot();
    bool op_swap();
    bool op_tuck();
    bool op_size();
    bool op_equal();
    bool op_equalverify();
    bool op_1add();
    bool op_1sub();
    bool op_negate();
    bool op_abs();
    bool op_not();
    bool op_0notequal();
    bool op_add();
    bool op_sub();
    bool op_booland();
    bool op_boolor();
    bool op_numequal();
    bool op_numequalverify();
    bool op_numnotequal();
    bool op_lessthan();
    bool op_greaterthan();
    bool op_lessthanorequal();
    bool op_greaterthanorequal();
    bool op_min();
    bool op_max();
    bool op_within();
    bool op_ripemd160();
    bool op_sha1();
    bool op_sha256();
    bool op_hash160();
    bool op_hash256();
    // op_checksig is a specialised case of op_checksigverify
    bool op_checksig(
        const transaction_type& parent_tx, uint32_t input_index);
    bool op_checksigverify(
        const transaction_type& parent_tx, uint32_t input_index);
    // multisig variants
    bool read_section(data_stack& section);
    bool op_checkmultisig(
        const transaction_type& parent_tx, uint32_t input_index);
    bool op_checkmultisigverify(
        const transaction_type& parent_tx, uint32_t input_index);

    data_chunk pop_stack();

    operation_stack operations_;
    // Used when executing the script
    data_stack stack_, alternate_stack_;
    operation_stack::iterator codehash_begin_;
    conditional_stack conditional_stack_;
};

std::string opcode_to_string(opcode code);
opcode string_to_opcode(const std::string& code_repr);
std::string pretty(const script& source_script);
std::ostream& operator<<(std::ostream& stream, const script& source_script);

script coinbase_script(const data_chunk& raw_script);
script parse_script(const data_chunk& raw_script);
data_chunk save_script(const script& scr);
size_t script_size(const script& scr);

} // namespace libbitcoin
