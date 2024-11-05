# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as flavours with context %}

include:
  - {{ tplroot }}.package


{%- for user in flavours.users %}

Flavours sources are set up for user '{{ user.name }}':
  file.managed:
    - name: {{ user._flavours.datadir | path_join("base16", "sources.yaml") }}
    - contents: |
        schemes: {{ user.flavours.get("schemes_source", "https://github.com/chriskempson/base16-schemes-source.git") }}
        templates: {{ user.flavours.get("templates_source", "https://github.com/chriskempson/base16-templates-source.git") }}
    - contents_newline: False # otherwise the file will always change
    - user: {{ user.name }}
    - group: {{ user.group }}
    - makedirs: true
    - require:
        - Flavours is installed for user '{{ user.name }}'

Flavours sources are synced for user '{{ user.name }}':
  cmd.run:
    - name: |
        {{ user.home | path_join(".local", "bin", "flavours") }} \
        {% if user.xdg %} --config '{{ user._flavours.conffile }}' --directory '{{ user._flavours.datadir }}'{% endif %} \
        update all
    - runas: {{ user.name }}
    - onchanges:
        - Flavours sources are set up for user '{{ user.name }}'
{%- endfor %}
