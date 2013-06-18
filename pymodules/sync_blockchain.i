%pythoncode %{

class SyncBlockchain(object):

    def __init__(self, chain):
        self._chain = chain

def create_getter(cls, name):
    def method(self, *args):
        future = Future()
        args = args + (future,)
        getattr(self._chain, name)(*args)
        return future.get()
    setattr(cls, name, method)

def create_composed_getter(cls, name):
    def method(self, *args):
        future = Future()
        args = (self._chain,) + args + (future,)
        globals()[name](*args)
        return future.get()
    setattr(cls, name, method)

create_getter(SyncBlockchain, "fetch_block_header")
create_getter(SyncBlockchain, "fetch_block_transaction_hashes")
create_getter(SyncBlockchain, "fetch_block_depth")
create_getter(SyncBlockchain, "fetch_last_depth")
create_getter(SyncBlockchain, "fetch_transaction")
create_getter(SyncBlockchain, "fetch_transaction_index")
create_getter(SyncBlockchain, "fetch_spend")
create_getter(SyncBlockchain, "fetch_outputs")
create_composed_getter(SyncBlockchain, "fetch_block")
create_composed_getter(SyncBlockchain, "fetch_locator")
create_composed_getter(SyncBlockchain, "fetch_history")
create_composed_getter(SyncBlockchain, "fetch_output_values")

%}

