import Foundation
import RefdsRedux

public enum BudgetComparisonAction: RefdsReduxAction {
    case fetchData
    case updateData(
        BudgetItemViewDataProtocol,
        BudgetItemViewDataProtocol,
        [BudgetComparisonChartViewDataProtocol],
        [BudgetComparisonChartViewDataProtocol]
    )
}
