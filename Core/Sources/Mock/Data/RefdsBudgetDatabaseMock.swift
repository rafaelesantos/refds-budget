import Foundation
import CoreData
import RefdsCoreData
import Domain

public final class RefdsBudgetDatabaseMock: RefdsBudgetDatabaseProtocol {
    lazy public var viewContext: NSManagedObjectContext = {
        container.viewContext
    }()
    
    public init() {}
    
    private lazy var coreDataModel: NSManagedObjectModel = {
        let description = RefdsCoreDataModelDescription(entities: [
            .entity(
                name: "BudgetEntity",
                managedObjectClass: BudgetEntity.self,
                attributes: [
                    .attribute(name: "id", type: .UUIDAttributeType, isOptional: true),
                    .attribute(name: "amount", type: .doubleAttributeType, isOptional: true),
                    .attribute(name: "message", type: .stringAttributeType, isOptional: true),
                    .attribute(name: "category", type: .UUIDAttributeType, isOptional: true),
                    .attribute(name: "date", type: .dateAttributeType, isOptional: true),
                ]
            ),
            .entity(
                name: "TransactionEntity",
                managedObjectClass: TransactionEntity.self,
                attributes: [
                    .attribute(name: "id", type: .UUIDAttributeType, isOptional: true),
                    .attribute(name: "amount", type: .doubleAttributeType, isOptional: true),
                    .attribute(name: "message", type: .stringAttributeType, isOptional: true),
                    .attribute(name: "category", type: .UUIDAttributeType, isOptional: true),
                    .attribute(name: "date", type: .dateAttributeType, isOptional: true),
                    .attribute(name: "status", type: .stringAttributeType, isOptional: true, defaultValue: TransactionStatus.spend.rawValue)
                ]
            ),
            .entity(
                name: "CategoryEntity",
                managedObjectClass: CategoryEntity.self,
                attributes: [
                    .attribute(name: "id", type: .UUIDAttributeType, isOptional: true),
                    .attribute(name: "color", type: .stringAttributeType, isOptional: true),
                    .attribute(name: "name", type: .stringAttributeType, isOptional: true),
                    .attribute(name: "icon", type: .stringAttributeType, isOptional: true),
                    .attribute(name: "budgets", type: .transformableAttributeType, isOptional: true, attributeValueClassName: "[UUID]", valueTransformerName: "NSSecureUnarchiveFromDataTransformer")
                ]
            ),
            .entity(
                name: "SettingsEntity",
                managedObjectClass: SettingsEntity.self,
                attributes: [
                    .attribute(name: "date", type: .dateAttributeType, isOptional: true),
                    .attribute(name: "theme", type: .stringAttributeType, isOptional: true),
                    .attribute(name: "icon", type: .stringAttributeType, isOptional: true),
                    .attribute(name: "isAnimatedIcon", type: .booleanAttributeType, isOptional: true),
                    .attribute(name: "appearence", type: .doubleAttributeType, isOptional: true),
                    .attribute(name: "hasAuthRequest", type: .booleanAttributeType, isOptional: true),
                    .attribute(name: "hasPrivacyMode", type: .booleanAttributeType, isOptional: true),
                    .attribute(name: "notifications", type: .booleanAttributeType, isOptional: true),
                    .attribute(name: "reminderNotification", type: .booleanAttributeType, isOptional: true),
                    .attribute(name: "warningNotification", type: .booleanAttributeType, isOptional: true),
                    .attribute(name: "breakingNotification", type: .booleanAttributeType, isOptional: true),
                    .attribute(name: "currentWarningNotificationAppears", type: .transformableAttributeType, isOptional: true, attributeValueClassName: "[UUID]", valueTransformerName: "NSSecureUnarchiveFromDataTransformer"),
                    .attribute(name: "currentBreakingNotificationAppears", type: .transformableAttributeType, isOptional: true, attributeValueClassName: "[UUID]", valueTransformerName: "NSSecureUnarchiveFromDataTransformer"),
                    .attribute(name: "liveActivity", type: .UUIDAttributeType, isOptional: true),
                    .attribute(name: "isPro", type: .booleanAttributeType, isOptional: true)
                ]
            ),
            .entity(
                name: "BubbleEntity",
                managedObjectClass: BubbleEntity.self,
                attributes: [
                    .attribute(name: "id", type: .UUIDAttributeType, isOptional: true),
                    .attribute(name: "color", type: .stringAttributeType, isOptional: true),
                    .attribute(name: "name", type: .stringAttributeType, isOptional: true),
                    .attribute(name: "icon", type: .stringAttributeType, isOptional: true)
                ]
            ),
        ])
        return description.makeModel()
    }()
    
    private lazy var container: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "ApplicationDebugEntity", managedObjectModel: self.coreDataModel)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()
}
