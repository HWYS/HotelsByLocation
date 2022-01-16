//
//  HotelsViewController.swift
//  Hotels
//
//  Created by Htet Wai Yan Swe on 1/15/22.
//

import UIKit

class HotelsViewController: UIViewController {
    var pin:  Locations!
    var dataController: DataController!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getHotelsFromApi()
    }
    
    private func getHotelsFromApi() {
        showHideActivityIndicator(true, activityIndicator)
        HotelsApiClient.getHotelsByCoordinate(lat: pin.lat, lon: pin.lon) { hotels, error in
            if hotels.isEmpty {
                self.showHideActivityIndicator(false, self.activityIndicator)
            }else{
                print(hotels)
            }
        }
        
        showHideActivityIndicator(false, activityIndicator)
    }
}

extension HotelsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let aNote = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotelCell", for: indexPath) as! HotelTableViewCell

        

        return cell
    }

}
