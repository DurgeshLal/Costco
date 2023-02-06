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
    private var temperatureFormatter: TemperatureFormatting
    
    public required init(_ navigationController: UINavigationController, container: ServiceResolving) {
        self.navigationController = navigationController
        self.networkManager = container.resolve()
        self.temperatureFormatter = container.resolve()
    }
    
    public func start() {
        let dataManager = CostcoDashboardDataManager(network: self.networkManager)
        let viewModel = CostcoDashboardViewModel(dataManager: dataManager, coordinator: self)
        let controller =  CostcoDashboardViewController(viewModel)
        navigationController.pushViewController(controller, animated: false)
    }
}

extension CostcoDashboardCoordinator {
    func didSelectWith(_ element: MountainPass) {
        let storyboard = UIStoryboard(name: "MountainPassRoadViewController", bundle:  Bundle.module)
        let controller = storyboard.instantiateViewController(
            identifier: "MountainPassRoadViewController",
            creator: { [weak self] coder in
                guard let self = self else { return UIViewController() }
                let viewModel = MountainPassRoadViewModel(data: element, temperatureFormatter: self.temperatureFormatter)
                return MountainPassRoadViewController(viewModel, coder: coder)
            }
        )
        navigationController.pushViewController(controller, animated: false)
    }
}
