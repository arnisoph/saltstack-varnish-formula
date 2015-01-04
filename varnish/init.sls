#!jinja|yaml

{% from 'varnish/defaults.yaml' import rawmap_osfam with context %}
{% set datamap = salt['grains.filter_by'](rawmap_osfam, merge=salt['pillar.get']('varnish:lookup')) %}

include: {{ datamap.sls_include|default([]) }}
extend: {{ datamap.sls_extend|default({}) }}

varnish:
  pkg:
    - installed
    - pkgs: {{ datamap.pkgs }}
  service:
    - running
    - name: {{ datamap.service.name|default('varnish') }}
    - enable: {{ datamap.service.enable|default(True) }}

{% for c in datamap.config.manage|default([]) %}
  {% set config = datamap.config[c] %}

varnish_config_{{ c }}:
  file:
    - {{ config.ensure|default('managed') }}
    - name: {{ config.path|default('/etc/varnish/' ~ c ~ '.vcl') }}
    - source: {{ config.template_path|default('salt://varnish/files/profiles/common/' ~ c ~ '.vcl') }}
    - user: {{ config.user|default('root') }}
    - group: {{ config.group|default('root') }}
    - mode: {{ config.mode|default(644) }}
    - template: jinja
    - defaults:
      datamap: {{ datamap }}
      context: {{ config }}
    - watch_in:
      - service: varnish
{% endfor %}
