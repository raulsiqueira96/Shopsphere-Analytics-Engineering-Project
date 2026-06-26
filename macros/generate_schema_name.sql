{% macro generate_schema_name(custom_schema_name, node) -%}
    
    {%- set default_schema = target.schema -%}
    
    {# If we are running in production and a custom schema is defined, use it directly #}
    {%- if target.name == 'prod' and custom_schema_name is not none -%}
        {{ custom_schema_name | trim }}
    
    {# If we are running in development, concatenate the schemas to keep dev clean #}
    {%- elif custom_schema_name is not none -%}
        {{ default_schema }}_{{ custom_schema_name | trim }}
    
    {# Default fallback if no custom schema is specified #}
    {%- else -%}
        {{ default_schema }}
    {%- endif -%}

{%- endmacro %}