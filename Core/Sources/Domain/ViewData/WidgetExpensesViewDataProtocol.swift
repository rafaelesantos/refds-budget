import Foundation
import Resource

public protocol WidgetExpensesViewDataProtocol {
    var isFilterByDate: Bool { get set }
    var category: String { get set }
    var tag: String { get set }
    var status: String { get set }
    var date: Date { get set }
    var spend: Double { get set }
    var budget: Double { get set }
    var percent: Double { get }
    var remaining: Double { get }
}