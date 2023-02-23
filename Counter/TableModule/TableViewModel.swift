//
//  TableViewModel.swift
//  Counter
//
//  Created by Данила on 21.02.2023.
//

import Foundation

final class TableViewModel {
    
    private let cdManager: CoreDataProtocol
    var models: [Model] = []
    
    init(cdManager: CoreDataProtocol) {
        self.cdManager = cdManager
    }
    
    func fetchModels() {
        models = cdManager.fetchMyCounters()
    }
    
    func createModel() -> Model? {
        guard let model = cdManager.createNew() else { return nil }
        models.append(model)
        cdManager.saveContext()
        return model
    }
    
    func transferModel() -> Model? {
        if models.count == 0 {
            return createModel()
        } else {
            guard let model = models[safe: 0] else { return nil }
            return model
        }
    }
}
