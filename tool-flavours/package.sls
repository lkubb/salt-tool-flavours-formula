{%- from 'tool-flavours/map.jinja' import flavours -%}

{%- for user in flavours.users %}
Rust is available for user {{ user.name }}:
  pkg.installed:
    - name: rust
    - unless:
      - sudo -u {{ user.name }} which cargo

Flavours is installed for user {{ user.name }}:
  cmd.run:
    - name: cargo install --locked --root=${HOME}/.local flavours # installs flavours into ~/.local/bin
    - runas: {{ user.name }}
    - unless:
      - sudo -u {{ user.name }} which flavours
{%- endfor %}
