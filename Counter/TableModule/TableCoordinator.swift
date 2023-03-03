//
//  TableCoordinator.swift
//  Counter
//
//  Created by Данила on 23.02.2023.
//

import UIKit

final class TableCoordinator {
    
    var rootViewController: UINavigationController
    private var childCoordinator = [CoordinatorProtocol]()
    
    private var isFirstShowMain = true
    private let coreData: CoreDataProtocol
    private let viewModel: TableViewModel
    
    
    init(cdManager: CoreDataProtocol) {
        coreData = cdManager
        viewModel = TableViewModel(cdManager: cdManager)
        rootViewController = UINavigationController()
    }
    
    deinit {
        print("deinit \(self.self)" )
    }
    
    private func showCounter(_ model: Model) {
        let mainCoordinator = MainCoordinator(rootViewController: rootViewController, cdManager: coreData,
                                              model: model, isFirstShow: isFirstShowMain)
        mainCoordinator.start()
    }
    
    private func showAddScreen() {
        let addCoordinator = AddScreenCoordinator(rootViewController: rootViewController, cdManager: coreData)
        addCoordinator.start()
        childCoordinator.append(addCoordinator)
        
        addCoordinator.dissmisAddScreen = { [unowned self] model in
            if let model = model {
                viewModel.addCounter(model: model)
            }
            childCoordinator = []
        }
    }
}

extension TableCoordinator: CoordinatorProtocol {
    func start() {
        let tableVC = TableViewController(viewModel: viewModel)
        rootViewController.viewControllers = [tableVC]
        
        tableVC.showCounter = { [weak self] model, indexPath in
            guard let self = self else { return }
            self.showCounter(model)
        }
        
        tableVC.showAdd = { [weak self] in
            guard let self = self else { return }
            self.showAddScreen()
        }
        
        isFirstShowMain = false
    }
}
