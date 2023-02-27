//
//  CountersSectionModel.swift
//  Counter
//
//  Created by Данила on 27.02.2023.
//

import RxDataSources

struct CounterSection {
    var items: [Item]
}

extension CounterSection: AnimatableSectionModelType {
    typealias Item = Model
    typealias Identity = Int
    
    init(original: CounterSection, items: [Item]) {
        self = original
        self.items = items
    }
    
    // Need to provide a unique id, only one section in our model
    var identity: Int {
        return 0
    }
}
