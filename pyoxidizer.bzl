# This file defines how PyOxidizer application building and packaging is
# performed. See PyOxidizer's documentation at
# https://pyoxidizer.readthedocs.io/en/stable/ for details of this
# configuration file format.

# Configuration files consist of functions which define build "targets."
# This function creates a Python executable and installs it in a destination
# directory.


def resource_callback(policy, resource):
    if type(resource) in ("PythonExtensionModule") or "pytest" in resource.name or "pluggy" in resource.name or "py" == resource.name or "py." == resource.name[0:3] or "test" in resource.name:
        resource.add_location = "filesystem-relative:lib"
    else:
        resource.add_location = "in-memory"


def make_exe():
    dist = default_python_distribution(flavor = "standalone_dynamic")
    policy = dist.make_python_packaging_policy()
    policy.allow_files = True
    policy.allow_in_memory_shared_library_loading = True
    policy.resources_location = "in-memory"
    policy.resources_location_fallback = "filesystem-relative:lib"
    policy.register_resource_callback(resource_callback)
    python_config = dist.make_python_interpreter_config()
    python_config.config_profile = "python"
    python_config.run_command = "import numpy;numpy.test(extra_argv=['--assert=plain'])"

    exe = dist.to_python_executable(
        name="np_example",

        # If no argument passed, the default `PythonPackagingPolicy` for the
        # distribution is used.
        packaging_policy=policy,

        # If no argument passed, the default `PythonInterpreterConfig` is used.
        config=python_config,
    )

    exe.windows_runtime_dlls_mode = "always"
    exe.windows_subsystem = "console"
    exe.add_python_resources(exe.pip_install(["git+https://github.com/franzhaas/numpy.git@numpy", "pytest", "hypothesis"]))
    return exe

def make_embedded_resources(exe):
    return exe.to_embedded_resources()

def make_install(exe):
    files = FileManifest()
    files.add_python_resource(".", exe)
    return files

def make_msi(exe):
    return exe.to_wix_msi_builder(
        "myapp",
        "My Application",
        "1.0",
        "Alice Jones"
    )


# Dynamically enable automatic code signing.
def register_code_signers():
    return

# Call our function to set up automatic code signers.
register_code_signers()

# Tell PyOxidizer about the build targets defined above.
register_target("exe", make_exe)
register_target("resources", make_embedded_resources, depends=["exe"], default_build_script=True)
register_target("install", make_install, depends=["exe"], default=True)
register_target("msi_installer", make_msi, depends=["exe"])

# Resolve whatever targets the invoker of this configuration file is requesting
# be resolved.
resolve_targets()
