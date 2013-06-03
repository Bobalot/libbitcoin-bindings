
/* The following doesn't seem to work with current typemap for some reason */
%extend libbitcoin::blockchain {
        void import_block(const block_type& import_block, size_t depth, PyObject *pyfunc) {
                Py_INCREF(pyfunc);
                self->import(import_block, depth, std::bind(python_cb_handler, pyfunc, _1));
        }
}
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
            return self.__nonzero__
%}
}
