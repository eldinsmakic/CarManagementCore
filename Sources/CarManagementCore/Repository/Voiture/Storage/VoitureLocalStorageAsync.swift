//
//  VoitureLocalStorageAsync.swift
//  
//
//  Created by eldin smakic on 10/10/2022.
//

import Foundation
import Defaults

public class VoitureLocalStorageAsync: LocalStorageProtocolAsync {
   
    public static var shared = VoitureLocalStorageAsync()

    private var list: [VoitureDTO] {
        get { Defaults[.voitures] }
        set { Defaults[.voitures] = newValue }
    }
    
    private init() {}

    public func add(_ value: CarManagementCore.VoitureDTO) async throws -> CarManagementCore.VoitureDTO {
        list.append(value)
        return value
    }
    
    public func update(_ value: CarManagementCore.VoitureDTO) async throws -> CarManagementCore.VoitureDTO {
        return value
    }

    public func get(byId id: UUID) async throws -> VoitureDTO {
        guard let value = list.first(where: { $0.id == id }) else {
            throw NSError(domain: "2", code: 2)
        }

        return value
    }
    
    
    public func remove(_ value: CarManagementCore.VoitureDTO) async throws -> CarManagementCore.VoitureDTO {
        list.removeAll { voiture in
            voiture == value
        }
        return value
    }
    
    public func fetch() async throws -> [CarManagementCore.VoitureDTO] {
        return list
    }
    
    public func erase() async throws {
        list = []
    }
}

public class VoitureRepositoryAsync: RepositoryGenericAsync<VoitureLocalStorageAsync,VoitureRemoteStorageAsync, VoitureDTO> {}
