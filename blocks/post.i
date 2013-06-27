/*
 Additions to error_code for more pythonic behaviour.

 TODO Make those functions into properties
*/
%extend std::error_code {
%pythoncode {
        def __repr__(self):
            return "error_code(%d, '%s')" % (self.value(), self.message())
        def __str__(self):
            return self.message()
        def __int__(self):
            return self.value()
        def __nonzero__(self):
            return self.value() != 0
        def __bool__(self):
            return self.__nonzero__()
%}
}

%extend std::array<uint8_t, 32> {
    void copy(const char* arrdat) {
        std::copy(arrdat, arrdat + 32, self->data());
    }
    std::string raw() {
        return std::string(self->begin(), self->end());
    }
}


%extend libbitcoin::output_point {
%pythoncode {
    @property
    def hash(self):
        return self.hash_inst.raw()
    @hash.setter
    def hash(self, str_hash):
        self.hash_inst.copy(str_hash)
    def __repr__(self):
        return "<%s:%s>" % (self.hash.encode("hex"), self.index)
    def is_null(self):
        return self.hash == "\0" * 32
}
}

%extend std::shared_ptr<channel> {
    libbitcoin::channel* _get_channel_unsafe() {
        return self->get();
    }

    void send_version(libbitcoin::version_type& packet,
        libbitcoin::channel_proxy::send_handler handler)
    {
        return (*self)->send(packet, handler);
    }
%pythoncode {
    def subscibe_transaction(self, handler):
        return self._get_channel_unsafe().subscribe_transaction(handler)

    def stop(self):
        return self._get_channel_unsafe().stop()
    def stopped(self):
        return self._get_channel_unsafe().stopped()

    # Send needs to be sorted somehow
    def send(self, packet, handler):
        return self.send_version(packet, handler)

    def send_raw(self, header, payload, handler):
        return self._get_channel_unsafe().send_raw(header, payload, handler)

    def subscribe_version(self, handler):
        return self._get_channel_unsafe().subscribe_version(handler)
    def subscribe_verack(self, handler):
        return self._get_channel_unsafe().subscribe_verack(handler)
    def subscribe_address(self, handler):
        return self._get_channel_unsafe().subscribe_address(handler)
    def subscribe_get_address(self, handler):
        return self._get_channel_unsafe().subscribe_get_address(handler)
    def subscribe_inventory(self, handler):
        return self._get_channel_unsafe().subscribe_inventory(handler)
    def subscribe_get_data(self, handler):
        return self._get_channel_unsafe().subscribe_get_data(handler)
    def subscribe_get_blocks(self, handler):
        return self._get_channel_unsafe().subscribe_get_blocks(handler)
    def subscribe_transaction(self, handler):
        return self._get_channel_unsafe().subscribe_transaction(handler)
    def subscribe_block(self, handler):
        return self._get_channel_unsafe().subscribe_block(handler)
    def subscribe_raw(self, handler):
        return self._get_channel_unsafe().subscribe_raw(handler)
    def subscribe_stop(self, handler):
        return self._get_channel_unsafe().subscribe_stop(handler)
%}
}

%extend std::shared_ptr<acceptor> {
    libbitcoin::acceptor* _get_acceptor_unsafe() {
        return self->get();
    }
%pythoncode {
    def accept(self, handler):
        return self._get_acceptor_unsafe().accept(handler)
%}
}

/*
 Additions to shared pointer for block type so we can access the
 internal properties.
 Swig doesn't know about the smart pointer and otherwise returns
 a blind object.

 Using the following we get the values as properties.

 TODO Find a better way of doing this
*/

%extend std::shared_ptr<block_type> {
        libbitcoin::block_type *_get_block_type_unsafe() {
                return self->get();
        }
%pythoncode {
        #this would do it but then not introspection...
        #def __getattr__(self, name):
        #    return getattr(self._get_block_type_unsafe(),  name)

        @property
        def header(self):
            return self._get_block_type_unsafe().header
        @header.setter
        def header(self, head):
            self._get_block_type_unsafe().header = head

        @property
        def transactions(self):
            return self._get_block_type_unsafe().transactions
%}       
}
