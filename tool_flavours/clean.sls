# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``tool_flavours`` meta-state
    in reverse order.
#}

include:
  - .completions.clean
  - .config.clean
  - .package.clean
