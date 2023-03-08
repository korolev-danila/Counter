//
//  MainViewModel.swift
//  Counter
//
//  Created by Данила on 17.02.2023.
//

import RxSwift

final class MainViewModel {
    
    private var model: Model
    private let coreData: CoreDataProtocol
    
    var countSubj = PublishSubject<String>()
    private var count = 0 {
        didSet {
            model.count = Int64(count)
            countSubj.onNext("\(count)")
        }
    }
    
    var isPlusSubj = PublishSubject<Bool>()
        
    init(model: Model, cdManager: CoreDataProtocol) {
        self.model = model
        self.coreData = cdManager
    }
    
    deinit {
        coreData.saveContext()
        print("deinit \(self.self)" )
    }
        
    func viewDidLoad() {
        count = Int(model.count)
        isPlusSubj.onNext(model.isPlus)
    }
    
    func updateCount() {
        if model.isPlus {
            count += Int(model.value)
        } else {
            count -= Int(model.value)
        }
    }
    
    func changePlus() {
        model.isPlus = !model.isPlus
        isPlusSubj.onNext(model.isPlus)
    }
    
    func zeroingCount() {
        count = 0
    }
}
