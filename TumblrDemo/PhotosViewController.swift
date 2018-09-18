//
//  PhotosViewController.swift
//  TumblrDemo
//
//  Created by Hein Soe on 9/11/18.
//  Copyright © 2018 Hein Soe. All rights reserved.
//

//TODO: Implement Each Cell Selection to Detail VC, then show New VC with Image and Text
//TODO: Create Placeholder Image, Launch Image

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var post:[[String: Any]] = []

    var refreshCtrl:UIRefreshControl!
    
    @IBOutlet weak var loadingAnim: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingAnim.startAnimating()
        tableView.delegate  = self
        tableView.dataSource = self
        fetchPhoto()
        
        refreshCtrl = UIRefreshControl()
        tableView.insertSubview(refreshCtrl, at: 0)
        
        refreshCtrl.addTarget(self, action: #selector(PhotosViewController.pullToRefresh(_:)), for: .valueChanged)
    }
    
    @objc func pullToRefresh (_ refreshCtrl: UIRefreshControl) {
        fetchPhoto()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchPhoto () {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
//        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if (error != nil) {
                self.networkError(fetch: self.fetchPhoto)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let fetchedPhotos = dataDictionary["response"] as! [String:Any]
                self.post = fetchedPhotos["posts"] as! [[String:Any]]
                self.tableView.reloadData()
                self.loadingAnim.stopAnimating()
                self.refreshCtrl.endRefreshing()
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photoCell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoTableViewCell
        let post = self.post[indexPath.row]
        if let photos = post["photos"] as? [[String: Any]] {
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String:Any]
            let urlStr = originalSize["url"] as! String
            
//            let smallerSize = photo["alt_sizes"] as! [[String:Any]]
//            let small_400Size = smallerSize[4]
//            let smallSizeStr = small_400Size["url"] as! String
            
            let url = URL(string: urlStr)
            photoCell.postImg.af_setImage(withURL: url!,placeholderImage:#imageLiteral(resourceName: "TumblrDemoIcon"), imageTransition: .crossDissolve(2.0))
        }
        return photoCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PhotoDetailsViewController
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let post = self.post[(indexPath?.row)!]

        if let photos = post["photos"] as? [[String: Any]] {
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String:Any]
            let urlStr = originalSize["url"] as! String
            
            //            let smallerSize = photo["alt_sizes"] as! [[String:Any]]
            //            let small_400Size = smallerSize[4]
            //            let smallSizeStr = small_400Size["url"] as! String
            
            let url = URL(string: urlStr)
            vc.photoURL = url
        }
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
