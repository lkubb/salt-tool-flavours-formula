# vim: ft=sls

{#-
    Removes flavours completions for all managed users.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as flavours with context %}


{%- for user in flavours.users | selectattr("flavours.completions", "defined") | selectattr("flavours.completions") %}

Flavours shell completions are available for user '{{ user.name }}':
  file.absent:
    - name: {{ user.home | path_join(user.completions, "_flavours") }}
{%- endfor %}
