@VDM.lifecycle.contract.type: #PUBLIC_LOCAL_API
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.sqlViewName: 'ZIFIOPACTGDOCIT'
@AbapCatalog.preserveKey:true
@EndUserText.label: 'Operational Accounting Document Item'
@VDM.viewType: #BASIC
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.representativeKey: 'AccountingDocumentItem'
@ObjectModel.usageType.sizeCategory: #XXL
@ObjectModel.usageType.dataClass:  #MIXED
@ObjectModel.usageType.serviceQuality: #C
@Analytics: {
      dataCategory: #DIMENSION,
      dataExtraction: {
        enabled: true,
        delta.changeDataCapture: {
          mapping:
            [
              {
                table: 'BSEG',
                role: #MAIN,
                viewElement: ['CompanyCode', 'AccountingDocument', 'FiscalYear', 'AccountingDocumentItem'],
                tableElement: ['bukrs', 'belnr', 'gjahr', 'buzei']
              }
            ]
         }
      }
    }
@ClientHandling.algorithm: #SESSION_VARIABLE
@AbapCatalog.buffering.status: #NOT_ALLOWED
@AccessControl.personalData.blocking: #('TRANSACTIONAL_DATA')
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions:true

@ObjectModel.modelingPattern: #ANALYTICAL_DIMENSION
@ObjectModel.supportedCapabilities: [#ANALYTICAL_DIMENSION,
                                     #CDS_MODELING_ASSOCIATION_TARGET,
                                     #CDS_MODELING_DATA_SOURCE,
                                     #EXTRACTION_DATA_SOURCE,
                                     #SQL_DATA_SOURCE]

define view ZI_OperationalAcctgDocItem
  as select from P_BSEG_COM //inner join t001 on P_BSEG_COM.bukrs = t001.bukrs

  /* *************************************************************
   *  association zur ID
   * *************************************************************
  */
  association [0..1] to I_JournalEntry                 as _JournalEntry                  on  $projection.CompanyCode        = _JournalEntry.CompanyCode
                                                                                         and $projection.FiscalYear         = _JournalEntry.FiscalYear
                                                                                         and $projection.AccountingDocument = _JournalEntry.AccountingDocument
  association [1..1] to I_CompanyCode                  as _CompanyCode                   on  $projection.CompanyCode = _CompanyCode.CompanyCode
  association [0..1] to I_FiscalYearForCompanyCode     as _FiscalYear                    on  $projection.FiscalYear  = _FiscalYear.FiscalYear
                                                                                         and $projection.CompanyCode = _FiscalYear.CompanyCode
  //association [0..1] to I_FiscalYear                 as _FiscalYear                 on  $projection.FiscalYear  = _FiscalYear.FiscalYear
  //                                                                                  and $projection.FiscalYearVariant = _FiscalYear.FiscalYearVariant
  association [0..1] to I_ControllingArea              as _ControllingArea               on  $projection.ControllingArea = _ControllingArea.ControllingArea
  association [0..1] to I_ControllingArea              as _ControllingAreaText           on  $projection.ControllingArea = _ControllingAreaText.ControllingArea
  association [0..1] to I_GLAccountInChartOfAccounts   as _GLAccountInChartOfAccounts    on  $projection.ChartOfAccounts = _GLAccountInChartOfAccounts.ChartOfAccounts
                                                                                         and $projection.GLAccount       = _GLAccountInChartOfAccounts.GLAccount
  association [0..1] to I_GLAccountInCompanyCode       as _GLAccountInCompanyCode        on  $projection.CompanyCode = _GLAccountInCompanyCode.CompanyCode
                                                                                         and $projection.GLAccount   = _GLAccountInCompanyCode.GLAccount
  association [0..*] to I_ProfitCenter                 as _ProfitCenter                  on  $projection.ControllingArea = _ProfitCenter.ControllingArea
                                                                                         and $projection.ProfitCenter    = _ProfitCenter.ProfitCenter
  association [0..1] to I_ProfitCenter                 as _CurrentProfitCenter           on  $projection.ControllingArea            = _CurrentProfitCenter.ControllingArea
                                                                                         and $projection.ProfitCenter               = _CurrentProfitCenter.ProfitCenter
                                                                                         and _CurrentProfitCenter.ValidityStartDate <= $session.system_date
                                                                                         and _CurrentProfitCenter.ValidityEndDate   >= $session.system_date
  association [0..*] to I_CostCenter                   as _CostCenter                    on  $projection.ControllingArea = _CostCenter.ControllingArea
                                                                                         and $projection.CostCenter      = _CostCenter.CostCenter
  association [0..1] to I_CostCenter                   as _CurrentCostCenter             on  $projection.ControllingArea          = _CurrentCostCenter.ControllingArea
                                                                                         and $projection.CostCenter               = _CurrentCostCenter.CostCenter
                                                                                         and _CurrentCostCenter.ValidityStartDate <= $session.system_date
                                                                                         and _CurrentCostCenter.ValidityEndDate   >= $session.system_date
  association [0..*] to I_CostCenterText               as _CostCenterText                on  $projection.ControllingArea = _CostCenterText.ControllingArea
                                                                                         and $projection.CostCenter      = _CostCenterText.CostCenter
  association [0..1] to I_Segment                      as _Segment                       on  $projection.Segment = _Segment.Segment
  association [0..*] to I_SegmentText                  as _SegmentText                   on  $projection.Segment = _SegmentText.Segment

  association [0..1] to I_Customer                     as _Customer                      on  $projection.Customer = _Customer.Customer
  association [0..1] to I_Customer                     as _CustomerText                  on  $projection.Customer = _CustomerText.Customer
  association [0..1] to I_CustomerCompany              as _CustomerCompany               on  $projection.Customer    = _CustomerCompany.Customer
                                                                                         and $projection.CompanyCode = _CustomerCompany.CompanyCode

  // do not use: #DEPRECATED  ; use _JournalEntryItemOneTimeData
  association [0..1] to I_OneTimeAccountBP             as _OneTimeAccountBP              on  $projection.CompanyCode            = _OneTimeAccountBP.CompanyCode
                                                                                         and $projection.FiscalYear             = _OneTimeAccountBP.FiscalYear
                                                                                         and $projection.AccountingDocument     = _OneTimeAccountBP.AccountingDocument
                                                                                         and $projection.AccountingDocumentItem = _OneTimeAccountBP.AccountingDocumentItem

  association [0..1] to I_JournalEntryItemOneTimeData  as _JournalEntryItemOneTimeData   on  $projection.CompanyCode            = _JournalEntryItemOneTimeData.CompanyCode
                                                                                         and $projection.FiscalYear             = _JournalEntryItemOneTimeData.FiscalYear
                                                                                         and $projection.AccountingDocument     = _JournalEntryItemOneTimeData.AccountingDocument
                                                                                         and $projection.AccountingDocumentItem = _JournalEntryItemOneTimeData.AccountingDocumentItem

  association [0..1] to I_Supplier                     as _Supplier                      on  $projection.Supplier = _Supplier.Supplier
  association [0..1] to I_Supplier                     as _SupplierText                  on  $projection.Supplier = _SupplierText.Supplier
  association [0..1] to I_SupplierCompany              as _SupplierCompany               on  $projection.Supplier    = _SupplierCompany.Supplier
                                                                                         and $projection.CompanyCode = _SupplierCompany.CompanyCode

  association [0..1] to I_ChartOfAccounts              as _ChartOfAccounts               on  $projection.ChartOfAccounts = _ChartOfAccounts.ChartOfAccounts
  association [0..*] to I_ChartOfAccountsText          as _ChartOfAccountsText           on  $projection.ChartOfAccounts = _ChartOfAccountsText.ChartOfAccounts
  association [0..1] to I_AccountingDocumentType       as _AccountingDocumentType        on  $projection.AccountingDocumentType = _AccountingDocumentType.AccountingDocumentType
  association [0..*] to I_AccountingDocumentTypeText   as _AccountingDocumentTypeText    on  $projection.AccountingDocumentType = _AccountingDocumentTypeText.AccountingDocumentType
  association [1..1] to I_Currency                     as _CompanyCodeCurrency           on  $projection.CompanyCodeCurrency = _CompanyCodeCurrency.Currency
  association [0..1] to I_Currency                     as _FunctionalCurrency            on  $projection.FunctionalCurrency = _FunctionalCurrency.Currency
  association [0..1] to I_Currency                     as _TransactionCurrency           on  $projection.TransactionCurrency = _TransactionCurrency.Currency
  association [0..1] to I_Currency                     as _BalanceTransactionCurrency    on  $projection.BalanceTransactionCurrency = _BalanceTransactionCurrency.Currency
  association [0..1] to I_Currency                     as _AdditionalCurrency1           on  $projection.AdditionalCurrency1 = _AdditionalCurrency1.Currency
  association [0..1] to I_Currency                     as _AdditionalCurrency2           on  $projection.AdditionalCurrency2 = _AdditionalCurrency2.Currency
  association [0..1] to I_Currency                     as _PaymentCurrency               on  $projection.PaymentCurrency = _PaymentCurrency.Currency
  association [0..1] to I_Currency                     as _CreditControlAreaCurrency     on  $projection.CreditControlAreaCurrency = _CreditControlAreaCurrency.Currency
  association [0..1] to I_FinancialAccountType         as _FinancialAccountType          on  $projection.FinancialAccountType = _FinancialAccountType.FinancialAccountType
  association [0..*] to I_FinancialAccountTypeText     as _FinancialAccountTypeText      on  $projection.FinancialAccountType = _FinancialAccountTypeText.FinancialAccountType
  association [0..1] to I_FunctionalArea               as _FunctionalArea                on  $projection.FunctionalArea = _FunctionalArea.FunctionalArea
  association [0..*] to I_FunctionalAreaText           as _FunctionalAreaText            on  $projection.FunctionalArea = _FunctionalAreaText.FunctionalArea
  association [0..1] to I_BusinessArea                 as _BusinessArea                  on  $projection.BusinessArea = _BusinessArea.BusinessArea
  association [0..*] to I_BusinessAreaText             as _BusinessAreaText              on  $projection.BusinessArea = _BusinessAreaText.BusinessArea
  association [0..1] to I_Material                     as _Material                      on  $projection.Material = _Material.Material //do not use any longer, use _Product
  association [0..*] to I_MaterialText                 as _MaterialText                  on  $projection.Material = _MaterialText.Material
  association [0..1] to I_Product                      as _Product                       on  $projection.Product = _Product.Product
  association [0..*] to I_ProductDescription           as _ProductText                   on  $projection.Product = _ProductText.Product
  association [0..1] to I_Plant                        as _Plant                         on  $projection.Plant = _Plant.Plant
  association [0..1] to I_InternalOrder                as _InternalOrder                 on  $projection.OrderID = _InternalOrder.InternalOrder
  association [0..1] to I_Order                        as _Order                         on  $projection.OrderID = _Order.OrderID

  association [0..1] to I_WBSElementByInternalKey      as _WBSElementInternalID          on  $projection.WBSElementInternalID = _WBSElementInternalID.WBSElementInternalID
  association [0..1] to I_WBSElementByInternalKey      as _WBSElementInternalIDText      on  $projection.WBSElementInternalID = _WBSElementInternalIDText.WBSElementInternalID
  association [0..1] to I_WBSElementBasicData          as _WBSElementBasicData           on  $projection.WBSElementInternalID = _WBSElementBasicData.WBSElementInternalID
  association [0..1] to I_WBSElementBasicData          as _WBSElementBasicDataText       on  $projection.WBSElementInternalID = _WBSElementBasicDataText.WBSElementInternalID

  association [0..1] to I_UnitOfMeasure                as _BaseUnit                      on  $projection.BaseUnit = _BaseUnit.UnitOfMeasure
  association [0..1] to I_UnitOfMeasure                as _GoodsMovementEntryUnit        on  $projection.GoodsMovementEntryUnit = _GoodsMovementEntryUnit.UnitOfMeasure
  association [0..1] to I_UnitOfMeasure                as _PurchasingDocumentPriceUnit   on  $projection.PurchasingDocumentPriceUnit = _PurchasingDocumentPriceUnit.UnitOfMeasure

  association [0..1] to I_AccountingDocumentCategory   as _AccountingDocumentCategory    on  $projection.AccountingDocumentCategory = _AccountingDocumentCategory.AccountingDocumentCategory
  association [0..*] to I_AccountingDocumentCategoryT  as _AccountingDocumentCategoryT   on  $projection.AccountingDocumentCategory = _AccountingDocumentCategoryT.AccountingDocumentCategory
  //  association [0..1] to I_AccountingDocumentCatGroupT as _AccountingDocumentCatGroupT  on $projection.AccountingDocumentCatGroup  = _AccountingDocumentCatGroupT.AccountingDocumentCatGroup

  association [0..1] to I_PostingKey                   as _PostingKey                    on  $projection.PostingKey = _PostingKey.PostingKey
  association [0..1] to I_DebitCreditCode              as _DebitCreditCode               on  $projection.DebitCreditCode = _DebitCreditCode.DebitCreditCode
  association [0..1] to I_BusinessArea                 as _PartnerBusinessArea           on  $projection.PartnerBusinessArea = _PartnerBusinessArea.BusinessArea
  association [0..*] to I_BusinessAreaText             as _PartnerBusinessAreaText       on  $projection.PartnerBusinessArea = _PartnerBusinessAreaText.BusinessArea
  association [0..1] to I_Country                      as _TaxCountry                    on  $projection.TaxCountry = _TaxCountry.Country
  association [0..1] to I_TaxType                      as _TaxType                       on  $projection.TaxType = _TaxType.TaxType
  association [0..1] to I_CompanyCode                  as _PartnerCompany                on  $projection.PartnerCompany = _PartnerCompany.CompanyCode
  association [0..1] to I_CompanyCode                  as _PartnerCompanyText            on  $projection.PartnerCompany = _PartnerCompanyText.CompanyCode
  association [0..1] to I_Partnercompany               as _PartnerCompany_2              on  $projection.PartnerCompany = _PartnerCompany_2.PartnerCompany
  association [0..1] to I_Partnercompany               as _PartnerCompanyText_2          on  $projection.PartnerCompany = _PartnerCompanyText_2.PartnerCompany
  association [0..1] to I_Country                      as _SupplyingCountry              on  $projection.SupplyingCountry = _SupplyingCountry.Country
  association [0..1] to I_InventoryValuationType       as _InventoryValuationType        on  $projection.InventoryValuationType = _InventoryValuationType.InventoryValuationType
  association [0..1] to I_PaymentDifferenceReason      as _PaymentDifferenceReason       on  $projection.PaymentDifferenceReason = _PaymentDifferenceReason.PaymentDifferenceReason
                                                                                         and $projection.CompanyCode             = _PaymentDifferenceReason.CompanyCode
  association [0..*] to I_PaymentDifferenceReasonT     as _PaymentDifferenceReasonText   on  $projection.PaymentDifferenceReason = _PaymentDifferenceReasonText.PaymentDifferenceReason
                                                                                         and $projection.CompanyCode             = _PaymentDifferenceReasonText.CompanyCode
  association [0..1] to I_Segment                      as _PartnerSegment                on  $projection.PartnerSegment = _PartnerSegment.Segment
  association [0..*] to I_SegmentText                  as _PartnerSegmentText            on  $projection.PartnerSegment = _PartnerSegmentText.Segment
  association [0..1] to I_SuplrBankDetailsByIntId      as _SupplierBankDetails           on  $projection.Supplier                = _SupplierBankDetails.Supplier
                                                                                         and $projection.BPBankAccountInternalID = _SupplierBankDetails.BPBankAccountInternalID

  association [1..1] to I_AccountingDocument           as _ClearingAccountingDocument    on  $projection.CompanyCode                = _ClearingAccountingDocument.CompanyCode
                                                                                         and $projection.FiscalYear                 = _ClearingAccountingDocument.FiscalYear
                                                                                         and $projection.ClearingAccountingDocument = _ClearingAccountingDocument.AccountingDocument
  association [0..1] to I_FiscalYearForCompanyCode     as _ClearingJrnlEntryFiscalYear   on  $projection.ClearingJournalEntryFiscalYear = _ClearingJrnlEntryFiscalYear.FiscalYear
                                                                                         and $projection.CompanyCode                    = _ClearingJrnlEntryFiscalYear.CompanyCode
  association [0..1] to I_JournalEntry                 as _ClearingJournalEntry          on  $projection.CompanyCode                    = _ClearingJournalEntry.CompanyCode
                                                                                         and $projection.ClearingJournalEntryFiscalYear = _ClearingJournalEntry.FiscalYear
                                                                                         and $projection.ClearingJournalEntry           = _ClearingJournalEntry.AccountingDocument

  association [0..1] to I_SpecialGLCode                as _SpecialGLCode                 on  $projection.SpecialGLCode        = _SpecialGLCode.SpecialGLCode
                                                                                         and $projection.FinancialAccountType = _SpecialGLCode.FinancialAccountType
  association [0..*] to I_TaxCode                      as _TaxCode                       on  $projection.TaxCode = _TaxCode.TaxCode
  //above solution for association to I_TaxCode not supported. TaxCalculationProcedure required as additional key field to make TaxCode unique
  //association[0..1] to I_TaxCode                      as _TaxCode                       on $projection.TaxCode = _TaxCode.TaxCode and
  //                                                                                         $projection._Company._Country.TaxCalculationProcedure = _TaxCode.TaxCalculationProcedure
  association [0..1] to I_FinancialTransactionType     as _FinancialTransactionType      on  $projection.FinancialTransactionType = _FinancialTransactionType.FinancialTransactionType
  association [0..1] to I_SalesOrder                   as _SalesDocument                 on  $projection.SalesDocument = _SalesDocument.SalesOrder
  association [0..1] to I_SalesOrderItem               as _SalesDocumentItem             on  $projection.SalesDocument     = _SalesDocumentItem.SalesOrder
                                                                                         and $projection.SalesDocumentItem = _SalesDocumentItem.SalesOrderItem
  association [0..1] to I_SalesDocument                as _SalesDoc                      on  $projection.SalesDocument = _SalesDoc.SalesDocument
  association [0..1] to I_SalesDocumentItem            as _SalesDocItem                  on  $projection.SalesDocument     = _SalesDocItem.SalesDocument
                                                                                         and $projection.SalesDocumentItem = _SalesDocItem.SalesDocumentItem
  association [0..1] to I_MasterFixedAsset             as _MasterFixedAsset              on  $projection.CompanyCode      = _MasterFixedAsset.CompanyCode
                                                                                         and $projection.MasterFixedAsset = _MasterFixedAsset.MasterFixedAsset
  association [0..1] to I_MasterFixedAsset             as _MasterFixedAssetText          on  $projection.CompanyCode      = _MasterFixedAssetText.CompanyCode
                                                                                         and $projection.MasterFixedAsset = _MasterFixedAssetText.MasterFixedAsset
  association [0..1] to I_FixedAsset                   as _FixedAssetText                on  $projection.CompanyCode      = _FixedAssetText.CompanyCode
                                                                                         and $projection.MasterFixedAsset = _FixedAssetText.MasterFixedAsset
                                                                                         and $projection.FixedAsset       = _FixedAssetText.FixedAsset
  association [0..1] to I_FixedAsset                   as _FixedAsset                    on  $projection.CompanyCode      = _FixedAsset.CompanyCode
                                                                                         and $projection.MasterFixedAsset = _FixedAsset.MasterFixedAsset
                                                                                         and $projection.FixedAsset       = _FixedAsset.FixedAsset
  association [0..1] to I_AssetTransactionType         as _AssetTransactionType          on  $projection.AssetTransactionType = _AssetTransactionType.AssetTransactionType

  association [0..1] to I_PersonWorkAgreement_1        as _PersonWorkAgreement_1         on  $projection.PersonnelNumber = _PersonWorkAgreement_1.PersonWorkAgreement
  association [0..1] to I_Employment                   as _Employment                    on  $projection.PersonnelNumber = _Employment.EmploymentInternalID
  //                                                                                   and  $projection.PostingDate                   >= _Employment.StartDate
  //                                                                                   and  $projection.PostingDate                   <= _Employment.EndDate

  association [0..1] to I_Housebank                    as _HouseBank                     on  $projection.CompanyCode = _HouseBank.CompanyCode
                                                                                         and $projection.HouseBank   = _HouseBank.HouseBank
  association [0..1] to I_PurchasingDocument           as _PurchasingDocument            on  $projection.PurchasingDocument = _PurchasingDocument.PurchasingDocument
  association [0..1] to I_PurchasingDocumentItem       as _PurchasingDocumentItem        on  $projection.PurchasingDocument     = _PurchasingDocumentItem.PurchasingDocument
                                                                                         and $projection.PurchasingDocumentItem = _PurchasingDocumentItem.PurchasingDocumentItem
  association [0..1] to I_Purreqvaluationarea          as _ValuationArea                 on  $projection.ValuationArea = _ValuationArea.ValuationArea
  association [0..1] to I_ProjectNetwork               as _ProjectNetwork                on  $projection.ProjectNetwork = _ProjectNetwork.ProjectNetwork
  association [0..1] to I_ProjectNetwork               as _ProjectNetworkText            on  $projection.ProjectNetwork = _ProjectNetworkText.ProjectNetwork
  association [0..*] to I_CostOriginGroup              as _CostOriginGroup               on  $projection.ControllingArea = _CostOriginGroup.ControllingArea
                                                                                         and
                                                                                             // not contained in view                                                                $projection.CostOriginType                 = _CostOriginGroup.CostOriginType and
                                                                                             $projection.CostOriginGroup = _CostOriginGroup.CostOriginGroup
  association [0..*] to I_ProfitCenter                 as _PartnerProfitCenter           on  $projection.ControllingArea     = _PartnerProfitCenter.ControllingArea
                                                                                         and $projection.PartnerProfitCenter = _PartnerProfitCenter.ProfitCenter
  association [0..*] to I_ProfitCenterText             as _ProfitCenterText              on  $projection.ControllingArea = _ProfitCenterText.ControllingArea
                                                                                         and $projection.ProfitCenter    = _ProfitCenterText.ProfitCenter
  association [0..*] to I_CostCenterActivityType       as _CostCtrActivityType           on  $projection.ControllingArea     = _CostCtrActivityType.ControllingArea
                                                                                         and $projection.CostCtrActivityType = _CostCtrActivityType.CostCtrActivityType
  association [0..1] to I_BusinessProcess              as _BusinessProcess               on  $projection.ControllingArea = _BusinessProcess.ControllingArea
                                                                                         and $projection.BusinessProcess = _BusinessProcess.BusinessProcess
  association [0..*] to I_BusinessProcessText          as _BusinessProcessText           on  $projection.ControllingArea = _BusinessProcessText.ControllingArea
                                                                                         and $projection.BusinessProcess = _BusinessProcessText.BusinessProcess
  association [0..1] to I_FunctionalArea               as _PartnerFunctionalArea         on  $projection.PartnerFunctionalArea = _PartnerFunctionalArea.FunctionalArea
  association [0..1] to I_HouseBankAccount             as _HouseBankAccount              on  $projection.CompanyCode      = _HouseBankAccount.CompanyCode
                                                                                         and $projection.HouseBank        = _HouseBankAccount.HouseBank
                                                                                         and $projection.HouseBankAccount = _HouseBankAccount.HouseBankAccount
  association [0..*] to I_HouseBankAccountText         as _HouseBankAccountText          on  $projection.CompanyCode      = _HouseBankAccountText.CompanyCode
                                                                                         and $projection.HouseBank        = _HouseBankAccountText.HouseBank
                                                                                         and $projection.HouseBankAccount = _HouseBankAccountText.HouseBankAccount
  association [0..1] to I_ReferenceDocumentType        as _ReferenceDocumentType         on  $projection.ReferenceDocumentType = _ReferenceDocumentType.ReferenceDocumentType
  association [0..1] to I_FiscalYearPeriodForCmpnyCode as _FiscalPeriod                  on  $projection.FiscalYear   = _FiscalPeriod.FiscalYear
                                                                                         and $projection.FiscalPeriod = _FiscalPeriod.FiscalPeriod
                                                                                         and $projection.CompanyCode  = _FiscalPeriod.CompanyCode
  association [0..1] to I_ChartOfAccounts              as _OffsettingChartOfAccounts     on  $projection.OffsettingChartOfAccounts = _OffsettingChartOfAccounts.ChartOfAccounts
  association [0..*] to I_ChartOfAccountsText          as _OffsettingChartOfAccountsText on  $projection.OffsettingChartOfAccounts = _OffsettingChartOfAccountsText.ChartOfAccounts
  // old association kept for compatibility. DO NOT USE
  association [0..1] to I_GLAccountInChartOfAccounts   as _OffsettingAccount             on  $projection.ChartOfAccounts   = _OffsettingAccount.ChartOfAccounts
                                                                                         and $projection.OffsettingAccount = _OffsettingAccount.GLAccount

  association [0..1] to I_OffsettingAccount            as _OffsettingAccountWithBP       on  $projection.OffsettingChartOfAccounts = _OffsettingAccountWithBP.ChartOfAccounts
                                                                                         and $projection.OffsettingAccountType     = _OffsettingAccountWithBP.OffsettingAccountType
                                                                                         and $projection.OffsettingAccount         = _OffsettingAccountWithBP.OffsettingAccount
  //association [0..1] to I_Glaccounttype              as _OffsettingAccountType       on $projection.OffsettingAccountType          = _OffsettingAccountType.GLAccountType
  association [0..1] to I_FinancialAccountType         as _OffsettingAccountType         on  $projection.OffsettingAccountType = _OffsettingAccountType.FinancialAccountType
  association [0..*] to I_FinancialAccountTypeText     as _OffsettingAccountTypeText     on  $projection.OffsettingAccountType = _OffsettingAccountTypeText.FinancialAccountType

  association [0..1] to I_CompanyCode                  as _CashLedgerCompanyCode         on  $projection.CashLedgerCompanyCode = _CashLedgerCompanyCode.CompanyCode
  association [0..1] to I_GLAccountInCompanyCode       as _CashLedgerAccount             on  $projection.CashLedgerCompanyCode = _CashLedgerAccount.CompanyCode
                                                                                         and $projection.CashLedgerAccount     = _CashLedgerAccount.GLAccount

  association [0..1] to I_BudgetPeriod                 as _BudgetPeriod                  on  $projection.BudgetPeriod = _BudgetPeriod.BudgetPeriod
  association [0..*] to I_BudgetPeriodText             as _BudgetPeriodText              on  $projection.BudgetPeriod = _BudgetPeriodText.BudgetPeriod
  association [0..1] to I_BudgetPeriod                 as _PartnerBudgetPeriod           on  $projection.PartnerBudgetPeriod = _PartnerBudgetPeriod.BudgetPeriod
  association [0..1] to I_Grant                        as _Grant                         on  $projection.GrantID = _Grant.GrantID
  association [0..1] to I_Grant                        as _PartnerGrant                  on  $projection.PartnerGrant = _PartnerGrant.GrantID

  association [0..1] to I_CompanyCode                  as _PubSecBudgetAccountCoCode     on  $projection.PubSecBudgetAccountCoCode = _PubSecBudgetAccountCoCode.CompanyCode
  association [0..1] to I_PubSecBudgetAccount          as _PubSecBudgetAccount           on  $projection.PubSecBudgetAccountCoCode = _PubSecBudgetAccount.PubSecBudgetAccountCoCode
                                                                                         and $projection.PubSecBudgetAccount       = _PubSecBudgetAccount.PubSecBudgetAccount

  association [0..1] to I_ServiceDocumentType          as _ServiceDocumentType           on  $projection.ServiceDocumentType = _ServiceDocumentType.ServiceDocumentType

  association [0..1] to I_SrvcDocByDocumentType        as _ServiceDocument               on  $projection.ServiceDocumentType = _ServiceDocument.ServiceDocumentType
                                                                                         and $projection.ServiceDocument     = _ServiceDocument.ServiceDocument

  association [0..1] to I_SrvcDocItemByDocumentType    as _ServiceDocumentItem           on  $projection.ServiceDocumentType = _ServiceDocumentItem.ServiceDocumentType
                                                                                         and $projection.ServiceDocument     = _ServiceDocumentItem.ServiceDocument
                                                                                         and $projection.ServiceDocumentItem = _ServiceDocumentItem.ServiceDocumentItem
  //  association [0..1] to I_REObjectByIntFinNumber       as _REObjectByIntFinNumber        on  $projection.REInternalFinNumber        = _REObjectByIntFinNumber.REInternalFinNumber

  association [0..1] to I_FinServicesProductGroup      as _FinServicesProductGroup       on  $projection.FinancialServicesProductGroup = _FinServicesProductGroup.FinancialServicesProductGroup
  association [0..1] to I_FinancialServicesBranch      as _FinancialServicesBranch       on  $projection.FinancialServicesBranch = _FinancialServicesBranch.FinancialServicesBranch
  association [0..1] to I_FinancialDataSource          as _FinancialDataSource           on  $projection.FinancialDataSource = _FinancialDataSource.FinancialDataSource
  association [0..1] to I_CustomerGroup                as _CustomerGroup                 on  $projection.CustomerGroup = _CustomerGroup.CustomerGroup
  association [0..1] to I_Country                      as _CustomerSupplierCountry       on  $projection.CustomerSupplierCountry = _CustomerSupplierCountry.Country
  association [0..1] to I_CustomerSupplierIndustry     as _CustomerSupplierIndustry      on  $projection.CustomerSupplierIndustry = _CustomerSupplierIndustry.Industry

{

      @ObjectModel.foreignKey.association: '_CompanyCode'
  key P_BSEG_COM.bukrs                                                                                              as CompanyCode,
      @ObjectModel.foreignKey.association: '_JournalEntry'
  key belnr                                                                                                         as AccountingDocument,
      @ObjectModel.foreignKey.association: '_FiscalYear'
  key gjahr                                                                                                         as FiscalYear,
  key buzei                                                                                                         as AccountingDocumentItem,

      @ObjectModel.foreignKey.association: '_ChartOfAccounts'
      ktopl                                                                                                         as ChartOfAccounts,
      buzid                                                                                                         as AccountingDocumentItemType,

      augdt                                                                                                         as ClearingDate,
      augcp                                                                                                         as ClearingCreationDate,

      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_ClearingJrnlEntryFiscalYear'
      auggj                                                                                                         as ClearingJournalEntryFiscalYear,
      @API.element.releaseState: #DEPRECATED
      @API.element.successor:    'ClearingJournalEntryFiscalYear'
      @VDM.lifecycle.status:    #DEPRECATED
      @VDM.lifecycle.successor: 'ClearingJournalEntryFiscalYear'
      cast( auggj  as fis_auggj_no_conv_depre preserving type )                                                     as ClearingDocFiscalYear,

      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_ClearingJournalEntry'
      augbl                                                                                                         as ClearingJournalEntry,
      @API.element.releaseState: #DEPRECATED
      @API.element.successor:    'ClearingJournalEntry'
      @VDM.lifecycle.status:    #DEPRECATED
      @VDM.lifecycle.successor: 'ClearingJournalEntry'
      @ObjectModel.foreignKey.association: '_ClearingAccountingDocument'
      cast( augbl as fis_augbl_depre preserving type )                                                              as ClearingAccountingDocument,

      @ObjectModel.foreignKey.association: '_PostingKey'
      bschl                                                                                                         as PostingKey,
      @ObjectModel.foreignKey.association: '_FinancialAccountType'
      koart                                                                                                         as FinancialAccountType,
      @ObjectModel.foreignKey.association: '_SpecialGLCode'
      umskz                                                                                                         as SpecialGLCode,
      umsks                                                                                                         as SpecialGLTransactionType,
      //zumsk,
      @ObjectModel.foreignKey.association: '_DebitCreditCode'
      shkzg                                                                                                         as DebitCreditCode,
      @ObjectModel.foreignKey.association: '_BusinessArea'
      gsber                                                                                                         as BusinessArea,
      @ObjectModel.foreignKey.association: '_PartnerBusinessArea'
      pargb                                                                                                         as PartnerBusinessArea,
      //      @ObjectModel.foreignKey.association: '_TaxCode'
      mwskz                                                                                                         as TaxCode,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_TaxCountry'
      tax_country                                                                                                   as TaxCountry,
      txdat_from                                                                                                    as TaxRateValidityStartDate,
      qsskz                                                                                                         as WithholdingTaxCode,
      //shzuz,
      //stekz,
      @ObjectModel.foreignKey.association: '_TaxType'
      mwart                                                                                                         as TaxType,
      txgrp                                                                                                         as TaxItemGroup,
      ktosl                                                                                                         as TransactionTypeDetermination,
      //kursr,
      valut                                                                                                         as ValueDate,
      zuonr                                                                                                         as AssignmentReference,
      sgtxt                                                                                                         as DocumentItemText,
      //zinkz,
      @ObjectModel.foreignKey.association: '_PartnerCompany_2'
      vbund                                                                                                         as PartnerCompany,
      @ObjectModel.foreignKey.association: '_FinancialTransactionType'
      bewar                                                                                                         as FinancialTransactionType,
      altkt                                                                                                         as CorporateGroupAccount,
      //vorgn,
      fdlev                                                                                                         as PlanningLevel,
      //fdgrp,
      //fdtag,
      //fkont,
      @ObjectModel.foreignKey.association: '_ControllingArea'
      kokrs                                                                                                         as ControllingArea,
      @ObjectModel.foreignKey.association: '_CostCenter'
      kostl                                                                                                         as CostCenter,

      @API.element.releaseState: #DEPRECATED
      @API.element.successor:    ''
      @VDM.lifecycle.status:    #DEPRECATED
      @VDM.lifecycle.successor: ''
      projn                                                                                                         as Project, // DO NOT USE ; this is the old unused Project

      @ObjectModel.foreignKey.association: '_Order'
      aufnr                                                                                                         as OrderID,
      vbeln                                                                                                         as BillingDocument,
      @ObjectModel.foreignKey.association: '_SalesDoc'
      vbel2                                                                                                         as SalesDocument,
      @ObjectModel.foreignKey.association: '_SalesDocItem'
      posn2                                                                                                         as SalesDocumentItem,
      eten2                                                                                                         as ScheduleLine,

      @Consumption.valueHelpDefinition: [
              { entity:  { name:    'I_AcctgServiceDocumentTypeVH',
                           element: 'ServiceDocumentType' }
              }]
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_ServiceDocumentType'
      service_doc_type                                                                                              as ServiceDocumentType,
      @Consumption.valueHelpDefinition: [
              { entity:  { name:    'I_AcctgServiceDocumentVH',
                           element: 'ServiceDocument' }
              }]
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_ServiceDocument'
      service_doc_id                                                                                                as ServiceDocument,
      @Consumption.valueHelpDefinition: [
              { entity:  { name:    'I_AcctgServiceDocumentItemVH',
                           element: 'ServiceDocumentItem' }
              }]
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_ServiceDocumentItem'
      service_doc_item_id                                                                                           as ServiceDocumentItem,

      @ObjectModel.foreignKey.association: '_MasterFixedAsset'
      anln1                                                                                                         as MasterFixedAsset,
      @ObjectModel.foreignKey.association: '_FixedAsset'
      anln2                                                                                                         as FixedAsset,
      @ObjectModel.foreignKey.association: '_AssetTransactionType'
      anbwa                                                                                                         as AssetTransactionType,
      bzdat                                                                                                         as AssetValueDate,
      @ObjectModel.foreignKey.association: '_Employment'
      pernr                                                                                                         as PersonnelNumber,
      //@Semantics.booleanIndicator
      xumsw                                                                                                         as IsSalesRelated,
      //xhres,
      //@Semantics.booleanIndicator
      xkres                                                                                                         as LineItemDisplayIsEnabled,
      //@Semantics.booleanIndicator
      xopvw                                                                                                         as IsOpenItemManaged,

      cast( xcpdd as farp_xcpdd )                                                                                   as AddressAndBankIsSetManually,
      //xskst,
      //xsauf,
      //xspro,
      //xserg,
      //xfakt,
      //xuman,
      @Analytics.internalName: #LOCAL
      //@Semantics.booleanIndicator
      xanet                                                                                                         as DownPaymentIsNetProcedure,
      //@Semantics.booleanIndicator
      xskrl                                                                                                         as IsNotCashDiscountLiable,
      //xinve,
      //xpanz,
      //@Semantics.booleanIndicator
      xauto                                                                                                         as IsAutomaticallyCreated,
      //xncop,
      //@Semantics.booleanIndicator
      xzahl                                                                                                         as IsUsedInPaymentTransaction,
      saknr                                                                                                         as OperationalGLAccount,
      @ObjectModel.foreignKey.association: '_GLAccountInChartOfAccounts'
      hkont                                                                                                         as GLAccount,
      @ObjectModel.foreignKey.association: '_Customer'
      kunnr                                                                                                         as Customer,
      @ObjectModel.foreignKey.association: '_Supplier'
      lifnr                                                                                                         as Supplier,
      filkd                                                                                                         as BranchAccount,
      //@Semantics.booleanIndicator
      xbilk                                                                                                         as IsBalanceSheetAccount,
      gvtyp                                                                                                         as ProfitLossAccountType,
      hzuon                                                                                                         as SpecialGLAccountAssignment,
      zfbdt                                                                                                         as DueCalculationBaseDate,
      zterm                                                                                                         as PaymentTerms,
      zbd1t                                                                                                         as CashDiscount1Days,
      zbd2t                                                                                                         as CashDiscount2Days,
      zbd3t                                                                                                         as NetPaymentDays,
      zbd1p                                                                                                         as CashDiscount1Percent,
      zbd2p                                                                                                         as CashDiscount2Percent,
      zlsch                                                                                                         as PaymentMethod,
      zlspr                                                                                                         as PaymentBlockingReason,
      zbfix                                                                                                         as FixedCashDiscount,
      @ObjectModel.foreignKey.association: '_HouseBank'
      hbkid                                                                                                         as HouseBank,
      @ObjectModel.foreignKey.association: '_SupplierBankDetails'
      bvtyp                                                                                                         as BPBankAccountInternalID,
      mwsk1                                                                                                         as TaxDistributionCode1,
      mwsk2                                                                                                         as TaxDistributionCode2,
      mwsk3                                                                                                         as TaxDistributionCode3,
      rebzg                                                                                                         as InvoiceReference,
      rebzj                                                                                                         as InvoiceReferenceFiscalYear,
      rebzz                                                                                                         as InvoiceItemReference,
      rebzt                                                                                                         as FollowOnDocumentType,
      //zollt,
      //zolld,
      lzbkz                                                                                                         as StateCentralBankPaymentReason,
      @ObjectModel.foreignKey.association: '_SupplyingCountry'
      landl                                                                                                         as SupplyingCountry,
      //diekz,
      samnr                                                                                                         as InvoiceList,
      //abper as SettlementFiscalYearPeriod,
      //vrskz,
      //vrsdt,
      disbn                                                                                                         as BillOfExchangeUsageDocument,
      //disbj,
      //disbz,
      wverw                                                                                                         as BillOfExchangeUsage,
      anfbn                                                                                                         as BoEPaytReq,
      anfbj                                                                                                         as BoEFiscalYear,
      anfbu                                                                                                         as BoECompCode,
      anfae                                                                                                         as BoEDueDate,
      //blnkz,
      //blnpz,
      mschl                                                                                                         as DunningKey,
      mansp                                                                                                         as DunningBlockingReason,
      madat                                                                                                         as LastDunningDate,
      manst                                                                                                         as DunningLevel,
      maber                                                                                                         as DunningArea,
      esrnr                                                                                                         as PaytSlipWthRefSubscriber,
      esrre                                                                                                         as PaytSlipWthRefReference,
      esrpz                                                                                                         as PaytSlipWthRefCheckDigit,
      qsznr                                                                                                         as WithholdingTaxCertificate,
      @ObjectModel.foreignKey.association: '_Material'
      @API.element.releaseState: #DEPRECATED
      @API.element.successor:    'Product'
      @VDM.lifecycle.status:    #DEPRECATED
      @VDM.lifecycle.successor: 'Product'
      matnr                                                                                                         as Material, // do not use any longer, use Product
      @ObjectModel.foreignKey.association: '_Product'
      cast( matnr as productnumber )                                                                                as Product,
      @ObjectModel.foreignKey.association: '_Plant'
      werks                                                                                                         as Plant,
      @ObjectModel.foreignKey.association: '_PurchasingDocument'
      ebeln                                                                                                         as PurchasingDocument,
      @ObjectModel.foreignKey.association: '_PurchasingDocumentItem'
      ebelp                                                                                                         as PurchasingDocumentItem,
      zekkn                                                                                                         as AccountAssignmentNumber,
      //@Semantics.booleanIndicator
      elikz                                                                                                         as IsCompletelyDelivered,
      vprsv                                                                                                         as MaterialPriceControl,
      @ObjectModel.foreignKey.association: '_ValuationArea'
      bwkey                                                                                                         as ValuationArea,
      @ObjectModel.foreignKey.association: '_InventoryValuationType'
      bwtar                                                                                                         as InventoryValuationType,
      //bustw,
      //psalt,
      //tbtkz,
      //spgrp,
      //spgrm,
      //spgrt,
      //spgrg,
      //spgrv,
      //spgrq,
      P_BSEG_COM.stceg                                                                                              as VATRegistration,
      egbld                                                                                                         as DelivOfGoodsDestCountry,
      eglld                                                                                                         as DelivOfGoodsOriginCountry,
      @ObjectModel.foreignKey.association: '_PaymentDifferenceReason'
      rstgr                                                                                                         as PaymentDifferenceReason,
      //ryacq,
      //rpacq,
      @ObjectModel.foreignKey.association: '_ProfitCenter'
      prctr                                                                                                         as ProfitCenter,
      //xhkom,
      vname                                                                                                         as JointVenture,
      recid                                                                                                         as JointVentureCostRecoveryCode,
      egrup                                                                                                         as JointVentureEquityGroup,
      cast( vptnr as jv_part_cds preserving type )                                                                  as JointVenturePartner,
      vertt                                                                                                         as TreasuryContractType,
      vertn                                                                                                         as AssetContract,
      vbewa                                                                                                         as CashFlowType,
      //depot,
      P_BSEG_COM.txjcd                                                                                              as TaxJurisdiction,

      //@ObjectModel.foreignKey.association: '_REObjectByIntFinNumber'
      cast( imkey as recaimkeyfi preserving type )                                                                  as REInternalFinNumber,
      @API.element.releaseState: #DEPRECATED
      @API.element.successor:    'REInternalFinNumber'
      @VDM.lifecycle.status:    #DEPRECATED
      @VDM.lifecycle.successor: 'REInternalFinNumber'
      imkey                                                                                                         as RealEstateObject,

      dabrz                                                                                                         as SettlementReferenceDate,
      //popts,

      @API.element.releaseState: #DEPRECATED
      @API.element.successor:    'CommitmentItemShortID'
      @VDM.lifecycle.status:    #DEPRECATED
      @VDM.lifecycle.successor: 'CommitmentItemShortID'
      fipos                                                                                                         as CommitmentItem,
      cast( fipos as fis_fipos_shortid preserving type )                                                            as CommitmentItemShortID,

      kstrg                                                                                                         as CostObject,
      @ObjectModel.foreignKey.association: '_ProjectNetwork'
      nplnr                                                                                                         as ProjectNetwork,
      aufpl                                                                                                         as OrderInternalBillOfOperations,
      aplzl                                                                                                         as OrderIntBillOfOperationsItem,
      @ObjectModel.foreignKey.association: '_WBSElementInternalID'
      cast( projk as fis_wbsint_no_conv preserving type )                                                           as WBSElementInternalID,

      @API.element.releaseState: #DECOMMISSIONED
      @API.element.successor:    'ProfitabilitySegment_2'
      @VDM.lifecycle.status:    #DEPRECATED
      @VDM.lifecycle.successor: 'ProfitabilitySegment_2'
      cast( case when paobjnr > '9999999999' then '9999999999' else lpad( paobjnr, 10, '0' ) end as rkeobjnr_numc ) as ProfitabilitySegment,
      cast( paobjnr as rkeobjnr_char )                                                                              as ProfitabilitySegment_2,

      //pasubnr,
      //spgrs,
      //spgrc,
      cast( btype as jv_bilind_cds preserving type )                                                                as JointVentureBillingType,
      etype                                                                                                         as JointVentureEquityType,
      //@Semantics.booleanIndicator
      xegdr                                                                                                         as IsEUTriangularDeal,
      //lnran,
      //      @ObjectModel.foreignKey.association: '_CostOriginGroup'
      hrkft                                                                                                         as CostOriginGroup,
      hwmet                                                                                                         as CompanyCodeCurrencyDetnMethod,
      //glupm,
      //@Semantics.booleanIndicator
      xragl                                                                                                         as ClearingIsReversed,
      uzawe                                                                                                         as PaymentMethodSupplement,
      //      @ObjectModel.foreignKey.association: '_AlternativeGLAccount'
      lokkt                                                                                                         as AlternativeGLAccount,
      //@ObjectModel.foreignKey.association: '_FundsCenter'
      fistl                                                                                                         as FundsCenter,
      //@ObjectModel.foreignKey.association: '_Fund'
      geber                                                                                                         as Fund,
      stbuk                                                                                                         as TaxCompanyCode,
      @ObjectModel.foreignKey.association: '_PartnerProfitCenter'
      pprct                                                                                                         as PartnerProfitCenter,
      xref1                                                                                                         as Reference1IDByBusinessPartner,
      xref2                                                                                                         as Reference2IDByBusinessPartner,
      @Analytics.internalName: #LOCAL
      kblnr                                                                                                         as EarmarkedFundsDocument,
      @Analytics.internalName: #LOCAL
      kblpos                                                                                                        as EarmarkedFundsDocumentItem,
      //fkber,
      //obzei,
      //@Semantics.booleanIndicator
      P_BSEG_COM.xnegp                                                                                              as IsNegativePosting,
      rfzei                                                                                                         as PaymentCardItem,
      ccbtc                                                                                                         as PaymentCardPaymentSettlement,
      P_BSEG_COM.kkber                                                                                              as CreditControlArea,
      empfb                                                                                                         as AlternativePayeePayer,
      xref3                                                                                                         as Reference3IDByBusinessPartner,
      dtws1                                                                                                         as DataExchangeInstruction1,
      dtws2                                                                                                         as DataExchangeInstruction2,
      dtws3                                                                                                         as DataExchangeInstruction3,
      dtws4                                                                                                         as DataExchangeInstruction4,
      //gricd,
      grirg                                                                                                         as Region,
      //gityp as EmploymentTaxDistrType,
      //@Semantics.booleanIndicator
      xpypr                                                                                                         as HasPaymentOrder,
      kidno                                                                                                         as PaymentReference,
      //idxsp,
      //linfv,
      //kontt,
      //kontl,
      //uebgdat,
      txdat                                                                                                         as TaxDeterminationDate,
      agzei                                                                                                         as ClearingItem,
      bupla                                                                                                         as BusinessPlace,
      secco                                                                                                         as TaxSection,
      @ObjectModel.foreignKey.association: '_CostCtrActivityType'
      lstar                                                                                                         as CostCtrActivityType,

      @API.element.releaseState: #DEPRECATED
      @API.element.successor:    'AcctsReceivablePledgingCode'
      @VDM.lifecycle.status:    #DEPRECATED
      @VDM.lifecycle.successor: 'AcctsReceivablePledgingCode'
      cession_kz                                                                                                    as AccountsReceivableIsPledged,
      cast( cession_kz as fis_cession_kz_code preserving type )                                                     as AcctsReceivablePledgingCode,

      @ObjectModel.foreignKey.association: '_BusinessProcess'
      prznr                                                                                                         as BusinessProcess,
      //pendays,
      //penrc,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_Grant'
      grant_nbr                                                                                                     as GrantID,
      @ObjectModel.foreignKey.association: '_FunctionalArea'
      fkber_long                                                                                                    as FunctionalArea,
      //@Semantics.booleanIndicator
      gmvkz                                                                                                         as CustomerIsInExecution,
      //srtype,
      //intreno,
      measure                                                                                                       as FundedProgram,
      //ppa_ex_ind,
      docln                                                                                                         as LedgerGLLineItem,
      @ObjectModel.foreignKey.association: '_Segment'
      segment                                                                                                       as Segment,
      @ObjectModel.foreignKey.association: '_PartnerSegment'
      psegment                                                                                                      as PartnerSegment,
      @ObjectModel.foreignKey.association: '_PartnerFunctionalArea'
      pfkber                                                                                                        as PartnerFunctionalArea,
      @ObjectModel.foreignKey.association: '_HouseBankAccount'
      hktid                                                                                                         as HouseBankAccount,
      kstar                                                                                                         as CostElement,
      //xlgclr,
      taxps                                                                                                         as TaxItemAcctgDocItemRef,
      pays_prov                                                                                                     as PaymentServiceProvider,
      pays_tran                                                                                                     as PaymentRefByPaytSrvcProvider,
      mndid                                                                                                         as SEPAMandate,
      //xfrge_bseg,
      @ObjectModel.foreignKey.association: '_ReferenceDocumentType'
      awtyp                                                                                                         as ReferenceDocumentType,
      awkey                                                                                                         as OriginalReferenceDocument,
      awsys                                                                                                         as ReferenceDocumentLogicalSystem,
      posnr                                                                                                         as AccountingDocumentItemRef,
      //buzei_sender,
      @ObjectModel.foreignKey.association: '_FiscalPeriod'
      h_monat                                                                                                       as FiscalPeriod,
      @ObjectModel.foreignKey.association: '_AccountingDocumentCategory'
      h_bstat                                                                                                       as AccountingDocumentCategory,

      h_budat                                                                                                       as PostingDate,
      h_bldat                                                                                                       as DocumentDate,
      @ObjectModel.foreignKey.association: '_AccountingDocumentType'
      h_blart                                                                                                       as AccountingDocumentType,
      netdt                                                                                                         as NetDueDate,
      sk1dt                                                                                                         as CashDiscount1DueDate,
      sk2dt                                                                                                         as CashDiscount2DueDate,
      //fqftype,
      //lqitem,
      @ObjectModel.foreignKey.association: '_OffsettingAccountWithBP'
      gkont                                                                                                         as OffsettingAccount,
      @ObjectModel.foreignKey.association: '_OffsettingAccountType'
      gkart                                                                                                         as OffsettingAccountType,
      @ObjectModel.foreignKey.association: '_OffsettingChartOfAccounts'
      gktopl                                                                                                        as OffsettingChartOfAccounts,
      //ghkon,
      //      @ObjectModel.foreignKey.association: '_PartnerFund'
      pgeber                                                                                                        as PartnerFund,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_PartnerGrant'
      pgrant_nbr                                                                                                    as PartnerGrant,
      @ObjectModel.foreignKey.association: '_BudgetPeriod'
      budget_pd                                                                                                     as BudgetPeriod,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_PartnerBudgetPeriod'
      pbudget_pd                                                                                                    as PartnerBudgetPeriod,
      j_1tpbupl                                                                                                     as BranchCode,
      //perop_beg,
      //perop_end,
      //fastpay,
      //ignr_ivref,
      //fmfgus_key,
      //fmxdocnr,
      //fmxyear,
      //fmxdocln,
      //fmxzekkn,
      cast( prodper as jv_prodper_cds preserving type )                                                             as JointVentureProductionDate,

      glo_ref1                                                                                                      as OplAcctgDocItmCntrySpcfcRef1,

      payt_rsn                                                                                                      as PaymentReason,

      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_CashLedgerCompanyCode'
      re_bukrs                                                                                                      as CashLedgerCompanyCode,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_CashLedgerAccount'
      re_account                                                                                                    as CashLedgerAccount,

      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_PubSecBudgetAccountCoCode'
      bdgt_account_cocode                                                                                           as PubSecBudgetAccountCoCode,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_PubSecBudgetAccount'
      bdgt_account                                                                                                  as PubSecBudgetAccount,


      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_FinServicesProductGroup'
      FS_PRODUCT_GROUP                                                                                              as FinancialServicesProductGroup,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_FinancialServicesBranch'
      BRANCH_ID                                                                                                     as FinancialServicesBranch,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_FinancialDataSource'
      DATASOURCE_ID                                                                                                 as FinancialDataSource,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_CustomerGroup'
      kdgrp                                                                                                         as CustomerGroup,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_CustomerSupplierCountry'
      land1                                                                                                         as CustomerSupplierCountry,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_CustomerSupplierIndustry'
      brsch                                                                                                         as CustomerSupplierIndustry,


      @ObjectModel.foreignKey.association: '_CompanyCodeCurrency'
      @Semantics.currencyCode:true
      h_hwaer                                                                                                       as CompanyCodeCurrency,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      dmbtr_shl                                                                                                     as AmountInCompanyCodeCurrency,

      // Functional Currency
      @ObjectModel.foreignKey.association: '_FunctionalCurrency'
      @Semantics.currencyCode:true
      rfccur                                                                                                        as FunctionalCurrency,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FunctionalCurrency'} }
      fcsl_shl                                                                                                      as AmountInFunctionalCurrency,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } kzbtr_shl,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } txbhw_shl,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      mwsts_shl                                                                                                     as TaxAmountInCoCodeCrcy,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      hwbas_shl                                                                                                     as TaxBaseAmountInCoCodeCrcy,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } hwzuz_shl,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      bdiff_shl                                                                                                     as ValuationDiffAmtInCoCodeCrcy,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      sknto_shl                                                                                                     as CashDiscountAmtInCoCodeCrcy,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      dmbt1_shl                                                                                                     as TaxBrkdwnAmount1InCoCodeCrcy,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      dmbt2_shl                                                                                                     as TaxBrkdwnAmount2InCoCodeCrcy,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      dmbt3_shl                                                                                                     as TaxBrkdwnAmount3InCoCodeCrcy,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } blnbt_shl,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      navhw_shl                                                                                                     as NonDcblTaxAmountInCoCodeCrcy,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      rewrt_shl                                                                                                     as InvoiceAmtInCoCodeCrcy,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } bonfb_shl,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } nprei_shl,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } rdiff_shl as CurrDiff,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } ppdiff_shl,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } penlc1_shl,

      @ObjectModel.foreignKey.association: '_TransactionCurrency'
      @Semantics.currencyCode:true
      h_waers                                                                                                       as TransactionCurrency,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      wrbtr_shl                                                                                                     as AmountInTransactionCurrency,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      txbfw_shl                                                                                                     as OriginalTaxBaseAmount,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      wmwst_shl                                                                                                     as TaxAmount,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      fwbas_shl                                                                                                     as TaxBaseAmountInTransCrcy,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'TransactionCurrency'} } fwzuz_shl,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      qsshb_shl                                                                                                     as WithholdingTaxBaseAmount,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'TransactionCurrency'} } gbetr_shl,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      fdwbt_shl                                                                                                     as PlannedAmtInTransactionCrcy,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      skfbt_shl                                                                                                     as CashDiscountBaseAmount,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      wskto_shl                                                                                                     as CashDiscountAmount,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      nebtr_shl                                                                                                     as NetPaymentAmount,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      wrbt1_shl                                                                                                     as TaxBrkdwnAmount1InTransCrcy,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      wrbt2_shl                                                                                                     as TaxBrkdwnAmount2InTransCrcy,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      wrbt3_shl                                                                                                     as TaxBrkdwnAmount3InTransCrcy,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      qbshb_shl                                                                                                     as WithholdingTaxAmount,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      qsfbt_shl                                                                                                     as WithholdingTaxExemptionAmt,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      navfw_shl                                                                                                     as NonDcblTaxAmountInTransCrcy,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      rewwr_shl                                                                                                     as InvoiceAmountInFrgnCurrency,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'TransactionCurrency'} } bualt_shl,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'TransactionCurrency'} } sctax_shl,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'TransactionCurrency'} } sttax_shl,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'TransactionCurrency'} } penfc_shl,


      @ObjectModel.foreignKey.association: '_BalanceTransactionCurrency'
      @Semantics.currencyCode:true
      pswsl                                                                                                         as BalanceTransactionCurrency,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'BalanceTransactionCurrency'} }
      pswbt_shl                                                                                                     as AmountInBalanceTransacCrcy,


      @ObjectModel.foreignKey.association: '_AdditionalCurrency1'
      @Semantics.currencyCode:true
      h_hwae2                                                                                                       as AdditionalCurrency1,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} }
      bdif2_shl                                                                                                     as ValuationDiffAmtInAddlCrcy1,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} } rdif2_shl,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} }
      dmbe2_shl                                                                                                     as AmountInAdditionalCurrency1,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} } dmb21_shl,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} } dmb22_shl,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} } dmb23_shl,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} }
      mwst2_shl                                                                                                     as TaxAmountInAdditionalCurrency1,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} } navh2_shl,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} } sknt2_shl,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} } txbh2_shl,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} } ppdif2_shl,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} } penlc2_shl,


      @ObjectModel.foreignKey.association: '_AdditionalCurrency2'
      @Semantics.currencyCode:true
      h_hwae3                                                                                                       as AdditionalCurrency2,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} }
      dmbe3_shl                                                                                                     as AmountInAdditionalCurrency2,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} } dmb31_shl,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} } dmb32_shl,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} } dmb33_shl,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} }
      mwst3_shl                                                                                                     as TaxAmountInAdditionalCurrency2,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} } navh3_shl,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} } sknt3_shl,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} }
      bdif3_shl                                                                                                     as ValuationDiffAmtInAddlCrcy2,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} } rdif3_shl,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} } txbh3_shl,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} } ppdif3_shl,

      //@DefaultAggregation: #SUM
      //@Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} } penlc3_shl,


      @ObjectModel.foreignKey.association: '_PaymentCurrency'
      @Semantics.currencyCode:true
      pycur                                                                                                         as PaymentCurrency,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'PaymentCurrency'} }
      pyamt_shl                                                                                                     as AmountInPaymentCurrency,

      @ObjectModel.foreignKey.association: '_CreditControlAreaCurrency'
      @Semantics.currencyCode:true
      t014_waers                                                                                                    as CreditControlAreaCurrency,
      //@Semantics: { amount : {currencyCode: 'CreditControlAreaCurrency'} } klibt_shl,

      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'CreditControlAreaCurrency'} }
      absbt_shl                                                                                                     as HedgedAmount,

      @ObjectModel.foreignKey.association: '_BaseUnit'
      @Semantics.unitOfMeasure:true
      meins                                                                                                         as BaseUnit,
      @DefaultAggregation: #SUM
      @Semantics: { quantity : {unitOfMeasure: 'BaseUnit'} }
      menge                                                                                                         as Quantity,

      @ObjectModel.foreignKey.association: '_GoodsMovementEntryUnit'
      @Semantics.unitOfMeasure:true
      erfme                                                                                                         as GoodsMovementEntryUnit,
      @DefaultAggregation: #SUM
      @Semantics: { quantity : {unitOfMeasure: 'GoodsMovementEntryUnit'} }
      erfmg                                                                                                         as QuantityInEntryUnit,

      @ObjectModel.foreignKey.association: '_PurchasingDocumentPriceUnit'
      @Semantics.unitOfMeasure:true
      bprme                                                                                                         as PurchasingDocumentPriceUnit,
      @DefaultAggregation: #SUM
      @Semantics: { quantity : {unitOfMeasure: 'PurchasingDocumentPriceUnit'} }
      bpmng                                                                                                         as PurchaseOrderQty,

      //      @DefaultAggregation: #NONE   // Is default for Type DEC unsigned and 0 decimals in SADL, in AE it will be treated as characteristic
      @Semantics: { quantity : {unitOfMeasure: 'BaseUnit'} }
      peinh                                                                                                         as MaterialPriceUnitQty,

      @DefaultAggregation: #SUM
      nbritm                                                                                                        as NumberOfItems,

      @API.element.releaseState: #DEPRECATED
      @API.element.successor:    'EarmarkedFundsDocument'
      @VDM.lifecycle.status:    #DEPRECATED
      @VDM.lifecycle.successor: 'EarmarkedFundsDocument'
      kblnr                                                                                                         as EarmarkedFunds,
      @API.element.releaseState: #DEPRECATED
      @API.element.successor:    'EarmarkedFundsDocumentItem'
      @VDM.lifecycle.status:    #DEPRECATED
      @VDM.lifecycle.successor: 'EarmarkedFundsDocumentItem'
      kblpos                                                                                                        as EarmarkedFundsItem,

      ///////////////////////////////////////////////////////////////////////////////
      //GST India BSEG Append
      ///////////////////////////////////////////////////////////////////////////////
      gst_part                                                                                                      as IN_GSTPartner,
      plc_sup                                                                                                       as IN_GSTPlaceOfSupply,
      hsn_sac                                                                                                       as IN_HSNOrSACCode,

      ///////////////////////////////////////////////////////////////////////////////
      //Globalisation Columbia BSEG Append
      ///////////////////////////////////////////////////////////////////////////////
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      txbhw_shl                                                                                                     as OriglTaxBaseAmountInCoCodeCrcy,
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      txbh2_shl                                                                                                     as OriginalTaxBaseAmtInAddlCrcy1,
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      txbh3_shl                                                                                                     as OriginalTaxBaseAmtInAddlCrcy2,

      _AccountingDocumentCategoryT,
      _AccountingDocumentCategory,
      _AccountingDocumentType,
      _AccountingDocumentTypeText,
      _AdditionalCurrency1,
      _AdditionalCurrency2,
      _AssetTransactionType,
      _BalanceTransactionCurrency,
      _BaseUnit,
      _BudgetPeriod,
      _BudgetPeriodText,
      _BusinessArea,
      _BusinessAreaText,
      _BusinessProcess,
      _BusinessProcessText,
      _CashLedgerAccount,
      _CashLedgerCompanyCode,
      _ChartOfAccounts,
      _ChartOfAccountsText,
      _ClearingJrnlEntryFiscalYear,
      _ClearingJournalEntry,
      @API.element.releaseState: #DEPRECATED
      @API.element.successor:    '_ClearingJournalEntry'
      @VDM.lifecycle.status:    #DEPRECATED
      @VDM.lifecycle.successor: '_ClearingJournalEntry'
      _ClearingAccountingDocument,
      _CompanyCode,
      _CompanyCodeCurrency,
      _FunctionalCurrency,
      _ControllingArea,
      _ControllingAreaText,
      _CostCenter,
      _CostCenterText,
      _CostCtrActivityType,
      _CostOriginGroup,
      _CreditControlAreaCurrency,
      _CurrentCostCenter,
      _CurrentProfitCenter,
      _Customer,
      _CustomerCompany,
      @API.element.releaseState: #DEPRECATED
      @API.element.successor:    '_JournalEntryItemOneTimeData'
      @VDM.lifecycle.status:    #DEPRECATED
      @VDM.lifecycle.successor: '_JournalEntryItemOneTimeData'
      _OneTimeAccountBP,
      _JournalEntryItemOneTimeData,
      _CustomerText,
      _DebitCreditCode,

      _PersonWorkAgreement_1,
      //@API.element.releaseState: #DEPRECATED
      //@API.element.successor:    '_PersonWorkAgreement_1'
      @VDM.lifecycle.status:    #DEPRECATED
      @VDM.lifecycle.successor: '_PersonWorkAgreement_1'
      _Employment,

      _FinancialAccountType,
      _FinancialAccountTypeText,
      _FinancialTransactionType,
      _FiscalPeriod,
      _FiscalYear,
      _FixedAsset,
      _FixedAssetText,
      _FunctionalArea,
      _FunctionalAreaText,
      _GLAccountInChartOfAccounts,
      _GLAccountInCompanyCode,
      _GoodsMovementEntryUnit,
      _Grant,
      _HouseBank,
      _HouseBankAccount,
      _HouseBankAccountText,
      _InternalOrder,
      _InventoryValuationType,
      _JournalEntry,
      _MasterFixedAsset,
      _MasterFixedAssetText,
      @API.element.releaseState: #DEPRECATED
      @API.element.successor:    '_Product'
      @VDM.lifecycle.status:    #DEPRECATED
      @VDM.lifecycle.successor: '_Product'
      _Material,
      @API.element.releaseState: #DEPRECATED
      @API.element.successor:    '_ProductText'
      @VDM.lifecycle.status:    #DEPRECATED
      @VDM.lifecycle.successor: '_ProductText'
      _MaterialText,
      _OffsettingAccount,
      _OffsettingAccountType,
      _OffsettingAccountTypeText,
      _OffsettingAccountWithBP,
      _OffsettingChartOfAccounts,
      _OffsettingChartOfAccountsText,
      _Order,
      _PartnerBudgetPeriod,
      _PartnerBusinessArea,
      _PartnerBusinessAreaText,
      @API.element.releaseState: #DEPRECATED
      @API.element.successor:    '_PartnerCompany_2'
      @VDM.lifecycle.status:    #DEPRECATED
      @VDM.lifecycle.successor: '_PartnerCompany_2'
      _PartnerCompany,
      _PartnerCompany_2,
      @API.element.releaseState: #DEPRECATED
      @API.element.successor:    '_PartnerCompanyText_2'
      @VDM.lifecycle.status:    #DEPRECATED
      @VDM.lifecycle.successor: '_PartnerCompanyText_2'
      _PartnerCompanyText,
      _PartnerCompanyText_2,
      _PartnerFunctionalArea,
      _PartnerGrant,
      _PartnerProfitCenter,
      _PartnerSegment,
      _PartnerSegmentText,
      _PaymentCurrency,
      _PaymentDifferenceReason,
      _PaymentDifferenceReasonText,
      _Plant,
      _PostingKey,
      _Product,
      _ProductText,
      _ProfitCenter,
      _ProfitCenterText,
      _ProjectNetwork,
      _ProjectNetworkText,
      _PubSecBudgetAccount,
      _PubSecBudgetAccountCoCode,
      _PurchasingDocument,
      _PurchasingDocumentItem,
      _PurchasingDocumentPriceUnit,
      _ReferenceDocumentType,

      _SalesDoc,
      _SalesDocItem,
      @API.element.releaseState: #DEPRECATED
      @API.element.successor:    '_SalesDoc'
      @VDM.lifecycle.status:     #DEPRECATED
      @VDM.lifecycle.successor:  '_SalesDoc'
      _SalesDocument,
      @API.element.releaseState: #DEPRECATED
      @API.element.successor:    '_SalesDocItem'
      @VDM.lifecycle.status:     #DEPRECATED
      @VDM.lifecycle.successor:  '_SalesDocItem'
      _SalesDocumentItem,

      _Segment,
      _SegmentText,
      _SpecialGLCode,
      _Supplier,
      _SupplierCompany,
      _SupplierBankDetails,
      _SupplierText,
      _SupplyingCountry,
      _TaxCountry,
      _TaxCode,
      _TaxType,
      _TransactionCurrency,
      //@API.element.releaseState: #DEPRECATED
      //@API.element.successor:    ''
      //@VDM.lifecycle.status:    #DEPRECATED
      //@VDM.lifecycle.successor: ''
      _ValuationArea,

      _WBSElementBasicData,
      //@API.element.releaseState: #DEPRECATED
      //@API.element.successor:    '_WBSElementBasicData'
      @VDM.lifecycle.status:     #DEPRECATED
      @VDM.lifecycle.successor:  '_WBSElementBasicData'
      _WBSElementInternalID,

      _WBSElementBasicDataText,
      @API.element.releaseState: #DEPRECATED
      @API.element.successor:    '_WBSElementBasicDataText'
      @VDM.lifecycle.status:     #DEPRECATED
      @VDM.lifecycle.successor:  '_WBSElementBasicDataText'
      _WBSElementInternalIDText,

      _ServiceDocumentType,
      _ServiceDocument,
      _ServiceDocumentItem,

      _FinServicesProductGroup,
      _FinancialServicesBranch,
      _FinancialDataSource,
      _CustomerGroup,
      _CustomerSupplierCountry,
      _CustomerSupplierIndustry,

      //_REObjectByIntFinNumber,

      // Just for Authorization Check!!! DO NOT USE!!! WILL BE DEPRECATED!!!
      @API.element.releaseState: #DEPRECATED
      //@API.element.successor:    ''
      @VDM.lifecycle.status:    #DEPRECATED
      //@VDM.lifecycle.successor: ''
      cast( '' as brgru)                                                                                            as GLAccountAuthorizationGroup,
      @API.element.releaseState: #DEPRECATED
      //@API.element.successor:    ''
      @VDM.lifecycle.status:    #DEPRECATED
      //@VDM.lifecycle.successor: ''
      cast( '' as brgru)                                                                                            as SupplierBasicAuthorizationGrp,
      @API.element.releaseState: #DEPRECATED
      //@API.element.successor:    ''
      @VDM.lifecycle.status:    #DEPRECATED
      //@VDM.lifecycle.successor: ''
      cast( '' as brgru)                                                                                            as CustomerBasicAuthorizationGrp,
      @API.element.releaseState: #DEPRECATED
      //@API.element.successor:    ''
      @VDM.lifecycle.status:    #DEPRECATED
      //@VDM.lifecycle.successor: ''
      cast( '' as brgru)                                                                                            as AcctgDocTypeAuthorizationGroup,
      @API.element.releaseState: #DEPRECATED
      //@API.element.successor:    ''
      @VDM.lifecycle.status:    #DEPRECATED
      //@VDM.lifecycle.successor: ''
      cast( '' as aufart)                                                                                           as OrderType,
      @API.element.releaseState: #DEPRECATED
      //@API.element.successor:    ''
      @VDM.lifecycle.status:    #DEPRECATED
      //@VDM.lifecycle.successor: ''
      cast( '' as auart)                                                                                            as SalesOrderType,
      @API.element.releaseState: #DEPRECATED
      //@API.element.successor:    ''
      @VDM.lifecycle.status:    #DEPRECATED
      //@VDM.lifecycle.successor: ''
      cast( '' as anlkl)                                                                                            as AssetClass

}
