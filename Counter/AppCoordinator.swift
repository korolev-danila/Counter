//
//  AppCoordinator.swift
//  Counter
//
//  Created by Данила on 23.02.2023.
//

import UIKit

final class ApplicationCoordinator {
    
    let window: UIWindow
    private var childCoordinator = [CoordinatorProtocol]()
    
    init(window: UIWindow) {
        self.window = window
    }
}

extension ApplicationCoordinator: CoordinatorProtocol {
    func start() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let cdManager = CoreDataManager(context: context)
        let tableCoordinator = TableCoordinator(cdManager: cdManager)
        
        tableCoordinator.start()
        childCoordinator = [tableCoordinator]
        window.rootViewController = tableCoordinator.rootViewController
    }
}
