//
// MarqueRepository.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import Foundation

struct MarqueDTO {
    let name: String
    let model: String
}


struct VoitureDTO {
    let marque: MarqueDTO
    let kilometrage: Int
    let carburant: CarburantDTO
}

enum CarburantDTO {
    case essence
    case gazole
}
