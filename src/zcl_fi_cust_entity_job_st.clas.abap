CLASS zcl_fi_cust_entity_job_st DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_fi_cust_entity_job_st IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA: lt_entityset TYPE STANDARD TABLE OF zi_jobstatus.

    CHECK io_request->is_data_requested( ).

    TRY.
        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
        DATA(lv_sql_filter) = io_request->get_filter( )->get_as_sql_string( ).

      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    lt_entityset = zcl_fi_job_status_fac=>factory(  )->query(
      EXPORTING
        it_filter_range = lt_filter
        iv_filter_str   = lv_sql_filter
        iv_offset       = io_request->get_paging( )->get_offset( )
        iv_page_size    = io_request->get_paging( )->get_page_size( )
        it_elements     = io_request->get_requested_elements( )
        it_sorting      = io_request->get_sort_elements( )
    ).

    io_response->set_data( lt_entityset ).

  ENDMETHOD.
ENDCLASS.
