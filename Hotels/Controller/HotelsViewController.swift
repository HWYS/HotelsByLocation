//
//  HotelsViewController.swift
//  Hotels
//
//  Created by Htet Wai Yan Swe on 1/15/22.
//

import UIKit
import CoreData

class HotelsViewController: UIViewController {
    var pin:  Locations!
    var dataController: DataController!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var fetchedResultsController: NSFetchedResultsController<Hotels>!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupFetchedResultsController()
    }
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Hotels> = Hotels.fetchRequest()
        let predicate = NSPredicate(format: "location == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptior = NSSortDescriptor(key: "reviewScore", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptior]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(pin)-hotels")
        //fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
            getPhotosFromDb()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        
        if fetchedResultsController.sections![0].numberOfObjects < 0 {
            getHotelsFromApi()
        }
    }
    
    private func getPhotosFromDb(){
        showHideActivityIndicator(true, activityIndicator)
        if let resutls = fetchedResultsController.fetchedObjects {
            DataModel.hotels = resutls
            
            if resutls.isEmpty {
                getHotelsFromApi()
            }else {
                showHideActivityIndicator(false, activityIndicator)
            }
        }
    }
    
    private func getHotelsFromApi() {
        if isConnectedToInternet {
            showHideActivityIndicator(true, activityIndicator)
            HotelsApiClient.getHotelsByCoordinate(lat: pin.lat, lon: pin.lon) { hotels, error in
                if hotels.isEmpty {
                    self.showHideActivityIndicator(false, self.activityIndicator)
                    self.showAlert(message: "No hotels  found for current location")
                }else{
                    self.saveHotels(hotels: hotels)
                }
            }
            
        }else {
            showAlert(message: "Internet connection is not available")
        }
        
    }
    private func saveHotels(hotels: [Hotel]) {
        
        for item in hotels {
            let hotel = Hotels(context: self.dataController.viewContext)
            hotel.location = self.pin
            hotel.hotelName = item.hotelName
            hotel.address = item.address
            hotel.photoUrl = item.photoUrl
            hotel.websiteUrl = item.websiteUrl
            hotel.reviewScore = item.reviewScore
            hotel.minPrice = item.minPrice
            
            try? self.dataController.viewContext.save()
            DataModel.hotels.append(hotel)
        }
        self.tableView.reloadData()
        showHideActivityIndicator(false, activityIndicator)
    }
    
    private func deleteFromDb() {
        if let hotels = fetchedResultsController.fetchedObjects {
            DataModel.hotels.removeAll()
            for hotel in hotels {
                dataController.viewContext.delete(hotel)
                do {
                    try dataController.viewContext.save()
                } catch {
                    debugPrint("Error Deleting All Photo")
                }
            }
        }
        getHotelsFromApi()
    }
    
}

extension HotelsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? DataModel.hotels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hotel = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotelTableViewCell", for: indexPath) as! HotelTableViewCell
        
        cell.hotelNameLabel.text = hotel.hotelName
        cell.addressLabel.text = hotel.address
        
        if let data = hotel.photo {
            cell.hotelImagerView.image = UIImage(data: data)
        } else {
            cell.activicatorIndicator.startAnimating()
            HotelsApiClient.downloadImage(photoUrl: hotel.photoUrl!) { data, error in
                if let data = data {
                    cell.hotelImagerView.image = UIImage(data: data)
                    cell.activicatorIndicator.stopAnimating()
                    
                    hotel.photo = data
                    try? self.dataController.viewContext.save()
                }
            }
        }
        return cell
    }

}
