@EndUserText.label: 'Job Status'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_FI_CUST_ENTITY_JOB_ST'
@Metadata.allowExtensions: true

define custom entity ZI_JobStatus
{
      @UI.lineItem       : [ {
        position         : 10,
        label            : 'Job'
      } ]
      @EndUserText.label : 'Job Name'
  key ApplicationJobName : abap.char(32);
      @UI.lineItem       : [ {
        position         : 20,
        label            : 'Numerador'
      } ]
      @EndUserText.label : 'Job Counter'
  key ApplicationJob     : abap.char(8);
      @UI.lineItem       : [ {
        position         : 30,
        label            : 'Usuário do Job'
      } ]
      @EndUserText.label : 'Schedule by'
      ScheduledByUser    : abp_creation_user;
      @UI.lineItem       : [ {
        position         : 40,
        label            : 'Status'
      } ]
      @EndUserText.label : 'Status'
      Status             : abap.char(1);
      @UI.lineItem       : [ {
        position         : 50,
        label            : 'Descr. Status'
      } ]
      @EndUserText.label : 'Status Description'
      StatusText         : abap.char(30);
}
