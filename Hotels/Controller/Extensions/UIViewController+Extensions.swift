//
//  UIViewController+Extensions.swift
//  Hotels
//
//  Created by Htet Wai Yan Swe on 1/15/22.
//

import Foundation
import UIKit

extension UIViewController {
    var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    
    
    func showHideActivityIndicator(_ isLoading: Bool, _ activityIndicator: UIActivityIndicatorView){
        if isLoading {
            activityIndicator.startAnimating()
        }else {
            activityIndicator.stopAnimating()
        }
    }
}
