//
//  RefdsBudgetWidgetBundle.swift
//  RefdsBudgetWidget
//
//  Created by Rafael Santos on 02/05/24.
//

import WidgetKit
import SwiftUI

@main
struct RefdsBudgetWidgetBundle: WidgetBundle {
    var body: some Widget {
        SystemSmallExpenseTracker()
        SystemSmallExpenseProgress()
        SystemSmallTransactions()
        SystemMediumExpenseTracker()
        SystemLargeExpenseTracker()
        RemainingLockScreen()
    }
}
