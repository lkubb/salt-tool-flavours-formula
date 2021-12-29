{%- from 'tool-flavours/map.jinja' import flavours -%}

Rust is installed:
  pkg.installed:
    - name: rust
    - unless:
      - sudo -u {{ user.name }} which cargo

{%- for user in flavours.users %}
Flavours is installed for user {{ user.name }}:
  cmd.run:
    - name: cargo --locked --root=${HOME}/.local install flavours # installs flavours into ~/.local/bin
    - runas: {{ user.name }}
    - unless:
      - sudo -u {{ user.name }} which flavours
{%- endfor %}
