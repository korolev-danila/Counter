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

final class AddScreenViewModel {
    
    private let coreData: CoreDataProtocol
    
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
        dissmisAddScreen(model)
    }
}
