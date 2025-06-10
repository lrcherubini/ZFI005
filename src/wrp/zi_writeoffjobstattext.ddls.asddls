@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Textos de Status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZI_WriteOffJobStatText
  as select from I_DomainFixedValueText
  association [0..1] to I_Language as _Language on $projection.Language = _Language.Language
{
  key cast(DomainValue as zde_escrbxa_status) as JobStatus,
      @ObjectModel.foreignKey.association:'_Language'
      @Semantics.language:true
  key Language,
      @Semantics.text:true
      DomainText                              as JobStatusText,
      @Analytics.hidden:true
      @Consumption.hidden:true
      DomainValue,
      DomainValuePosition,
      _Language
}
where
  SAPDataDictionaryDomain = 'ZDO_ESCRBXA_STATUS';
