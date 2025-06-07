INTERFACE zif_job_fb09_wrapper
  PUBLIC .

  CLASS-METHODS execute
    IMPORTING
      !iv_bukrs    TYPE bseg-bukrs
      !iv_belnr    TYPE bseg-belnr
      !iv_gjahr    TYPE bseg-gjahr
      !iv_buzei    TYPE bseg-buzei
      !iv_dtws1    TYPE bseg-dtws1 DEFAULT '02'
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
      !iv_bukrs    TYPE bseg-bukrs
      !iv_belnr    TYPE bseg-belnr
      !iv_gjahr    TYPE bseg-gjahr
      !iv_buzei    TYPE bseg-buzei
      !iv_dtws1    TYPE bseg-dtws1 DEFAULT '02'
    EXPORTING
      ev_loghandle TYPE if_bali_log=>ty_handle.

ENDINTERFACE.
