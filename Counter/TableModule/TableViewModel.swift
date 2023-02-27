//
//  TableViewModel.swift
//  Counter
//
//  Created by Данила on 21.02.2023.
//

import RxCocoa
import RxSwift

final class TableViewModel {
    
    private let cdManager: CoreDataProtocol
    
    var sections = BehaviorRelay<[CounterSection]>(value: [])
  //  let sectionDatas = [CustomSectionDataType(ID: "1", header: "test", items: ["WTF!"])]
 //   let items = BehaviorRelay(value: [sectionDatas])


    var models = PublishSubject<[Model]>()
    var modelsArray: [Model] = [] {
        didSet {
            models.onNext(modelsArray)
            let sectionDatas = CounterSection(items: modelsArray)
            sections.accept([sectionDatas])
        }
    }
        
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
    
    func deleteAll() {
        cdManager.resetAllRecords()
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
