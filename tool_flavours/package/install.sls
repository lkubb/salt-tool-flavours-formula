# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as flavours with context %}

{%- if "cargo" in salt["saltutil.list_extmods"]().get("states", []) %}

include:
  - tool_rust


{%-   for user in flavours.users %}

Flavours is installed for user '{{ user.name }}':
  cargo.installed:
    - name: {{ flavours.lookup.pkg.name }}
    - version: {{ flavours.get("version") or "latest" }}
    - user: {{ user.name }}
    {#- do not specify alternative return value to be able to unset default version #}
    - locked: true
    - root: {{ user.home | path_join(".local") }}
    - require_in:
      - Flavours setup is completed
{%-   endfor %}

{%- else %}

Rust is available:
  pkg.installed:
    - name: rust
    - unless:
      - sudo -u {{ user.name }} which cargo

{%-   for user in flavours.users %}

Check if flavours is installed for user '{{ user.name }}':
  cmd.run:
    - name: test -x {{ user.home | path_join(".local", "bin", "flavours") }}
    - runas: {{ user.name }}
    - python_shell: True # command uses shell features
    - onfail_in:
      - Flavours is installed for user '{{ user.name }}'

{%-     if flavours.version == "latest" %}

Check if flavours is up to date for user '{{ user.name }}':
  cmd.run:
    - name: cargo search flavours | head -n 1 | grep "$(flavours --version | cut -f 2- -d ' ')"
    - runas: {{ user.name }}
    - python_shell: True # command uses shell features
    - require:
      - Rust is available
      - Check if flavours is installed for user '{{ user.name }}'
    - onfail_in:
      - Flavours is installed for user '{{ user.name }}'
{%-     else %}

Check if flavours version is as specified for user '{{ user.name }}':
  cmd.run:
    - name: flavours --version | cut -f 2- -d ' '
    - runas: {{ user.name }}
    - python_shell: True # command uses shell features
    - require:
      - Check if flavours is installed for user '{{ user.name }}'
    - onfail_in:
      - Flavours is installed for user '{{ user.name }}'
{%-     endif %}

Flavours is installed for user '{{ user.name }}':
  cmd.run:
    - name: cargo install --locked --root=${HOME}/.local flavours # installs flavours into ~/.local/bin
    - runas: {{ user.name }}
    - onfail:
      - Check if flavours version is as specified for user '{{ user.name }}'
      #- sudo -u {{ user.name }} which flavours
    - require:
      - Rust is available
    - require_in:
      - Flavours setup is completed
{%-   endfor %}
{%- endif %}

Flavours setup is completed:
  test.nop:
    - name: Hooray, Flavours setup has finished.
