/*
 CB_HANDLER_NONS
 Creates a callback handler for a specific type
*/
%define CB_HANDLER_NONS(type, swigtype)
%inline %{
void python_ ## type ## _cb_handler(PyObject *pyfunc, const std::error_code &ec, const type& blk) {
    PyGILState_STATE gstate;
    gstate = PyGILState_Ensure();
    std::error_code* ec_copy = new std::error_code(ec);
    PyObject *errorobj = SWIG_NewPointerObj(SWIG_as_voidptr(ec_copy), SWIGTYPE_p_std__error_code, SWIG_POINTER_OWN);
    type* result_copy = new type(blk);
    PyObject *resultobj = SWIG_NewPointerObj(result_copy, swigtype , SWIG_POINTER_OWN);

    PyObject *arglist = Py_BuildValue("(OO)", errorobj, resultobj);
    PyObject *result = PyEval_CallObject(pyfunc, arglist);
    Py_DECREF(pyfunc);
    if (result == NULL) {
            PyErr_Print();
    }
    Py_DECREF(arglist);
    PyGILState_Release(gstate);
};
%}
void python_ ## type ## _cb_handler(PyObject *pyfunc, const std::error_code&, const type& blk);
%nothread python_ ## type ## _cb_handler;
%enddef

/*
 CB_HANDLER_NONS
 Creates a callback handler for a specific type
*/
%define CB_HANDLER(type)
%inline %{
void python_ ## type ## _cb_handler(PyObject *pyfunc, const std::error_code &ec, const type& blk) {

    PyGILState_STATE gstate;
    gstate = PyGILState_Ensure();
    std::error_code* ec_copy = new std::error_code(ec);
    PyObject *errorobj = SWIG_NewPointerObj(SWIG_as_voidptr(ec_copy), SWIGTYPE_p_std__error_code, SWIG_POINTER_OWN);
    type* result_copy = new type(blk);
    PyObject *resultobj = SWIG_NewPointerObj(result_copy, SWIGTYPE_p_libbitcoin__ ## type, SWIG_POINTER_OWN);

    PyObject *arglist = Py_BuildValue("(OO)", errorobj, resultobj);
    PyObject *result = PyEval_CallObject(pyfunc, arglist);
    Py_DECREF(pyfunc);
    if (result == NULL) {
            PyErr_Print();
    }
    Py_DECREF(arglist);
    PyGILState_Release(gstate);
};
%}
void python_ ## type ## _cb_handler(PyObject *pyfunc, const std::error_code&, const type& blk);
%nothread python_ ## type ## _cb_handler;
%enddef

/*
  Handler instancing
 */

CB_HANDLER(block_type)
CB_HANDLER(transaction_type)
CB_HANDLER(block_info)

CB_HANDLER_NONS(block_locator_type, SWIGTYPE_p_std__vectorT_std__arrayT_uint8_t_32_t_std__allocatorT_std__arrayT_uint8_t_32_t_t_t)
CB_HANDLER_NONS(inventory_list, SWIGTYPE_p_std__vectorT_libbitcoin__inventory_vector_type_std__allocatorT_libbitcoin__inventory_vector_type_t_t)
CB_HANDLER_NONS(output_point_list, SWIGTYPE_p_std__vectorT_libbitcoin__output_point_std__allocatorT_libbitcoin__output_point_t_t)
CB_HANDLER_NONS(input_point, SWIGTYPE_p_libbitcoin__output_point)
CB_HANDLER_NONS(index_list, SWIGTYPE_p_std__vectorT_size_t_std__allocatorT_size_t_t_t)
CB_HANDLER_NONS(output_value_list, SWIGTYPE_p_std__vectorT_unsigned_long_long_std__allocatorT_unsigned_long_long_t_t)

/* ??? what's this for? */
CB_HANDLER_NONS(get_address_type, SWIGTYPE_p_get_address_type)

/* channel.subscribe_XX */
/* I needed to add libbitcoin__ prefix to get some of these to work. */
CB_HANDLER_NONS(version_type, SWIGTYPE_p_libbitcoin__version_type)
CB_HANDLER_NONS(verack_type, SWIGTYPE_p_libbitcoin__verack_type)
CB_HANDLER_NONS(address_type, SWIGTYPE_p_address_type)
CB_HANDLER_NONS(inventory_type, SWIGTYPE_p_inventory_type)
CB_HANDLER_NONS(get_data_type, SWIGTYPE_p_get_data_type)
CB_HANDLER_NONS(get_blocks_type, SWIGTYPE_p_libbitcoin__get_blocks_type)

/*
*/


/*
 Custom handlers
*/

%{
void python_history_cb_handler(PyObject *pyfunc, const std::error_code &ec,
    const output_point_list& outpoints, const input_point_list& inpoints) {

    PyGILState_STATE gstate;
    gstate = PyGILState_Ensure();
    std::error_code* ec_copy = new std::error_code(ec);
    PyObject *errorobj = SWIG_NewPointerObj(SWIG_as_voidptr(ec_copy), SWIGTYPE_p_std__error_code, SWIG_POINTER_OWN);
    output_point_list* outpl_copy = new output_point_list(outpoints);
    PyObject* outpl_py = SWIG_NewPointerObj(
        outpl_copy,
        SWIGTYPE_p_std__vectorT_libbitcoin__output_point_std__allocatorT_libbitcoin__output_point_t_t,
        SWIG_POINTER_OWN);
    input_point_list* inpl_copy = new input_point_list(inpoints);
    PyObject* inpl_py = SWIG_NewPointerObj(
        inpl_copy,
        SWIGTYPE_p_std__vectorT_libbitcoin__output_point_std__allocatorT_libbitcoin__output_point_t_t,
        SWIG_POINTER_OWN);
    PyObject *arglist = Py_BuildValue("(OOO)", errorobj, outpl_py, inpl_py);
    PyObject *result = PyEval_CallObject(pyfunc, arglist);
    Py_DECREF(pyfunc);
    if (result == NULL) {
            PyErr_Print();
    }
    Py_DECREF(arglist);
    PyGILState_Release(gstate);
}
%}
void python_history_cb_handler(PyObject *pyfunc, const std::error_code &ec,
    const output_point_list& outpoints, const input_point_list& inpoints);
%nothread python_history_cb_handler;

/*
 Python callback with no parameters
 */

%{

void python_cb_handler(PyObject *pyfunc, const std::error_code &ec) {
    PyGILState_STATE gstate;
    gstate = PyGILState_Ensure();
    std::error_code* ec_copy = new std::error_code(ec);
    PyObject *errorobj = SWIG_NewPointerObj(SWIG_as_voidptr(ec_copy), SWIGTYPE_p_std__error_code, SWIG_POINTER_OWN);
    PyObject *arglist = Py_BuildValue("(O)", errorobj);
    PyObject *result = PyEval_CallObject(pyfunc, arglist);
    Py_DECREF(pyfunc);
    if (result == NULL) {
            PyErr_Print();
    }
    Py_DECREF(arglist);
    PyGILState_Release(gstate);
};

void python_size_t_err_cb_handler(PyObject *pyfunc, const std::error_code &ec, const size_t s) {
    PyGILState_STATE gstate;
    gstate = PyGILState_Ensure();
    std::error_code* ec_copy = new std::error_code(ec);
    PyObject *errorobj = SWIG_NewPointerObj(SWIG_as_voidptr(ec_copy), SWIGTYPE_p_std__error_code, SWIG_POINTER_OWN);
    PyObject *arglist = Py_BuildValue("ON", errorobj, PyInt_FromSize_t(s));
    PyObject *result = PyEval_CallObject(pyfunc, arglist);
    Py_DECREF(pyfunc);
    if (result == NULL) {
            PyErr_Print();
    }
    Py_DECREF(arglist);
    PyGILState_Release(gstate);
};


void python_size_t_cb_handler(PyObject *pyfunc, const size_t &s) {
    PyGILState_STATE gstate;
    gstate = PyGILState_Ensure();
    PyObject *arglist = Py_BuildValue("(l)", s);
    PyObject *result = PyEval_CallObject(pyfunc, arglist);
    Py_DECREF(pyfunc);
    if (result == NULL) {
            PyErr_Print();
    }
    Py_DECREF(arglist);
    PyGILState_Release(gstate);
};

void python_reorganize_cb_handler(PyObject *pyfunc, const std::error_code &ec, size_t s,
            const libbitcoin::blockchain::block_list &list1, const libbitcoin::blockchain::block_list &list2) {
    PyGILState_STATE gstate;
    gstate = PyGILState_Ensure();
    std::error_code* ec_copy = new std::error_code(ec);
    PyObject *errorobj = SWIG_NewPointerObj(SWIG_as_voidptr(ec_copy), SWIGTYPE_p_std__error_code, SWIG_POINTER_OWN);
    blockchain::block_list* list1_copy = new blockchain::block_list(list1);
    PyObject *list1obj = SWIG_NewPointerObj(SWIG_as_voidptr(list1_copy), SWIGTYPE_p_std__vectorT_std__shared_ptrT_block_type_t_std__allocatorT_std__shared_ptrT_block_type_t_t_t, SWIG_POINTER_OWN );
    blockchain::block_list* list2_copy = new blockchain::block_list(list2);
    PyObject *list2obj = SWIG_NewPointerObj(SWIG_as_voidptr(list2_copy), SWIGTYPE_p_std__vectorT_std__shared_ptrT_block_type_t_std__allocatorT_std__shared_ptrT_block_type_t_t_t, SWIG_POINTER_OWN );
    PyObject *arglist = Py_BuildValue("(OIOO)", errorobj, s, list1obj, list2obj);
    PyObject *result = PyEval_CallObject(pyfunc, arglist);
    Py_DECREF(pyfunc);
    if (result == NULL) {
            PyErr_Print();
    }
    Py_DECREF(arglist);
    PyGILState_Release(gstate);
};

/*
 Python callback for channel
*/
void python_channel_cb_handler(PyObject *pyfunc, const std::error_code& ec, libbitcoin::channel_ptr channel) {
    PyGILState_STATE gstate;
    gstate = PyGILState_Ensure();

    /* Initialize swig pointers */
    std::error_code* ec_copy = new std::error_code(ec);
    PyObject *errorobj = SWIG_NewPointerObj(SWIG_as_voidptr(ec_copy), SWIGTYPE_p_std__error_code, SWIG_POINTER_OWN);
    PyObject *resultobj = 0;
    libbitcoin::channel_ptr* result_copy = new channel_ptr(channel);
    resultobj = SWIG_NewPointerObj(SWIG_as_voidptr(result_copy), SWIGTYPE_p_std__shared_ptrT_channel_t , SWIG_POINTER_OWN);

    /* Call function */
    PyObject *arglist = Py_BuildValue("(OO)", errorobj, resultobj);
    PyObject *result = PyEval_CallObject(pyfunc, arglist);
    Py_DECREF(pyfunc);
    if (result == NULL) {
            PyErr_Print();
    }
    Py_DECREF(arglist);
    PyGILState_Release(gstate);
};

void python_acceptor_cb_handler(PyObject *pyfunc, const std::error_code& ec, libbitcoin::acceptor_ptr accept) {
    PyGILState_STATE gstate;
    gstate = PyGILState_Ensure();

    /* Initialize swig pointers */
    std::error_code* ec_copy = new std::error_code(ec);
    PyObject *errorobj = SWIG_NewPointerObj(SWIG_as_voidptr(ec_copy), SWIGTYPE_p_std__error_code, SWIG_POINTER_OWN);
    PyObject *resultobj = 0;
    libbitcoin::acceptor_ptr* result_copy = new acceptor_ptr(accept);
    resultobj = SWIG_NewPointerObj(SWIG_as_voidptr(result_copy), SWIGTYPE_p_std__shared_ptrT_acceptor_t , SWIG_POINTER_OWN);

    /* Call function */
    PyObject *arglist = Py_BuildValue("(OO)", errorobj, resultobj);
    PyObject *result = PyEval_CallObject(pyfunc, arglist);
    Py_DECREF(pyfunc);
    if (result == NULL) {
            PyErr_Print();
    }
    Py_DECREF(arglist);
    PyGILState_Release(gstate);
};

%}

void python_cb_handler(PyObject *pyfunc, const std::error_code&);
%nothread python_cb_handler;
void python_size_t_cb_handler(PyObject *pyfunc, const size_t &s);
%nothread python_size_t_cb_handler;
void python_channel_cb_handler(PyObject *pyfunc, const std::error_code& ec, libbitcoin::channel_ptr channel);
%nothread python_channel_cb_handler;
void python_acceptor_cb_handler(PyObject *pyfunc, const std::error_code& ec, libbitcoin::acceptor_ptr accept);
%nothread python_acceptor_cb_handler;
void python_reorganize_cb_handler(PyObject *pyfunc, const std::error_code &ec, size_t s,
            const libbitcoin::blockchain::block_list &list1, const libbitcoin::blockchain::block_list &list2);
%nothread python_reorganize_cb_handler;


/* Declare python callback */

/*
void python_size_cb_handler(PyObject *pyfunc, const std::error_code&, const size_t);
void python_size_size_cb_handler(PyObject *pyfunc, const std::error_code&, size_t, size_t);

void python_inventory_cb_handler(PyObject *pyfunc, const std::error_code&, const inventory_list&);
void python_block_locator_cb_handler(PyObject *pyfunc, const std::error_code&, const block_locator_type&);
void python_transaction_type_cb_handler(PyObject *pyfunc, const std::error_code&, const transaction_type&);
void python_input_point_cb_handler(PyObject *pyfunc, const std::error_code&, const input_point&);
void python_output_point_list_cb_handler(PyObject *pyfunc, const std::error_code&, const output_point_list&);
*/



