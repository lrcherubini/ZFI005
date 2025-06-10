INTERFACE zif_fi_job_status
  PUBLIC .

  TYPES: ty_result TYPE STANDARD TABLE OF ZI_JobStatus2 WITH DEFAULT KEY.

  METHODS: query
    IMPORTING
      it_filter_range TYPE IF_RAP_QUERY_FILTER=>TT_NAME_RANGE_PAIRS OPTIONAL
      iv_filter_str   TYPE string OPTIONAL
      iv_offset       TYPE int8 OPTIONAL
      iv_page_size    TYPE int8 OPTIONAL
      it_elements     TYPE if_rap_query_request=>tt_requested_elements OPTIONAL
      it_sorting      TYPE if_rap_query_request=>tt_sort_elements OPTIONAL
    RETURNING VALUE(rt_result) TYPE ty_result.

ENDINTERFACE.
