%module bitcoin

%include <stdint.i>
%include <std_vector.i>
%include <std_string.i>
%include <std_shared_ptr.i>
%include <typemaps.i>

/* Headers and declarations for our output c++ program */
%{

#include "bitcoin/bitcoin.hpp"

using std::shared_ptr;
using boost::asio::io_service;
using boost::asio::ip::tcp;
using namespace libbitcoin;
using std::placeholders::_1;
using std::placeholders::_2;

%}

%ignore libbitcoin::hosts::hosts(threadpool &,size_t);

%include "blocks/typemaps.i"
%include "blocks/templates.i"

%apply libbitcoin::threadpool & { libbitcoin::threadpool * };
%apply libbitcoin::blockchain & { libbitcoin::blockchain * };
%apply libbitcoin::leveldb_blockchain & { libbitcoin::leveldb_blockchain * };
%apply libbitcoin::channel & { libbitcoin::channel * };
%apply libbitcoin::transaction_type & { libbitcoin::transaction_type * };
%apply libbitcoin::handshake & { libbitcoin::handshake * };

%include "blocks/pre.i"
%include "blocks/callbacks.i"

%include "bitcoin/types.hpp"
namespace libbitcoin {
    typedef std::vector<size_t> index_list;
}
%include "modules/error_code.i"
%include "modules/primitives.i"

%include "modules/threadpool.i"
/* Header files we want to wrap */
%include "modules/hosts.i"
%include "modules/handshake.i"
%include "modules/network.i"
%include "modules/channel.i"

typedef std::shared_ptr<libbitcoin::channel> channel_ptr;
%template(py_channel_ptr) std::shared_ptr<libbitcoin::channel>;

%include "modules/protocol.i"
%include "bitcoin/utility/elliptic_curve_key.hpp"

%include "modules/block.i"
%include "modules/blockchain.i"
%include "modules/leveldb.i"

%include "bitcoin/transaction.hpp"
%include "modules/transaction_pool.i"

%include "bitcoin/poller.hpp"
%apply libbitcoin::poller & { libbitcoin::poller * };

%ignore libbitcoin::session_params::handshake_;
%ignore libbitcoin::session_params::protocol_;
%ignore libbitcoin::session_params::blockchain_;
%ignore libbitcoin::session_params::poller_;
%ignore libbitcoin::session_params::transaction_pool_;
%nodefaultctor session_params;
%include "bitcoin/session.hpp"

%{

namespace libbitcoin {
const session_params *create_session_params( handshake& handshake_, protocol& protocol_, blockchain& blockchain_, poller& poller_, transaction_pool& transaction_pool_) {
    return new session_params({handshake_, protocol_, blockchain_, poller_, transaction_pool_});
}
}

%}

namespace libbitcoin {
const session_params *create_session_params( handshake& handshake_, protocol& protocol_, blockchain& blockchain_, poller& poller_, transaction_pool& transaction_pool_);
}

%include "modules/deterministic.i"

%include "blocks/post.i"

