{% macro count_sessions_per_event_type() %} 

    {% set event_types = dbt_utils.get_column_values(
        table = ref('stg_postgres__events')
        , column = 'event_type'
        )
    %}

    {% for event_type in event_types %}
        , COUNT(DISTINCT (CASE WHEN event_type = '{{ event_type }}' THEN session_guid END)) AS total_sessions_with_{{ event_type }}
    {% endfor %}

{% endmacro %} 