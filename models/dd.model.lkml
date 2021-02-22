connection: "snowlooker"

# include all the views
include: "/views/**/*.view"
include: "/**/*.dashboard"


datagroup: dd_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}
datagroup: order_items {
  sql_trigger: select max(created_at) from order_items ;;
  max_cache_age: "4 hour"
}

datagroup: deafult_dg {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hour"
}

datagroup: :abc {
  sql_trigger: select current_date ;;
  max_cache_age: "2 hour"
}

persist_with: dd_default_datagroup

explore: distribution_centers {}

explore: etl_jobs {}

explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {

#   sql_always_where: ${order_items.returned_date} is null;;
#   sql_always_having: ${order_items.total_sales_price} > 200 ;;
#    sql_always_where: ${order_items.status} ='complete';;
#   sql_always_having: ${order_items.count} > 5;;


  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  conditionally_filter: {
    filters: {
      field:order_items.created_date
      value: "last 2 years"
    }
    unless: [users.id]
  }

  always_filter:
  {filters:
    {field: order_items.created_date
      value: "before today"
    }}

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: users {
  persist_with: :deafult_dg
  }

explore: sql_runner_query{}
