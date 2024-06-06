SELECT *
FROM {{ ref('stg_SQL_SERVER_DBO__ORDERS') }}
WHERE delivered_at < created_at





version: 2

sources:

  - name: google_sheets # name of the source 
    schema: google_sheets # this is the schema our raw data lives in
    database: <ALUMNOX>_DEV_BRONZE_DB# this is the name of our database

    quoting:
      database: false
      schema: false
      identifier: false

    freshness:
      warn_after: {count: 24, period: hour}
      error_after: {count: 48, period: hour}

    tables:

      - name: budget
        loaded_at_field: _fivetran_synced
        columns:
          - name: _row
            tests:
              - unique
              - not_null
          - name: product_id
            tests:
              - relationships:
                  to: source('sql_server_dbo','products')
                  field: product_id
          - name: quantity
            tests: 
              - positive_values
          - name: month
          - name: _fivetran_synced