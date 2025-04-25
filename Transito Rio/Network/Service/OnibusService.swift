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
                        completion(self.removerOnibusRepetidos())
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
    
    private func removerOnibusRepetidos() -> [Onibus] {
        self.listaOnibus.reverse()
        
        var onibusAntigo: Onibus = self.listaOnibus[0]
        
        var novaListaOnibus: [Onibus] = []
        novaListaOnibus.append(onibusAntigo)
        
        var listaOrdens: [String] = []
        listaOrdens.append(onibusAntigo.ordem)
        
        for i in 1 ... self.listaOnibus.count-1 {
            let onibus = self.listaOnibus[i]
            if onibusAntigo.ordem != onibus.ordem &&
               !listaOrdens.contains(onibus.ordem) {
                novaListaOnibus.append(onibus)
                listaOrdens.append(onibus.ordem)
            }
            onibusAntigo = onibus
        }
        
        listaOrdens.removeAll()
        self.listaOnibus.removeAll()
        self.listaOnibus = novaListaOnibus
        
        return self.listaOnibus
    }
}
