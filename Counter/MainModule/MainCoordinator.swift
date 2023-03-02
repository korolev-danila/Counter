//
//  MainCoordinator.swift
//  Counter
//
//  Created by Данила on 23.02.2023.
//

import UIKit

final class MainCoordinator {
    var rootViewController: UINavigationController
    private var model: Model
    private let coreData: CoreDataProtocol
    private var isFirstShow: Bool
        
    init(rootViewController: UINavigationController, cdManager: CoreDataProtocol, model: Model, isFirstShow: Bool ) {
        self.rootViewController = rootViewController
        self.model = model
        self.coreData = cdManager
        self.isFirstShow = isFirstShow
    }
    
    deinit {
        print("deinit \(self.self)" )
    }
}

extension MainCoordinator: CoordinatorProtocol {
    func start() {
        let mainVM = MainViewModel(model: model, cdManager: coreData)
        let mainVC = MainViewController(viewModel: mainVM)
        rootViewController.pushViewController(mainVC, animated: !isFirstShow)
    }
}
