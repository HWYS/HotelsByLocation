//
//  ViewController.swift
//  Hotels
//
//  Created by Htet Wai Yan Swe on 1/15/22.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Locations>!
    let defaults = UserDefaults.standard
    
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSearchBar()
        
        addLogPressListenerToMap()
        setUpFetchResultsController()
        
        if let region = loadRegion(withKey: "mapregion") {
            mapView.region = region
        }
    }
    
    private func addSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.barStyle = .black
        searchController.searchBar.searchTextField.backgroundColor = .darkGray
        searchController.searchBar.placeholder = "Type location name and hit Enter"
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
        saveRegion(withKey: "mapregion")
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
    
    private func setUpFetchResultsController() {
        let fetchRequest: NSFetchRequest<Locations> = Locations.fetchRequest()
        let sortDescriptior = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptior]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "locations")
        
        do {
            try fetchedResultsController.performFetch()
            getLocationsFromDb()
            
        }catch {
            fatalError("Cannot fetch to database: " + error.localizedDescription)
        }
    }
    
    private func getLocationsFromDb(){
        if let resutls = fetchedResultsController.fetchedObjects {
            DataModel.locations = resutls
            addAnnotationsToMap()
        }
    }
}



