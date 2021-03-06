//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Labuser on 1/26/16.
//  Copyright © 2016 Shefali Gupta. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?
    var endpoint: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self


        // Do any additional setup after loading the view.
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            //print("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary]?
                            self.tableView.reloadData()
                    }
                }
        })
        task.resume()
    
    
        let progressHUD = loadDataFromNetwork()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    override func viewDidAppear(animated: Bool) {
        let indexPath = tableView.indexPathForSelectedRow
        if (indexPath != nil) {
            tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        }
        
        //don't hide navigation bar on tap
        navigationController?.hidesBarsOnTap = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count;
        } else {
            return 0;
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        cell.selectionStyle = .Default
        cell.accessoryType = .None
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        cell.titleLabel.text = title
        let overview = movie["overview"] as! String
        cell.overviewLabel.text = overview
        
        if let posterPath = movie["poster_path"] as? String {
            let baseURL = "http://image.tmdb.org/t/p/w500"
            let imageRequest = NSURLRequest(URL: NSURL(string: baseURL + posterPath)!)
            
            cell.posterView.setImageWithURLRequest(
                imageRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        cell.posterView.alpha = 0.0
                        cell.posterView.image = image
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            cell.posterView.alpha = 1.0
                        })
                    } else {
                        print("Image was cached so just update the image")
                        cell.posterView.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
            
            
        }
        
        return cell
    }
    
    
    
    func loadDataFromNetwork() {
        
        // ... Create the NSURLRequest (myRequest) ...
        let myRequest2 = NSURLRequest()
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(myRequest2,
            completionHandler: { (data, response, error) in
                
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                // ... Remainder of response handling code ...
                
        });
        task.resume()
    }
    
    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        let myRequest = NSURLRequest()
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(myRequest, completionHandler: {(data, response, error) in
            
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        
        });
        task.resume()
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
        detailViewController.hidesBottomBarWhenPushed = true
        
        
        print("prepare for segue")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
