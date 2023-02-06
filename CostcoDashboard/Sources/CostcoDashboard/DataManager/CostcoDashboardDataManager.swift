//
//  CostcoDashboardDataManager.swift
//  
//
//  Created by Durgesh Lal on 2/3/23.
//

import Foundation
import CostcoApis

protocol CostcoDashboardDataManaging {
    func fetchRoadCondition(_ url: String, params: [String : String]) async throws -> CostcoDashboard
}

struct CostcoDashboardDataManager: CostcoDashboardDataManaging {
    
    private let network: NetworkManaging
    
    init(network: NetworkManaging) {
        self.network = network
    }
    
    func fetchRoadCondition(_ url: String, params: [String : String]) async throws -> CostcoDashboard {
        try await network.request(url: url, params: params)
    }
}
