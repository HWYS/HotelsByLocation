//
//  HotelTableViewCell.swift
//  Hotels
//
//  Created by Htet Wai Yan Swe on 1/16/22.
//

import UIKit

class HotelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hotelImagerView: UIImageView!
    @IBOutlet weak var activicatorIndicator: UIActivityIndicatorView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
