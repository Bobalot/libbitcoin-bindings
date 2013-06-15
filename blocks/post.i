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
}
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
        def version(self):
            return self._get_block_type_unsafe().version
        @property
        def previous_block_hash(self):
            return self._get_block_type_unsafe().previous_block_hash
        @property
        def merkle(self):
            return self._get_block_type_unsafe().merkle
        @property
        def timestamp(self):
            return self._get_block_type_unsafe().timestamp
        @property
        def bits(self):
            return self._get_block_type_unsafe().bits
        @property
        def nonce(self):
            return self._get_block_type_unsafe().nonce
        @property
        def transactions(self):
            return self._get_block_type_unsafe().transactions
%}       
}
