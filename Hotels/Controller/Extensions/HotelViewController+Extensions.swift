//
//  HotelViewController+Extensions.swift
//  Hotels
//
//  Created by Htet Wai Yan Swe on 1/17/22.
//

import Foundation
import UIKit
import CoreData

extension HotelsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hotel = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotelTableViewCell", for: indexPath) as! HotelTableViewCell
        
        cell.hotelNameLabel.text = hotel.hotelName
        cell.addressLabel.text = hotel.address
        cell.ratingLabel.text = "\(hotel.reviewScore)"
        cell.priceLabel.text  = #"$\#(hotel.minPrice)"#
        
        if let data = hotel.photo {
            cell.hotelImagerView.image = UIImage(data: data)
        } else {
            cell.activicatorIndicator.startAnimating()
            downloadPhoto(photoUrl: hotel.photoUrl!) { data in
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isConnectedToInternet {
            let destination = self.storyboard?.instantiateViewController(identifier: "HotelDetailViewController") as! HotelDetailViewController
            destination.url  = DataModel.hotels[indexPath.row].websiteUrl!
            destination.hotelName = DataModel.hotels[indexPath.row].hotelName!
            self.navigationController?.pushViewController(destination, animated: true)
        }else {
            showAlert(message: "No internet connection is available")
        }
        
    }
}

extension HotelsViewController: NSFetchedResultsControllerDelegate  {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        default:
            break
        }
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
