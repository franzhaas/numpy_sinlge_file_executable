import sys
from setuptools import setup
#from Cython.Build import cythonize

#if 'setuptools.extension' in sys.modules:
#    m = sys.modules['setuptools.extension']
#    m.Extension.__dict__ = m._Extension.__dict__

from distutils.core import setup, Extension

module1 = Extension('spam_no_extra_incref',
                    sources = ['food2.c'])

module2 = Extension('spam_extra_incref',
                    sources = ['food.c'])


#setup(name="cython_example_fib", ext_modules=cythonstuff, compiler_directives={'embedsignature': True, "emit_code_comments": True})
setup(name="food", ext_modules = [module1, module2] )
