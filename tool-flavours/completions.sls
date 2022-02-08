{%- from 'tool-flavours/map.jinja' import flavours %}

include:
  - .package

{%- for user in flavours.users | selectattr('completions', 'defined') | selectattr('completions') %}

Completions directory for flavours is available for user '{{ user.name }}':
  file.directory:
    - name: {{ user.home }}/{{ user.completions }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - makedirs: true

Flavours completions are available for user '{{ user.name }}':
  cmd.run:
    - name: {{ user.home }}/.local/bin/flavours --completions {{ user.shell }} > {{ user.home }}/{{ user.completions }}/_flavours
    - creates: {{ user.home }}/{{ user.completions }}/_flavours
    - onchanges:
      - Flavours is installed for user {{ user.name }}
    - runas: {{ user.name }}
    - require:
      - Flavours is installed for user {{ user.name }}
      - Completions directory for flavours is available for user '{{ user.name }}'
{%- endfor %}
