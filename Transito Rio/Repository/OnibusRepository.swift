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
        self.onibusService.buscarOnibus(completion: { listaOnibus in
            let novaListaOnibus = self.verificarHoraDeEnvioDaLocalizacao(listaOnibus: listaOnibus)
            completion(Resource(result: novaListaOnibus))
        })
    }
    
    private func verificarHoraDeEnvioDaLocalizacao(listaOnibus: [Onibus]) -> [Onibus] {
        var novaListaOnibus: [Onibus] = []
        
        for onibus in listaOnibus {
            let dataHoraEnvio = Date(timeIntervalSinceNow: Double(onibus.datahoraenvio) ?? 0)

            let tempoEmSecundos = Calendar.current.component(.second, from: dataHoraEnvio)
            if tempoEmSecundos <= 10 {
                var posicao = 0
                for onibusJaAdicionado in novaListaOnibus {
                    if onibusJaAdicionado.ordem == onibus.ordem {
                        novaListaOnibus.remove(at: posicao)
                    }
                    posicao += 1
                }
                novaListaOnibus.append(onibus)
            }
        }
        
        return novaListaOnibus
    }
}
