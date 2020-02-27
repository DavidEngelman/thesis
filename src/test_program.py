import llvmlite.ir as ll
import llvmlite.binding as llvm
import sys
from ctypes import *



def create_execution_engine():
    """
    Create an ExecutionEngine suitable for JIT code generation on
    the host CPU.  The engine is reusable for an arbitrary number of
    modules.
    """
    # Create a target machine representing the host
    target = llvm.Target.from_default_triple()
    target_machine = target.create_target_machine()
    # And an execution engine with an empty backing module
    backing_mod = llvm.parse_assembly("")
    engine = llvm.create_mcjit_compiler(backing_mod, target_machine)
    return engine

def compile_ir(engine, llvm_ir):
    """
    Compile the LLVM IR string with the given engine.
    The compiled module object is returned.
    """
    # Create a LLVM module object from the IR
    mod = llvm.parse_assembly(llvm_ir)
    mod.verify()
    # Now add the module and make sure it is ready for execution
    engine.add_module(mod)
    engine.finalize_object()
    engine.run_static_constructors()
    return mod



def run(llvm_ir):
        llvm.initialize()
        llvm.initialize_native_target()
        llvm.initialize_native_asmprinter()  # yes, even this one
        engine = create_execution_engine()
        mod = compile_ir(engine, llvm_ir)

        # Look up the function pointer (a Python int)
        func_ptr = engine.get_function_address("main")

        # Run the function via ctypes
        string_set = [ 'Hello', "zqd" ]

        select_type = (c_wchar_p * len(string_set))
        select = select_type()
        select[:] = string_set
        print(select)
        cfunc = CFUNCTYPE(c_int32, select_type)(func_ptr)
        res = cfunc(2, select)
        print("program output:", res)


if __name__ == "__main__":

    filename = sys.argv[1]

    with open(filename, 'r') as file:
            llvm_ir = file.read()

    run(llvm_ir)