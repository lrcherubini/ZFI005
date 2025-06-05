class ZCX_FI_ESCRI_BAIXA definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

public section.

  interfaces IF_T100_MESSAGE .
  interfaces IF_T100_DYN_MSG .

  constants:
    begin of ZCX_FI_ESCRI_BAIXA,
      msgid type symsgid value 'ZFI_ESCR_BAIXA',
      msgno type symsgno value '000',
      attr1 type scx_attrname value 'BUKRS',
      attr2 type scx_attrname value 'BELNR',
      attr3 type scx_attrname value 'GJAHR',
      attr4 type scx_attrname value 'BUZEI',
    end of ZCX_FI_ESCRI_BAIXA .
  constants:
    begin of ZCX_FI_NOT_FOUND,
      msgid type symsgid value 'ZFI_ESCR_BAIXA',
      msgno type symsgno value '001',
      attr1 type scx_attrname value 'BUKRS',
      attr2 type scx_attrname value 'BELNR',
      attr3 type scx_attrname value 'GJAHR',
      attr4 type scx_attrname value 'BUZEI',
    end of ZCX_FI_NOT_FOUND .
  constants:
    begin of ZCX_FI_MISS_REF3,
      msgid type symsgid value 'ZFI_ESCR_BAIXA',
      msgno type symsgno value '002',
      attr1 type scx_attrname value 'BUKRS',
      attr2 type scx_attrname value 'BELNR',
      attr3 type scx_attrname value 'GJAHR',
      attr4 type scx_attrname value 'BUZEI',
    end of ZCX_FI_MISS_REF3 .
  data BUKRS type BUKRS .
  data BELNR type BELNR_D .
  data GJAHR type GJAHR .
  data BUZEI type BUZEI .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !BUKRS type BUKRS optional
      !BELNR type BELNR_D optional
      !GJAHR type GJAHR optional
      !BUZEI type BUZEI optional .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCX_FI_ESCRI_BAIXA IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->BUKRS = BUKRS .
me->BELNR = BELNR .
me->GJAHR = GJAHR .
me->BUZEI = BUZEI .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = ZCX_FI_ESCRI_BAIXA .
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
