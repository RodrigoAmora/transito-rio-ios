//
//  SobreViewController.swift
//  Transito Rio
//
//  Created by Rodrigo Amora on 07/03/24.
//

import UIKit

class SobreViewController: BaseViewController {

    // MARK: - @IBOutlets
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbVersion: UILabel!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViews()
    }

    // MARK: - Methods
    private func initViews() {
        self.lbEmail.text = String(localized: "created_by_email")
        self.lbEmail.textAlignment = .center
        
        self.lbName.text = String(localized: "created_by")
        self.lbName.textAlignment = .center
        
        let versionApp = self.getVersionApp()
        self.lbVersion.text = versionApp
        self.lbVersion.textAlignment = .center
    }
    
    private func getVersionApp() -> String? {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        return "\(String(localized: "created_by_version")) \(appVersion)"
    }

}
