//
//  VoitureLocalStorageAsync.swift
//  
//
//  Created by eldin smakic on 10/10/2022.
//

import Foundation
import Defaults

@available(*, deprecated, message: "Upgrade version but need real storage")
public class VoitureLocalStorageAsync: LocalStorageProtocolAsync {
   
    public static var shared = VoitureLocalStorageAsync()

    private var list: [CarDTO] {
        get { Defaults[.voitures] }
        set { Defaults[.voitures] = newValue }
    }
    
    private init() {}

    public func add(_ value: CarManagementCore.CarDTO) async throws -> CarManagementCore.CarDTO {
        list.append(value)
        return value
    }
    
    public func update(_ value: CarManagementCore.CarDTO) async throws -> CarManagementCore.CarDTO {
        return value
    }

    public func get(byId id: UUID) async throws -> CarDTO {
        guard let value = list.first(where: { $0.id == id }) else {
            throw NSError(domain: "2", code: 2)
        }

        return value
    }
    
    
    public func remove(_ value: CarManagementCore.CarDTO) async throws -> CarManagementCore.CarDTO {
        list.removeAll { voiture in
            voiture == value
        }
        return value
    }
    
    public func fetch() async throws -> [CarManagementCore.CarDTO] {
        return list
    }
    
    public func erase() async throws {
        list = []
    }
}

public class VoitureRepositoryAsync: RepositoryGenericAsync<VoitureLocalStorageAsync,VoitureRemoteStorageAsync, CarDTO> {}
