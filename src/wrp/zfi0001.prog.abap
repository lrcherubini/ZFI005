*&---------------------------------------------------------------------*
*& Report ZFI0001
*&---------------------------------------------------------------------*

REPORT zfi0001.

DATA: gv_jobname  TYPE tbtco-jobname,
      gv_jobcount TYPE tbtco-jobcount.

PARAMETERS: p_anfbu TYPE bseg-anfbu OBLIGATORY,
            p_anfbn TYPE bseg-anfbn OBLIGATORY,
            p_anfbj TYPE bseg-anfbj OBLIGATORY,
            p_stgrd TYPE stgrd DEFAULT '01',
            p_bldat TYPE bldat DEFAULT sy-datum.

START-OF-SELECTION.

  CALL FUNCTION 'GET_JOB_RUNTIME_INFO'
    IMPORTING
*     eventid         =
*     eventparm       =
*     external_program_active =
      jobcount        = gv_jobcount
      jobname         = gv_jobname
*     stepcount       =
    EXCEPTIONS
      no_runtime_info = 1
      OTHERS          = 2.

  zcl_escrbxa_status=>update_status(
    iv_commit   = abap_true
    iv_procs    = 'FB08'
    iv_bukrs    = p_anfbu
    iv_belnr    = p_anfbn
    iv_gjahr    = p_anfbj
    iv_status   = zif_escrbxa_status=>agendado
    iv_jobname  = gv_jobname
    iv_jobcount = gv_jobcount
  ).

  PERFORM zf_process_fb08.

FORM zf_process_fb08.

  DATA: ls_return TYPE bapiret2,
        lt_return TYPE bapiret2_tt.

  zcl_job_fb08_wrapper=>process(
    EXPORTING
      iv_bukrs     = p_anfbu
      iv_belnr     = p_anfbn
      iv_gjahr     = p_anfbj
      iv_stgrd     = p_stgrd
      iv_bldat     = p_bldat
    IMPORTING
      ev_loghandle = DATA(lv_loghandle)
  ).

  WAIT UP TO 1 SECONDS.

  TRY.
      DATA(lo_logs) = cl_bali_log_db=>get_instance( )->load_log_with_items(
        EXPORTING
          handle = lv_loghandle
      ).

      LOOP AT lo_logs->get_all_items( ) INTO DATA(ls_item).

        CLEAR ls_return.

        CASE ls_item-item->category.
          WHEN if_bali_constants=>c_category_message.
            DATA(lo_message_ref) = CAST if_bali_message_getter( ls_item-item ).

            CALL FUNCTION 'BALW_BAPIRETURN_GET2'
              EXPORTING
                type   = lo_message_ref->severity
                cl     = lo_message_ref->id
                number = lo_message_ref->number
                par1   = lo_message_ref->variable_1
                par2   = lo_message_ref->variable_2
                par3   = lo_message_ref->variable_3
                par4   = lo_message_ref->variable_4
              IMPORTING
                return = ls_return.

          WHEN if_bali_constants=>c_category_free_text
            OR if_bali_constants=>c_category_exception.

            DATA(lo_text_ref) = CAST if_bali_item_getter( ls_item-item ).

            DATA(lt_msg) = zcl_ba_util=>split_text_2_msg(
              EXPORTING
                iv_text = lo_text_ref->get_message_text( )
            ).

            DATA(ls_msg) = VALUE #( lt_msg[ 1 ] OPTIONAL ).

            CALL FUNCTION 'BALW_BAPIRETURN_GET2'
              EXPORTING
                type   = lo_text_ref->severity
                cl     = 'ZFI_ESCR_BAIXA'
                number = '000'
                par1   = ls_msg-msgv1
                par2   = ls_msg-msgv2
                par3   = ls_msg-msgv3
                par4   = ls_msg-msgv4
              IMPORTING
                return = ls_return.

          WHEN OTHERS. CONTINUE.
        ENDCASE.

        APPEND ls_return TO lt_return.

        IF ls_return-type CA 'AEX'.
          DATA(lv_error) = abap_true.

        ENDIF.

      ENDLOOP.

      zcl_escrbxa_status=>update_status(
        iv_commit   = abap_true
        iv_procs    = 'FB08'
        iv_bukrs    = p_anfbu
        iv_belnr    = p_anfbn
        iv_gjahr    = p_anfbj
        iv_status   = COND #( WHEN lv_error IS INITIAL THEN zif_escrbxa_status=>sucesso ELSE zif_escrbxa_status=>erro )
        iv_jobname  = gv_jobname
        iv_jobcount = gv_jobcount
      ).

      CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
        EXPORTING
          it_message = lt_return.

    CATCH cx_bali_runtime.
  ENDTRY.

ENDFORM.
