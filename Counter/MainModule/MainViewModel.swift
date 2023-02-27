//
//  MainViewModel.swift
//  Counter
//
//  Created by Данила on 17.02.2023.
//

import RxSwift

final class MainViewModel {
    
    private let cdManager: CoreDataProtocol
    private var model: Model
    
    var countSubj = BehaviorSubject<String>(value: "")
    var isPlus = true
    var count = 0 {
        didSet {
            countSubj.onNext("\(count)")
        }
    }
    
    init(cdManager: CoreDataProtocol, model: Model) {
        self.cdManager = cdManager
        self.model = model
    }
    
    deinit {
        model.count = Int64(count)
        cdManager.saveContext()
        print("deinit \(self.self)" )
    }
    
    func viewDidLoad() {
        count = Int(model.count)
        print(count)
    }
    
    func updateCount() {
        if isPlus {
            count += 1
        } else {
            count -= 1
        }
    }
    
    func changePlus() -> Bool {
        isPlus = !isPlus
        return isPlus
    }
    
    func zeroingCount() {
        count = 0
    }
    
}
