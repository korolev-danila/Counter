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
    private var modelsArray: [Model] = []
    
    // MARK: - init
    init(cdManager: CoreDataProtocol) {
        self.cdManager = cdManager
        fetchModels()
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
    
    private func updateSections() {
        let sectionDatas = CounterSection(items: modelsArray)
        sections.accept([sectionDatas])
    }
    
    private func updateIndex(start: Int, end: Int) {
        var _start = start
        var _end = end
        
        if end < start { _start = end; _end = start }
        if _end > modelsArray.count - 1 { _end = modelsArray.count - 1 }
        
        for i in _start..._end {
            guard let item = modelsArray[safe: i] else { return }
            item.index = Int16(i)
        }
        cdManager.saveContext()
        printAll(modelsArray)
    }
    
    private func printAll(_ arr: [Model]) {
        var str = "@ array: "
        for item in arr {
            str += "\(item.count) / \(item.index) -- "
        }
        str.removeLast(4)
        print(str)
    }
    
    // MARK: -
    func fetchModels() {
        let mod = cdManager.fetchMyCounters()
        modelsArray = mod.sorted { $0.index < $1.index }
        updateSections()
        printAll(modelsArray)
    }
    
    func deleteAll() {
        cdManager.resetAllRecords()
    }
    
    func addCounter(model: Model) {
        model.index = Int16(modelsArray.count)
        modelsArray.append(model)
        updateSections()
        cdManager.saveContext()
    }
    
    func deleteItem(at indexPath: IndexPath) {
        guard let model = modelsArray[safe: indexPath.row] else { return }
        
        modelsArray.remove(at: indexPath.row)
        updateSections()
        cdManager.delete(counter: model)
        updateIndex(start: indexPath.row, end: modelsArray.count - 1)
    }
    
    func itemMoved(at indexPaths: ControlEvent<ItemMovedEvent>.Element) {
        let item = modelsArray.remove(at: indexPaths.sourceIndex.row)
        modelsArray.insert(item, at: indexPaths.destinationIndex.row)
        updateIndex(start: indexPaths.sourceIndex.row, end: indexPaths.destinationIndex.row)
    }
}
