//
//  ViewController.swift
//  Hotels
//
//  Created by Htet Wai Yan Swe on 1/15/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLogPressListenerToMap()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func addLogPressListenerToMap() {
        let longGesture = UILongPressGestureRecognizer()
        longGesture.minimumPressDuration = 0.2
        longGesture.addTarget(self, action: #selector(longPressed))
        mapView.addGestureRecognizer(longGesture)
    }
    
    @objc func longPressed(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizer.State.began {
            return
        }
        if isConnectedToInternet {
            let point = gestureRecognizer.location(in: mapView)
            let coord = mapView.convert(point, toCoordinateFrom: mapView)
            getCityNameByCoordinate(coordinte: coord)
            
        }else {
            showAlert(message: "Internet connection is not available")
        }
        
    }
}


