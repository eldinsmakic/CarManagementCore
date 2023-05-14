//
//  VoitureRepository.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import Foundation

public class VoitureRepository: RepositoryGeneric<VoitureLocalStorage, CarDTO> {}

public protocol CarStorageProtocol {
    func add(_ value: CarDTO) async throws -> Result<CarDTO,GenericErrorAsync>
    func update(_ value: CarDTO) async throws-> Result<CarDTO,GenericErrorAsync>
    func remove(_ value: CarDTO) async throws-> Result<CarDTO,GenericErrorAsync>
    func remove(byID id: UUID) async throws-> Result<CarDTO?,GenericErrorAsync>
    func get(byId id: UUID) async throws -> Result<CarDTO,GenericErrorAsync>
    func fetch() async throws -> Result<[CarDTO],GenericErrorAsync>
    func erase() async throws -> Result<Void,GenericErrorAsync>
}

public protocol CarRepositoryProtocol: CarStorageProtocol {}
