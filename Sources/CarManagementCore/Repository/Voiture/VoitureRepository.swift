//
//  VoitureRepository.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import Foundation

public class VoitureRepository: RepositoryGeneric<VoitureLocalStorage, VoitureDTO> {}

public protocol VoitureRepositoryProtocol {
    func add(_ value: VoitureDTO) async -> Result<VoitureDTO,GenericErrorAsync>
    func update(_ value: VoitureDTO) async -> Result<VoitureDTO,GenericErrorAsync>
    func remove(_ value: VoitureDTO) async -> Result<VoitureDTO,GenericErrorAsync>
    func remove(byID id: UUID) async -> Result<VoitureDTO?,GenericErrorAsync>
    func get(byId id: UUID) async -> Result<VoitureDTO,GenericErrorAsync>
    func fetch() async -> Result<[VoitureDTO],GenericErrorAsync>
    func erase() async -> Result<Void,GenericErrorAsync>
}
