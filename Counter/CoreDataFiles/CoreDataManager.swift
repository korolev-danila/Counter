//
//  CoreDataManager.swift
//  Counter
//
//  Created by Данила on 22.02.2023.
//

import CoreData

protocol CoreDataProtocol {
    func fetchMyCounters() -> [Model]
    func resetAllRecords()
    func saveContext()
    func createNew() -> Model?
    func delete(counter: Model)
}

final class CoreDataManager {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

// MARK: - CoreDataProtocol
extension CoreDataManager: CoreDataProtocol {
    func fetchMyCounters() -> [Model] {
        do {
            let array = try context.fetch(Model.fetchRequest())
            return array
        } catch let error as NSError {
            print(error.localizedDescription)
            return []
        }
    }

    func resetAllRecords() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Model")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func saveContext() {
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func createNew() -> Model? {
        guard let entity = NSEntityDescription.entity(forEntityName: "Model",
                                                      in: context) else { return nil }
        let counter = Model(entity: entity , insertInto: context)
        counter.id = UUID()
        return counter
    }

    func delete(counter: Model) {
        context.delete(counter)
        saveContext()
    }
}
