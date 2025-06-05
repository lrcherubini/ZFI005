CLASS zcl_fi_escritural_baixa DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES zif_fi_escritural_baixa.

    ALIASES:
      valid_rule        FOR zif_fi_escritural_baixa~valid_rule,
      subst_rule        FOR zif_fi_escritural_baixa~subst_rule,
      bte_proc_1430     FOR zif_fi_escritural_baixa~bte_proc_1430,
      badi_fieb_change  FOR zif_fi_escritural_baixa~badi_fieb_change,
      action_fb08       FOR zif_fi_escritural_baixa~action_fb08,
      ty_key            FOR zif_fi_escritural_baixa~ty_key,
      ty_subst_rule     FOR zif_fi_escritural_baixa~ty_subst_rule,
      ty_val_rule_ret   FOR zif_fi_escritural_baixa~ty_val_rule_ret,
      ty_badi_fieb      FOR zif_fi_escritural_baixa~ty_badi_fieb,
      gc_val_rule_ret   FOR zif_fi_escritural_baixa~gc_val_rule_ret.

  METHODS:
    constructor
      IMPORTING
        !is_key TYPE ty_key
      RAISING
        zcx_fi_escri_baixa.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: ms_key  TYPE ty_key,
          ms_bseg TYPE i_operationalacctgdocitem.

    METHODS:
      read_bseg RAISING zcx_fi_escri_baixa.

ENDCLASS.



CLASS zcl_fi_escritural_baixa IMPLEMENTATION.

  METHOD constructor.
    ms_key = is_key.
    read_bseg( ).

  ENDMETHOD.

  METHOD read_bseg.

    SELECT SINGLE FROM i_operationalacctgdocitem
     FIELDS *
     WHERE companycode            EQ @ms_key-companycode
       AND accountingdocument     EQ @ms_key-accountingdocument
       AND fiscalyear             EQ @ms_key-fiscalyear
       AND accountingdocumentitem EQ @ms_key-accountingdocumentitem
       INTO @ms_bseg.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_fi_escri_baixa
        EXPORTING
          textid = zcx_fi_escri_baixa=>zcx_fi_not_found
          bukrs  = ms_key-companycode
          belnr  = ms_key-accountingdocument
          gjahr  = ms_key-fiscalyear
          buzei  = ms_key-accountingdocumentitem.

    ENDIF.

  ENDMETHOD.

  METHOD valid_rule.

    cv_result = gc_val_rule_ret-true.

    CHECK ms_bseg-dataexchangeinstruction1 NE '02' AND ms_bseg-reference3idbybusinesspartner IS INITIAL.

    MESSAGE e002 WITH ms_bseg-companycode ms_bseg-accountingdocument
      ms_bseg-fiscalyear ms_bseg-accountingdocumentitem
      INTO DATA(lv_msg).

    cv_result = gc_val_rule_ret-false.

  ENDMETHOD.

  METHOD subst_rule.

    CHECK ms_bseg-dataexchangeinstruction1 NE '02'.

    IF ms_bseg-reference3idbybusinesspartner IS INITIAL.
      RAISE EXCEPTION TYPE zcx_fi_escri_baixa
        EXPORTING
          textid = zcx_fi_escri_baixa=>zcx_fi_miss_ref3
          bukrs  = ms_bseg-companycode
          belnr  = ms_bseg-accountingdocument
          gjahr  = ms_bseg-fiscalyear
          buzei  = ms_bseg-accountingdocumentitem.

    ELSE.
      CLEAR: cv_anfbu, cv_anfbn, cv_anfbj.

    ENDIF.

  ENDMETHOD.

  METHOD bte_proc_1430.

    CHECK iv_koart EQ 'D' AND iv_shkzg EQ 'S' AND iv_xref3 IS NOT INITIAL.

    CHECK iv_netdt NE ms_bseg-NetDueDate AND iv_dtws1 EQ '02' AND ms_bseg-DataExchangeInstruction1 NE '02'.

    " CALL Wrap FB08

  ENDMETHOD.

  METHOD badi_fieb_change.

    CHECK iv_vgext EQ '03'.

    " CALL Wrap FB08

  ENDMETHOD.

  METHOD action_fb08.

    " CALL Wrap FB08

  ENDMETHOD.
ENDCLASS.
