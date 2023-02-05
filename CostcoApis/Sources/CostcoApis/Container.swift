//
//  Container.swift
//  
//
//  Created by Durgesh Lal on 2/3/23.
//

import Foundation

public final class Container: ServiceResolving {
    
    private class Weak<Wrapped> {
        private weak var object: AnyObject?
        init(value: Wrapped) {
            self.value = value
        }
        
        var value: Wrapped? {
            get {
                guard let object = object else { return nil }
                return object as? Wrapped
            }
            set { object = newValue as AnyObject}
        }
    }
    
    private struct Service {
        var scope: ServiceScope = .weak
        var factory: ServiceFactory<Any>
    }
    
    private let parent: Resolving?
    
    private var registeredServices : [ObjectIdentifier : Service] = [:]
    
    private var resolvedServices : [ObjectIdentifier : Any] = [:]
    
    private var resolvedWeakServices : [ObjectIdentifier : Weak<Any>] = [:]
    
    public init(parent: Resolving? = nil) {
        self.parent = parent
    }
    
    
    public func register<T>(scope: ServiceScope, _ factory: @escaping ServiceFactory<T>) {
        self.register(T.self, scope: scope, using: factory)
    }
    
    
    public func register<T>(_ type: T.Type, scope: ServiceScope, using factory: @escaping ServiceFactory<T>) {
        let identifier = ObjectIdentifier(T.self)
        let service = Service(scope: scope, factory: factory)
        self.registeredServices[identifier] = service
    }
    
    public func createChild() -> ServiceResolving {
        return Container(parent: self)
    }
    
    public func unregister<T>(_ type: T.Type) {
        let identifier = ObjectIdentifier(T.self)
        self.resolvedServices.removeValue(forKey: identifier)
        self.registeredServices.removeValue(forKey: identifier)
        self.resolvedWeakServices.removeValue(forKey: identifier)
    }
    
    public func unregisterAll() {
        self.resolvedServices.removeAll()
        self.registeredServices.removeAll()
        self.resolvedWeakServices.removeAll()
    }
    
    public func resolve<T>() -> T {
        let identifier = ObjectIdentifier(T.self)
        
        if !self.isRegistered(T.self) {
            fatalError("Unable to resolve \(T.self). Ensure you have registered this service")
        }
        
        guard let resolved = self.resolvedServices[identifier] as? T else {
            guard let weakResolved = self.resolvedWeakServices[identifier], let resolved = weakResolved.value as? T else {
                self.resolvedWeakServices.removeValue(forKey: identifier)
                guard let service = self.registeredServices[identifier], let resolved = service.factory(self) as? T else {
                    guard let resolved = self.parent?.resolve(T.self) else {
                        fatalError("Unable to resolve \(T.self). Ensure you have registered this service")
                    }
                    return resolved
                }
                if service.scope == .container {
                    self.resolvedServices[identifier] = resolved
                } else if service.scope == .weak {
                    self.resolvedWeakServices[identifier] = Weak(value: resolved)
                }
                return resolved
            }
            return resolved
        }
        return resolved
    }
    
    public func isRegistered<T>(_ type: T.Type) -> Bool {
        let identifier = ObjectIdentifier(T.self)
        if self.registeredServices.keys.contains(identifier) {
            return true
        }
        return parent?.isRegistered(type) ?? false
    }
}


