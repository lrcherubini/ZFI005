@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Escritural de Baixa'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true

define root view entity ZC_OperAcctgDocItemWriteOff
  alias DocItem
  provider contract transactional_query
  as projection on ZI_OperAcctgDocItemWriteOff
{
  key CompanyCode,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
  key AccountingDocument,
  key FiscalYear,
  key AccountingDocumentItem,

      @ObjectModel.foreignKey.association: '_ChartOfAccounts'
      ChartOfAccounts,
      AccountingDocumentItemType,

      ClearingDate,
      ClearingCreationDate,

      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_ClearingJrnlEntryFiscalYear'
      ClearingJournalEntryFiscalYear,

      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_ClearingJournalEntry'
      ClearingJournalEntry,

      @ObjectModel.foreignKey.association: '_PostingKey'
      PostingKey,
      @ObjectModel.foreignKey.association: '_FinancialAccountType'
      FinancialAccountType,
      @ObjectModel.foreignKey.association: '_SpecialGLCode'
      SpecialGLCode,
      SpecialGLTransactionType,
      @ObjectModel.foreignKey.association: '_DebitCreditCode'
      DebitCreditCode,
      @ObjectModel.foreignKey.association: '_BusinessArea'
      BusinessArea,
      @ObjectModel.foreignKey.association: '_PartnerBusinessArea'
      PartnerBusinessArea,
      TaxCode,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_TaxCountry'
      TaxCountry,
      TaxRateValidityStartDate,
      WithholdingTaxCode,
      TaxType,
      TaxItemGroup,
      TransactionTypeDetermination,
      ValueDate,
      AssignmentReference,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.80
      DocumentItemText,
      @ObjectModel.foreignKey.association: '_PartnerCompany_2'
      PartnerCompany,
      @ObjectModel.foreignKey.association: '_FinancialTransactionType'
      FinancialTransactionType,
      CorporateGroupAccount,
      PlanningLevel,
      @ObjectModel.foreignKey.association: '_ControllingArea'
      ControllingArea,
      @ObjectModel.foreignKey.association: '_CostCenter'
      CostCenter,

      @ObjectModel.foreignKey.association: '_Order'
      OrderID,
      BillingDocument,
      @ObjectModel.foreignKey.association: '_SalesDoc'
      SalesDocument,
      @ObjectModel.foreignKey.association: '_SalesDocItem'
      SalesDocumentItem,
      ScheduleLine,

      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_ServiceDocumentType'
      ServiceDocumentType,

      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_ServiceDocument'
      ServiceDocument,

      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_ServiceDocumentItem'
      ServiceDocumentItem,

      @ObjectModel.foreignKey.association: '_MasterFixedAsset'
      MasterFixedAsset,
      @ObjectModel.foreignKey.association: '_FixedAsset'
      FixedAsset,
      @ObjectModel.foreignKey.association: '_AssetTransactionType'
      AssetTransactionType,
      AssetValueDate,
      PersonnelNumber,
      IsSalesRelated,
      LineItemDisplayIsEnabled,
      IsOpenItemManaged,

      AddressAndBankIsSetManually,
      @Analytics.internalName: #LOCAL
      DownPaymentIsNetProcedure,
      IsNotCashDiscountLiable,
      IsAutomaticallyCreated,
      IsUsedInPaymentTransaction,
      OperationalGLAccount,
      @ObjectModel.foreignKey.association: '_GLAccountInChartOfAccounts'
      GLAccount,
      @ObjectModel.foreignKey.association: '_Customer'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @ObjectModel.text.element: ['CustomerName']
      @Consumption.valueHelpDefinition: [{ entity : {name: 'I_Customer', element: 'Customer'  }, useForValidation: true }]
      Customer,
      _Customer.CustomerName,
      @ObjectModel.foreignKey.association: '_Supplier'
      Supplier,
      BranchAccount,
      IsBalanceSheetAccount,
      ProfitLossAccountType,
      SpecialGLAccountAssignment,
      DueCalculationBaseDate,
      PaymentTerms,
      CashDiscount1Days,
      CashDiscount2Days,
      NetPaymentDays,
      CashDiscount1Percent,
      CashDiscount2Percent,
      PaymentMethod,
      PaymentBlockingReason,
      FixedCashDiscount,
      @ObjectModel.foreignKey.association: '_HouseBank'
      HouseBank,
      @ObjectModel.foreignKey.association: '_SupplierBankDetails'
      BPBankAccountInternalID,
      TaxDistributionCode1,
      TaxDistributionCode2,
      TaxDistributionCode3,
      InvoiceReference,
      InvoiceReferenceFiscalYear,
      InvoiceItemReference,
      FollowOnDocumentType,
      StateCentralBankPaymentReason,
      @ObjectModel.foreignKey.association: '_SupplyingCountry'
      SupplyingCountry,
      InvoiceList,
      BillOfExchangeUsageDocument,
      BillOfExchangeUsage,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      ZZBoEPayRequest,
      ZZBoEFiscalYear,
      ZZBoECompanyCode,
      ZZBoEDueDate,
      DunningKey,
      DunningBlockingReason,
      LastDunningDate,
      DunningLevel,
      DunningArea,
      PaytSlipWthRefSubscriber,
      PaytSlipWthRefReference,
      PaytSlipWthRefCheckDigit,
      WithholdingTaxCertificate,

      @ObjectModel.foreignKey.association: '_Product'
      Product,
      @ObjectModel.foreignKey.association: '_Plant'
      Plant,
      PurchasingDocument,
      PurchasingDocumentItem,
      AccountAssignmentNumber,
      //@Semantics.booleanIndicator
      IsCompletelyDelivered,
      MaterialPriceControl,
      ValuationArea,
      @ObjectModel.foreignKey.association: '_InventoryValuationType'
      InventoryValuationType,
      VATRegistration,
      DelivOfGoodsDestCountry,
      DelivOfGoodsOriginCountry,
      @ObjectModel.foreignKey.association: '_PaymentDifferenceReason'
      PaymentDifferenceReason,
      @ObjectModel.foreignKey.association: '_ProfitCenter'
      ProfitCenter,
      JointVenture,
      JointVentureCostRecoveryCode,
      JointVentureEquityGroup,
      JointVenturePartner,
      TreasuryContractType,
      AssetContract,
      CashFlowType,
      TaxJurisdiction,

      REInternalFinNumber,
      SettlementReferenceDate,
      CommitmentItemShortID,

      CostObject,
      ProjectNetwork,
      OrderInternalBillOfOperations,
      OrderIntBillOfOperationsItem,
      WBSElementInternalID,
      ProfitabilitySegment_2,

      JointVentureBillingType,
      JointVentureEquityType,
      IsEUTriangularDeal,
      CostOriginGroup,
      CompanyCodeCurrencyDetnMethod,
      ClearingIsReversed,
      PaymentMethodSupplement,
      AlternativeGLAccount,
      FundsCenter,
      Fund,
      TaxCompanyCode,
      @ObjectModel.foreignKey.association: '_PartnerProfitCenter'
      PartnerProfitCenter,
      Reference1IDByBusinessPartner,
      Reference2IDByBusinessPartner,
      @Analytics.internalName: #LOCAL
      EarmarkedFundsDocument,
      @Analytics.internalName: #LOCAL
      EarmarkedFundsDocumentItem,
      IsNegativePosting,
      PaymentCardItem,
      PaymentCardPaymentSettlement,
      CreditControlArea,
      AlternativePayeePayer,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      Reference3IDByBusinessPartner,
      DataExchangeInstruction1,
      DataExchangeInstruction2,
      DataExchangeInstruction3,
      DataExchangeInstruction4,
      Region,
      HasPaymentOrder,
      PaymentReference,
      TaxDeterminationDate,
      ClearingItem,
      BusinessPlace,
      TaxSection,
      @ObjectModel.foreignKey.association: '_CostCtrActivityType'
      CostCtrActivityType,
      AcctsReceivablePledgingCode,
      BusinessProcess,
      @Analytics.internalName: #LOCAL
      GrantID,
      @ObjectModel.foreignKey.association: '_FunctionalArea'
      FunctionalArea,
      CustomerIsInExecution,
      FundedProgram,
      LedgerGLLineItem,
      @ObjectModel.foreignKey.association: '_Segment'
      Segment,
      @ObjectModel.foreignKey.association: '_PartnerSegment'
      PartnerSegment,
      @ObjectModel.foreignKey.association: '_PartnerFunctionalArea'
      PartnerFunctionalArea,
      HouseBankAccount,
      CostElement,
      TaxItemAcctgDocItemRef,
      PaymentServiceProvider,
      PaymentRefByPaytSrvcProvider,
      SEPAMandate,
      @ObjectModel.foreignKey.association: '_ReferenceDocumentType'
      ReferenceDocumentType,
      OriginalReferenceDocument,
      ReferenceDocumentLogicalSystem,
      AccountingDocumentItemRef,
      @ObjectModel.foreignKey.association: '_FiscalPeriod'
      FiscalPeriod,
      @ObjectModel.foreignKey.association: '_AccountingDocumentCategory'
      AccountingDocumentCategory,

      PostingDate,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.80
      DocumentDate,
      @ObjectModel.foreignKey.association: '_AccountingDocumentType'
      AccountingDocumentType,
      NetDueDate,
      CashDiscount1DueDate,
      CashDiscount2DueDate,
      @ObjectModel.foreignKey.association: '_OffsettingAccountWithBP'
      OffsettingAccount,
      @ObjectModel.foreignKey.association: '_OffsettingAccountType'
      OffsettingAccountType,
      @ObjectModel.foreignKey.association: '_OffsettingChartOfAccounts'
      OffsettingChartOfAccounts,
      PartnerFund,
      @Analytics.internalName: #LOCAL
      PartnerGrant,
      BudgetPeriod,
      @Analytics.internalName: #LOCAL
      PartnerBudgetPeriod,
      BranchCode,
      JointVentureProductionDate,

      OplAcctgDocItmCntrySpcfcRef1,

      PaymentReason,

      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_CashLedgerCompanyCode'
      CashLedgerCompanyCode,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_CashLedgerAccount'
      CashLedgerAccount,

      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_PubSecBudgetAccountCoCode'
      PubSecBudgetAccountCoCode,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_PubSecBudgetAccount'
      PubSecBudgetAccount,


      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_FinServicesProductGroup'
      FinancialServicesProductGroup,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_FinancialServicesBranch'
      FinancialServicesBranch,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_FinancialDataSource'
      FinancialDataSource,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_CustomerGroup'
      CustomerGroup,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_CustomerSupplierCountry'
      CustomerSupplierCountry,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_CustomerSupplierIndustry'
      CustomerSupplierIndustry,


      @ObjectModel.foreignKey.association: '_CompanyCodeCurrency'
      CompanyCodeCurrency,


      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      AmountInCompanyCodeCurrency,

      // Functional Currency
      @ObjectModel.foreignKey.association: '_FunctionalCurrency'
      FunctionalCurrency,

      @Semantics: { amount : {currencyCode: 'FunctionalCurrency'} }
      AmountInFunctionalCurrency,


      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      TaxAmountInCoCodeCrcy,


      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      TaxBaseAmountInCoCodeCrcy,


      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      ValuationDiffAmtInCoCodeCrcy,


      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      CashDiscountAmtInCoCodeCrcy,


      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      TaxBrkdwnAmount1InCoCodeCrcy,


      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      TaxBrkdwnAmount2InCoCodeCrcy,


      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      TaxBrkdwnAmount3InCoCodeCrcy,


      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      NonDcblTaxAmountInCoCodeCrcy,


      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      InvoiceAmtInCoCodeCrcy,

      @ObjectModel.foreignKey.association: '_TransactionCurrency'
      TransactionCurrency,


      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      AmountInTransactionCurrency,


      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      OriginalTaxBaseAmount,


      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      TaxAmount,


      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      TaxBaseAmountInTransCrcy,


      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      WithholdingTaxBaseAmount,


      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      PlannedAmtInTransactionCrcy,


      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      CashDiscountBaseAmount,


      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      CashDiscountAmount,


      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      NetPaymentAmount,


      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      TaxBrkdwnAmount1InTransCrcy,


      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      TaxBrkdwnAmount2InTransCrcy,


      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      TaxBrkdwnAmount3InTransCrcy,


      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      WithholdingTaxAmount,


      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      WithholdingTaxExemptionAmt,


      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      NonDcblTaxAmountInTransCrcy,


      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      InvoiceAmountInFrgnCurrency,

      @ObjectModel.foreignKey.association: '_BalanceTransactionCurrency'
      BalanceTransactionCurrency,


      @Semantics: { amount : {currencyCode: 'BalanceTransactionCurrency'} }
      AmountInBalanceTransacCrcy,

      @ObjectModel.foreignKey.association: '_AdditionalCurrency1'
      AdditionalCurrency1,


      @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} }
      ValuationDiffAmtInAddlCrcy1,


      @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} }
      AmountInAdditionalCurrency1,


      @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} }
      TaxAmountInAdditionalCurrency1,

      @ObjectModel.foreignKey.association: '_AdditionalCurrency2'
      AdditionalCurrency2,


      @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} }
      AmountInAdditionalCurrency2,


      @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} }
      TaxAmountInAdditionalCurrency2,


      @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} }
      ValuationDiffAmtInAddlCrcy2,

      @ObjectModel.foreignKey.association: '_PaymentCurrency'
      PaymentCurrency,

      @Semantics: { amount : {currencyCode: 'PaymentCurrency'} }
      AmountInPaymentCurrency,

      @ObjectModel.foreignKey.association: '_CreditControlAreaCurrency'

      CreditControlAreaCurrency,


      @Semantics: { amount : {currencyCode: 'CreditControlAreaCurrency'} }
      HedgedAmount,

      @ObjectModel.foreignKey.association: '_BaseUnit'

      BaseUnit,

      @Semantics: { quantity : {unitOfMeasure: 'BaseUnit'} }
      Quantity,

      @ObjectModel.foreignKey.association: '_GoodsMovementEntryUnit'

      GoodsMovementEntryUnit,

      @Semantics: { quantity : {unitOfMeasure: 'GoodsMovementEntryUnit'} }
      QuantityInEntryUnit,

      @ObjectModel.foreignKey.association: '_PurchasingDocumentPriceUnit'

      PurchasingDocumentPriceUnit,

      @Semantics: { quantity : {unitOfMeasure: 'PurchasingDocumentPriceUnit'} }
      PurchaseOrderQty,

      @Semantics: { quantity : {unitOfMeasure: 'BaseUnit'} }
      MaterialPriceUnitQty,


      NumberOfItems,

      ///////////////////////////////////////////////////////////////////////////////
      //GST India BSEG Append
      ///////////////////////////////////////////////////////////////////////////////
      IN_GSTPartner,
      IN_GSTPlaceOfSupply,
      IN_HSNOrSACCode,

      ///////////////////////////////////////////////////////////////////////////////
      //Globalisation Columbia BSEG Append
      ///////////////////////////////////////////////////////////////////////////////
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      OriglTaxBaseAmountInCoCodeCrcy,
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      OriginalTaxBaseAmtInAddlCrcy1,
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      OriginalTaxBaseAmtInAddlCrcy2,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      DocumentReferenceID,

      actionFB09,

      /* Associations */
      _AccountingDocumentCategory,
      _AccountingDocumentCategoryT,
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
      _ClearingJournalEntry,
      _ClearingJrnlEntryFiscalYear,
      _CompanyCode,
      _CompanyCodeCurrency,
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
      _CustomerGroup,
      _CustomerSupplierCountry,
      _CustomerSupplierIndustry,
      _CustomerText,
      _DebitCreditCode,
      _Employment,
      _FinancialAccountType,
      _FinancialAccountTypeText,
      _FinancialDataSource,
      _FinancialServicesBranch,
      _FinancialTransactionType,
      _FinServicesProductGroup,
      _FiscalPeriod,
      _FiscalYear,
      _FixedAsset,
      _FixedAssetText,
      _FunctionalArea,
      _FunctionalAreaText,
      _FunctionalCurrency,
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
      _JournalEntryItemOneTimeData,
      _MasterFixedAsset,
      _MasterFixedAssetText,
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
      _PartnerCompanyText_2,
      _PartnerCompany_2,
      _PartnerFunctionalArea,
      _PartnerGrant,
      _PartnerProfitCenter,
      _PartnerSegment,
      _PartnerSegmentText,
      _PaymentCurrency,
      _PaymentDifferenceReason,
      _PaymentDifferenceReasonText,
      _PersonWorkAgreement_1,
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
      _Segment,
      _SegmentText,
      _ServiceDocument,
      _ServiceDocumentItem,
      _ServiceDocumentType,
      _SpecialGLCode,
      _Supplier,
      _SupplierBankDetails,
      _SupplierCompany,
      _SupplierText,
      _SupplyingCountry,
      _TaxCode,
      _TaxCountry,
      _TaxType,
      _TransactionCurrency,
      _WBSElementBasicData,
      _WBSElementBasicDataText
}
