//
//  MovieTableViewController.swift
//  API-Sandbox
//
//  Created by Carlos Diez on 10/19/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

protocol MovieSelectionDelegate: class {
    func movieSelected(newMovieData: JSON)
}

class MovieTableViewController: UITableViewController {
    
    weak var delegate: MovieSelectionDelegate?
    var allMoviesData = [JSON]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiToContact = "https://itunes.apple.com/us/rss/topmovies/limit=25/json"
        // This code will call the iTunes top 25 movies endpoint listed above
        Alamofire.request(apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    // Do what you need to with JSON here!
                    // The rest is all boiler plate code you'll use for API requests
                    
                    self.allMoviesData = json["feed"]["entry"].arrayValue
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMoviesData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieTableViewCell", for: indexPath) as! MovieTableViewCell
        
        let movieData = allMoviesData[indexPath.row]
        let movie = Movie(json: movieData)
        
        cell.movieTitleLabel.text = movie.name
        cell.priceLabel.text = "$\(movie.price)"
        cell.posterImageView.af_setImage(withURL: URL(string: movie.poster)!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = allMoviesData[indexPath.row]
        self.delegate?.movieSelected(newMovieData: selectedMovie)
        
        if let detailViewController = self.delegate as? DetailViewController {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
    }
}
