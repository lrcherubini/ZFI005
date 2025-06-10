@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Status Job Escr. Baixa - FB09'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZI_WriteOffJobFB09
  as select from ztfi_escrbxa_st
  association [0..1] to ZI_JobStatus2 as _Jobs on  ztfi_escrbxa_st.jobname  = _Jobs.ApplicationJobName
                                               and ztfi_escrbxa_st.jobcount = _Jobs.ApplicationJob
{
  key bukrs    as CompanyCode,
  key belnr    as AccountingDocument,
  key gjahr    as FiscalYear,
  key buzei    as AccountingDocumentItem,
      status   as Status,
      jobcount as Jobcount,
      jobname  as Jobname,

      _Jobs
}
where
  procs = 'FB09'
