//
//  MapViewController+Extensions.swift
//  Hotels
//
//  Created by Htet Wai Yan Swe on 1/16/22.
//

import Foundation
import MapKit

extension MapViewController {
    
    func getCityNameByCoordinate(coordinte: CLLocationCoordinate2D){
        showHideActivityIndicator(true, self.activityIndicator)
        
        let location = CLLocation(latitude: coordinte.latitude, longitude: coordinte.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: handleCityNameResponse(addressArray:error:))
    }
    
    private func handleCityNameResponse(addressArray: [CLPlacemark]?, error: Error?) {
        if error == nil {
            if addressArray!.count > 0 {
                let locationName = addressArray?[0].locality ?? "My Location"
                print(locationName)
            }
        }else {
            showHideActivityIndicator(false, self.activityIndicator)
        }
    }
}


extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            /*let destination = self.storyboard?.instantiateViewController(identifier: "PhotoAlbumViewController") as! PhotoAlbumViewController
            destination.dataController = self.dataController
            let pin = DataModel.pins.first(where: {$0.latitude == view.annotation?.coordinate.latitude})
           
            destination.pin = pin
            self.navigationController?.pushViewController(destination, animated: true)*/
        }
        
    }
}
