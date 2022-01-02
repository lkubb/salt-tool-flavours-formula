{%- from 'tool-flavours/map.jinja' import flavours %}

include:
  - .package
{%- if flavours.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') %}
  - .configsync
{%- endif %}
