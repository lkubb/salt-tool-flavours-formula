{%- from 'tool-flavours/map.jinja' import flavours %}

include:
  - .package
  - .sources
{%- if flavours.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') %}
  - .configsync
{%- endif %}
