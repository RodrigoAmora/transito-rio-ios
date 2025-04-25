//
//  OnibusViewController.swift
//  Transito Rio
//
//  Created by Rodrigo Amora on 29/11/23.
//

import UIKit
import MapKit

class OnibusViewController: BaseViewController {

    // MARK: - @IBOutlets
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var onibusMapView: MKMapView!
    
    // MARK: - Atributes
    private let locationManager = CLLocationManager()
    private var minhaLocalizacao: CLLocation?
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0
    private lazy var onibusViewModel: OnibusViewModel = OnibusViewModel(onibusDelegate: self)
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurarNavBar()
        self.atualizarLocalizacao()
        self.configurarDelegates()
    }
    
    // MARK: - Methods
    private func buscarOnibus() {
        self.activityIndicatorView.configureActivityIndicatorView()
        self.onibusViewModel.buscarOnibus()
    }
    
    private func configurarDelegates() {
        self.onibusMapView.delegate = self
    }
    
    private func configurarNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.blue

        let textColor = [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = textColor
                
        self.tabBarController?.navigationController?.navigationBar.standardAppearance = appearance
        self.tabBarController?.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.tabBarController?.navigationController?.navigationBar.tintColor = .white
        
        
        let menuSobre = UIAction(title: String(localized: "menu_sobre"), image: UIImage(systemName: "info.circle")) { _ in
            self.changeViewControllerWithPresent(SobreViewController())
        }
        
        let btnMenuItem = UIBarButtonItem()
        btnMenuItem.image = UIImage(systemName: "text.justify")
        btnMenuItem.menu = UIMenu(title: "", children: [menuSobre])
        
        self.tabBarController?.navigationItem.title = String(localized: "app_name")
        self.tabBarController?.navigationItem.rightBarButtonItem = btnMenuItem
    }
    
    private func centralizarMapView() {
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        //let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        
        //let region = MKCoordinateRegion(center: coordinates, span: span)
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: CLLocationDistance(exactly: 1500)!, longitudinalMeters: CLLocationDistance(exactly: 1500)!)
        
        self.onibusMapView.setRegion(region, animated: true)
        self.onibusMapView.showsUserLocation = true
    }
    
    private func centralizarMapView(listaOnibus: [Onibus]) {
        var coordinates: CLLocationCoordinate2D
        var region: MKCoordinateRegion
        
        if (listaOnibus.isEmpty) {
            let rioDeJaneiroLatitude = -22.8968093
            let rioDeJaneiroLongitude = -43.1833839
            coordinates = CLLocationCoordinate2D(latitude: rioDeJaneiroLatitude, longitude: rioDeJaneiroLongitude)
            region = MKCoordinateRegion(center: coordinates, latitudinalMeters: CLLocationDistance(exactly: 1500)!, longitudinalMeters: CLLocationDistance(exactly: 1500)!)
        } else {
            coordinates = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
            
            //let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            //region = MKCoordinateRegion(center: coordinates, span: span)
            
            region = MKCoordinateRegion( center: coordinates, latitudinalMeters: CLLocationDistance(exactly: 1500)!, longitudinalMeters: CLLocationDistance(exactly: 1500)!)
            
            self.onibusMapView.showsUserLocation = true
        }
        
        self.onibusMapView.setRegion(region, animated: true)
    }
    
    private func limparMapa() {
        if self.onibusMapView.annotations.count > 0 {
            self.onibusMapView.removeAnnotations(self.onibusMapView.annotations)
        }
    }
    
    private func atualizarLocalizacao() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }
    
    private func popularMapView(listaOnibus: [Onibus]) {
        let minhaLocalizacao = CLLocation(latitude: Double(latitude), longitude: Double(longitude))
        
        for onibus in listaOnibus {
            let latidudaOnibus = Double(onibus.latitude.replacingOccurrences(of: ",", with: ".")) ?? 0.0
            let longitudeOnibus = Double(onibus.longitude.replacingOccurrences(of: ",", with: ".")) ?? 0.0
            
            let localizacaoOnibus = CLLocation(latitude: latidudaOnibus, longitude: longitudeOnibus)
            
            if (minhaLocalizacao.distance(from: localizacaoOnibus) <= 2000) {
                let latitude = Double(latidudaOnibus)
                let longitude = Double(longitudeOnibus)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                annotation.title = "\(String(localized: "numero_carro")) \(onibus.ordem) - \(String(localized: "linha_carro")) \(onibus.linha)"
                
                self.onibusMapView.addAnnotation(annotation)
            }
        }
        
        /**
         Caso não tenha onibus próximo da localização do aparelho,
         exibe os onibus no centro do Rio de Janeiro
         */
        if (self.onibusMapView.annotations.count == 0) {
            let rioDeJaneiroLatitude = -22.8968093
            let rioDeJaneiroLongitude = -43.1833839
            let localizscaoRioDeJaneiro = CLLocation(latitude: rioDeJaneiroLatitude, longitude: rioDeJaneiroLongitude)
            
            for onibus in listaOnibus {
                let latidudaOnibus = Double(onibus.latitude.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                let longitudeOnibus = Double(onibus.longitude.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                
                let localizacaoOnibus = CLLocation(latitude: latidudaOnibus, longitude: longitudeOnibus)
                
                if (localizscaoRioDeJaneiro.distance(from: localizacaoOnibus) <= 2000) {
                    let latitude = Double(latidudaOnibus)
                    let longitude = Double(longitudeOnibus)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    annotation.title = "\(String(localized: "numero_carro")) \(onibus.ordem) - \(String(localized: "linha_carro")) \(onibus.linha)"
                    
                    self.onibusMapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    private func verificarSeHaOnibusProximos(listaOnibus: [Onibus]) {
        let localizacaoAtual = CLLocation(latitude: self.latitude, longitude: self.longitude)
        
        var onibusProximos: [Onibus] = []
        for onibus in listaOnibus {
            let onibusLatitude = Double(onibus.latitude.replacingOccurrences(of: ",", with: ".")) ?? 0.0
            let onibusLongitude = Double(onibus.longitude.replacingOccurrences(of: ",", with: ".")) ?? 0.0
            
            let localizacaoOnibus = CLLocation(latitude: onibusLatitude, longitude: onibusLongitude)
            
            let distancia = localizacaoAtual.distance(from: localizacaoOnibus)
            
            if (distancia.isLessThanOrEqualTo(3000)) {
                onibusProximos.append(onibus)
            }
        }
        
        self.centralizarMapView(listaOnibus: onibusProximos)
    }
    
    private func agendarPoximaBusca() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.limparMapa()
            self.buscarOnibus()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension OnibusViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {}
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        self.centralizarMapView()
        self.buscarOnibus()
    }
}

// MARK: - MKMapViewDelegate
extension OnibusViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Onibus"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
}

// MARK: - OnibusDelegate
extension OnibusViewController: OnibusDelegate {
    func replaceAll(listaOnibus: [Onibus]) {
        self.activityIndicatorView.hideActivityIndicatorView()
        self.verificarSeHaOnibusProximos(listaOnibus: listaOnibus)
        self.popularMapView(listaOnibus: listaOnibus)
        self.agendarPoximaBusca()
    }
    
    func showError() {
        self.activityIndicatorView.hideActivityIndicatorView()
        self.agendarPoximaBusca()
    }
}
