import Foundation
import RefdsRedux
import RefdsBudgetData

public enum BudgetComparisonAction: RefdsReduxAction {
    case fetchData
    case updateData(
        BudgetRowViewDataProtocol,
        BudgetRowViewDataProtocol,
        [BudgetComparisonChartViewDataProtocol],
        [BudgetComparisonChartViewDataProtocol]
    )
}
