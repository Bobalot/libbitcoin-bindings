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

%include "blocks/typemaps.i"
%include "blocks/templates.i"
%include "blocks/pre.i"

/* Header files we want to wrap */
%include "bitcoin/utility/elliptic_curve_key.hpp"
%include "bitcoin/types.hpp"
%include "modules/primitives.i"


%include "modules/block.i"
%include "modules/threadpool.i"
%include "modules/blockchain.i"
%include "modules/leveldb.i"
%include "modules/deterministic.i"

%include "blocks/post.i"

