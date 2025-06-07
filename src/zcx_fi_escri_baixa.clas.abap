CLASS zcx_fi_escri_baixa DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .

    CONSTANTS:
      BEGIN OF zcx_fi_escri_baixa,
        msgid TYPE symsgid VALUE 'ZFI_ESCR_BAIXA',
        msgno TYPE symsgno VALUE '000',
        attr1 TYPE scx_attrname VALUE 'BUKRS',
        attr2 TYPE scx_attrname VALUE 'BELNR',
        attr3 TYPE scx_attrname VALUE 'GJAHR',
        attr4 TYPE scx_attrname VALUE 'BUZEI',
      END OF zcx_fi_escri_baixa .
    CONSTANTS:
      BEGIN OF zcx_fi_not_found,
        msgid TYPE symsgid VALUE 'ZFI_ESCR_BAIXA',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'BUKRS',
        attr2 TYPE scx_attrname VALUE 'BELNR',
        attr3 TYPE scx_attrname VALUE 'GJAHR',
        attr4 TYPE scx_attrname VALUE 'BUZEI',
      END OF zcx_fi_not_found .
    CONSTANTS:
      BEGIN OF zcx_fi_miss_ref3,
        msgid TYPE symsgid VALUE 'ZFI_ESCR_BAIXA',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'BUKRS',
        attr2 TYPE scx_attrname VALUE 'BELNR',
        attr3 TYPE scx_attrname VALUE 'GJAHR',
        attr4 TYPE scx_attrname VALUE 'BUZEI',
      END OF zcx_fi_miss_ref3 .
    CONSTANTS:
      BEGIN OF zcx_fi_miss_anfbn,
        msgid TYPE symsgid VALUE 'ZFI_ESCR_BAIXA',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'BUKRS',
        attr2 TYPE scx_attrname VALUE 'BELNR',
        attr3 TYPE scx_attrname VALUE 'GJAHR',
        attr4 TYPE scx_attrname VALUE 'BUZEI',
      END OF zcx_fi_miss_anfbn .
    DATA bukrs TYPE bukrs .
    DATA belnr TYPE belnr_d .
    DATA gjahr TYPE gjahr .
    DATA buzei TYPE buzei .

    METHODS constructor
      IMPORTING
        !textid   LIKE if_t100_message=>t100key OPTIONAL
        !previous LIKE previous OPTIONAL
        !bukrs    TYPE bukrs OPTIONAL
        !belnr    TYPE belnr_d OPTIONAL
        !gjahr    TYPE gjahr OPTIONAL
        !buzei    TYPE buzei OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_fi_escri_baixa IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    me->bukrs = bukrs .
    me->belnr = belnr .
    me->gjahr = gjahr .
    me->buzei = buzei .
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = zcx_fi_escri_baixa .
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
