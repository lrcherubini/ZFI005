CLASS zcl_fi_escritural_baixa_fac DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.
  PUBLIC SECTION.

    TYPES: BEGIN OF ty_instances,
             key      TYPE zif_fi_escritural_baixa=>ty_key,
             instance TYPE REF TO zif_fi_escritural_baixa,
           END OF ty_instances.

    CLASS-METHODS:
      get_instance
        IMPORTING
                  is_key             TYPE zif_fi_escritural_baixa=>ty_key
        RETURNING VALUE(ro_instance) TYPE REF TO zif_fi_escritural_baixa
        RAISING   zcx_fi_escri_baixa.

  PRIVATE SECTION.
    CLASS-DATA:
      mt_instances TYPE HASHED TABLE OF ty_instances
                   WITH UNIQUE KEY key.
ENDCLASS.



CLASS zcl_fi_escritural_baixa_fac IMPLEMENTATION.
  METHOD get_instance.

    READ TABLE mt_instances INTO DATA(ls_instances) WITH KEY key = is_key.

    IF sy-subrc EQ 0.
      ro_instance = ls_instances-instance.

    ELSE.
      CREATE OBJECT ro_instance TYPE zcl_fi_escritural_baixa
        EXPORTING
          is_key = is_key.

      INSERT VALUE #( key = is_key instance = ro_instance ) INTO TABLE mt_instances.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
