{#- Small SQL helpers used by the staging models, so the JSON / time-zone details live in one place. -#}

{# Extract a top-level JSON field as text. Keys may contain spaces and Polish letters. #}
{% macro json_get(column, key) -%}
  json_extract_string({{ column }}, '$."{{ key }}"')
{%- endmacro %}


{# Interpret a naive local timestamp in `tz` and return the naive UTC timestamp. #}
{% macro local_to_utc(column, tz) -%}
  timezone('UTC', timezone('{{ tz }}', {{ column }}))
{%- endmacro %}


{# Convert a naive UTC timestamp to naive local time in `tz`. #}
{% macro utc_to_local(column, tz) -%}
  timezone('{{ tz }}', timezone('UTC', {{ column }}))
{%- endmacro %}


{# ISO day of week: Monday = 1 ... Sunday = 7. #}
{% macro iso_day_of_week(column) -%}
  isodow({{ column }})
{%- endmacro %}


{# Text to timestamp, NULL when unparseable. #}
{% macro try_to_timestamp(column) -%}
  try_cast(replace({{ column }}, 'T', ' ') as timestamp)
{%- endmacro %}


{# Text to double, NULL when unparseable (also accepts a decimal comma). #}
{% macro try_to_double(column) -%}
  try_cast(replace({{ column }}, ',', '.') as double)
{%- endmacro %}
