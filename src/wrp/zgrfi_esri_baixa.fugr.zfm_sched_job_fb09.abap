FUNCTION zfm_sched_job_fb09.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_BUKRS) TYPE  BSEG-BUKRS
*"     VALUE(IV_BELNR) TYPE  BSEG-BELNR
*"     VALUE(IV_GJAHR) TYPE  BSEG-GJAHR
*"     VALUE(IV_BUZEI) TYPE  BSEG-BUZEI
*"     VALUE(IV_DTWS1) TYPE  BSEG-DTWS1
*"  EXPORTING
*"     VALUE(EV_JOBNAME) TYPE  TBTCJOB-JOBNAME
*"     VALUE(EV_JOBCOUNT) TYPE  TBTCJOB-JOBCOUNT
*"  EXCEPTIONS
*"      JOB_OPEN_ERROR
*"      JOB_SUBMIT_ERROR
*"      JOB_CLOSE_ERROR
*"----------------------------------------------------------------------
  DATA: lv_strtdt TYPE tbtcjob-sdlstrtdt,
        lv_strttm TYPE tbtcjob-sdlstrttm,
        lv_valid  TYPE c LENGTH 1,
        ls_params TYPE pri_params.

* Get Print Parameters
  CLEAR sy-msgty.

  CALL FUNCTION 'GET_PRINT_PARAMETERS'
    EXPORTING
      no_dialog              = 'X'
    IMPORTING
      valid                  = lv_valid
      out_parameters         = ls_params
    EXCEPTIONS
      archive_info_not_found = 1
      invalid_print_params   = 2
      invalid_archive_params = 3
      OTHERS                 = 4.

  IF sy-subrc NE 0 OR lv_valid IS NOT INITIAL.
    IF sy-msgty NE space.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
        RAISING job_open_error.

    ELSE.
      MESSAGE e006 RAISING job_open_error.

    ENDIF.
  ENDIF.

  ev_jobname = |FB09_ESC_BXA_{ iv_bukrs }{ iv_belnr }{ iv_gjahr }|.

  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = ev_jobname
    IMPORTING
      jobcount         = ev_jobcount
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
      RAISING job_open_error.

  ENDIF.

  SUBMIT zfi0002 VIA JOB ev_jobname NUMBER ev_jobcount
    WITH p_bukrs = iv_bukrs
    WITH p_belnr = iv_belnr
    WITH p_gjahr = iv_gjahr
    WITH p_buzei = iv_buzei
    WITH p_dtws1 = iv_dtws1
    AND RETURN.

  IF sy-subrc NE 0.
    CASE sy-subrc.
      WHEN 4.      MESSAGE e007 RAISING job_submit_error.
      WHEN 8.      MESSAGE e008 RAISING job_submit_error.
      WHEN 12.     MESSAGE e009 RAISING job_submit_error.
      WHEN OTHERS. MESSAGE e010 RAISING job_submit_error.
    ENDCASE.
  ENDIF.

  DATA(lv_stdaz) = CONV p2012-anzhl( '0.01' ). " 36 segundos

  CALL FUNCTION 'CATT_ADD_TO_TIME'
    EXPORTING
      idate = sy-datum
      itime = sy-uzeit
      stdaz = lv_stdaz
    IMPORTING
      edate = lv_strtdt
      etime = lv_strttm.

  CALL FUNCTION 'JOB_CLOSE'
    EXPORTING
      jobcount             = ev_jobcount
      jobname              = ev_jobname
      strtimmed            = 'X'
      sdlstrtdt            = lv_strtdt
      sdlstrttm            = lv_strttm
    EXCEPTIONS
      cant_start_immediate = 1
      invalid_startdate    = 2
      jobname_missing      = 3
      job_close_failed     = 4
      job_nosteps          = 5
      job_notex            = 6
      lock_failed          = 7
      OTHERS               = 8.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
      RAISING job_close_error.

  ENDIF.

  zcl_escrbxa_status=>update_status(
    iv_commit   = abap_true
    iv_procs    = 'FB09'
    iv_bukrs    = iv_bukrs
    iv_belnr    = iv_belnr
    iv_gjahr    = iv_gjahr
    iv_buzei    = iv_buzei
    iv_status   = zif_escrbxa_status=>agendado
    iv_jobname  = ev_jobname
    iv_jobcount = ev_jobcount
  ).

ENDFUNCTION.
