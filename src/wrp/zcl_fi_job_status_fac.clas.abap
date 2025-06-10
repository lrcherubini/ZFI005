CLASS zcl_fi_job_status_fac DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS factory
      RETURNING VALUE(ro_inst) TYPE REF TO zif_fi_job_status.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_fi_job_status_fac IMPLEMENTATION.
  METHOD factory.

    ro_inst = NEW zcl_fi_job_status(  ).

  ENDMETHOD.
ENDCLASS.
