# vim: ft=sls

{#-
    Ensures Flavours adheres to the XDG spec
    as best as possible for all managed users.
    Has a dependency on `tool_flavours.package`_.
#}

include:
  - .migrated
