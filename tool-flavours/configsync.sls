{%- from 'tool-flavours/map.jinja' import flavours %}

{%- for user in flavours.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') %}
flavours configuration is setup for user '{{ user.name }}':
  file.managed:
    - name: {{ user.home }}/.config/flavours/config.toml
    - source:
      - salt://dotconfig/{{ user.name }}/flavours/config.toml
      - salt://dotconfig/flavours/config.toml
    - context:
        user: {{ user | json }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: True
{%- endfor %}
