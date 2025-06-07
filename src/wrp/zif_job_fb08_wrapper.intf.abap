INTERFACE zif_job_fb08_wrapper
  PUBLIC .

  CLASS-METHODS execute
    IMPORTING
      !iv_bukrs   TYPE bukrs
      !iv_belnr   TYPE belnr_d
      !iv_gjahr   TYPE gjahr
      !iv_buzei   TYPE bseg-buzei
      !iv_stgrd   TYPE stgrd DEFAULT '01'
      !iv_bldat   TYPE bldat DEFAULT sy-datum
    EXPORTING
      ev_jobname  TYPE tbtcjob-jobname
      ev_jobcount TYPE tbtcjob-jobcount
    RAISING
      zcx_fi_escri_baixa.

  CLASS-METHODS: return_job
    IMPORTING
      p_task TYPE csequence.

  CLASS-METHODS process
    IMPORTING
      !iv_bukrs    TYPE bukrs
      !iv_belnr    TYPE belnr_d
      !iv_gjahr    TYPE gjahr
      !iv_stgrd    TYPE stgrd DEFAULT '01'
      !iv_bldat    TYPE bldat DEFAULT sy-datum
    EXPORTING
      ev_loghandle TYPE if_bali_log=>ty_handle.

ENDINTERFACE.
