%define CB_HANDLER(type)
%inline %{
void python_ ## type ## _cb_handler(PyObject *pyfunc, const std::error_code &ec, const type& blk) {
        PyGILState_STATE gstate;
        gstate = PyGILState_Ensure();
        PyObject *resultobj = SWIG_NewPointerObj((new libbitcoin::type(static_cast< const libbitcoin::type& >(blk))), SWIGTYPE_p_libbitcoin__ ## type , 0 );

        PyObject *arglist = Py_BuildValue("(O)", resultobj);
        PyObject *result = PyEval_CallObject(pyfunc, arglist);
        Py_DECREF(arglist);
        PyGILState_Release(gstate);
};
%}
void python_ ## type ## _cb_handler(PyObject *pyfunc, const std::error_code&, const type& blk);
%nothread python_ ## type ## _cb_handler;
%enddef

%{

/*
 Python callback
*/
void python_cb_handler(PyObject *pyfunc, const std::error_code &ec) {
        PyGILState_STATE gstate;
        gstate = PyGILState_Ensure();
        PyObject *arglist = Py_BuildValue("(I)", ec);
        PyObject *result = PyEval_CallObject(pyfunc, arglist);
        Py_DECREF(arglist);
        PyGILState_Release(gstate);
};

void python_block_cb_handler(PyObject *pyfunc, const std::error_code &ec, const block_type& blk) {
        PyGILState_STATE gstate;
        gstate = PyGILState_Ensure();
        PyObject *resultobj = SWIG_NewPointerObj((new libbitcoin::block_type(static_cast< const libbitcoin::block_type& >(blk))), SWIGTYPE_p_libbitcoin__block_type, 0 );
        Py_INCREF(resultobj);

        PyObject *arglist = Py_BuildValue("(O)", resultobj);
        PyObject *result = PyEval_CallObject(pyfunc, arglist);
        Py_DECREF(arglist);
        PyGILState_Release(gstate);
};

%}

CB_HANDLER(block_type)
CB_HANDLER(transaction_type)

/*
CB_HANDLER(inventory_list)
CB_HANDLER(block_locator)
CB_HANDLER(output_point_list)
*/

/* Declare python callback */
void python_cb_handler(PyObject *pyfunc, const std::error_code&);
void python_block_cb_handler(PyObject *pyfunc, const std::error_code&, const block_type& blk);

/*
void python_size_cb_handler(PyObject *pyfunc, const std::error_code&, const size_t);
void python_size_size_cb_handler(PyObject *pyfunc, const std::error_code&, size_t, size_t);

void python_inventory_cb_handler(PyObject *pyfunc, const std::error_code&, const inventory_list&);
void python_block_locator_cb_handler(PyObject *pyfunc, const std::error_code&, const block_locator_type&);
void python_transaction_type_cb_handler(PyObject *pyfunc, const std::error_code&, const transaction_type&);
void python_input_point_cb_handler(PyObject *pyfunc, const std::error_code&, const input_point&);
void python_output_point_list_cb_handler(PyObject *pyfunc, const std::error_code&, const output_point_list&);
*/

%nothread python_cb_handler;
%nothread python_block_cb_handler;

/* EXTRA CRUFT */

/*%rename(errFunc) std::function<void (const std::error_code&)>;*/

/* Found this on internets, not sure it will be useful */
%ignore boost::noncopyable;
namespace boost {
    class noncopyable {};
}


