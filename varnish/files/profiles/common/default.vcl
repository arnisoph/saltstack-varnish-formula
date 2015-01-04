{% for c in datamap.config.manage|default([]) if datamap.config[c].include|default(True) -%}
include "{{ c }}.vcl";
{% endfor -%}
