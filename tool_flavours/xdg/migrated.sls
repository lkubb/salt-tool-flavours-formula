# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as flavours with context %}

include:
  - {{ tplroot }}.package


{%- if 'Darwin' == grains.kernel %}
{%-   for user in flavours.users | rejectattr('xdg', 'sameas', false) %}

{%-     set user_default_conf = user.home | path_join(flavours.lookup.paths.confdir) %}
{%-     set user_default_data = user.home | path_join(flavours.lookup.paths.datadir) %}
{%-     set user_xdg_confdir = user.xdg.config | path_join(flavours.lookup.paths.xdg_dirname) %}
{%-     set user_xdg_datadir = user.xdg.data | path_join(flavours.lookup.paths.xdg_dirname) %}
{%-     set user_xdg_conffile = user_xdg_confdir | path_join(flavours.lookup.paths.xdg_conffile) %}

# workaround for file.rename not supporting user/group/mode for makedirs
XDG_CONFIG/DATA_HOME exists for Flavours for user '{{ user.name }}':
  file.directory:
    - names:
      - {{ user.xdg.config }}:
        - onlyif:
          - test -e '{{ user_default_conf }}'
      - {{ user.xdg.data }}:
        - onlyif:
          - test -e '{{ user_default_data }}'
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0700'
    - makedirs: true

Existing Flavours configuration and data is migrated for user '{{ user.name }}':
  file.rename:
    - names:
      - {{ user_xdg_confdir }}:
        - source: {{ user_default_conf }}
      - {{ user_xdg_datadir }}:
        - source: {{ user_default_data }}
    - require:
      - XDG_CONFIG/DATA_HOME exists for Flavours for user '{{ user.name }}'
    - require_in:
      - Flavours setup is completed

Flavours has its config file in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.managed:
    - name: {{ user_xdg_conffile }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - makedirs: true
    - mode: '0600'
    - dir_mode: '0700'
    - require:
      - Existing Flavours configuration and data is migrated for user '{{ user.name }}'
    - require_in:
      - Flavours setup is completed

# @FIXME
# This actually does not make sense and might be harmful:
# Each file is executed for all users, thus this breaks
# when more than one is defined!
Flavours uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        FLAVOURS_CONFIG_FILE: {{ user_xdg_conffile }}
        FLAVOURS_DATA_DIRECTORY: {{ user_xdg_datadir }}
    - require_in:
      - Flavours setup is completed

{%-     if user.get('persistenv') %}

persistenv file for Flavours exists for user '{{ user.name }}':
  file.managed:
    - name: {{ user.home | path_join(user.persistenv) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

Flavours knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ user.home | path_join(user.persistenv) }}
    - text: |
        export FLAVOURS_CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/{{ flavours.lookup.paths.xdg_dirname | path_join(flavours.lookup.paths.xdg_conffile) }}"
        export FLAVOURS_DATA_DIRECTORY="${XDG_DATA_HOME:-$HOME/.local/share}/{{ flavours.lookup.paths.xdg_dirname }}"
    - require:
      - persistenv file for Flavours exists for user '{{ user.name }}'
    - require_in:
      - Flavours setup is completed
{%-     endif %}
{%-   endfor %}
{%- endif %}
