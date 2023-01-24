//
//  File.swift
//  
//
//  Created by eldin smakic on 09/10/2022.
//

import Foundation
import Defaults

public struct OperationDTO: Codable, Equatable {
    public var idVoiture: UUID
    public var id: UUID
    public var nom: String
    public var kilometrage: String
    public var cout: String
    public var date: Date
    public var typeOperation: OperationType

    public init(
        idVoiture: UUID,
        id: UUID,
        nom: String,
        kilometrage: String,
        cout: String,
        date: Date,
        typeOperation: OperationType
    ) {
        self.idVoiture = idVoiture
        self.id = id
        self.nom = nom
        self.kilometrage = kilometrage
        self.cout = cout
        self.date = date
        self.typeOperation = typeOperation
    }
}

public enum OperationType: Codable, Equatable {
    case upgrade
    case repair
    case maintenance
}

