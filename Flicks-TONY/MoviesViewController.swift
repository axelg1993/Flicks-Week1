//
//  MoviesViewController.swift
//  Flicks-TONY
//
//  Created by Axel Guzman on 2/3/16.
//  Copyright © 2016 Axel Guzman. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
      
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
       
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        networkRequest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.magentaColor()
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! Movie_Cell
        let movie = movies![indexPath.row]
        let title = movie ["title"] as! String
        let overview = movie ["overview"] as! String
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.selectedBackgroundView = backgroundView
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let imageRequest = NSURLRequest(URL: NSURL(string: baseUrl)!)
       
        if let posterPath = movie ["poster_path"] as? String{
            let imageUrl = NSURL(string: baseUrl + posterPath)
            
            cell.posterView.setImageWithURL(imageUrl!)
        }
        
        cell.posterView.setImageWithURLRequest(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = image
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        cell.posterView.alpha = 1.0
                    })}
                else {
                    print("Image was cached so just update the image")
                    cell.posterView.image = image
                }},
            
            failure: { (imageRequest, imageResponse, error) -> Void in})

        print ("row \(indexPath.row)")
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func networkRequest(){
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
                            
                            self.movies = responseDictionary["results"] as?  [NSDictionary]
                            print("response: \(responseDictionary)")
                            self.tableView.reloadData()
                            
                            
                            self.refreshControl.endRefreshing()
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
                }
        }
        )
        task.resume()
    }
   
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
                        // Reload the tableView now that there is new data
                self.tableView.reloadData()
                
                // Tell the refreshControl to stop spinning
                refreshControl.endRefreshing()	
    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
       
    let detailViewController = segue.destinationViewController as! DetailViewController
     detailViewController.movie = movie
        
        print("prepare for segue called")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
