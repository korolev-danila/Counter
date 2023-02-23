//
//  MainCoordinator.swift
//  Counter
//
//  Created by Данила on 23.02.2023.
//

import UIKit

final class MainCoordinator {
    var rootViewController: UINavigationController
    private let cdManager: CoreDataProtocol
    private var model: Model?
    
    init(rootViewController: UINavigationController, cdManager: CoreDataProtocol, model: Model? = nil) {
        self.rootViewController = rootViewController
        self.cdManager = cdManager
        self.model = model
    }
    
    deinit {
        print("deinit \(self.self)" )
    }
}

extension MainCoordinator: CoordinatorProtocol {
    func start() {

        if let model = model {
            let mainVM = MainViewModel(cdManager: cdManager, model: model)
            let mainVC = MainViewController(viewModel: mainVM)
            rootViewController.pushViewController(mainVC, animated: false)
        } else {
            /// first start application
            guard let newModel = cdManager.createNew() else { return }
            let mainVM = MainViewModel(cdManager: cdManager, model: newModel)
            let mainVC = MainViewController(viewModel: mainVM)
            rootViewController.pushViewController(mainVC, animated: false)
        }
    }
}
