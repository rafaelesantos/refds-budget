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
    case categoriesChartHeader
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
    // MARK: - Transactions
    case transactionNavigationTitle
    case transactionEditNavigationTitle
    case transactionsCopyHeader
    case transactionsCopyFooter
    case transactionsRemoveTransactions
    case transactionsCopyTransactions
    case transactionsNewTransactions
    case transactionsMoreMultiMenuHeader
    case transactionsMoreMenuHeader
    case transactionsAddTransaction
    case transactionsFilterByDate
    case transactionsCleanCategoriesFilter
    case transactionsCategoriesFilterHeader
    case transactionsCategorieAllSelected
    case transactionsLargestPurchaseHeader
    case transactionsOptionsSelect
    case transactionsOptionsSelectDone
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
    case tagsCollapsedHeader
    case tagsChartSectionHeader
    case tagsMenuSelectHeader
    case tagsRemoveTag
    case tagsEditTag
    case tagsCleanSelected
    case menuCleanSelections
    // MARK: - Filter
    case filterDateMonth
    case filterDateYear
    case filterCategory
    case filterTags
    // MARK: - Widget
    case widgetAppName
    case widgetCurrentSpend
    case widgetTotalBudget
    case widgetRemaining
    case widgetTitleSystemSmallExpanseTracker
    case widgetDescriptionSystemSmallExpanseTracker
    case widgetTitleSystemSmallTransactions
    case widgetDescriptionSystemSmallTransactions
    // MARK: - Application Icon
    case appIconDefault
    case appIconLight
    case appIconDark
    case appIconSystem
    case appIconLightSystem
    case appIconDarkSystem
    case appIconLgbt
    // MARK: - Settings
    case settingsNavigationTitle
    case settingsSectionCustomization
    case settingsRowAppearence
    case settingsRowTheme
    case settingsSectionIcons
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
    //MARK: - Welcome
    case welcomeCategoryTitle
    case welcomeCategoryDescription
    case welcomeBudgetTitle
    case welcomeBudgetDescription
    case welcomeTransactionTitle
    case welcomeTransactionDescription
    case welcomeFooterDescription
    case welcomeFooterButton
}
