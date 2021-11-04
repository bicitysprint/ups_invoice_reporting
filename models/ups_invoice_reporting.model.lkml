connection: "db"

include: "/views/*.view.lkml"

datagroup: ups_invoice_reporting_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "24 hours"
}

named_value_format: gbp_format_dp {
  value_format: "\"£\"#,##0.00"
}

persist_with: ups_invoice_reporting_default_datagroup


explore: UPS_Invoice_Report{
  view_name: vw_ups_invoicereport
  view_label: "UPS Invoice Report"
  description: "Main UPS Invoice Cost Data"
  }
