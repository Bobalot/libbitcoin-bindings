#ifndef LIBBITCOIN_TRANSACTION_POOL_HPP
#define LIBBITCOIN_TRANSACTION_POOL_HPP

#include <functional>
#include <boost/circular_buffer.hpp>

#include <bitcoin/threadpool.hpp>
#include <bitcoin/types.hpp>
#include <bitcoin/primitives.hpp>
#include <bitcoin/blockchain/blockchain.hpp>

namespace libbitcoin {

struct transaction_entry_info
{
    typedef std::function<void (const std::error_code&)> confirm_handler;
    hash_digest hash;
    transaction_type tx;
    confirm_handler handle_confirm;
};

typedef boost::circular_buffer<transaction_entry_info> pool_buffer;

/**
 * Before bitcoin transactions make it into a block, they go into
 * a transaction memory pool. This class encapsulates that functionality
 * performing the neccessary validation of a transaction before accepting
 * it into its internal buffer.
 *
 * The interface has been deliberately kept simple to minimise overhead.
 * This class attempts no tracking of inputs or spends and only provides
 * a store/fetch paradigm. Tracking must be performed externally and make
 * use of store's handle_store and handle_confirm to manage changes in the
 * state of memory pool transactions.
 *
 * @code
 *  threadpool pool(1);
 *  // transaction_pool needs access to the blockchain
 *  blockchain* chain = load_our_backend();
 *  // create and initialize the transaction memory pool
 *  transaction_pool txpool(pool, *chain);
 *  txpool.start();
 * @endcode
 */
class transaction_pool
{
public:
    typedef std::function<
        void (const std::error_code&, const index_list&)> store_handler;

    typedef std::function<
        void (const std::error_code&, const transaction_type&)>
            fetch_handler;

    typedef std::function<void (bool)> exists_handler;

    typedef transaction_entry_info::confirm_handler confirm_handler;

    transaction_pool(threadpool& pool, blockchain& chain);
    void start();


    /// Non-copyable class
    /// Non-copyable class

    /**
     * Attempt to store a transaction.
     *
     * handle_store is called on completion. The second argument is a list
     * of unconfirmed input indexes. These inputs refer to a transaction
     * that is not in the blockchain and is currently in the memory pool.
     *
     * In the case where store results in error::input_not_found, the
     * unconfirmed field refers to the single problematic input.
     *
     * @param[in]   stored_transaction  Transaction to store
     * @param[in]   handle_confirm      Handler for when transaction
     *                                  becomes confirmed.
     * @code
     *  void handle_confirm(
     *      const std::error_code& ec    // Status of operation
     *  );
     * @endcode
     * @param[in]   handle_store        Completion handler for
     *                                  store operation.
     * @code
     *  void handle_store(
     *      const std::error_code& ec,      // Status of operation
     *      const index_list& unconfirmed   // Unconfirmed input indexes
     *  );
     * @endcode
     */
    void store(const transaction_type& stored_transaction,
        confirm_handler handle_confirm, store_handler handle_store);

    /**
     * Fetch transaction by hash.
     *
     * @param[in]   transaction_hash  Transaction's hash
     * @param[in]   handle_fetch      Completion handler for fetch operation.
     * @code
     *  void handle_fetch(
     *      const std::error_code& ec,      // Status of operation
     *      const transaction_type& tx  // Transaction
     *  );
     * @endcode
     */
    void fetch(const hash_digest& transaction_hash,
        fetch_handler handle_fetch);

    /**
     * Is this transaction in the pool?
     *
     * @param[in]   transaction_hash  Transaction's hash
     * @param[in]   handle_exists     Completion handler for exists operation.
     * @code
     *  void handle_exists(bool);
     * @endcode
     */
    void exists(const hash_digest& transaction_hash,
        exists_handler handle_exists);

private:
    void do_store(const transaction_type& stored_transaction,
        confirm_handler handle_confirm, store_handler handle_store);
    void handle_delegate(
        const std::error_code& ec, const index_list& unconfirmed,
        const transaction_entry_info& tx_entry, store_handler handle_store);

    bool tx_exists(const hash_digest& tx_hash);

    void reorganize(const std::error_code& ec,
        size_t fork_point,
        const blockchain::block_list& new_blocks,
        const blockchain::block_list& replaced_blocks);
    void resubmit_all();
    void takeout_confirmed(const blockchain::block_list& new_blocks);
    void try_delete(const hash_digest& tx_hash);

    io_service::strand strand_;
    blockchain& chain_;
    pool_buffer pool_;
};

} // namespace libbitcoin

#endif

