//
//  MainViewModel.swift
//  Counter
//
//  Created by Данила on 17.02.2023.
//

import RxSwift

final class MainViewModel {
    
    var countSubj = PublishSubject<String>()
    var count = 0
    
    func update() {
        count += 1
        countSubj.onNext("\(count)")
    }
}
