//
//  File.swift
//  
//
//  Created by eldin smakic on 03/11/2022.
//

import Foundation


public class VoitureRemoteStorageAsync: RemoteStorageProtocolAsync {
    
    public static var shared = VoitureRemoteStorageAsync()

    var values: [CarDTO] = []

    public func add(_ value: CarManagementCore.CarDTO) async throws -> CarManagementCore.CarDTO {
        return value
    }

    public func update(_ value: CarManagementCore.CarDTO) async throws -> CarManagementCore.CarDTO {
        return value
    }
    
    public func remove(_ value: CarManagementCore.CarDTO) async throws -> CarManagementCore.CarDTO {
        return value
    }
    
    public func fetch() async throws -> [CarManagementCore.CarDTO] {
        return values
    }
    
    public func erase() async throws {
    }
}
