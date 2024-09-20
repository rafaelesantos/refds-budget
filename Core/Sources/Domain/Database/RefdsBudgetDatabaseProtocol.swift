import Foundation
import CoreData

public protocol RefdsBudgetDatabaseProtocol {
    var viewContext: NSManagedObjectContext { get set }
}
