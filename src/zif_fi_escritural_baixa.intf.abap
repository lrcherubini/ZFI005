INTERFACE zif_fi_escritural_baixa PUBLIC.

  TYPES:
    BEGIN OF ty_key,
      companycode            TYPE i_operationalacctgdocitem-companycode,
      accountingdocument     TYPE i_operationalacctgdocitem-accountingdocument,
      fiscalyear             TYPE i_operationalacctgdocitem-fiscalyear,
      accountingdocumentitem TYPE i_operationalacctgdocitem-accountingdocumentitem,
    END OF ty_key.

  TYPES:
    BEGIN OF ty_subst_rule,
      anfbu TYPE i_operationalacctgdocitem-CompanyCode,
      anfbn TYPE i_operationalacctgdocitem-AccountingDocument,
      anfbj TYPE i_operationalacctgdocitem-FiscalYear,
    END OF ty_subst_rule.

  TYPES:
    ty_val_rule_ret TYPE c LENGTH 1.

  TYPES:
    BEGIN OF ty_badi_fieb,
      vgext TYPE c LENGTH 27,
      kkref TYPE c LENGTH 35,
    END OF ty_badi_fieb.

  CONSTANTS:
    BEGIN OF gc_val_rule_ret,
      true  TYPE ty_val_rule_ret VALUE 'T',
      false TYPE ty_val_rule_ret VALUE 'F',
    END OF gc_val_rule_ret.

  METHODS:
    valid_rule
      CHANGING
        !cv_result TYPE ty_val_rule_ret,

    subst_rule
      CHANGING
        !cv_anfbu TYPE ty_subst_rule-anfbu
        !cv_anfbn TYPE ty_subst_rule-anfbn
        !cv_anfbj TYPE ty_subst_rule-anfbj
      RAISING
        zcx_fi_escri_baixa,

    bte_proc_1430
      IMPORTING
        iv_koart TYPE koart
        iv_shkzg TYPE shkzg
        iv_xref3 TYPE i_operationalacctgdocitem-reference3idbybusinesspartner
        iv_netdt TYPE i_operationalacctgdocitem-netduedate
        iv_dtws1 TYPE i_operationalacctgdocitem-dataexchangeinstruction1,

    badi_fieb_change
      IMPORTING
        iv_vgext TYPE ty_badi_fieb-vgext,

    action_fb08.

ENDINTERFACE.
