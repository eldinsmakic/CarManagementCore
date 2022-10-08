//
//  File.swift
//  
//
//  Created by eldin smakic on 08/10/2022.
//

import Foundation
import Defaults
import Combine

public class VoitureLocalStorage: LocalStorageProtocol {
    
    public static var shared = VoitureLocalStorage()

    public let model: AnyPublisher<[VoitureDTO], Never>

    private var publisher = PassthroughSubject<[VoitureDTO], Never>()
    
    private init() {
        self.model = publisher.eraseToAnyPublisher()
    }

    func updateDate() {
        publisher.send(list)
    }

    public func fetch() {
        updateDate()
    }

    public func add(_ value: VoitureDTO) {
        var localList = list
        localList.append(value)
        list = localList
    
        updateDate()
    }

    public func remove(_ value: VoitureDTO) {
        var localList = list
        localList.removeAll { voiture in
            value == voiture
        }
        list = localList
    
        updateDate()
    }

    public func delete(at offsets: IndexSet) {
        var localList = list
        localList.remove(atOffsets: offsets)

        list = localList
    
        updateDate()
    }

    public func erase() {
        list = []

        updateDate()
    }

    private var list: [VoitureDTO] {
        get { Defaults[.voitures] }
        set { Defaults[.voitures] = newValue }
    }
}

extension Defaults.Keys {
    static let voitures = Key<[VoitureDTO]>("voitures", default: [])
}

