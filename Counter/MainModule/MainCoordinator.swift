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
    private var model: Model
    private var isFirstShow: Bool
    
    init(rootViewController: UINavigationController, cdManager: CoreDataProtocol, model: Model, isFirstShow: Bool ) {
        self.rootViewController = rootViewController
        self.cdManager = cdManager
        self.model = model
        self.isFirstShow = isFirstShow
    }
    
    deinit {
        print("deinit \(self.self)" )
    }
}

extension MainCoordinator: CoordinatorProtocol {
    func start() {
        let mainVM = MainViewModel(cdManager: cdManager, model: model)
        let mainVC = MainViewController(viewModel: mainVM)
        rootViewController.pushViewController(mainVC, animated: !isFirstShow)
    }
}
