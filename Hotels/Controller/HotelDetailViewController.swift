//
//  HotelDetailViewController.swift
//  Hotels
//
//  Created by Htet Wai Yan Swe on 1/16/22.
//

import UIKit
import WebKit

class HotelDetailViewController: UIViewController {
    var url = ""
    var hotelName = ""
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = hotelName
        webView.load(URLRequest(url: URL(string: url)!))
    }

}
