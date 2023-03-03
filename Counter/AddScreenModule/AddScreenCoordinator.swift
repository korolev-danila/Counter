//
//  AddScreenCoordinator.swift
//  Counter
//
//  Created by Данила on 03.03.2023.
//

import UIKit

final class AddScreenCoordinator {

    private let rootViewController: UINavigationController
    private let coreData: CoreDataProtocol
    
    var dissmisAddScreen: (Model?) -> () = { _ in }
        
    init(rootViewController: UINavigationController, cdManager: CoreDataProtocol) {
        self.rootViewController = rootViewController
        self.coreData = cdManager
    }
    
    deinit {
        print("deinit \(self.self)" )
    }
}

extension AddScreenCoordinator: CoordinatorProtocol {
    func start() {
        let addScreenVM = AddScreenViewModel(cdManager: coreData)
        addScreenVM.dissmisAddScreen = { [weak self] model in
            guard let self = self else { return }
            self.dissmisAddScreen(model)
        }
        
        let addScreenVC = AddScreenViewController(viewModel: addScreenVM)
        rootViewController.showDetailViewController(addScreenVC, sender: nil)
    }
}
