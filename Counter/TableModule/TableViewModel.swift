//
//  TableViewModel.swift
//  Counter
//
//  Created by Данила on 21.02.2023.
//

import RxSwift

final class TableViewModel {
    
    private let cdManager: CoreDataProtocol
    
    var models = PublishSubject<[Model]>()
    private var modelsArray: [Model] = [] {
        didSet {
            models.onNext(modelsArray)
        }
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - init
    init(cdManager: CoreDataProtocol) {
        self.cdManager = cdManager
    }
    
    // MARK: - Private method
    private func createModel() -> Model? {
        guard let model = cdManager.createNew() else { return nil }
        modelsArray.append(model)
        cdManager.saveContext()
        return model
    }
    
    func fetchModels() {
        modelsArray = cdManager.fetchMyCounters()
    }
    
    func transferModel() -> Model? {
        if modelsArray.count == 0 {
            return createModel()
        } else {
            guard let model = modelsArray[safe: 0] else { return nil }
            return model
        }
    }
    
    func addCounter() {
        guard let model = cdManager.createNew() else { return }
        cdManager.saveContext()
        modelsArray.append(model)
    }
}
