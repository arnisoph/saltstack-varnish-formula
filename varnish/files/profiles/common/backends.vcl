{% for id, backend in context.backends|default({})|dictsort -%}
  {%- set probe = backend.probe|default({}) %}
backend b_{{ id }} {
  .host = "{{ backend.host }}";
  .port = "{{ backend.port|default(80) }}";
  .connect_timeout = {{ backend.connection_timeout|default('10s') }};
  .first_byte_timeout = {{ backend.first_byte_timeout|default('60s') }};
  .between_bytes_timeout = {{ backend.between_bytes_timeout|default('60s') }};
  .max_connections = {{ backend.max_connections|default(50) }};

  {%- if probe.ensure|default('present') == 'present' %}
  .probe = {
  {%- if 'request' in probe %}
    .request =
    {%- for r in probe.request %}
      {%- if not loop.last %}
      "{{ r }}"
      {%- else %}
      "{{ r }}";
      {%- endif -%}
    {%- endfor -%}
  {%- else %}
    .url = "{{ probe.url|default('/') }}";
  {%- endif %}
    .expected_response = {{ probe.expected_response|default(200) }};
    .timeout = {{ probe.timeout|default('2s') }};
    .interval = {{ probe.interval|default('5s') }};
    .initial = {{ probe.initial|default(1) }};
    .window = {{ probe.window|default(8) }};
    .threshold = {{ probe.threshold|default(3) }};
  }
  {%- endif %}
}

{% endfor %}
