{%- from "heat/map.jinja" import server with context %}

heat_syncdb:
  cmd.run:
  - name: heat-manage db_sync
  {%- if grains.get('noservices') or server.get('role', 'primary') == 'secondary' %}
  - onlyif: /bin/false
  {%- endif %}
