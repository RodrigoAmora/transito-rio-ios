//
//  OnibusService.swift
//  Transito Rio
//
//  Created by Rodrigo Amora on 29/11/23.
//

import Foundation
import Alamofire

class OnibusService {
    
    func buscarOnibus(completion: @escaping(_ listaOnibus: [Onibus], _ error: Int?) -> Void) {
        let dateFormated = DateFormatter().capturarDataHoraAtual()
        
        let baseURL = "https://dados.mobilidade.rio/gps/sppo"
        let onibusURL = "\(baseURL)?dataInicial=\(dateFormated)"
        
        AF.request("\(baseURL)?dataInicial\(dateFormated)",
                    method: .get,
                    encoding: URLEncoding.default)
                    .responseJSON{ response in
                        switch response.result {
                            case .success(let json):
                                let statusCode = response.response?.statusCode
                                switch statusCode {
                                    case 200:
                                        do {
                                            guard let data = response.data else { return }
                                            
                                            let listaOnibus = try JSONDecoder().decode([Onibus].self, from: data)
                                            completion(listaOnibus, nil)
                                        } catch {
                                            print("Error retriving questions \(error)")
                                            completion([], nil)
                                        }
                                        break
                                    
                                    default:
                                        completion([], statusCode)
                                        break
                                }
                            
                            case .failure(let error):
                                completion([], error.responseCode)
                                break
                        }
                    }
    }
}
