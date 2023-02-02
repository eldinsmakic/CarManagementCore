//
//  OperationLocalStorageAsync.swift
//  
//
//  Created by eldin smakic on 19/10/2022.
//
//

import Foundation
import Defaults
import Combine

public class OperationLocalStorageAsync: LocalStorageProtocolAsync {
    public static var shared = OperationLocalStorageAsync()

    private var list: [OperationDTO] {
        get { Defaults[.operations] }
        set { Defaults[.operations] = newValue }
    }
    
    private init() {}

    public func add(_ value: CarManagementCore.OperationDTO) async throws -> CarManagementCore.OperationDTO {
        list.append(value)
        return value
    }
    
    public func update(_ value: CarManagementCore.OperationDTO) async throws -> CarManagementCore.OperationDTO {
        return value
    }

    public func get(byId id: UUID) async throws -> OperationDTO {
        let value = list.first { operation in
            operation.id == id
        }
        
        if value != nil {
            return value!
        }
        
        throw NSError(domain: "err", code: 1)
    }

    public func remove(_ value: CarManagementCore.OperationDTO) async throws -> CarManagementCore.OperationDTO {
        list.removeAll { operation in
            operation == value
        }
        return value
    }
    
    public func fetch() async throws -> [CarManagementCore.OperationDTO] {
        return list
    }
    
    public func erase() async throws {
        list = []
    }
}

extension Defaults.Keys {
    static let operations = Key<[OperationDTO]>("operations", default: [])
}

extension OperationDTO: DefaultsSerializable {
    public static let bridge = MyBridge<Self>()
}
