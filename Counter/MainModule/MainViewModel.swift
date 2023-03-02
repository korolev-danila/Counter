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
            countSubj.onNext("\(count)")
        }
    }
    
    var isPlusSubj = PublishSubject<Bool>()
    private var isPlus = true {
        didSet {
            isPlusSubj.onNext(isPlus)
        }
    }
        
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
        isPlus = model.isPlus
    }
    
    func viewWillDisappear() {
        model.count = Int64(count)
        model.isPlus = isPlus
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
