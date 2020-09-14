view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.last_name,
      users.first_name,
      users.id,
      inventory_items.id,
      inventory_items.product_name
    ]
  }

  dimension: shipping_days {
    type: number
    sql: datediff(day,${shipped_date},${delivered_date}) ;;
  }


  dimension_group: ship_days {
    type: duration
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date} ;;
    intervals: [day]
    label: "ship_days"
  }

measure: count_distinct_order {
  description: "A count of unique orders"
  type: count_distinct
  sql: ${order_id} ;;
}

measure: total_sales_price {
  type: sum
  description: "Total sales price in usd"
sql: ${sale_price} ;;
value_format_name: usd
}

measure: averae_sales_price {
  type: average
  sql: ${sale_price} ;;
}

measure: sales_for_email_traffic {
  type: sum
  sql: ${sale_price} ;;
  value_format_name: usd
  filters: [users.traffic_source: "Email"]
}

measure: percentage_of_sales_email_traffic {
  type: number
  sql: 1.0*${sales_for_email_traffic}/nullif(${total_sales_price},0) ;;
  value_format_name: percent_0
}

measure: average_spend_per_user {
  type: number
  sql: 1.0*${total_sales_price}/nullif(${users.count},0) ;;
  value_format_name: usd
}
##sql_always_where: ${ordr_items.returned_date} is null;;
}
