CLASS lhc_docitem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR docitem RESULT result.

    METHODS fb09 FOR MODIFY
      IMPORTING keys FOR ACTION docitem~fb09 RESULT result.

ENDCLASS.

CLASS lhc_docitem IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD fb09.

    LOOP AT keys INTO DATA(ls_keys).

      TRY.
          DATA(lo_scrb) = zcl_fi_escritural_baixa_fac=>get_instance(
            EXPORTING
              is_key      = VALUE zif_fi_escritural_baixa=>ty_key(
              companycode            = ls_keys-companycode
              accountingdocument     = ls_keys-accountingdocument
              fiscalyear             = ls_keys-fiscalyear
              accountingdocumentitem = ls_keys-accountingdocumentitem
          ) ).

      lo_scrb->action_fb09(
        IMPORTING
          ev_jobname  = DATA(lv_jobname)
          ev_jobcount = DATA(lv_jobcount)
      ).

      APPEND VALUE #( %tky = ls_keys-%tky ) TO result.

      CATCH zcx_fi_escri_baixa INTO DATA(lx_escrb).

      ENDTRY.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_operacctgdocitemwriteof DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_operacctgdocitemwriteof IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
