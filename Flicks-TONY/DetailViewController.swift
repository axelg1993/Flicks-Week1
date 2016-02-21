//
//  DetailViewController.swift
//  Flicks-TONY
//
//  Created by Axel Guzman on 2/14/16.
//  Copyright © 2016 Axel Guzman. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"]
        overviewLabel.text = overview as? String
        overviewLabel.sizeToFit()
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let SIbaseUrl = "https://image.tmdb.org/t/p/w45"
        let LIbaseUrl = "https://image.tmdb.org/t/p/original"
        
     if let posterPath = movie ["poster_path"] as? String{
       
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        posterImageView.setImageWithURL(imageUrl!)
       
        let smallImageRequest = NSURLRequest(URL: NSURL(string: SIbaseUrl + posterPath)!)
        let largeImageRequest = NSURLRequest(URL: NSURL(string: LIbaseUrl + posterPath)!)

        self.posterImageView.setImageWithURLRequest(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest: NSURLRequest, smallImageResponse: NSHTTPURLResponse?, smallImage: UIImage) -> Void in
                
                // smallImageResponse will be nil if the smallImage is already available
                // in cache (might want to do something smarter in that case).
    
                self.posterImageView.alpha = 0.0
                self.posterImageView.image = smallImage;
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.posterImageView.alpha = 1.0
                    }, completion: {(sucess) -> Void in
                        
                        // The AFNetworking ImageView Category only allows one request to be sent at a time
                        // per ImageView. This code must be in the completion block.
                        
                       self.posterImageView.setImageWithURLRequest(
                            largeImageRequest,
                            placeholderImage: smallImage,
                        success: { (largeImageRequest: NSURLRequest, largeImageResponse: NSHTTPURLResponse?, largeImage: UIImage) -> Void in
                            
                                self.posterImageView.image = largeImage;
                                
                        },
                            failure: { (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) -> Void in
                                // do something for the failure condition of the large image request
                                // possibly setting the ImageView's image to a default image
                        })
                })
            },
            failure: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                // possibly try to get the large image
        })
        }
            print(movie)
        
        // Do any additional setup after loading the view.
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
