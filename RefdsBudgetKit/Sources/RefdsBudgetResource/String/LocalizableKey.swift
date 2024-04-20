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
    // MARK: - Transactions
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
    // MARK: - Home
    // MARK: - Tags
    case tagsNavigationTitle
    case tagsInputHeader
    case tagsInputNamePlaceholder
    case tagsSaveButton
    case tagsCollapsedHeader
    case tagsChartSectionHeader
    case tagsMenuSelectHeader
    case tagsRemoveTag
    case tagsCleanSelected
    case menuCleanSelections
}
