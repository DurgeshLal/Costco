//
//  Environment.swift
//  
//
//  Created by Durgesh Lal on 2/3/23.
//

import Foundation

public protocol EnvironmentManaging {
    typealias RequestHeaders = [String : String]
    var headers: RequestHeaders? { get }
    var baseUrl: String { get }
}

enum EnumEnvironment: EnvironmentManaging {
    case development
    case prod
    
    var headers: RequestHeaders? { nil }
    
    var baseUrl: String {
        switch self {
        case .development:
            return "https://meowfacts.herokuapp.com/"
        case .prod:
            return "https://meowfacts.herokuapp.com/"
        }
    }
}

