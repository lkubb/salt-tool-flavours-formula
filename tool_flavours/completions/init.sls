# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as flavours with context %}

include:
  - {{ sls_package_install }}


{%- for user in flavours.users | selectattr('completions', 'defined') | selectattr('completions') %}

Completions directory for Flavours is available for user '{{ user.name }}':
  file.directory:
    - name: {{ user.home | path_join(user.completions) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0700'
    - makedirs: true

Flavours shell completions are available for user '{{ user.name }}':
  cmd.run:
    - name: {{ user.home | path_join('.local', 'bin', 'flavours') }} --completions {{ user.shell }} > {{ user.home | path_join(user.completions, '_flavours') }}
    - creates: {{ user.home | path_join(user.completions, '_flavours') }}
    - onchanges:
      - Flavours is installed for user '{{ user.name }}'
    - runas: {{ user.name }}
    - require:
      - Flavours setup is completed
      - Completions directory for Flavours is available for user '{{ user.name }}'
{%- endfor %}
