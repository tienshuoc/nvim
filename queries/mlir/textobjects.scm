; extends

(operation
  rhs: (custom_operation
    (func_dialect "func.func"))) @function.outer

(operation
  rhs: (custom_operation
    (llvm_dialect "llvm.func"))) @function.outer

(func_dialect
  "func.func"
  body: (region
    .
    "{"
    _+ @function.inner
    "}"))

(llvm_dialect
  "llvm.func"
  body: (region
    .
    "{"
    _+ @function.inner
    "}"))

; Generic assembly uses quoted operation names.
((operation
  rhs: (generic_operation
    (string_literal) @_function)) @function.outer
  (#any-of? @_function "\"func.func\"" "\"llvm.func\""))

((generic_operation
  (string_literal) @_function
  (region
    .
    "{"
    _+ @function.inner
    "}"))
  (#any-of? @_function "\"func.func\"" "\"llvm.func\""))
