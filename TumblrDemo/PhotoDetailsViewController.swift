//
//  PhotoDetailsViewController.swift
//  TumblrDemo
//
//  Created by Hein Soe on 9/18/18.
//  Copyright © 2018 Hein Soe. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    public var photoURL:URL?
    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.img.af_setImage(withURL: photoURL!)
    }
    
    @IBAction func tappedImg(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "fullscreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //TODO: transfer data
        let destinVC = segue.destination as! FullScreenViewController
        destinVC.photoURL = self.photoURL
        
    }
 
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
