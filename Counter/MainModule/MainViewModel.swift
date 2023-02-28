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
    
    var countSubj = BehaviorSubject<String>(value: "")
    var isPlus = true
    var count = 0 {
        didSet {
            countSubj.onNext("\(count)")
        }
    }
    
    var deinitCounter: (Model) -> () = { _ in }
    
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
    }
    
    func viewWillDisappear() {
        print("viewWillDisappear")
        model.count = Int64(count)
        deinitCounter(model)
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
