version: 2

models:
  - name: int_user_sessions_agg
    description: "Events aggregation on user session level"
    columns:
      - name: user_guid
        description: ""

      - name: session_guid
        description: ""

      - name: total_page_views
        description: ""

      - name: total_add_to_carts
        description: ""

      - name: total_chekouts
        description: ""

      - name: total_package_shippeds
        description: ""

      - name: first_session_event_at
        description: ""

      - name: last_session_event_at
        description: ""