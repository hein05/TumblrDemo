//
//  PhotosViewController.swift
//  TumblrDemo
//
//  Created by Hein Soe on 9/11/18.
//  Copyright © 2018 Hein Soe. All rights reserved.
//

//TODO: Create Launch Image

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {

    var post:[[String: Any]] = []
    static let bottomRefreshH:CGFloat = 60.0
    
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
        loadingAnim.frame.origin.x = self.view.frame.width/2
        loadingAnim.frame.origin.y = self.view.frame.height/2
//        self.view.addSubview(loadingAnim)
        
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
                self.isMoreDatatLoading = false
                self.tableView.reloadData()
                self.loadingAnim.stopAnimating()
                self.refreshCtrl.endRefreshing()
            }
        }
        task.resume()
    }
    // MARK: Implementing Tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return post.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.906838613)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15
        profileView.layer.borderColor = #colorLiteral(red: 0.8831892449, green: 0.8831892449, blue: 0.8831892449, alpha: 0.7984535531)
        profileView.layer.borderWidth = 1
        
        profileView.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        headerView.addSubview(profileView)
        
        let post = self.post[section]
        let date = post["date"] as? String
        
        let label = UILabel(frame: CGRect(x: 50, y: 10, width: 500, height: 30))
        
        label.text = date
        label.textColor = #colorLiteral(red: 0.09458656521, green: 0.1154079092, blue: 0.1404068845, alpha: 1)
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photoCell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoTableViewCell
        
        let post = self.post[indexPath.section]
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
    
    // MARK:Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PhotoDetailsViewController
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let post = self.post[(indexPath?.section)!]

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
    
    var isMoreDatatLoading = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(!isMoreDatatLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDatatLoading = true
                
                loadingAnim.frame.origin.y = tableView.bounds.size.height
                loadingAnim.startAnimating()
                self.fetchPhoto()
            }
        }
    }
    
}
