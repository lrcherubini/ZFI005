CLASS zcl_fi_escritural_baixa DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES zif_fi_escritural_baixa.

    ALIASES:
      valid_rule        FOR zif_fi_escritural_baixa~valid_rule,
      subst_rule        FOR zif_fi_escritural_baixa~subst_rule,
      bte_proc_1430     FOR zif_fi_escritural_baixa~bte_proc_1430,
      badi_fieb_change  FOR zif_fi_escritural_baixa~badi_fieb_change,
      action_fb08       FOR zif_fi_escritural_baixa~action_fb08,
      action_fb09       FOR zif_fi_escritural_baixa~action_fb09,
      ty_key            FOR zif_fi_escritural_baixa~ty_key,
      ty_subst_rule     FOR zif_fi_escritural_baixa~ty_subst_rule,
      ty_val_rule_ret   FOR zif_fi_escritural_baixa~ty_val_rule_ret,
      ty_job            FOR zif_fi_escritural_baixa~ty_job,
      ty_badi_fieb      FOR zif_fi_escritural_baixa~ty_badi_fieb,
      gc_val_rule_ret   FOR zif_fi_escritural_baixa~gc_val_rule_ret,
      gc_applog         FOR zif_fi_escritural_baixa~gc_applog,
      gc_job_sched      FOR zif_fi_escritural_baixa~gc_job_sched.

    METHODS:
      constructor
        IMPORTING
          !is_key TYPE ty_key
        RAISING
          zcx_fi_escri_baixa.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: ms_key  TYPE ty_key,
          ms_bseg TYPE i_operationalacctgdocitem,
          mo_log  TYPE REF TO if_bali_log.

    METHODS:
      read_bseg RAISING zcx_fi_escri_baixa.

    METHODS:
      call_fb08
        EXPORTING
          ev_jobname  TYPE ty_job-jobname
          ev_jobcount TYPE ty_job-jobcount
        RAISING
          zcx_fi_escri_baixa.

    METHODS:
      create_log.

    METHODS:
      add_log_item
        IMPORTING
          item TYPE REF TO if_bali_item_setter.

ENDCLASS.



CLASS zcl_fi_escritural_baixa IMPLEMENTATION.

  METHOD constructor.
    ms_key = is_key.
    read_bseg( ).
    create_log( ).

  ENDMETHOD.

  METHOD read_bseg.

    SELECT SINGLE FROM i_operationalacctgdocitem
     FIELDS *
     WHERE companycode            EQ @ms_key-companycode
       AND accountingdocument     EQ @ms_key-accountingdocument
       AND fiscalyear             EQ @ms_key-fiscalyear
       AND accountingdocumentitem EQ @ms_key-accountingdocumentitem
       INTO @ms_bseg.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_fi_escri_baixa
        EXPORTING
          textid = zcx_fi_escri_baixa=>zcx_fi_not_found
          bukrs  = ms_key-companycode
          belnr  = ms_key-accountingdocument
          gjahr  = ms_key-fiscalyear
          buzei  = ms_key-accountingdocumentitem.

    ENDIF.

  ENDMETHOD.

  METHOD valid_rule.

    cv_result = gc_val_rule_ret-true.

    CHECK ms_bseg-dataexchangeinstruction1 NE '02' AND ms_bseg-reference3idbybusinesspartner IS INITIAL.

    MESSAGE w002 WITH ms_bseg-companycode ms_bseg-accountingdocument
      ms_bseg-fiscalyear ms_bseg-accountingdocumentitem
      INTO DATA(lv_msg).

    cv_result = gc_val_rule_ret-false.

    add_log_item( cl_bali_message_setter=>create_from_sy( ) ).

  ENDMETHOD.

  METHOD subst_rule.

    CHECK ms_bseg-dataexchangeinstruction1 NE '02'.

    IF ms_bseg-reference3idbybusinesspartner IS INITIAL.
      add_log_item( cl_bali_message_setter=>create(
          severity   = if_bali_constants=>c_severity_warning
          id         = zcx_fi_escri_baixa=>zcx_fi_miss_ref3-msgid
          number     = zcx_fi_escri_baixa=>zcx_fi_miss_ref3-msgno
          variable_1 = |{ ms_bseg-companycode }|
          variable_2 = |{ ms_bseg-accountingdocument ALPHA = OUT }|
          variable_3 = |{ ms_bseg-fiscalyear }|
          variable_4 = |{ ms_bseg-accountingdocumentitem ALPHA = OUT }|
        )
      ).

      RAISE EXCEPTION TYPE zcx_fi_escri_baixa
        EXPORTING
          textid = zcx_fi_escri_baixa=>zcx_fi_miss_ref3
          bukrs  = ms_bseg-companycode
          belnr  = ms_bseg-accountingdocument
          gjahr  = ms_bseg-fiscalyear
          buzei  = ms_bseg-accountingdocumentitem.

    ELSE.
      CLEAR: cv_anfbu, cv_anfbn, cv_anfbj.

    ENDIF.

  ENDMETHOD.

  METHOD bte_proc_1430.

    CHECK iv_koart EQ 'D' AND iv_shkzg EQ 'S' AND iv_xref3 IS NOT INITIAL.

    CHECK iv_netdt NE ms_bseg-netduedate AND iv_dtws1 EQ '02' AND ms_bseg-dataexchangeinstruction1 NE '02'.

    TRY.
        call_fb08( ).
      CATCH zcx_fi_escri_baixa.
    ENDTRY.

  ENDMETHOD.

  METHOD badi_fieb_change.

    CHECK iv_vgext EQ '03'.

    TRY.
        call_fb08( ).
      CATCH zcx_fi_escri_baixa.
    ENDTRY.

  ENDMETHOD.

  METHOD action_fb08.

    call_fb08(
      IMPORTING
        ev_jobcount = ev_jobcount
        ev_jobname  = ev_jobname
    ).

  ENDMETHOD.

  METHOD action_fb09.

    TRY.
        zcl_job_fb09_wrapper=>execute(
          EXPORTING
            iv_bukrs    = ms_bseg-companycode
            iv_belnr    = ms_bseg-accountingdocument
            iv_gjahr    = ms_bseg-fiscalyear
            iv_buzei    = ms_bseg-accountingdocumentitem
            iv_dtws1    = '02'
          IMPORTING
            ev_jobname  = ev_jobname
            ev_jobcount = ev_jobcount
        ).

        add_log_item( cl_bali_message_setter=>create(
            severity = if_bali_constants=>c_severity_status
            id       = gc_job_sched-msgid
            number   = gc_job_sched-msgno
            variable_1 = |{ ev_jobname }|
            variable_2 = |{ ev_jobcount ALPHA = OUT }|
          )
        ).

      CATCH zcx_fi_escri_baixa INTO DATA(lx_escri_baixa).
        add_log_item( cl_bali_exception_setter=>create(
            severity  = if_bali_constants=>c_severity_error
            exception = lx_escri_baixa
          )
        ).

        RAISE EXCEPTION lx_escri_baixa.

    ENDTRY.

  ENDMETHOD.

  METHOD call_fb08.

    TRY.
        zcl_job_fb08_wrapper=>execute(
          EXPORTING
            iv_bukrs    = ms_bseg-companycode
            iv_belnr    = ms_bseg-accountingdocument
            iv_gjahr    = ms_bseg-fiscalyear
            iv_buzei    = ms_bseg-accountingdocumentitem
          IMPORTING
            ev_jobname  = ev_jobname
            ev_jobcount = ev_jobcount
        ).

        add_log_item( cl_bali_message_setter=>create(
            severity = if_bali_constants=>c_severity_status
            id       = gc_job_sched-msgid
            number   = gc_job_sched-msgno
            variable_1 = |{ ev_jobname }|
            variable_2 = |{ ev_jobcount ALPHA = OUT }|
          )
        ).

      CATCH zcx_fi_escri_baixa INTO DATA(lx_escri_baixa).
        add_log_item( cl_bali_exception_setter=>create(
            severity  = if_bali_constants=>c_severity_error
            exception = lx_escri_baixa
          )
        ).

        RAISE EXCEPTION lx_escri_baixa.

    ENDTRY.

  ENDMETHOD.

  METHOD create_log.

    TRY.
        mo_log = cl_bali_log=>create_with_header(
          header = cl_bali_header_setter=>create(
            object      = gc_applog-object
            subobject   = gc_applog-sb_proc
            external_id = |{ ms_key-companycode }{ ms_key-accountingdocument }{ ms_key-fiscalyear }{ ms_key-accountingdocumentitem }|
          )
        ).

      CATCH cx_bali_runtime.
    ENDTRY.

  ENDMETHOD.

  METHOD add_log_item.

    TRY.
        mo_log->add_item( item = item ).

        cl_bali_log_db=>get_instance( )->save_log_2nd_db_connection( log = mo_log ).

      CATCH cx_bali_runtime.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
