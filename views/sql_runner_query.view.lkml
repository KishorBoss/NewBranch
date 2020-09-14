view: sql_runner_query {
  derived_table: {
    sql: select order_items.user_id as user_id,
      count(distinct order_items.order_id) as lifetime_order_count,
      sum(order_items.sale_price) as lifetime_revenue,
      min(order_items.created_at) as first_order,
      max(order_items.created_at)as last_order
      from order_items
      group by user_id
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}."LIFETIME_ORDER_COUNT" ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}."LIFETIME_REVENUE" ;;
  }

  dimension_group: first_order {
    type: time
    sql: ${TABLE}."FIRST_ORDER" ;;
  }

  dimension_group: last_order {
    type: time
    sql: ${TABLE}."LAST_ORDER" ;;
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue, first_order_time, last_order_time]
  }
}
