//
//  TableCellViewModel.swift
//  Counter
//
//  Created by Данила on 27.02.2023.
//

import RxCocoa
import RxSwift

class TableCellViewModel {
    
    var count: Driver<String>

    init(withCounter model: Model) {
        count = .just("\(model.count)")
    }
}
