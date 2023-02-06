//
//  CostcoApis.swift
//
//
//  Created by Durgesh Lal on 2/3/23.
//

import Foundation
import UIKit
import Combine

public enum Failure: Error {
    case badUrl, parsingError, statusCode, decoding
    case badResponse(_ errorDescription: String?)
    case other(Error)
    
    public static func map(_ error: Error) -> Failure {
      return (error as? Failure) ?? .other(error)
    }
}

public protocol NetworkManaging {
    typealias RequestParameters = [String : String]
    func request<T: Decodable>(url: String, params: RequestParameters?, callBack: @escaping (Result<T, Failure>) -> Void)
    func request<T: Decodable>(url: String, params: RequestParameters?) async throws -> T
    func request<T: Decodable>(url: String, params: RequestParameters?) -> AnyPublisher<T, Failure>
    func request(url: String, callBack: @escaping (Result<Data, Failure>) -> Void)
}

public extension NetworkManaging {
    func request<T: Decodable>(url: String, callBack: @escaping (Result<T, Failure>) -> Void) {
        self.request(url: url, params: nil, callBack: callBack)
    }
}



public protocol TemperatureFormatting {
    func formatFahrenheit(temperature: Int?) -> String?
}


public protocol Caching {
    var enable: Bool { get }
    func object(forKey key: AnyObject) -> AnyObject?
    func setObject(_ obj: AnyObject, forKey key: AnyObject)
}

public extension Caching {
    var enable: Bool {
        true
    }
}
