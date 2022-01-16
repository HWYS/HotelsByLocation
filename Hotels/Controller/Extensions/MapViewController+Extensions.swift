//
//  MapViewController+Extensions.swift
//  Hotels
//
//  Created by Htet Wai Yan Swe on 1/16/22.
//

import Foundation
import MapKit

extension MapViewController {
    
    func addAnnotationsToMap() {
        showHideActivityIndicator(true, activityIndicator)
        mapView.removeAnnotations(mapView.annotations)
        for pin in DataModel.locations {
            
            var annotations = [MKPointAnnotation]()
            
            let lat = CLLocationDegrees(pin.lat)
            let long = CLLocationDegrees(pin.lon)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = pin.locationName
            annotations.append(annotation)
            mapView.addAnnotations(annotations)
        }
        
        showHideActivityIndicator(false, activityIndicator)
    }
    
    func getCityNameByCoordinate(coordinte: CLLocationCoordinate2D){
        showHideActivityIndicator(true, self.activityIndicator)
        
        let location = CLLocation(latitude: coordinte.latitude, longitude: coordinte.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { addressArray, error in
            self.handleCityNameResponse(coordinate: coordinte, addressArray: addressArray, error: error)
        }
    }
    
    private func handleCityNameResponse(coordinate: CLLocationCoordinate2D, addressArray: [CLPlacemark]?, error: Error?) {
        if error == nil {
            if addressArray!.count > 0 {
                let locationName = addressArray?[0].locality ?? "My Location"
                self.saveLocation(coordinte: coordinate, locationName: locationName)
            }
        }else {
            showHideActivityIndicator(false, self.activityIndicator)
        }
    }
    
    func getGeoLocationByName(locationName: String){
        showHideActivityIndicator(true, activityIndicator)
        CLGeocoder().geocodeAddressString(locationName) { (marker, error) in
            if let _ = error {
                self.showAlert(message: "Error when getting location")
               
                self.showHideActivityIndicator(false, self.activityIndicator)
            } else {
                var location: CLLocation?
                
                if let marker = marker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.saveLocation(coordinte: location.coordinate, locationName: locationName)
                } else {
                    self.showHideActivityIndicator(false, self.activityIndicator)
                    self.showAlert(message: "Error when getting location")
                    
                }
            }
        }
    }
    
    private func saveLocation(coordinte: CLLocationCoordinate2D, locationName: String) {
        let pin = Locations(context: dataController.viewContext)
        pin.lat = coordinte.latitude
        pin.lon = coordinte.longitude
        pin.creationDate = Date()
        pin.locationName = locationName
        
        try? dataController.viewContext.save()
        DataModel.locations.append(pin)
        
        addPinToMap(pin: pin)
    }
    
    private func addPinToMap(pin: Locations) {
        let coordinate = CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.lon)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = pin.locationName
        mapView.addAnnotation(annotation)
        mapView.setCenter(coordinate, animated: true)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region =  MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        showHideActivityIndicator(false, activityIndicator)
    }
    
    func saveRegion(withKey key:String) {
        let locationData = [mapView.region.center.latitude, mapView.region.center.longitude,
                            mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta]
        defaults.set(locationData, forKey: key)
    }
    
    func loadRegion(withKey key:String) -> MKCoordinateRegion? {
        guard let region = defaults.object(forKey: key) as? [Double] else { return nil }
        let center = CLLocationCoordinate2D(latitude: region[0], longitude: region[1])
        let span = MKCoordinateSpan(latitudeDelta: region[2], longitudeDelta: region[3])
        return MKCoordinateRegion(center: center, span: span)
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
            let destination = self.storyboard?.instantiateViewController(identifier: "HotelsViewController") as! HotelsViewController
            
            destination.dataController = self.dataController
            let pin = DataModel.locations.first(where: {$0.lat == view.annotation?.coordinate.latitude})
           
            destination.pin = pin
            self.navigationController?.pushViewController(destination, animated: true)
        }
        
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        saveRegion(withKey: "mapregion")
    }
}

extension  MapViewController:  UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText  = searchBar.searchTextField.text {
            if !searchText.isEmpty {
                getGeoLocationByName(locationName: searchText)
            }
        }
        searchBar.resignFirstResponder()
    }
}
