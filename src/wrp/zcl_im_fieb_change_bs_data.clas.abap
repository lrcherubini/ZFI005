CLASS zcl_im_fieb_change_bs_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_ex_fieb_change_bs_data .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_im_fieb_change_bs_data IMPLEMENTATION.


  METHOD if_ex_fieb_change_bs_data~change_data.

    TRY.
        DATA(lo_escri_baixa) = zcl_fi_escritural_baixa_fac=>get_instance(
          EXPORTING
            is_key      = VALUE zif_fi_escritural_baixa=>ty_key(
            companycode            = c_febko-bukrs
            accountingdocument     = c_febep-kkref(10)
            fiscalyear             = c_febep-kkref+10(4)
            accountingdocumentitem = c_febep-xblnr+13(3)
        ) ).

        lo_escri_baixa->badi_fieb_change( iv_vgext = c_febep-vgext ).

      CATCH zcx_fi_escri_baixa INTO DATA(lx_escri_baixa).

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
