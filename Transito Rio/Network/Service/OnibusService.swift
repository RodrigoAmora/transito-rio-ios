//
//  OnibusService.swift
//  Transito Rio
//
//  Created by Rodrigo Amora on 29/11/23.
//

import Foundation
import Alamofire

class OnibusService {
    
    func buscarOnibus(completion: @escaping(_ listaOnibus: [Onibus]) -> Void) {
        let dateFormated = DateFormatter().capturarDataHoraAtual()
        
        let baseURL = "https://dados.mobilidade.rio/gps/sppo"
        let onibusURL = "\(baseURL)?dataInicial=\(dateFormated)"
        
        AF.request(onibusURL,
                    method: .get,
                    encoding: URLEncoding.default)
            .responseJSON{ response in
                switch response.result {
                    case .success(_):
                        do {
                            guard let data = response.data else { return }
                            
                            let listaOnibus = try JSONDecoder().decode([Onibus].self, from: data)
                            completion(listaOnibus)
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
    
}
