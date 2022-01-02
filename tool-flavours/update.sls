{%- from 'tool-flavours/map.jinja' import flavours %}

{%- if flavours.users | selectattr('dotconfig') %}
include:
  - .configsync
{%- endif %}

{%- for user in flavours.users %}
Check if flavours is up to date for user {{ user.name }}:
  cmd.run:
    - name: cargo search flavours | head -n 1 | grep "$(flavours --version | cut -f 2- -d ' ')"
    - runas: {{ user.name }}
    - python_shell: True # command uses shell features

Flavours is updated for user {{ user.name }}:
  cmd.run:
    - name: cargo --locked --root=${HOME}/.local install flavours # installs flavours into ~/.local/bin
    - runas: {{ user.name }}
    - onfail:
      - Check if flavours is up to date for user {{ user.name }}
{%- endfor %}

# Updating schemes and themes results in custom ones that are not part of the repos
# being deleted. Therefore it is not done here.
