{%- for user in salt['pillar.get']('tool:user', []) %}
{%- from 'tool/rbw/map.jinja' import user with context %}
flavours configuration is setup for user '{{ user.name }}':
  file.managed:
    - name: {{ user.home }}/.config/flavours/config.toml
    - source:
      - salt://user/{{ user.name }}/dotfiles/flavours/config.toml
      - salt://user/dotfiles/flavours/config.toml
    - context:
        user: {{ user }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
{%- endfor %}
