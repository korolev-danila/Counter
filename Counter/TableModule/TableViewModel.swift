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
}
