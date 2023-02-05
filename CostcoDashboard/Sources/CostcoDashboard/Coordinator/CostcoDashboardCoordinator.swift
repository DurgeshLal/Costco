//
//  CostcoDashboardCoordinator.swift
//  
//
//  Created by Durgesh Lal on 2/3/23.
//

import Foundation
import UIKit
import CostcoApis

final public class CostcoDashboardCoordinator: Coordinator {
    public var children: [Coordinator] = []
    public var navigationController: UINavigationController
    private var networkManager: NetworkManaging
    
    public required init(_ navigationController: UINavigationController, container: ServiceResolving) {
        self.navigationController = navigationController
        self.networkManager = container.resolve()
    }
    
    public func start() {
        let storyboard = UIStoryboard(name: "CostcoDashboardViewController", bundle:  Bundle.module)
        let controller = storyboard.instantiateViewController(
            identifier: "CostcoDashboardViewController",
            creator: { [weak self] coder in
                guard let self = self else { return UIViewController() }
//                let dataManager = AlbertsonsDashboardDataManager(networkManager: self.networkManager)
                let viewModel = CostcoDashboardViewModel()
                return CostcoDashboardViewController(viewModel, coder: coder)
            }
        )
        navigationController.pushViewController(controller, animated: false)
    }
}
