//
//  ServiceResolving.swift
//  
//
//  Created by Durgesh Lal on 2/3/23.
//

import Foundation
/// This is refered from one of my previous Demo project I did.
///  Originally it was refered from different blogs including
///  https://betterprogramming.pub/modern-dependency-injection-in-swift-952286b308be
///  https://www.raywenderlich.com/22203552-resolver-for-ios-dependency-injection-getting-started
///
public protocol Resolving: AnyObject {
    ///Resolve the service to a component. This function operates on the type pf the service upon which it is called
    func resolve<T>() -> T
    
    /// Resolves the service to a component. This function opertaes on the type of service passed in.
    func resolve<T>(_ type: T.Type) -> T
    
    /// Check if the serivce is registered in any container
    func isRegistered<T>(_ type: T.Type) -> Bool
}

public enum ServiceScope {
    case weak /// Keeps the instance as long it has reference retained or the container exists
    case transient /// New instance is returned every time
    case container /// Keeps the instance as long as container exists
}

public typealias ServiceFactory<T> = (Resolving) -> T

public protocol ServiceResolving: Resolving {
    /// Creates new child container
    func createChild() -> ServiceResolving
    
    /// Function to register a service for use based on the type on which it is called
    func register<T>(scope: ServiceScope, _ : @escaping ServiceFactory<T>)
    
    func register<T>(_ type: T.Type, scope: ServiceScope, using: @escaping ServiceFactory<T>)
    
    func unregister<T>(_ type: T.Type)
    
    func unregisterAll()
}

public extension ServiceResolving {
    func register<T>(_ factory: @escaping ServiceFactory<T>) {
        self.register(scope: .weak, factory)
    }
    
    func register<T>(_ type: T.Type, using factory: @escaping ServiceFactory<T>) {
        self.register(type, scope: .weak, using: factory)
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        self.resolve()
    }
}
