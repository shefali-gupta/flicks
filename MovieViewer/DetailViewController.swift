//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Labuser on 2/1/16.
//  Copyright © 2016 Shefali Gupta. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var releaseDateLabel: UILabel!
   
    var movie: NSDictionary!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as? String
        //titleLabel.text = title
        
        // setting the title to movie title
        self.navigationItem.title = title
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        let releaseDate = movie["release_date"] as? String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.dateFromString(releaseDate!)
        dateFormatter.dateStyle = .MediumStyle
        print("date: \(date)")
        let formattedDate = dateFormatter.stringFromDate(date!)
        print("formatted date: \(formattedDate)")
        releaseDateLabel.text = formattedDate
        
        
        //customize navigation bar
        
        navigationController?.hidesBarsOnTap = true
        
        // making the bar transparent
        /*
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
        */
        
        
        //let baseURL = "http://image.tmdb.org/t/p/w500"
        let smallImageURL = "https://image.tmdb.org/t/p/w45"
        let largeImageURL = "https://image.tmdb.org/t/p/original"
        
        if let posterPath = movie["poster_path"] as? String {
            
            let smallImageRequest = NSURLRequest(URL: NSURL(string: smallImageURL + posterPath)!)
            let largeImageRequest = NSURLRequest(URL: NSURL(string: largeImageURL + posterPath)!)
            
            self.posterImageView.setImageWithURLRequest(
                smallImageRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = smallImage;
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        
                        self.posterImageView.alpha = 1.0
                        
                        }, completion: { (sucess) -> Void in
                            
                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                            // per ImageView. This code must be in the completion block.
                            self.posterImageView.setImageWithURLRequest(
                                largeImageRequest,
                                placeholderImage: smallImage,
                                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    
                                    self.posterImageView.image = largeImage;
                                    
                                },
                                failure: { (request, response, error) -> Void in
                                    // do something for the failure condition of the large image request
                                    // possibly setting the ImageView's image to a default image
                            })
                    })
                },
                failure: { (request, response, error) -> Void in
                    // do something for the failure condition
                    // possibly try to get the large image
            })

        }
        
        
        print(movie)

        // Do any additional setup after loading the view.
        
        
        //initially loading a low-res version of the poster
        
        
    
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
