# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as flavours with context %}


{%- for user in flavours.users %}

Flavours config file is cleaned for user '{{ user.name }}':
  file.absent:
    - name: {{ user['_flavours'].conffile }}

{%-   if user.xdg %}

Flavours config dir is absent for user '{{ user.name }}':
  file.absent:
    - name: {{ user['_flavours'].confdir }}
{%-   endif %}
{%- endfor %}
