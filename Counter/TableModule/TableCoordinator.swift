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
    
    private var showCounterIndex: IndexPath?
    
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
        childCoordinator = [mainCoordinator]
        
        mainCoordinator.deinitCounter = { [weak self] model in
            guard let self = self else { return }
            self.viewModel.updateModel(model, at: self.showCounterIndex)
            self.childCoordinator = []
        }
    }
}

extension TableCoordinator: CoordinatorProtocol {
    func start() {
        viewModel.fetchModels()
        let lastModel = viewModel.transferModel()
        let tableVC = TableViewController(viewModel: viewModel)
        rootViewController.viewControllers = [tableVC]
        
        tableVC.showCounter = { [weak self] model, indexPath in
            guard let self = self else { return }
            self.showCounterIndex = indexPath
            self.showCounter(model)
        }
        
        //        if let model = lastModel {
        //            showCounter(model)
        //        }
        isFirstShowMain = false
    }
}
