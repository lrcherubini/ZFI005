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

          READ ENTITIES OF zi_operacctgdocitemwriteoff  IN LOCAL MODE
            ENTITY docitem
              ALL FIELDS WITH VALUE #( ( %key = CORRESPONDING #( ls_keys ) ) )
            RESULT DATA(lt_docitem)
            FAILED DATA(lt_loc_failed)
            REPORTED DATA(lt_loc_reported).

          LOOP AT lt_docitem INTO DATA(ls_docitem).

            APPEND VALUE #( %cid_ref               = ls_keys-%cid_ref
                            companycode            = ls_keys-companycode
                            accountingdocument     = ls_keys-accountingdocument
                            fiscalyear             = ls_keys-fiscalyear
                            accountingdocumentitem = ls_keys-accountingdocumentitem
                            %param                 = CORRESPONDING #( ls_docitem ) ) TO result.

            APPEND VALUE #( %cid                   = ls_keys-%cid_ref
                            companycode            = ls_keys-companycode
                            accountingdocument     = ls_keys-accountingdocument
                            fiscalyear             = ls_keys-fiscalyear
                            accountingdocumentitem = ls_keys-accountingdocumentitem
                            %msg                   = new_message(
                            id       = 'ZFI_ESCR_BAIXA'
                            number   = '012'
                            severity = if_abap_behv_message=>severity-success
                            v1       = lv_jobname
                            v2       = lv_jobcount )
            ) TO reported-docitem.

          ENDLOOP.

        CATCH zcx_fi_escri_baixa INTO DATA(lx_escrb).
          APPEND VALUE #( %cid                   = ls_keys-%cid_ref
                          companycode            = ls_keys-companycode
                          accountingdocument     = ls_keys-accountingdocument
                          fiscalyear             = ls_keys-fiscalyear
                          accountingdocumentitem = ls_keys-accountingdocumentitem
          ) TO failed-docitem.

          APPEND VALUE #( %cid                   = ls_keys-%cid_ref
                          companycode            = ls_keys-companycode
                          accountingdocument     = ls_keys-accountingdocument
                          fiscalyear             = ls_keys-fiscalyear
                          accountingdocumentitem = ls_keys-accountingdocumentitem
                          %msg                   = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = lx_escrb->get_text( ) )
          ) TO reported-docitem.

      ENDTRY.

      CLEAR: lt_docitem,
             lt_loc_failed,
             lt_loc_reported.

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
