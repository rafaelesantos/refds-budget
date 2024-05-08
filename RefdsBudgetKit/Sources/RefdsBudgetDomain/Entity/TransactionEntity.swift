import Foundation
import SwiftUI
import CoreData
import RefdsShared
import RefdsBudgetResource

@objc(TransactionEntity)
public class TransactionEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        return NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: UUID
    @NSManaged public var date: TimeInterval
    @NSManaged public var id: UUID
    @NSManaged public var message: String
    @NSManaged public var status: String
}

public enum TransactionStatus: String, Codable, CaseIterable {
    case spend
    case pending
    case cleared
    
    public var description: String {
        switch self {
        case .spend: return .localizable(by: .addTransactionStatusSpend)
        case .pending: return .localizable(by: .addTransactionStatusPending)
        case .cleared: return .localizable(by: .addTransactionStatusCleared)
        }
    }
    
    public var icon: RefdsIconSymbol? {
        switch self {
        case .spend: return nil
        case .pending: return .exclamationmarkTriangleFill
        case .cleared: return .checkmarkSealFill
        }
    }
    
    public var color: Color {
        switch self {
        case .spend: return .primary
        case .pending: return .orange
        case .cleared: return .green
        }
    }
}
