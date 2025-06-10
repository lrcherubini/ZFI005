CLASS zcl_fi_job_status DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    INTERFACES zif_fi_job_status .

    ALIASES:
      query FOR zif_fi_job_status~query.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_fi_job_status IMPLEMENTATION.

  METHOD query.

    DATA: lr_job    TYPE RANGE OF zi_jobstatus-applicationjobname,
          lr_count  TYPE RANGE OF zi_jobstatus-applicationjob,
          lr_user   TYPE RANGE OF zi_jobstatus-scheduledbyuser,
          lt_sort   TYPE TABLE OF string,
          lt_fields TYPE TABLE OF string,
          ls_result LIKE LINE OF rt_result,
          lt_base   TYPE STANDARD TABLE OF i_jobstatus,
          lv_dbsta  TYPE tbtcjob-status,
          lv_acsta  TYPE tbtcjob-status.

    LOOP AT it_sorting INTO DATA(ls_sort) WHERE element_name EQ 'ApplicationJobName'
                                             OR element_name EQ 'ApplicationJob'
                                             OR element_name EQ 'ScheduledByUser'.

      APPEND |{ ls_sort-element_name } { COND string( WHEN ls_sort-descending IS NOT INITIAL THEN 'DESCENDING' ) }| TO lt_sort.

    ENDLOOP.

    IF sy-subrc NE 0.
      APPEND 'ApplicationJobName' TO lt_sort.
      APPEND ', ApplicationJob'     TO lt_sort.

    ENDIF.

    APPEND 'ApplicationJobName' TO lt_fields.
    APPEND ', ApplicationJob'     TO lt_fields.

    IF  line_exists( it_elements[ table_line = 'ScheduledByUser' ] )
     OR it_elements IS INITIAL.
      APPEND ', ScheduledByUser' TO lt_fields.

    ENDIF.

    SELECT FROM i_jobstatus
      FIELDS (lt_fields)
      WHERE applicationjob     IN @lr_count
        AND applicationjobname IN @lr_job
        AND scheduledbyuser    IN @lr_user
      ORDER BY (lt_sort)
      INTO CORRESPONDING FIELDS OF TABLE @lt_base
      UP TO @iv_page_size ROWS
      OFFSET @iv_offset.

    CHECK sy-subrc EQ 0.

    LOOP AT lt_base INTO DATA(ls_base).

      CLEAR: ls_result,
             lv_dbsta,
             lv_acsta.

      MOVE-CORRESPONDING ls_base TO ls_result.

      IF   line_exists( it_elements[ table_line = 'Status' ] )
        OR line_exists( it_elements[ table_line = 'StatusText' ] )
        OR it_elements IS INITIAL.

        CALL FUNCTION 'BP_JOB_CHECKSTATE'
          EXPORTING
            dialog                       = 'N'
            jobcount                     = ls_base-applicationjob
            jobname                      = ls_base-applicationjobname
          IMPORTING
            status_according_to_db       = lv_dbsta
            actual_status                = lv_acsta
          EXCEPTIONS
            checking_of_job_has_failed   = 1
            correcting_job_status_failed = 2
            invalid_dialog_type          = 3
            job_does_not_exist           = 4
            no_check_privilege_given     = 5
            ready_switch_too_dangerous   = 6
            OTHERS                       = 7.

        IF sy-subrc EQ 0.
          ls_result-status = lv_acsta.

          CALL FUNCTION 'TMS_BCI_GET_JOB_STATUSTEXT'
            EXPORTING
              iv_status = lv_acsta
            IMPORTING
              ev_text   = ls_result-statustext.

        ENDIF.
      ENDIF.

      APPEND ls_result TO rt_result.

    ENDLOOP.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    DATA(lt_data) = query( iv_page_size = 10 ).

    out->write( lt_data ).

  ENDMETHOD.
ENDCLASS.
