//
//  Extension.swift
//  TumblrDemo
//
//  Created by Hein Soe on 9/11/18.
//  Copyright © 2018 Hein Soe. All rights reserved.
//

import UIKit

extension PhotosViewController {
    func networkError (fetch: @escaping () -> ()) {
        let showAlert = UIAlertController(title: "Network", message: "Internet Connection Seems to be offline", preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { (action) in
            fetch()
        }
        showAlert.addAction(retryAction)
        self.present(showAlert, animated: true, completion: nil)
    }
}
