view: vw_ups_invoicereport {
##  sql_table_name: "CC"."VW_UPS_INVOICEREPORT"
  derived_table: {
    persist_for: "24 hour"
    sql: select * from vw_ups_invoicereport ;;
  }


  dimension: billed_weight {
    type: number
    sql: case
    when ${TABLE}."BilledWeight" IS NULL then '0'
    else ${TABLE}."BilledWeight"
    END ;;
  }

  dimension: ct_amt {
    type: number
    sql: ${TABLE}."CT_Amt" ;;
    value_format_name: gbp
  }

  dimension: ctagent_cost {
    type: number
    sql: ${TABLE}."CTAgentCost" ;;
    value_format_name: gbp
  }

  dimension: customer_key {
    type: string
    sql: ${TABLE}."CustomerKey" ;;
  }

  dimension: customer_name {
    type: string
    sql: ${TABLE}."CustomerName" ;;
  }

  dimension: datasource {
    label: "Date Source"
    type: string
    sql: case
    when ${TABLE}."DataSource" = '1' or "DataSource" = '2' then 'Invoiced'
    when ${TABLE}."DataSource" = '0' then 'Not Yet Invoiced'
    END ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."Description" ;;
  }

  dimension: entered_weight {
    type: number
    sql: case
    when ${TABLE}."EnteredWeight" IS NULL then '0'
    else ${TABLE}."EnteredWeight"
    END ;;
  }

  dimension_group: invoice {
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
    sql: ${TABLE}."InvoiceDate" ;;
  }

  dimension: job_no {
    type: string
    sql: ${TABLE}."JobNo" ;;
##    drill_fields: [job_no,jobcode]
  }

  dimension: job_number {
    type: number
    sql: ${TABLE}."JobNumber" ;;
  }

  dimension: jobcode {
    type: string
    sql: ${TABLE}."JOBCODE" ;;
  }

  dimension: miscellaneous {
    type: string
    sql: ${TABLE}."Miscellaneous" ;;
  }

  dimension: MissingHawbFlag {
    type: string
    sql: ${TABLE}."MissingHawbFlag" ;;
  }

  dimension: ndishipmentreference {
    label: "NDI Shipment Reference"
    type: string
    sql: ${TABLE}."NDIShipmentreference" ;;
  }

  dimension: package_dimensions {
    type: string
    sql: case
    when ${TABLE}."PackageDimensions" IS NULL then '0'
    else ${TABLE}."PackageDimensions"
    END  ;;
  }

  dimension: has_package_dimensions {
    type: yesno
    sql: case
    when ${TABLE}."PackageDimensions" IS NULL then 'N'
    when ${TABLE}."PackageDimensions" IS NOT NULL then 'Y'
    END ;;
  }

 dimension: receiveraddress {
   label: "Receiver Address"
    type: string
    sql: ${TABLE}."ReceiverAddress" ;;
 }

 dimension: receiverpostal {
   label: "Receiver Postal"
    type: string
    sql: ${TABLE}."ReceiverPostal" ;;
 }

 dimension: senderaddress {
   label: "Sender Address"
    type: string
    sql: ${TABLE}."Sender Address" ;;
 }

  dimension: senderpostal {
    label: "Sender Postal"
    type: string
    sql: ${TABLE}."Sender Postal" ;;
  }

  dimension: tracking_number {
    primary_key: yes
    type: string
    sql: ${TABLE}."TrackingNumber" ;;
##    drill_fields: [job_no,jobcode]
##    link: {
##      label: "See Cost Breakdowns and Related Details"
##      url: "/dashboards-next/1500?Tracking%20Number={{ value }}"
##      icon_url: "https://looker.com/favicon.ico"
##    }
  }

  dimension_group: transaction {
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
    sql: ${TABLE}."TransactionDate" ;;
  }

  dimension: ups_amt {
    type: number
    sql: ${TABLE}."UPS_Amt" ;;
    value_format_name: gbp
  }

  dimension: upsinvoicenumber {
    label: "UPS Invoice No"
    type: string
    sql: ${TABLE}."UPSInvoiceNumber" ;;
  }


################################################# MEASURES ##########################################


  measure: count {
    type: count_distinct
    sql: ${TABLE}."TrackingNumber" ;;
##    drill_fields: [customer_name]
  }

  measure: count_of_tracking_numbers {
    type: count_distinct
    sql:case
    when ${TABLE}."NDIShipmentreference" is null and  ${TABLE}."MissingHawbFlag"= 'T' then ${TABLE}."TrackingNumber"
    when ${TABLE}."NDIShipmentreference" is null and  ${TABLE}."MissingHawbFlag"= 'F' then ${TABLE}."TrackingNumber"
    when ${TABLE}."NDIShipmentreference" is not null and ${TABLE}."MissingHawbFlag"= 'F' then '0'
    END ;;

 ## filters: [ndishipmentreference: "is null", MissingHawbFlag: "= T"]
  }


  measure: sum {
    type: sum
    sql: ${ct_amt}+${ctagent_cost}+${ups_amt} ;;
    value_format: "0.00"
  }

  measure: sum_of_ct_amt {
    label: "CT Jobcode Total"
    type: sum
    sql: ${ct_amt} ;;
    value_format: "0.00"
    drill_fields: [tracking_number,ndishipmentreference,job_no,transaction_date,jobcode,ct_amt,customer_key,customer_name]
  }

  measure: sum_of_ups_amt {
    label: "UPS Invoice Total"
    type: sum
    sql: ${ups_amt} ;;
    value_format: "0.00"
   drill_fields: [tracking_number,ndishipmentreference,job_no,transaction_date,jobcode,ups_amt,customer_key,customer_name]
  }

  measure: sum_of_CTAgentCost_amt {
    label: "CT Expected Cost Total"
    type: sum
    sql: ${ctagent_cost} ;;
    value_format: "0.00"
   drill_fields: [tracking_number,ndishipmentreference,job_no,transaction_date,jobcode,ctagent_cost,customer_key,customer_name]
  }

  measure: variance1 {
    label: "Variance"
    type: sum
    sql: ${ups_amt}-${ctagent_cost} ;;
    value_format: "0.00"
  }



}
