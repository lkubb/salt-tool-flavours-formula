# vim: ft=sls

{#-
    Manages the Flavours package configuration by

    * recursively syncing from a dotfiles repo

    Has a dependency on `tool_flavours.package`_.
#}

include:
  - .sync
