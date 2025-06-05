FUNCTION ZFM_ESC_BAIXA_BTE_PROC_1430.
*"--------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_BKDF) TYPE  BKDF OPTIONAL
*"  TABLES
*"      T_BKPF STRUCTURE  BKPF
*"      T_BSEG STRUCTURE  BSEG
*"      T_BSEC STRUCTURE  BSEC OPTIONAL
*"      T_BKPFSUB STRUCTURE  BKPF_SUBST
*"      T_BSEGSUB STRUCTURE  BSEG_SUBST
*"  CHANGING
*"     REFERENCE(I_BKDFSUB) TYPE  BKDF_SUBST OPTIONAL
*"--------------------------------------------------------------------

*----------------------------------------------------------------------*
* Cópia de SAMPLE_PROCESS_00001430
* Função configurada na FIBF:
* - Configurações
* - Módulos de processo
* - ...de um cliente
* - Processo 00001430 (MODIFICAR DOCUMENTO: substit.campo cab./linha)
*----------------------------------------------------------------------*

  LOOP AT t_bseg.

    TRY.
        DATA(lo_escri_baixa) = zcl_fi_escritural_baixa_fac=>get_instance(
          EXPORTING
            is_key      = VALUE zif_fi_escritural_baixa=>ty_key(
            companycode            = t_bseg-bukrs
            accountingdocument     = t_bseg-belnr
            fiscalyear             = t_bseg-gjahr
            accountingdocumentitem = t_bseg-buzei
        ) ).

        lo_escri_baixa->bte_proc_1430(
          iv_koart = t_bseg-koart
          iv_shkzg = t_bseg-shkzg
          iv_xref3 = t_bseg-xref3
          iv_netdt = t_bseg-netdt
          iv_dtws1 = t_bseg-dtws1
        ).

      CATCH zcx_fi_escri_baixa INTO DATA(lx_escri_baixa).

    ENDTRY.

  ENDLOOP.

ENDFUNCTION.
