//
//  AddScreenViewModel.swift
//  Counter
//
//  Created by Данила on 03.03.2023.
//

import RxSwift

protocol AddScreenViewModelProtocol {
    func addCounter()
}

struct LocalModel {
    var name: String
    var count: Int
    var value: Int
    var type: CounterType
}

final class AddScreenViewModel {
    
    private let coreData: CoreDataProtocol
    
    var localModel = LocalModel(name: "", count: 0, value: 1, type: .classic)
    var nameSubj = BehaviorSubject<String>(value: "")
    var countSubj = BehaviorSubject<String>(value: "0")
    
    var dissmisAddScreen: (Model?) -> () = { _ in }
    
    init(cdManager: CoreDataProtocol) {
        self.coreData = cdManager
    }
    
    deinit {
        dissmisAddScreen(nil)
        print("deinit \(self.self)" )
    }
    
    func addCounter() {
        guard let model = coreData.createNew() else { return }
        model.name = localModel.name
        model.count = Int64(localModel.count)
        model.value = Int16(localModel.value)
        model.counterType = localModel.type
        dissmisAddScreen(model)
    }
}
