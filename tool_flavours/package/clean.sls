# vim: ft=sls

{#-
    Removes the Flavours package.
    Has a dependency on `tool_flavours.config.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as flavours with context %}

include:
  - {{ sls_config_clean }}


Flavours is removed:
  pkg.removed:
    - name: {{ flavours.lookup.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
