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
    
    init(cdManager: CoreDataProtocol) {
        self.cdManager = cdManager
        rootViewController = UINavigationController()
    }
    
    deinit {
        print("deinit \(self.self)" )
    }
}

extension TableCoordinator: CoordinatorProtocol {
    func start() {
        let tableVM = TableViewModel(cdManager: cdManager)
        tableVM.fetchModels()
        let lastModel = tableVM.transferModel()
        let tableVC = TableViewController(viewModel: tableVM)
        rootViewController.viewControllers = [tableVC]
        
        let mainCoordinator = MainCoordinator(rootViewController: rootViewController,
                                              cdManager: cdManager, model: lastModel)
        mainCoordinator.start()
    }
}
