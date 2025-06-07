CLASS zcl_job_fb08_wrapper DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES zif_job_fb08_wrapper.

    ALIASES:
      execute        FOR zif_job_fb08_wrapper~execute,
      return_job     FOR zif_job_fb08_wrapper~return_job,
      process        FOR zif_job_fb08_wrapper~process.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA:
      gv_done     TYPE abap_boolean,
      gv_jobname  TYPE tbtcjob-jobname,
      gv_jobcount TYPE tbtcjob-jobcount,
      gs_return   TYPE bapiret2.

    CLASS-METHODS: initialize.

ENDCLASS.

CLASS zcl_job_fb08_wrapper IMPLEMENTATION.

  METHOD initialize.

    CLEAR: gv_done,
           gv_jobname,
           gv_jobcount,
           gs_return.

  ENDMETHOD.

  METHOD execute.

    SELECT SINGLE FROM bseg
      FIELDS bukrs, belnr, gjahr, buzei,
             anfbu, anfbn, anfbj
      WHERE bukrs EQ @iv_bukrs
        AND belnr EQ @iv_belnr
        AND gjahr EQ @iv_gjahr
        AND buzei EQ @iv_buzei
     INTO @DATA(ls_bseg).

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_fi_escri_baixa
        EXPORTING
          textid = zcx_fi_escri_baixa=>zcx_fi_not_found
          bukrs  = iv_bukrs
          belnr  = iv_belnr
          gjahr  = iv_gjahr
          buzei  = iv_buzei.

    ELSEIF ls_bseg-anfbn IS INITIAL.
      RAISE EXCEPTION TYPE zcx_fi_escri_baixa
        EXPORTING
          textid = zcx_fi_escri_baixa=>zcx_fi_not_found
          bukrs  = iv_bukrs
          belnr  = iv_belnr
          gjahr  = iv_gjahr
          buzei  = iv_buzei.

    ENDIF.

    TRY.
        DATA(lv_guid) = cl_system_uuid=>create_uuid_c22_static( ).

      CATCH cx_uuid_error.
        lv_guid = sy-datum && sy-uzeit.

    ENDTRY.

    initialize(  ).

    CALL FUNCTION 'ZFM_SCHED_JOB_FB08'
      STARTING NEW TASK lv_guid
      DESTINATION IN GROUP DEFAULT
      CALLING return_job ON END OF TASK
      EXPORTING
        iv_anfbu = ls_bseg-anfbu
        iv_anfbn = ls_bseg-anfbn
        iv_anfbj = ls_bseg-anfbj
        iv_stgrd = iv_stgrd
        iv_bldat = iv_bldat
      .

    WAIT FOR ASYNCHRONOUS TASKS UNTIL gv_done EQ abap_true.

    IF gs_return IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcx_fi_escri_baixa
        MESSAGE ID gs_return-id TYPE gs_return-type NUMBER gs_return-number
          WITH gs_return-message_v1 gs_return-message_v2
               gs_return-message_v3 gs_return-message_v4.

      zcl_escrbxa_status=>update_status(
        iv_commit   = abap_false
        iv_procs    = 'FB08'
        iv_bukrs    = ls_bseg-anfbu
        iv_belnr    = ls_bseg-anfbn
        iv_gjahr    = ls_bseg-anfbj
        iv_status   = zif_escrbxa_status=>erro
        iv_jobname  = gv_jobname
        iv_jobcount = gv_jobcount
      ).

    ENDIF.

    ev_jobcount = gv_jobcount.
    ev_jobname  = gv_jobname.

  ENDMETHOD.

  METHOD return_job.

    DATA: lv_fmess TYPE char255.

    RECEIVE RESULTS FROM FUNCTION 'ZFM_SCHED_JOB_FB08'
      IMPORTING
        ev_jobname            = gv_jobname
        ev_jobcount           = gv_jobcount
      EXCEPTIONS
        job_open_error        = 1
        job_submit_error      = 2
        job_close_error       = 3
        communication_failure = 4 MESSAGE lv_fmess
        system_failure        = 5 MESSAGE lv_fmess
        OTHERS                = 6.

    IF sy-subrc NE 0.
      IF lv_fmess IS NOT INITIAL.
        DATA(lt_msg) = zcl_ba_util=>split_text_2_msg( lv_fmess ).
        DATA(ls_msg) = CORRESPONDING symsg( VALUE #( lt_msg[ 1 ] OPTIONAL ) ).
        ls_msg-msgid = 'ZFI_ESCR_BAIXA'.
        ls_msg-msgno = '000'.

      ELSE.
        ls_msg = CORRESPONDING #( syst ).

      ENDIF.

      CALL FUNCTION 'BALW_BAPIRETURN_GET2'
        EXPORTING
          type   = 'E'
          cl     = ls_msg-msgid
          number = ls_msg-msgno
          par1   = ls_msg-msgv1
          par2   = ls_msg-msgv2
          par3   = ls_msg-msgv3
          par4   = ls_msg-msgv4
        IMPORTING
          return = gs_return.

    ENDIF.

    gv_done = abap_true.

  ENDMETHOD.

  METHOD process.

    TYPES:
      BEGIN OF ty_fb08_ret,
        bukrs TYPE bukrs,
        belnr TYPE belnr_d,
        gjahr TYPE gjahr,
        t_msg TYPE tab_bdcmsgcoll,
      END OF ty_fb08_ret.

    DATA: ls_fb08_ret TYPE ty_fb08_ret.

    TRY.
        DATA(lo_log) = cl_bali_log=>create_with_header(
          header = cl_bali_header_setter=>create(
            object      = zif_fi_escritural_baixa=>gc_applog-object
            subobject   = zif_fi_escritural_baixa=>gc_applog-sb_job
            external_id = |{ iv_bukrs }{ iv_belnr }{ iv_gjahr }|
          )
        ).

      CATCH cx_bali_runtime.
    ENDTRY.

    CALL FUNCTION 'FB08_DELETE_BUFFER'.
    DELETE FROM DATABASE rfdt(ra) ID 'FBRA'.

    CALL FUNCTION 'CALL_FB08'
      EXPORTING
        i_bukrs      = iv_bukrs
        i_belnr      = iv_belnr
        i_gjahr      = iv_gjahr
*       i_bvorg      = space
        i_stgrd      = iv_stgrd
*       i_voidr      =
        i_budat      = iv_bldat
*       i_monat      =
*       i_xsimu      = space
*       i_update     = 'A'
*       i_mode       = 'N'
*       i_no_auth    = space
*       i_bldat      =
*       i_vatdate    =
*       i_prcheck    = space
*       i_write_log  = space
*    IMPORTING
*       e_budat      =
*       e_monat      =
*       e_xsofo      =
      EXCEPTIONS
        not_possible = 1
        OTHERS       = 2.

    DATA(lv_subrc) = sy-subrc.

    TRY.
        IF lv_subrc NE 0.
          lo_log->add_item( item = cl_bali_message_setter=>create_from_sy( ) ).

        ELSE.
          lo_log->add_item( item =
            cl_bali_message_setter=>create(
              severity   = if_bali_constants=>c_severity_status
              id         = 'ZFI_ESCR_BAIXA'
              number     = '005'
              variable_1 = |{ iv_bukrs }|
              variable_2 = |{ iv_belnr ALPHA = OUT }|
              variable_3 = |{ iv_gjahr }|
            )
          ).

        ENDIF.

        IMPORT bkpf-bukrs TO ls_fb08_ret-bukrs
               bkpf-belnr TO ls_fb08_ret-belnr
               bkpf-gjahr TO ls_fb08_ret-gjahr
               msg        TO ls_fb08_ret-t_msg
          FROM DATABASE rfdt(ra) ID 'FBRA'.

        IF    iv_bukrs EQ ls_fb08_ret-bukrs
          AND iv_belnr EQ ls_fb08_ret-belnr
          AND iv_gjahr EQ ls_fb08_ret-gjahr.

          LOOP AT ls_fb08_ret-t_msg INTO DATA(ls_msg).

            lo_log->add_item( item =
              cl_bali_message_setter=>create(
                severity   = ls_msg-msgtyp
                id         = ls_msg-msgid
                number     = CONV #( ls_msg-msgnr )
                variable_1 = CONV #( ls_msg-msgv1 )
                variable_2 = CONV #( ls_msg-msgv2 )
                variable_3 = CONV #( ls_msg-msgv3 )
                variable_4 = CONV #( ls_msg-msgv4 )
              )
            ).

          ENDLOOP.
        ENDIF.

        cl_bali_log_db=>get_instance( )->save_log_2nd_db_connection( log = lo_log ).
        ev_loghandle = lo_log->get_handle(  ).

      CATCH cx_bali_runtime.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
