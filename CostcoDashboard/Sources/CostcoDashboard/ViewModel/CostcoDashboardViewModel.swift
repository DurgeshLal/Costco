//
//  CostcoDashboardViewModel.swift
//  
//
//  Created by Durgesh Lal on 2/3/23.
//

import Foundation

class CostcoDashboardViewModel: ObservableObject {
    struct URLs {
        static let home = "https://www.costco.com/"
        static let passes = "Traffic/api/MountainPassConditions/MountainPassConditionsREST.svc/GetMountainPassConditionsAsJson"
    }
    
    struct Constants {
        static let accountPagId = "AccountHomeView"
    }
    
    enum State {
        case loading
        case ready
        case error(_ messgae: String)
    }
    
    private var dataSource: [MountainPass] = []
    private let dataManager: CostcoDashboardDataManaging
    private let coordinator: CostcoDashboardCoordinator?
    private var fetchRoadConditionParameters: [String : String] {
        ["AccessCode" : "73575df4-61c1-4f2b-9aed-3139f91a512d"]
    }
    
    @Published var viewState: State = .loading
    
    required init(dataManager: CostcoDashboardDataManaging, coordinator: CostcoDashboardCoordinator?) {
        self.dataManager = dataManager
        self.coordinator = coordinator
    }
    
    lazy var title: String = {
       "Costco"
    }()
    
    lazy var homePageUrl: URL = {
        if let url = URL(string: URLs.home) {
            return url
        }
        fatalError("Unable to convert string into url")
    }()
    
    lazy var script: String = { """
        var buttons = document.getElementsByClassName("MuiButtonBase-root MuiButton-root MuiButton-text-button MuiButton-text-buttonPrimary MuiButton-sizeMedium MuiButton-text-buttonSizeMedium MuiButton-root MuiButton-text-button MuiButton-text-buttonPrimary MuiButton-sizeMedium MuiButton-text-buttonSizeMedium css-4bcnsk");
        for (var i = 0; i < buttons.length; i++) {
            buttons[i].addEventListener("click", function() {
            webkit.messageHandlers.buttonClicked.postMessage("Button was clicked");
            });
        }
        """
    }()
    
    func shouldCallAccountPage(_ pageName: String?) -> Bool {
        guard let name = pageName else { return false }
        return name == Constants.accountPagId
    }
    
}

extension CostcoDashboardViewModel {
    
    func didSelectWarehouses() {
        if let item = dataSource.first(where: { $0.mountainPassName == "Snoqualmie Pass I-90" }) {
            coordinator?.didSelectWith(item)
        }
    }
    
    func didSelectAccount() {
        if let item = dataSource.first(where: { $0.mountainPassName == "Stevens Pass US 2" }) {
            coordinator?.didSelectWith(item)
        }
    }
}

extension CostcoDashboardViewModel {
    
    func fetchRoadCondition() async throws  {
        viewState = .loading
        let model = try await dataManager.fetchRoadCondition(URLs.passes, params: fetchRoadConditionParameters)
        if let passess = model.passes {
            dataSource = passess
        }
        viewState = .ready
    }
}
