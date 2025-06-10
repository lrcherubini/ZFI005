@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Logs SLG1'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}

define view entity ZI_WriteOffLogs
  as select from R_ApplicationLogHeader
{
      @Semantics.uuid
      @Consumption.semanticObject: 'ApplicationLog'
  key ApplicationLogUUID              as LogHandle,
      ApplicationLogObject,
      ApplicationLogSubObject,
      ApplicationLogExternalID,
      @Semantics.systemDateTime.createdAt
      ApplicationLogDateTime,
      ApplicationLogDate,
      ApplicationLogTime,
      @Semantics.user.createdBy
      ApplicationLogUser,
      @Semantics.systemDateTime.lastChangedAt
      ApplicationLogChangedDateTime,
      ApplicationLogChangedDate,
      ApplicationLogChangedTime,
      @Semantics.user.lastChangedBy
      ApplicationLogChangedUser,
      ApplicationLogExpiryDate,
      LogIsNotDeletedBeforeExpiry,
      NumberOfAllMessages,
      NumberOfAbortMessages,
      NumberOfErrorMessages,
      NumberOfWarningMessages,
      NumberOfInformationMessages,
      NumberOfStatusMessages,
      case
      when cast( NumberOfAbortMessages as abap.int4) > 0    then 2
      when cast( NumberOfErrorMessages as abap.int4) > 0    then 2
      when cast( NumberOfWarningMessages as abap.int4) > 0  then 1
      when cast( NumberOfAllMessages as abap.int4) > 0      then 3
      else cast( 5  as abap.int4) end as Criticality
}
where
  ApplicationLogObject = 'ZFI_ESCR_BAIXA'
