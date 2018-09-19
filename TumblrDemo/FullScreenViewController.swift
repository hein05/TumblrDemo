//
//  FullScreenViewController.swift
//  TumblrDemo
//
//  Created by Hein Soe on 9/18/18.
//  Copyright © 2018 Hein Soe. All rights reserved.
//

import UIKit

class FullScreenViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    var photoURL:URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        img.af_setImage(withURL: photoURL!)
    }

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func zoom(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let currScale = self.img.frame.size.width / self.img.bounds.size.width
            let newScale = currScale * sender.scale
            let transfrom = CGAffineTransform(scaleX: newScale, y: newScale)
            self.img.transform = transfrom
            sender.scale = 1
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
