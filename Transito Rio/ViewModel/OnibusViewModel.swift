//
//  OnibusViewModel.swift
//  Transito Rio
//
//  Created by Rodrigo Amora on 30/11/23.
//

import Foundation

class OnibusViewModel {
    
    // MARK: - Atributes
    private lazy var onibusRepository = OnibusRepository()
    private var onibusDelegate: OnibusDelegate
    
    // MARK: - init
    init(onibusDelegate: OnibusDelegate) {
        self.onibusDelegate = onibusDelegate
    }
    
    // MARK: - Methods
    func buscarOnibus() {
        self.onibusRepository.buscarOnibus(completion: { [weak self] resource in
            let listaOnibus = resource.result ?? []
            let errorCode = resource.errorCode
            
            if listaOnibus != nil {
                self?.onibusDelegate.populateMap(listaOnibus: listaOnibus)
            } else {
                self?.onibusDelegate.showError()
            }
        })
    }
}
