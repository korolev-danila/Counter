//
//  TableCellViewModel.swift
//  Counter
//
//  Created by Данила on 27.02.2023.
//

import RxCocoa
import RxSwift

class TableCellViewModel {
    
    var name: Driver<String>
    var count: Driver<String>

    init(withCounter model: Model) {
        switch model.counterType {
        case .classic:
            name = .just("classic")
        case .minimal:
            name = .just("minimal")
        case .timeCounter:
            name = .just("timeCounter")
        }
        
        count = .just("\(model.count)")
    }
}
