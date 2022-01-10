#include <Python.h>

static int spam_exec(PyObject *module) {
    PyModule_AddStringConstant(module, "food", "spam");
    return 0;
}

#ifdef Py_mod_exec
static PyModuleDef_Slot spam_slots[] = {
    {Py_mod_exec, spam_exec},
    {0, NULL}
};
#endif

static PyModuleDef spam_def = {
    PyModuleDef_HEAD_INIT,                      /* m_base */
    "spam",                                     /* m_name */
    PyDoc_STR("Utilities for cooking spam"),    /* m_doc */
    0,                                          /* m_size */
    NULL,                                       /* m_methods */
#ifdef Py_mod_exec
    spam_slots,                                 /* m_slots */
#else
    NULL,
#endif
    NULL,                                       /* m_traverse */
    NULL,                                       /* m_clear */
    NULL,                                       /* m_free */
};

PyMODINIT_FUNC
PyInit_spam_extra_incref(void) {
#ifdef Py_mod_exec
    PyObject *module;
    module =  PyModuleDef_Init(&spam_def);
    Py_INCREF(module);
    return module;
#else
    PyObject *module;
    module = PyModule_Create(&spam_def);
    if (module == NULL) return NULL;
    if (spam_exec(module) != 0) {
        Py_DECREF(module);
        return NULL;
    }
    return module;
#endif
}
