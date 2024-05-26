//
//  OnibusService.swift
//  Transito Rio
//
//  Created by Rodrigo Amora on 29/11/23.
//

import Foundation
import Alamofire

class OnibusService {
    
    private var listaOnibus: [Onibus] = []
    
    func buscarOnibus(completion: @escaping(_ listaOnibus: [Onibus]) -> Void) {
        let dateFormated = DateFormatter().capturarDataHoraAtual()
        
        let baseURL = "https://dados.mobilidade.rio/gps/sppo"
        let onibusURL = "\(baseURL)?dataInicial=\(dateFormated)&dataFinal=\(dateFormated)"
        
        AF.request(onibusURL,
                    method: .get,
                    encoding: URLEncoding.default)
        .responseDecodable(of: [Onibus].self) { response in
            switch response.result {
                case .success(_):
                    do {
                        guard let data = response.data else { return }
                        
                        self.listaOnibus = try JSONDecoder().decode([Onibus].self, from: data)
                        completion(self.verificarHoraDeEnvioDaLocalizacao())
                    } catch {
                        print("Error retriving questions \(error)")
                        completion([])
                    }
                    break
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion([])
                    break
            }
        }
    }
    
    private func verificarHoraDeEnvioDaLocalizacao() -> [Onibus] {
        var novaListaOnibus: [Onibus] = []
        
        for onibus in self.listaOnibus {
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
        self.listaOnibus.removeAll()
        return novaListaOnibus
    }
}
