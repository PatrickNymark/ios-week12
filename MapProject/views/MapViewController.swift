//
//  MapViewController.swift
//  MapProject
//
//  Created by Patrick Nymark on 04/08/2020.
//  Copyright © 2020 Patrick Nymark. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    private let locationManager = CLLocationManager()
    private var annotations = [Annotation]()
    private var coordinates = CLLocationCoordinate2D()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var modalCloseBtn: UIButton!
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var modalSaveBtn: UIButton!
    @IBOutlet weak var modalTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        modalView.isHidden = true
        
        // long press listener for map to open pin modal
        let lpgr = UILongPressGestureRecognizer(target: self, action:#selector(self.handleLongPress))
        mapView.addGestureRecognizer(lpgr)
        
        // modal close click listener
        modalCloseBtn.addTarget(self, action: #selector(self.handleCloseModal), for: .touchUpInside)
        
        // modal save click listener
        modalSaveBtn.addTarget(self, action: #selector(self.handleSaveClick), for: .touchUpInside)
        
        // mapview delegate
        mapView.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        
        FirebaseRepo.startListener(vc: self)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizer.State.ended {
            return
        } else if gestureRecognizer.state != UIGestureRecognizer.State.began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            self.coordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)

            loadModalView()
        }
    }
    
    @objc func handleCloseModal() {
        modalView.isHidden = true
        modalTextField.text = ""
    }
    
    @objc func handleSaveClick() {
        guard let title = modalTextField.text else { return }
        
        FirebaseRepo.addAnnotation(title: title, user: "test", lat: self.coordinates.latitude, long: self.coordinates.longitude, completion: { (success) -> Void in
            if success {
                handleCloseModal()
            }
        })
    }
    
    private func loadModalView() {
        modalView.layer.shadowColor = UIColor.black.cgColor
        modalView.layer.shadowOpacity = 0.23
        modalView.layer.shadowOffset = .zero
        modalView.layer.shadowRadius = 6
        
        modalView.isHidden = false
    }
    
    func updateAnnotations(annotations: [Annotation]) {
        for a in annotations {
            self.annotations.append(a)
            
            var coordinate = CLLocationCoordinate2D()
            coordinate.latitude = a.lat
            coordinate.longitude = a.long
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = a.title
            self.mapView.addAnnotation(annotation)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //        let selectedAnnotation = view.annotationx
        guard let selectedAnnotation = view.annotation else { return }
        guard let title = selectedAnnotation.title else { return }
        print(title)
        
        FirebaseRepo.deleteAnnotation(title: title!)
        mapView.removeAnnotation(selectedAnnotation)
    }
}
