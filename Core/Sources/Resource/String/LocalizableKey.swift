import Foundation

public enum LocalizableKey: String {
    // MARK: - Error
    case errorExistingCategoryTitle
    case errorNotFoundCategoryTitle
    case errorNotFoundBudgetTitle
    case errorExistingTransactionTitle
    case errorNotFoundTransactionTitle
    case errorCantDeleteCategoryTitle
    case errorCantDeleteBudgetTitle
    case errorExistingBudgetTitle
    case errorCantSaveOnDatabaseTitle
    case errorAcceptTermsTitle
    case errorNotFoundProductsTitle
    case errorPurchaseTitle
    case errorIconUpdateTitle
    
    case errorExistingCategoryDescription
    case errorNotFoundCategoryDescription
    case errorNotFoundBudgetDescription
    case errorExistingTransactionDescription
    case errorNotFoundTransactionDescription
    case errorCantDeleteCategoryDescription
    case errorCantDeleteBudgetDescription
    case errorExistingBudgetDescription
    case errorCantSaveOnDatabaseDescription
    case errorExistingTagTitle
    case errorNotFoundTagTitle
    case errorCantDeleteTagTitle
    case errorExistingTagDescription
    case errorNotFoundTagDescription
    case errorCantDeleteTagDescription
    case errorAcceptTermsDescription
    case errorNotFoundProductsDescription
    case errorPurchaseDescription
    case errorIconUpdateDescription
    // MARK: - Loading Row
    case loadinginRowTitle
    case loadinginRowDescription
    // MARK: - Category Row
    case categoryRowTransactions
    // MARK: - Add Budget
    case addBudgetDescriptionBudget
    case addBudgetDescriptionHeader
    case addBudgetSelectedMonth
    case addBudgetSelectedYear
    case addBudgetDateHeader
    case addBudgetAdd
    case addBudgetEmptyCategories
    case addBudgetSelectedCategory
    case addBudgetCategoryHeader
    case addBudgetAISuggestion
    // MARK: - Add Category
    case addCategoryInputName
    case addCategoryColorHeader
    case addCategoryInputHex
    case addCategoryIconsHeader
    case addCategorySelectedIcon
    case addCategoryShowLessIcons
    case addCategoryShowMoreIcons
    case addCategorySaveCategoryButton
    // MARK: - Categories
    case categoriesNavigationTitle
    case categoriesBalanceTitle
    case categoriesBalanceSubtitle
    case categoriesPeriod
    case categoriesBalance
    case categoriesEmptyCategoriesTitle
    case categoriesEmptyCategoriesDescription
    case categoriesEmptyCategoriesButton
    case categoriesEmptyBudgetsTitle
    case categoriesEmptyBudgetsDescription
    case categoriesEmptyBudgetsButton
    case categoriesEditBudget
    case categoriesEditCategory
    case categoriesRemoveBudget
    case categoriesRemoveCategory
    case categoriesApplyFilters
    case categoriesDate
    case categoriesFilter
    case categoriesLegend
    case categoriesGreenLegendTitle
    case categoriesGreenLegendDescription
    case categoriesYellowLegendTitle
    case categoriesYellowLegendDescription
    case categoriesOrangeLegendTitle
    case categoriesOrangeLegendDescription
    case categoriesRedLegendTitle
    case categoriesRedLegendDescription
    case categoriesBudgetChartHeader
    case categoriesTransactionsChartHeader
    case categoriesWithoutBudgetHeader
    case categoriesWithoutBudgetDescription
    // MARK: - Category
    case categoryBalanceTitle
    case categoryBalanceSubtitle
    case categoryBudgetsHeader
    case categoryTransactionsHeader
    // MARK: - Empty Budget
    case emptyTitle
    case emptyDescriptions
    case emptyBudgetsTitle
    case emptyTransactionsTitle
    // MARK: - Item Navigation
    case itemNavigationProfile
    case itemNavigationCategories
    case itemNavigationHome
    case itemNavigationTransactions
    case itemNavigationSettings
    // MARK: - Add Transaction
    case addTransactionRemaining
    case addTransactionSaveButton
    case addTransactionNavigationTitle
    case addTransactionDescriptionPrompt
    case addTransactionStatusHeader
    case addTransactionStatusSelect
    case addTransactionStatusSpend
    case addTransactionStatusPending
    case addTransactionStatusCleared
    case addTransactionDescriptionCount
    // MARK: - Transactions
    case transactionNavigationTitle
    case transactionEditNavigationTitle
    case transactionsCopyHeader
    case transactionsCopyFooter
    case transactionsRemoveTransactions
    case transactionsShareText
    case transactionsShare
    case transactionsNewTransactions
    case transactionsMoreMultiMenuHeader
    case transactionsMoreMenuHeader
    case transactionsAddTransaction
    case transactionsFilterByDate
    case transactionsCleanCategoriesFilter
    case transactionsCategoriesFilterHeader
    case transactionsCategoriesAllSelected
    case transactionsLargestPurchaseHeader
    case transactionsOptionsSelect
    case transactionsOptionsSelectDone
    case transactionsPaginationHeader
    case transactionsPaginationDaysAmount
    case transactionsPaginationDay
    case transactionsPaginationDays
    case transactionsPaginationHalfMonth
    case transactionsPaginationAllDays
    // MARK: - Home
    case homeNavigationTitle
    case homeRemainingHeader
    case homeRemainingTitle
    case homeRemainingCategoryTransactions
    case homeManageTags
    case homeSpendBudgetHeader
    case homeSpendBudgetCategory
    case homeSpendBudgetBudgetTitle
    case homeSpendBudgetSpendTitle
    case homeSpendBudgetPercentageResult
    // MARK: - Tags
    case tagsNavigationTitle
    case tagsInputHeader
    case tagsInputNamePlaceholder
    case tagsSaveButton
    case tagsChartSectionHeader
    case tagsMenuSelectHeader
    case tagsRemoveTag
    case tagsEditTag
    case tagsCleanSelected
    case tagsHeader
    case menuCleanSelections
    // MARK: - Filter
    case filterDate
    case filterCategory
    case filterTags
    case filterCurrentMonth
    // MARK: - Widget
    case widgetAppName
    case widgetCurrentSpend
    case widgetTotalBudget
    case widgetRemaining
    case widgetTitleSystemSmallExpanseTracker
    case widgetDescriptionSystemSmallExpanseTracker
    case widgetTitleSystemSmallTransactions
    case widgetDescriptionSystemSmallTransactions
    case widgetTitleRemainingLockScreen
    case widgetDescriptionRemainingLockScreen
    // MARK: - Application Icon
    case appIconAppIcon
    case appIconDarkMainCornerIcon
    case appIconDarkMainIcon
    case appIconDarkProCornerIcon
    case appIconDarkProIcon
    case appIconDarkSystemCornerIcon
    case appIconDarkSystemIcon
    case appIconDeveloperDarkMainIcon
    case appIconDeveloperDarkProIcon
    case appIconDeveloperDarkSystemIcon
    case appIconDeveloperLightMainIcon
    case appIconDeveloperLightProIcon
    case appIconDeveloperLightSystemIcon
    case appIconDeveloperMainIcon
    case appIconDeveloperProIcon
    case appIconDeveloperSystemIcon
    case appIconLightMainCornerIcon
    case appIconLightMainIcon
    case appIconLightProCornerIcon
    case appIconLightProIcon
    case appIconLightSystemCornerIcon
    case appIconLightSystemIcon
    case appIconMainCornerIcon
    case appIconProCornerIcon
    case appIconProIcon
    case appIconSystemCornerIcon
    case appIconSystemIcon
    // MARK: - Settings
    case settingsNavigationTitle
    case settingsSectionCustomization
    case settingsRowAppearance
    case settingsRowAppearanceDark
    case settingsRowAppearanceLight
    case settingsRowAppearanceSystem
    case settingsRowTheme
    case settingsSectionIcons
    case settingsRowAnimatedIcons
    case settingsSectionMoreOptions
    case settingsRowTestFlight
    case settingsTagBeta
    case settingsRowReviewDetail
    case settingsRowReview
    case settingsRowShare
    case settingsSectionAbout
    case settingsDevJob
    case settingsApplicationName
    case settingsApplicationVersion
    case settingsApplicationDescription
    case settingsSectionSecurity
    case settingsPrivacyPolicy
    case settingsRowFaceID
    case settingsRowPrivacyMode
    case settingsFilename
    case settingsFileHeader
    case settingsFileExport
    case settingsFileImport
    //MARK: - Welcome
    case welcomeCategoryTitle
    case welcomeCategoryDescription
    case welcomeBudgetTitle
    case welcomeBudgetDescription
    case welcomeTransactionTitle
    case welcomeTransactionDescription
    case welcomeFooterDescription
    case welcomeFooterButton
    // MARK: - Subscription
    case subscriptionWelcomePremium
    case subscriptionBecomePremium
    case subscriptionNavigationTitle
    case subscriptionSubtitle
    case subscriptionSubtitlePro
    case subscriptionFeaturesHeader
    case subscriptionFreeHeader
    case subscriptionPremiumHeader
    case subscriptionRowSelectPlan
    case subscriptionPlansHeader
    case subscriptionPriceHeader
    case subscriptionPriceObsevations
    case subscriptionTermsButton
    case subscriptionTermsDescription
    case subscriptionManageButton
    case subscriptionButton
    case subscriptionButtonRestore
    case subscriptionExpirationDate
    case subscriptionCurrentPlanPurchaseDate
    case subscriptionCurrentPlanRemaining
    case subscriptionCurrentPlan
    case subscriptionFeatureTitle1
    case subscriptionFeatureTitle2
    case subscriptionFeatureTitle3
    case subscriptionFeatureTitle4
    case subscriptionFeatureTitle5
    case subscriptionFeatureTitle6
    case subscriptionFeatureTitle7
    case subscriptionFeatureTitle8
    case subscriptionFeatureTitle9
    case subscriptionFeatureTitle10
    case subscriptionFeatureTitle11
    case subscriptionFeatureTitle12
    // MARK: - Import
    case importNavigationTitle
    case importTotalValue
    case importTransactionsAmount
    case importPeriod
    case importWarning
    case importImportHeader
    case importShowLessCategories
    case importShowMoreCategories
    // MARK: - Intelligence
    case intelligenceTrainingGettingData
    case intelligenceTrainingPreparingData
    case intelligenceTrainingTrainingData
    case intelligenceTrainingSavingData
    // MARK: - Comparison Row
    case comparisonRowHeader
    case comparisonRowDescription
    case comparisonRowButton
    // MARK: - Comparison
    case comparisonBudgetSelection
    case comparisonBudgetVS
    case comparisonBudgetVariation
    case comparisonBudgetPerformance
    case comparisonBudgetPerformanceDescription
    case comparisonBudgetCategoryPerformance
    case comparisonBudgetTagComparison
    case comparisonBudgetBackButton
    // MARK: - Artificial Intelligence
    case aiTitle
}