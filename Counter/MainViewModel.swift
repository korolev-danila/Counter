//
//  MainViewModel.swift
//  Counter
//
//  Created by Данила on 17.02.2023.
//

import RxSwift

final class MainViewModel {
    
    var countSubj = PublishSubject<String>()
    var isPlus = true
    var count = 0 {
        didSet {
            countSubj.onNext("\(count)")
        }
    }
    
    func updateCount() {
        if isPlus {
            count += 1
        } else {
            count -= 1
        }
    }
    
    func changePlus() {
        isPlus = !isPlus
    }
    
    func zeroingCount() {
        count = 0
    }
    
}
