//
//  NetworkManager.swift
//  
//
//  Created by Durgesh Lal on 2/3/23.
//

import Foundation
import CostcoApis
import Combine

class NetworkManager: NetworkManaging {
    
    private let environment: EnvironmentManaging
    private let cache: Caching
    public required init(_ environment: EnvironmentManaging, cache: Caching) {
        self.cache = cache
        self.environment = environment
    }

    // Asyn Await comatible api
    func request<T: Decodable>(url: String, params: RequestParameters?) async throws -> T {
        
        let model: T = try await withCheckedThrowingContinuation( { continuation in
            
            @Sendable func decode(data: Data) {
                guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                    continuation.resume(throwing: Failure.parsingError)
                    return
                }
                print("Response from asyn await \(decodedResponse)")
                continuation.resume(returning: decodedResponse)
            }
            
            var urlComponents = URLComponents(string: environment.baseUrl + url)
            if let _params = params {
                urlComponents?.queryItems = _params.map {
                     URLQueryItem(name: $0, value: $1)
                }
            }
            
            guard let url = urlComponents?.url else {
                continuation.resume(throwing: Failure.badUrl)
                return
            }
            if let cachedData = cache.object(forKey: url as AnyObject) as? Data {
                decode(data: cachedData)
                return
            }
            
            let request = URLRequest(url: url)
            
            Task {
                do {
                    let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
                    guard let response = response as? HTTPURLResponse else {
                        continuation.resume(throwing: Failure.badResponse("error?.localizedDescription"))
                        return
                    }
                    switch response.statusCode {
                    case 200...299:
                        if cache.enable {
                            cache.setObject(data as AnyObject, forKey: url as AnyObject)
                        }
                        decode(data: data)
                    case 401:
                        continuation.resume(throwing: Failure.badResponse("error?.localizedDescription"))
                    default:
                        continuation.resume(throwing: Failure.badResponse("error?.localizedDescription"))
                    }
                } catch {
                    continuation.resume(throwing: Failure.badResponse("error?.localizedDescription"))
                }
            }
        })
        return model
    }
}

/// Unused network apis, not using for now, just for demonstration to have these options
extension NetworkManager {
    
    func request<T: Decodable>(url: String, params: RequestParameters?, callBack: @escaping (Result<T, Failure>) -> Void) {
        let defaultSession = URLSession(configuration: .default)
        var urlComponents = URLComponents(string: environment.baseUrl + url)
        if let _params = params {
            urlComponents?.queryItems = _params.map {
                 URLQueryItem(name: $0, value: $1)
            }
        }
        
        guard let url = urlComponents?.url  else {
            DispatchQueue.main.async {
                callBack(.failure(.badUrl))
            }
            return
        }
        
        let request = URLRequest(url: url)
        
        defaultSession.dataTask(with: request) { data, response, error in
            guard let unWrapedData = data else {
                DispatchQueue.main.async {
                    callBack(.failure(.badResponse(error?.localizedDescription)))
                }
                return
            }
            let decoder = JSONDecoder()
            if let model = try? decoder.decode(T.self, from: unWrapedData) {
                DispatchQueue.main.async {
                    callBack(.success(model))
                }
            } else {
                DispatchQueue.main.async {
                    callBack(.failure(.parsingError))
                }
            }
        }.resume()
    }
    
    // Combine specific api
    func request<T: Decodable>(url: String, params: RequestParameters?) -> AnyPublisher<T, Failure> {
        let defaultSession = URLSession(configuration: .default)
        var urlComponents = URLComponents(string: environment.baseUrl + url)
        if let _params = params {
            urlComponents?.queryItems = _params.map {
                 URLQueryItem(name: $0, value: $1)
            }
        }
        
        guard let url = urlComponents?.url else {
            return Fail(error: Failure.badUrl).eraseToAnyPublisher()
        }
        let urlRequest = URLRequest(url: url)

        return defaultSession.dataTaskPublisher(for: urlRequest)
          .tryMap { response in
            guard let httpURLResponse = response.response as? HTTPURLResponse,
              httpURLResponse.statusCode == 200 else {
                throw Failure.statusCode
            }
            
            print("response \(httpURLResponse) data \(response.data), description : \(response)")
            return response.data
          }
          .decode(type: T.self, decoder: JSONDecoder())
          .mapError { Failure.map($0) }
          .eraseToAnyPublisher()
    }
    
    func request(url: String, callBack: @escaping (Result<Data, Failure>) -> Void) {
        let defaultSession = URLSession(configuration: .default)
        let urlComponents = URLComponents(string: url)
        
        guard let url = urlComponents?.url  else {
            DispatchQueue.main.async {
                callBack(.failure(.badUrl))
            }
            return
        }
        
        let request = URLRequest(url: url)
        
        defaultSession.dataTask(with: request) { data, response, error in
            guard let unWrapedData = data else {
                DispatchQueue.main.async {
                    callBack(.failure(.badResponse(error?.localizedDescription)))
                }
                return
            }
            DispatchQueue.main.async {
                callBack(.success(unWrapedData))
            }
        }.resume()
    }
   
}
