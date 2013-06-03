import sys

from bitcoin import threadpool, hosts, handshake, network, protocol, session
from bitcoin import leveldb_blockchain, poller, transaction_pool, create_session_params
from bitcoin import hash_transaction
import time

def print_block(block):
    time.ctime(block.timestamp), block.merkle.encode('hex')

class fullnode(object):
    def __init__(self):
        self._net_pool = threadpool(1)
        self._disk_pool = threadpool(1)
        self._mem_pool = threadpool(1)
        self._hosts = hosts(self._net_pool)
        self._handshake = handshake(self._net_pool)
        self._network = network(self._net_pool)
        self._protocol = protocol(self._net_pool,
                                  self._hosts,
                                  self._handshake,
                                  self._network)
        self._chain = leveldb_blockchain(self._disk_pool)
        self._poller = poller(self._mem_pool, self._chain)
        self._txpool = transaction_pool(self._mem_pool, self._chain)
        pars = create_session_params(self._handshake,
				     self._protocol,
				     self._chain,
				     self._poller,
				     self._txpool)
        self._session = session(self._net_pool, pars)
        print "[fullnode] ok"

    def start(self):
        self._protocol.subscribe_channel(self.monitor_tx)
        self._chain.start('database', self.on_chain_start)
        self._chain.subscribe_reorganize(self.on_reorganize)
        self._txpool.start()
        self._session.start(self.on_session_start)
        print "[fullnode.start] ok"

    def stop(self):
        self._session.stop(self.on_session_stop)
        self._net_pool.stop()
        self._disk_pool.stop()
        self._mem_pool.stop()
        self._net_pool.join()
        self._disk_pool.join()
        self._mem_pool.join()
        self._chain.stop()
        print "[fullnode.stop] ok"

    def on_chain_start(self, ec):
        print "[fullnode.chain] started", ec

    def on_session_stop(self, ec):
        print "[fullnode.session] stopped", ec

    def on_session_start(self, ec):
        print "[fullnode.session] started", ec
        if ec:
            self.stop()
            sys.exit(1)

    def on_reorganize(self, ec, height, arrivals, replaced):
        print '[fullnode.reorganize]', height, str(ec), len(arrivals), len(replaced)
        if len(arrivals):
            print ' arrival', print_block(arrivals[0])
        if len(list2):
            print ' replaced', print_block(arrivals[1])
        self._chain.subscribe_reorganize(self.on_reorganize)

    def monitor_tx(self, node):
        print "(fullnode.tx)", node
        node.subscribe_transaction(lambda ec, tx: self.recv_tx(node, tx, ec))
        self._protocol.subscribe_channel(self.monitor_tx)

    def handle_confirm(self, ec):
        print "(fullnode.store) confirm", ec

    def recv_tx(self, node, tx, ec):
        print "(fullnode.recv_tx)", ec, tx
        if ec:
            print "error", ec
            return
        print ' *', len(tx.inputs), len(tx.outputs)
        self._txpool.store(tx, self.handle_confirm, lambda _ec, u: self.new_unconfirm_valid_tx(node, tx, u, _ec))
        node.subscribe_transaction(lambda _ec, _tx: self.recv_tx(node, _tx, _ec))

    def new_unconfirm_valid_tx(self, node, tx, unconfirmed, ec):
        print "(fullnode.valid_tx)", ec, tx, unconfirmed
        tx_hash = hash_transaction(tx)
        if ec:
            print "Error", ec
        else:
            print "Accepted transaction"
            print unconfirmed.__class__
            if not unconfirmed.empty():
               print "Unconfirmed"
               for idx in unconfirmed: 
                   print ' ', idx
            print tx_hash


if __name__ == '__main__':
    app = fullnode()
    app.start()
    raw_input()
    app.stop()
 
