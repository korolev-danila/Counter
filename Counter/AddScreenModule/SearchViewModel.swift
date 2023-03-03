//
//  AddScreenViewModel.swift
//  Counter
//
//  Created by Данила on 03.03.2023.
//

import RxSwift

final class AddScreenViewModel {
    
    private let coreData: CoreDataProtocol
    
    init(cdManager: CoreDataProtocol) {
        self.coreData = cdManager
    }
    
    deinit {
        coreData.saveContext()
        print("deinit \(self.self)" )
    }
}
