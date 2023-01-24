//
//  OperationRemoteStorage.swift
//  
//
//  Created by eldin smakic on 24/01/2023.
//

import Foundation

public class OperationRemoteStorage: RemoteStorageProtocolAsync {
    public static var shared = OperationRemoteStorage()

    var values: [OperationDTO] = []

    public func add(_ value: CarManagementCore.OperationDTO) async throws -> CarManagementCore.OperationDTO {
        return value
    }

    public func update(_ value: CarManagementCore.OperationDTO) async throws -> CarManagementCore.OperationDTO {
        return value
    }
    
    public func remove(_ value: CarManagementCore.OperationDTO) async throws -> CarManagementCore.OperationDTO {
        return value
    }
    
    public func fetch() async throws -> [CarManagementCore.OperationDTO] {
        return values
    }
    
    public func erase() async throws {
    }
}
