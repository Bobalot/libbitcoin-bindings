import bitcoin
import sys

port = 8369

def listening_started(ec, acceptor):
    if ec:
        print >> sys.stderr, str(ec)
        return
    acceptor.accept(
        lambda ec, node: accepted(ec, node, acceptor))

def accepted(ec, node, acceptor):
    if ec:
        print >> sys.stderr, str(ec)
        return
    print "Accepted connection!"
    node.subscribe_stop(node_stopped)
    node.subscribe_version(version_received)
    acceptor.accept(
        lambda ec, node: accepted(ec, node, acceptor))

def version_received(ec, ver):
    if ec:
        print >> sys.stderr, str(ec)
        return
    print "User agent:", ver.user_agent

def node_stopped(ec):
    if ec:
        print >> sys.stderr, str(ec)
        return

# ------------------------

def connect_started(ec, node):
    if ec:
        print >> sys.stderr, str(ec)
        return
    version = bitcoin.version_type()
    version.version = 60000
    version.services = 1
    version.address_me.services = version.services
    # Ignore version.address_me.ip
    version.address_me.port = 8333
    version.address_you.services = version.services
    # Ignore version.address_you.ip
    version.address_you.port = 8333
    # Set the user agent.
    version.user_agent = "/libbitcoin/connect-test/"
    version.start_depth = 0
    version.nonce = 1234
    node.send(version, version_sent)

def version_sent(ec):
    if ec:
        print >> sys.stderr, str(ec)
        return
    print "Version sent."

def main():
    pool = bitcoin.threadpool(2)
    net = bitcoin.network(pool)
    net.listen(port, listening_started)
    raw_input()
    net.connect("localhost", port, connect_started)
    raw_input()
    pool.stop()
    pool.join()

if __name__ == "__main__":
    main()

