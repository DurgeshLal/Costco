//
//  CostcoDashboardViewModel.swift
//  
//
//  Created by Durgesh Lal on 2/3/23.
//

import Foundation

struct CostcoDashboardViewModel {
    
    lazy var title: String = {
       "Costco"
    }()
    
    lazy var homePageUrl: URL = {
        if let url = URL(string: "https://www.costco.com/") {
            return url
        }
        fatalError("Unable to convert string into url")
    }()
}
