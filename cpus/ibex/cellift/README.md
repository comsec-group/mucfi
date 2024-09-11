# Ibex instrumentation

Cellift-meta must be sourced.

Then, start with installing the Python requirements:

```
make installrequirements
```

## Developer infos

### Design modifications

Some of the original source files could not be processed by our tool chain. They were copied into ./src and modifications were marked with a comment "cellift_modification".
In order to exclude them from compilation, they needed to be added to the list SRCS_TO_SKIP in ./scripts/gen_sv2v_out.py. Then the files were added to target.core (e.g. run_vanilla_notrace.core), which tells fusesoc which files and packages to include.

#### NECESSARY MANUAL OPENTITAN MODIFICATION:
(TODO: script this)

Add the following modification:

cellift-designs/cellift-opentitan/opentitan$ git diff hw/ip/prim/rtl/prim_util_memload.svh
diff --git a/hw/ip/prim/rtl/prim_util_memload.svh b/hw/ip/prim/rtl/prim_util_memload.svh
index 7f8c6da92..69a98e9ed 100644
--- a/hw/ip/prim/rtl/prim_util_memload.svh
+++ b/hw/ip/prim/rtl/prim_util_memload.svh
@@ -58,8 +58,8 @@ initial begin
   logic show_mem_paths;

   // Print the hierarchical path to the memory to help make formal connectivity checks easy.
-  void'($value$plusargs("show_mem_paths=%0b", show_mem_paths));
-  if (show_mem_paths) $display("%m");
+  // void'($value$plusargs("show_mem_paths=%0b", show_mem_paths)); // cellift_modification
+  // if (show_mem_paths) $display("%m");

   if (MemInitFile != "") begin : gen_meminit
       $display("Initializing memory %m from file '%s'.", MemInitFile);

### Opentitan root dir

Set CURR_OPENTITAN_ROOT in scripts/gen_sv2v_out.py
And in env.sh



