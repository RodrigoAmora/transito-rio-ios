//
//  OnibusRepository.swift
//  Transito Rio
//
//  Created by Rodrigo Amora on 30/11/23.
//

import Foundation

class OnibusRepository {
    
    // MARK: - Atributes
    private lazy var onibusService = OnibusService()
    private var resource: Resource<[Onibus]>?
    
    // MARK: - Methods
    func buscarOnibus(completion: @escaping(_ listaOnibus: Resource<[Onibus]>) -> Void) {
        self.onibusService.buscarOnibus(completion: { [weak self] listaOnibus, error in
            if listaOnibus.count == 0 {
                completion(Resource(result: nil, errorCode: error))
            } else {
                completion(Resource(result: listaOnibus))
            }
        })
    }
}
