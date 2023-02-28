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
    
    var sections = PublishRelay<[CounterSection]>() //BehaviorRelay

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
    
    deinit {
        cdManager.saveContext()
        print("deinit \(self.self)" )
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
        let mod = cdManager.fetchMyCounters()
        modelsArray = mod
        let sectionDatas = CounterSection(items: mod)
        sections.accept([sectionDatas])
        print("%%%%%%%%%")
//        for item in modelsArray {
//            print(item.count)
//        }
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
    
    func updateModel(_ model: Model, at indexPath: IndexPath?) {
        print("updateModel " + "\(model.count)" + " at \(String(describing: indexPath))")

    }
    
    func deleteItem(at indexPath: IndexPath) {
        guard let model = modelsArray[safe: indexPath.row] else { return }
        
        modelsArray.remove(at: indexPath.row)
        cdManager.delete(counter: model)
    }
    
    func itemMoved(at indexPaths: ControlEvent<ItemMovedEvent>.Element) {
        for item in modelsArray {
            print(item.count)
        }
        let item = modelsArray.remove(at: indexPaths.sourceIndex.row)
        modelsArray.insert(item, at: indexPaths.destinationIndex.row)

   //     self.sections.accept([ColorSection(items: self.colors)])
    }
}
