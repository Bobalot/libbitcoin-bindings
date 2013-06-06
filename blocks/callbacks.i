/*
 CB_HANDLER_NONS
 Creates a callback handler for a specific type
*/
%define CB_HANDLER_NONS(type, swigtype)
%inline %{
void python_ ## type ## _cb_handler(PyObject *pyfunc, const std::error_code &ec, const type& blk) {
        PyGILState_STATE gstate;
        gstate = PyGILState_Ensure();
        PyObject *errorobj = SWIG_NewPointerObj(SWIG_as_voidptr(&ec), SWIGTYPE_p_std__error_code, 0 );
        PyObject *resultobj = SWIG_NewPointerObj((new libbitcoin::type(static_cast< const libbitcoin::type& >(blk))), swigtype , 0 );

        PyObject *arglist = Py_BuildValue("(OO)", errorobj, resultobj);
        PyObject *result = PyEval_CallObject(pyfunc, arglist);
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
        PyObject *errorobj = SWIG_NewPointerObj(SWIG_as_voidptr(&ec), SWIGTYPE_p_std__error_code, 0 );
        PyObject *resultobj = SWIG_NewPointerObj((new libbitcoin::type(static_cast< const libbitcoin::type& >(blk))), SWIGTYPE_p_libbitcoin__ ## type , 0 );

        PyObject *arglist = Py_BuildValue("(OO)", errorobj, resultobj);
        PyObject *result = PyEval_CallObject(pyfunc, arglist);
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

%define CB_HANDLER_NONS_LIST(type, swigtype)
%inline %{
void python_ ## type ## _cb_handler(PyObject *pyfunc, const std::error_code &ec, const type& blk) {
        PyGILState_STATE gstate;
        gstate = PyGILState_Ensure();
        PyObject *errorobj = SWIG_NewPointerObj(SWIG_as_voidptr(&ec), SWIGTYPE_p_std__error_code, 0 );
        PyObject* resultobj = PyTuple_New(blk.size());
        for (size_t i = 0; i < blk.size(); ++i)
        {
            const hash_digest& hash = blk[i].hash;
            const char* hash_ptr = reinterpret_cast<const char*>(hash.data());
            PyObject *item = PyTuple_New(2);
            PyObject *pyhash = PyString_FromStringAndSize(hash_ptr, hash.size());
            PyObject *pyidx = PyInt_FromSize_t(blk[i].index);
            PyTuple_SetItem(item, 0, pyhash);
            PyTuple_SetItem(item, 1, pyidx);
            PyTuple_SetItem(resultobj, i, item);
        }
        PyObject *arglist = Py_BuildValue("(OO)", errorobj, resultobj);
        PyObject *result = PyEval_CallObject(pyfunc, arglist);
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

CB_HANDLER_NONS(block_locator_type, SWIGTYPE_p_block_locator_type)
CB_HANDLER_NONS(inventory_list, SWIGTYPE_p_inventory_list)
CB_HANDLER_NONS_LIST(output_point_list, SWIGTYPE_p_output_point)
CB_HANDLER_NONS(address_type, SWIGTYPE_p_address_type)
CB_HANDLER_NONS(get_address_type, SWIGTYPE_p_get_address_type)
CB_HANDLER_NONS(input_point, SWIGTYPE_p_input_point)
CB_HANDLER_NONS(index_list, SWIGTYPE_p_std__vectorT_size_t_std__allocatorT_size_t_t_t)

/* channel.subscribe_XX */
CB_HANDLER_NONS(version_type, SWIGTYPE_p_version_type)
CB_HANDLER_NONS(verack_type, SWIGTYPE_p_verack_type)
CB_HANDLER_NONS(inventory_type, SWIGTYPE_p_inventory_type)
CB_HANDLER_NONS(get_data_type, SWIGTYPE_p_get_data_type)
CB_HANDLER_NONS(get_blocks_type, SWIGTYPE_p_get_blocks_type)

/*
*/


/*
 Custom handlers
*/


%{

/*
 Python callback with no parameters
 */

void python_cb_handler(PyObject *pyfunc, const std::error_code &ec) {
        PyGILState_STATE gstate;
        gstate = PyGILState_Ensure();
        PyObject *errorobj = SWIG_NewPointerObj(SWIG_as_voidptr(&ec), SWIGTYPE_p_std__error_code, 0 );
        PyObject *arglist = Py_BuildValue("(O)", errorobj);
        PyObject *result = PyEval_CallObject(pyfunc, arglist);
        if (result == NULL) {
                PyErr_Print();
        }
        Py_DECREF(arglist);
        PyGILState_Release(gstate);
};

void python_size_t_err_cb_handler(PyObject *pyfunc, const std::error_code &ec, const size_t s) {
        PyGILState_STATE gstate;
        gstate = PyGILState_Ensure();
        PyObject *errorobj = SWIG_NewPointerObj(SWIG_as_voidptr(&ec), SWIGTYPE_p_std__error_code, 0 );
        PyObject *arglist = Py_BuildValue("ON", errorobj, PyInt_FromSize_t(s));
        PyObject *result = PyEval_CallObject(pyfunc, arglist);
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
        PyObject *errorobj = SWIG_NewPointerObj(SWIG_as_voidptr(&ec), SWIGTYPE_p_std__error_code, 0 );
        PyObject *list1obj = SWIG_NewPointerObj(SWIG_as_voidptr(&list1), SWIGTYPE_p_std__vectorT_std__shared_ptrT_block_type_t_std__allocatorT_std__shared_ptrT_block_type_t_t_t, 0 );
        PyObject *list2obj = SWIG_NewPointerObj(SWIG_as_voidptr(&list2), SWIGTYPE_p_std__vectorT_std__shared_ptrT_block_type_t_std__allocatorT_std__shared_ptrT_block_type_t_t_t, 0 );
        PyObject *arglist = Py_BuildValue("(OIOO)", errorobj, s, list1obj, list2obj);
        PyObject *result = PyEval_CallObject(pyfunc, arglist);
        if (result == NULL) {
                PyErr_Print();
        }
        Py_DECREF(arglist);
        PyGILState_Release(gstate);
};


/*
 Python callback for channel
*/
void python_channel_cb_handler(PyObject *pyfunc, libbitcoin::channel_ptr channel) {
        PyGILState_STATE gstate;
        gstate = PyGILState_Ensure();

        /* Initialize swig pointers */
        PyObject *resultobj = 0;
        resultobj = SWIG_NewPointerObj(SWIG_as_voidptr(channel.get()), SWIGTYPE_p_libbitcoin__channel, 0 );

        /* Call function */
        PyObject *arglist = Py_BuildValue("(O)", resultobj);
        PyObject *result = PyEval_CallObject(pyfunc, arglist);
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
void python_channel_cb_handler(PyObject *pyfunc, libbitcoin::channel_ptr channel);
%nothread python_channel_cb_handler;
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



