//
//  Loadable.swift
//  CheckLessons
//
//  Created by fsociety.1 on 3/20/19.
//  Copyright © 2019 fsociety.1. All rights reserved.
//

import UIKit
import PKHUD

protocol Loadable {
    func showLoader()
    func hideLoaderSuccess()
    func hideLoaderFailure()
    func hideLoader()
}

extension Loadable where Self: UIViewController {
    func showLoader() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        HUD.show(.systemActivity, onView: self.view)
    }
    func hideLoader() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        HUD.hide()
    }
    func hideLoaderSuccess() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        HUD.flash(.success, delay: 0.5)
    }
    func hideLoaderFailure() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        UIApplication.shared.endIgnoringInteractionEvents()
        HUD.flash(.error, onView: self.view, delay: 1.0, completion: nil)
    }
}
