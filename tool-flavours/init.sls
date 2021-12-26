Rust is installed:
  pkg.installed:
    - name: rust
    - unless:
      - sudo -u {{ user.name }} which cargo

{%- for user in salt['pillar.get']('tool:users') %}
# @TODO write a cargo module/state and make target configurable
# also consider installing it globally, not per-user
Flavours is installed for user {{ user.name }}:
  cmd.run:
    - name: cargo --locked --root=${HOME}/.local install flavours # installs flavours into ~/.local/bin
    - runas: {{ user.name }}
    - unless:
      - sudo -u {{ user.name }} which flavours
{%- endfor %}
