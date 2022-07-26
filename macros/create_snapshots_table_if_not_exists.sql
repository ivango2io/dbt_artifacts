{% macro create_snapshots_table_if_not_exists(database_name, schema_name, table_name) -%}

    {%- if adapter.get_relation(database=database_name, schema=schema_name, identifier=table_name) is none -%}
        {% if database_name %}
        {{ log("Creating table " ~ adapter.quote(database_name ~ "." ~ schema_name ~ "." ~ table_name), info=true) }}
        {% else %}
        {{ log("Creating table " ~ adapter.quote(schema_name ~ "." ~ table_name), info=true) }}
        {% endif %}
        {%- set query -%}
            {{ adapter.dispatch('get_create_snapshots_table_if_not_exists_statement', 'dbt_artifacts')(database_name, schema_name, table_name) }}
        {% endset %}
        {%- call statement(auto_begin=True) -%}
            {{ query }}
        {%- endcall -%}
    {%- endif -%}

{%- endmacro %}

{% macro databricks__get_create_snapshots_table_if_not_exists_statement(database_name, schema_name, table_name) -%}
    create table {{schema_name}}.{{table_name}} (
        command_invocation_id STRING,
        node_id STRING,
        database STRING,
        schema STRING,
        name STRING,
        depends_on_nodes STRING,
        package_name STRING,
        path STRING,
        checksum STRING,
        strategy STRING
    )
    using delta
{%- endmacro %}

{% macro snowflake__get_create_snapshots_table_if_not_exists_statement(database_name, schema_name, table_name) -%}
    create table {{database_name}}.{{schema_name}}.{{table_name}} (
        command_invocation_id STRING,
        node_id STRING,
        database STRING,
        schema STRING,
        name STRING,
        depends_on_nodes ARRAY,
        package_name STRING,
        path STRING,
        checksum STRING,
        strategy STRING
    )
{%- endmacro %}

{% macro default__get_create_snapshots_table_if_not_exists_statement(database_name, schema_name, table_name) -%}
    create table {{database_name}}.{{schema_name}}.{{table_name}} (
        command_invocation_id STRING,
        node_id STRING,
        database STRING,
        schema STRING,
        name STRING,
        depends_on_nodes STRING,
        package_name STRING,
        path STRING,
        checksum STRING,
        strategy STRING
    )
{%- endmacro %}
