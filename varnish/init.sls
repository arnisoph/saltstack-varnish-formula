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
