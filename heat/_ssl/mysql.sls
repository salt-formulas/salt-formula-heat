{%- from "heat/map.jinja" import server with context %}

heat_ssl_mysql:
  test.show_notification:
    - text: "Running heat._ssl.mysql"

{%- if server.database.get('x509',{}).get('enabled',False) %}

  {%- set ca_file=server.database.x509.ca_file %}
  {%- set key_file=server.database.x509.key_file %}
  {%- set cert_file=server.database.x509.cert_file %}

mysql_heat_ssl_x509_ca:
  {%- if server.database.x509.cacert is defined %}
  file.managed:
    - name: {{ ca_file }}
    - contents_pillar: heat:server:database:x509:cacert
    - mode: 444
    - user: heat
    - group: heat
    - makedirs: true
  {%- else %}
  file.exists:
    - name: {{ ca_file }}
  {%- endif %}

mysql_heat_client_ssl_cert:
  {%- if server.database.x509.cert is defined %}
  file.managed:
    - name: {{ cert_file }}
    - contents_pillar: heat:server:database:x509:cert
    - mode: 440
    - user: heat
    - group: heat
    - makedirs: true
  {%- else %}
  file.exists:
    - name: {{ cert_file }}
  {%- endif %}

mysql_heat_client_ssl_private_key:
  {%- if server.database.x509.key is defined %}
  file.managed:
    - name: {{ key_file }}
    - contents_pillar: heat:server:database:x509:key
    - mode: 400
    - user: heat
    - group: heat
    - makedirs: true
  {%- else %}
  file.exists:
    - name: {{ key_file }}
  {%- endif %}

mysql_heat_ssl_x509_set_user_and_group:
  file.managed:
    - names:
      - {{ ca_file }}
      - {{ cert_file }}
      - {{ key_file }}
    - user: heat
    - group: heat

{% elif server.database.get('ssl',{}).get('enabled',False) %}
mysql_ca_heat:
  {%- if server.database.ssl.cacert is defined %}
  file.managed:
    - name: {{ server.database.ssl.cacert_file }}
    - contents_pillar: heat:server:database:ssl:cacert
    - mode: 0444
    - makedirs: true
  {%- else %}
  file.exists:
    - name: {{ server.database.ssl.get('cacert_file', server.cacert_file) }}
  {%- endif %}

{%- endif %}