INTERFACE zif_escrbxa_status
  PUBLIC .

  CONSTANTS:
    agendado    TYPE zde_escrbxa_status VALUE '01',
    processando TYPE zde_escrbxa_status VALUE '02',
    sucesso     TYPE zde_escrbxa_status VALUE '03',
    erro        TYPE zde_escrbxa_status VALUE '04'.

  CLASS-METHODS update_status
    IMPORTING
      iv_commit   TYPE abap_boolean DEFAULT abap_false
      iv_procs    TYPE tcode
      iv_bukrs    TYPE bukrs
      iv_belnr    TYPE belnr_d
      iv_gjahr    TYPE gjahr
      iv_buzei    TYPE buzei OPTIONAL
      iv_status   TYPE ztfi_escrbxa_st-status
      iv_jobname  TYPE ztfi_escrbxa_st-jobname OPTIONAL
      iv_jobcount TYPE ztfi_escrbxa_st-jobcount OPTIONAL.

ENDINTERFACE.
