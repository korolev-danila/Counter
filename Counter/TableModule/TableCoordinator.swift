//
//  TableCoordinator.swift
//  Counter
//
//  Created by Данила on 23.02.2023.
//

import UIKit

final class TableCoordinator {
    var rootViewController: UINavigationController
    private let cdManager: CoreDataProtocol
    private var isFirstShowMain = true
    
    init(cdManager: CoreDataProtocol) {
        self.cdManager = cdManager
        rootViewController = UINavigationController()
    }
    
    deinit {
        print("deinit \(self.self)" )
    }
    
    private func showCounter(_ model: Model) {
        let mainCoordinator = MainCoordinator(rootViewController: rootViewController,
                                              cdManager: cdManager, model: model, isFirstShow: isFirstShowMain)
        mainCoordinator.start()
    }
}

extension TableCoordinator: CoordinatorProtocol {
    func start() {
        let tableVM = TableViewModel(cdManager: cdManager)
    //    tableVM.deleteAll()
        tableVM.fetchModels()
        let lastModel = tableVM.transferModel()
        let tableVC = TableViewController(viewModel: tableVM)
        rootViewController.viewControllers = [tableVC]
        
        tableVC.showCounter = { [weak self] model in
            guard let self = self else { return }
            self.showCounter(model)
        }
        
//        if let model = lastModel {
//            showCounter(model)
//        }
        isFirstShowMain = false
    }
}
