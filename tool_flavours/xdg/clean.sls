# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as flavours with context %}


{%- if 'Darwin' == grains.kernel %}
{%-   for user in flavours.users | rejectattr('xdg', 'sameas', False) %}

{%-     set user_default_conf = user.home | path_join(flavours.lookup.paths.confdir) %}
{%-     set user_xdg_confdir = user.xdg.config | path_join(flavours.lookup.paths.xdg_dirname) %}
{%-     set user_xdg_conffile = user_xdg_confdir | path_join(flavours.lookup.paths.xdg_conffile) %}

Flavours configuration lives in Library for user '{{ user.name }}':
  file.rename:
    - name: {{ user_default_conf }}
    - source: {{ user_xdg_confdir }}

Flavours does not use XDG dirs during this salt run:
  environ.setenv:
    - value:
        FLAVOURS_CONFIG_FILE: false
        FLAVOURS_DATA_DIRECTORY: false
    - false_unsets: true

{%-     if user.get('persistenv') %}

Flavours is ignorant about XDG location for user '{{ user.name }}':
  file.replace:
    - name: {{ user.home | path_join(user.persistenv) }}
    # This does not work. I checked with ``tool_rust``, which is working,
    # it seems once anything longer than CARGO_HOME is inserted for the first
    # variable, something breaks:
    # Rendering SLS 'base:tool_flavours.xdg.clean' failed: could not find expected ':'
    - text: {{ ( '^(' ~ ('export FLAVOURS_DATA_DIRECTORY="${XDG_DATA_HOME:-$HOME/.local/share/' ~ flavours.lookup.paths.xdg_dirname ~ '"')
              | regex_escape ~ '|' ~
              ('export FLAVOURS_CONFIG_FILE=${XDG_CONFIG_HOME:-$HOME/.config/' ~ flavours.lookup.paths.xdg_dirname
                | path_join(flavours.lookup.paths.xdg_conffile) ~ '"') | regex_escape
                ~ ')$') | yaml }}
    - repl: ''
    - ignore_if_missing: true
{%-     endif %}
{%-   endfor %}
{%- endif %}
