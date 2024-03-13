//
//  BaseViewController.swift
//  Transito Rio
//
//  Created by Rodrigo Amora on 04/12/23.
//

import Foundation
import UIKit


class BaseViewController: UIViewController {
    func changeViewControllerWithPresent(_ destinationViewController: UIViewController) {
        self.present(destinationViewController, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let buttonOK = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(buttonOK)
        present(alert, animated: true, completion: nil)
    }
}
