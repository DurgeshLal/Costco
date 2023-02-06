//
//  MockCostcoDashboardDataManager.swift
//  
//
//  Created by Durgesh Lal on 2/6/23.
//

import Foundation
import CostcoApis
import Combine

@testable import CostcoDashboard

struct MockCostcoDashboardDataManager: CostcoDashboardDataManaging {
    
    
    private let networkManager: NetworkManaging
    
    init(_ networkManger: NetworkManaging) {
        self.networkManager = networkManger
    }
    
    func fetchRoadCondition(_ url: String, params: [String : String]) async throws -> CostcoDashboard {
        return try await networkManager.request(url: "Dashboard", params: nil)
    }
}

