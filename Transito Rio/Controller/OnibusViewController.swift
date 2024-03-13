//
//  OnibusViewController.swift
//  Transito Rio
//
//  Created by Rodrigo Amora on 29/11/23.
//

import UIKit
import MapKit
import CoreLocation

class OnibusViewController: BaseViewController {

    // MARK: - @IBOutlets
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var btnMenuItem: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var onibusMapView: MKMapView!
    
    // MARK: - Atributes
    private let locationManager = CLLocationManager()
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0
    private var listaOnibus: [Onibus] = []
    private lazy var onibusViewModel: OnibusViewModel = OnibusViewModel(onibusDelegate: self)
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.atualizarLocalizacao()
        self.configurarDelegates()
        self.configurarNavBar()
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
        let menuSobre = UIAction(title: String(localized: "menu_sobre"), image: UIImage(systemName: "info.circle")) { _ in
            //self.changeViewControllerWithPresent(SobreViewController())
        }
        
        self.btnMenuItem.image = UIImage(systemName: "text.justify")
        self.btnMenuItem.menu = UIMenu(title: "", children: [menuSobre])
        
        self.navBar.topItem?.title = String(localized: "app_name")
    }
    
    private func centralizarMapView() {
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        //let region = MKCoordinateRegion(center: coordinates, span: span)
        let region = MKCoordinateRegion( center: coordinates, latitudinalMeters: CLLocationDistance(exactly: 1500)!, longitudinalMeters: CLLocationDistance(exactly: 1500)!)
        
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
            region = MKCoordinateRegion( center: coordinates, latitudinalMeters: CLLocationDistance(exactly: 1500)!, longitudinalMeters: CLLocationDistance(exactly: 1500)!)
        } else {
            coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
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
        for onibus in listaOnibus {
            let latitude = Double(onibus.latitude.replacingOccurrences(of: ",", with: ".")) ?? 0.0
            let longitude = Double(onibus.longitude.replacingOccurrences(of: ",", with: ".")) ?? 0.0
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.title = "\(String(localized: "numero_carro")) \(onibus.ordem) - \(String(localized: "linha_carro")) \(onibus.linha)"
            
            self.onibusMapView.addAnnotation(annotation)
        }
    }
    
    private func verificarSeHaOnibusProximos() {
        let localizacaoAtual = CLLocation(latitude: self.latitude, longitude: self.longitude)
        
        var onibusProximos: [Onibus] = []
        for onibus in self.listaOnibus {
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            self.buscarOnibus()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension OnibusViewController: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {}
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        self.centralizarMapView()
        self.buscarOnibus()
    }
}

// MARK: - MKMapViewDelegate
extension OnibusViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
//        guard annotation is Salon else { return nil }

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
        self.listaOnibus = listaOnibus
        self.limparMapa()
        self.verificarSeHaOnibusProximos()
        self.popularMapView(listaOnibus: listaOnibus)
        self.agendarPoximaBusca()
    }
    
    func showError() {
        self.activityIndicatorView.hideActivityIndicatorView()
        //self.showAlert(title: "", message: String(localized: "sem_onibus"))
        self.agendarPoximaBusca()
    }
}
