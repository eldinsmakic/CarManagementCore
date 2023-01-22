//
//  File.swift
//  
//
//  Created by eldin smakic on 09/10/2022.
//

import Foundation

protocol OperationDTO {
    var nom: String { get }
    var kilometrage: String { get }
    var cout: String { get }
    var date: Date { get }
}

struct CarburantDT: OperationDTO {
    var nom: String
    var kilometrage: String
    var cout: String
    var date: Date
    var quantité: Double
    var prixAuLitre: Double
}

struct EntretienDTO: OperationDTO {
    var nom: String
    var kilometrage: String
    var cout: String
    var date: Date
}

struct RepartionDTO: OperationDTO {
    var nom: String
    var kilometrage: String
    var cout: String
    var date: Date
}

struct AmeliorationDTO: OperationDTO {
    var nom: String
    var kilometrage: String
    var cout: String
    var date: Date
}
