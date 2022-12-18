//
//  Injection.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import Foundation
import Swinject

public class Injection {
    public static let shared = Injection()

    lazy var container: Container = {
        let container = Container()
        
        container.removeAll()
        return container
    }()
    
    public func removeAll() {
        container.removeAll()
    }

    public func register<Service>(_ serviceType: Service.Type, name: String? = nil, factory: @escaping (Resolver) -> Service) {
        container.register(serviceType, name: name, factory: factory).inObjectScope(.container)
        
    }
    
    public func register<Service>(_ serviceType: Service.Type, name: String? = nil, objetScope: ObjectScopeProtocol, factory: @escaping (Resolver) -> Service) {
        container.register(serviceType, name: name, factory: factory).inObjectScope(objetScope)
    }

    private init() {}
}

@propertyWrapper
public struct Injected<Service> {
    private var service: Service!
    var container: Container?
    var name: String?

    private let localContainer = Injection.shared.container

    public init() {}

    public init(name: String? = nil, container: Container? = nil) {
        self.name = name
        self.container = container
    }

    public var wrappedValue: Service {
        mutating get {
            if self.service == nil {
                self.service = container?.resolve(Service.self, name: name) ?? localContainer.resolve(Service.self, name: name)
            }
            return service
        }
        mutating set { service = newValue }
    }

    public var projectedValue: Injected<Service> {
        get { self }
        mutating set { self = newValue }
    }
}
