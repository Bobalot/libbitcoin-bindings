
/* The following doesn't seem to work with current typemap for some reason */
%extend libbitcoin::blockchain {
        void import_block(const block_type& import_block, size_t depth, PyObject *pyfunc) {
                Py_INCREF(pyfunc);
                self->import(import_block, depth, std::bind(python_cb_handler, pyfunc, _1));
        }

        void py_fetch_block_header(size_t depth, PyObject *pyfunc) {
                Py_INCREF(pyfunc);
                self->fetch_block_header(depth, std::bind(python_block_cb_handler, pyfunc, _1, _2));
        }
}
