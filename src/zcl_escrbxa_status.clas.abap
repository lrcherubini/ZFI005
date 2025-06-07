CLASS zcl_escrbxa_status DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_escrbxa_status .

    ALIASES:
      update_status FOR zif_escrbxa_status~update_status.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_escrbxa_status IMPLEMENTATION.

  METHOD update_status.

    DATA(ls_status) = VALUE ztfi_escrbxa_st(
      client   = sy-mandt
      procs    = iv_procs
      bukrs    = iv_bukrs
      belnr    = iv_belnr
      gjahr    = iv_gjahr
      buzei    = iv_buzei
      status   = iv_status
      jobname  = iv_jobname
      jobcount = iv_jobcount ).

    MODIFY ztfi_escrbxa_st FROM @ls_status.

    CHECK iv_commit IS NOT INITIAL.

    COMMIT WORK.

  ENDMETHOD.
ENDCLASS.
