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
        self.report("[fullnode] ok")

    def report(self, text, *args):
        print str(text) + " ".join(map(lambda s: str(s), args))

    def start(self):
        self._protocol.subscribe_channel(self.monitor_tx)
        self._chain.start('database', self.on_chain_start)
        self._chain.subscribe_reorganize(self.on_reorganize)
        self._txpool.start()
        self._session.start(self.on_session_start)
        self.report("[fullnode.start] ok")

    def stop(self):
        self._session.stop(self.on_session_stop)
        self._net_pool.stop()
        self._disk_pool.stop()
        self._mem_pool.stop()
        self._net_pool.join()
        self._disk_pool.join()
        self._mem_pool.join()
        self._chain.stop()
        self.report("[fullnode.stop] ok")

    def on_chain_start(self, ec):
        self.report("[fullnode.chain] started ", ec)

    def on_session_stop(self, ec):
        self.report("[fullnode.session] stopped", ec)

    def on_session_start(self, ec):
        self.report("[fullnode.session] started", ec)
        if ec:
            self.stop()
            sys.exit(1)

    def on_reorganize(self, ec, height, arrivals, replaced):
        self.report('[fullnode.reorganize]', height, str(ec), len(arrivals), len(replaced))
        if len(arrivals):
            self.report(' arrival', print_block(arrivals[0]))
        if len(replaced):
            self.report(' replaced', print_block(arrivals[1]))
        self._chain.subscribe_reorganize(self.on_reorganize)

    def monitor_tx(self, node):
        self.report("(fullnode.tx)", node)
        node.subscribe_transaction(lambda ec, tx: self.recv_tx(node, tx, ec))
        self._protocol.subscribe_channel(self.monitor_tx)

    def handle_confirm(self, ec):
        self.report("(fullnode.store) confirm", ec)

    def recv_tx(self, node, tx, ec):
        self.report("(fullnode.recv_tx)", ec, tx)
        if ec:
            self.report("error", ec)
            return
        self.report(' *', len(tx.inputs), len(tx.outputs))
        self._txpool.store(tx, self.handle_confirm, lambda _ec, u: self.new_unconfirm_valid_tx(node, tx, u, _ec))
        node.subscribe_transaction(lambda _ec, _tx: self.recv_tx(node, _tx, _ec))

    def new_unconfirm_valid_tx(self, node, tx, unconfirmed, ec):
        self.report("(fullnode.valid_tx)", ec, tx, unconfirmed)
        tx_hash = hash_transaction(tx)
        if ec:
            self.report("Error", ec)
        else:
            self.report("Accepted transaction")
            self.report(unconfirmed.__class__)
            if not unconfirmed.empty():
                self.report("Unconfirmed")
                for idx in unconfirmed:
                    self.report(' ', idx)
            self.report(tx_hash)


if __name__ == '__main__':
    app = fullnode()
    app.start()
    try:
        raw_input()
    except KeyboardInterrupt:
        pass
    app.stop()
