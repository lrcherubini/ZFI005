*&---------------------------------------------------------------------*
*& Include          ZI_FI_GGBS_ESCRI_BAIXA
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
* FORM z001.
*----------------------------------------------------------------------*
* Rotina declara no pool de rotinas ZRGGBS00 (Cópia de RGGBS000)
* de regras de substituição de FI (GGB1)
*----------------------------------------------------------------------*
FORM z001.

  TRY.
      DATA(lo_escri_baixa) = zcl_fi_escritural_baixa_fac=>get_instance(
        EXPORTING
          is_key      = VALUE zif_fi_escritural_baixa=>ty_key(
          companycode            = bseg-bukrs
          accountingdocument     = bseg-belnr
          fiscalyear             = bseg-gjahr
          accountingdocumentitem = bseg-buzei
      ) ).

    CATCH zcx_fi_escri_baixa.
      RETURN.

  ENDTRY.

  TRY.
      lo_escri_baixa->subst_rule(
        CHANGING
          cv_anfbu = bseg-anfbu
          cv_anfbn = bseg-anfbn
          cv_anfbj = bseg-anfbj
      ).

    CATCH zcx_fi_escri_baixa INTO DATA(lx_escri_baixa).
      MESSAGE lx_escri_baixa->get_text( ) TYPE 'E'.

  ENDTRY.

ENDFORM.
