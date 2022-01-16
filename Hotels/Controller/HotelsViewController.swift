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
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Hotels around \(pin.locationName!)"
        
        getCurrentWeather()
        setupFetchedResultsController()
    }
    
    private func getCurrentWeather(){
        if isConnectedToInternet {
            showHideActivityIndicator(true, activityIndicator)
            WeatherApiClient.getCurrentWeatherByCoordinate(q: pin.locationName!, lat: pin.lat, lon: pin.lon) { response, error in
                if let response = response {
                    self.temperatureLabel.text = "\(response.main.temp)"
                    let url = "http://openweathermap.org/img/wn/\(response.weather[0].icon)@2x.png"
                    self.downloadPhoto(photoUrl: url) { data in
                        if let data = data {
                            self.weatherImage.image = UIImage(data: data)
                        }
                    }
                    self.showHideActivityIndicator(false, self.activityIndicator)
                    
                }else {
                    self.showAlert(message: "Unable to get current weather forecast")
                    self.showHideActivityIndicator(false, self.activityIndicator)
                }
            }
        }else {
            showHideActivityIndicator(false, activityIndicator)
            showAlert(message: "Open internet setting to see current weather forecase")
        }
    }
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Hotels> = Hotels.fetchRequest()
        let predicate = NSPredicate(format: "location == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptior = NSSortDescriptor(key: "reviewScore", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptior]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(pin)-hotels")
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
            getHotelsFromDb()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        
        if fetchedResultsController.sections![0].numberOfObjects < 0 {
            getHotelsFromApi()
        }
    }
    
    private func getHotelsFromDb(){
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
    
    func downloadPhoto(photoUrl: String, completion: @escaping(Data?) -> Void) {
        
        HotelsApiClient.downloadImage(photoUrl: photoUrl) { data, error in
            completion(data)
        }
        
    }
    
}


