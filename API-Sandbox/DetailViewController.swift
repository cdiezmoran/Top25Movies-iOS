//
//  ViewController.swift
//  API-Sandbox
//
//  Created by Dion Larson on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

class DetailViewController: UIViewController {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var rightsOwnerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movieData: JSON! {
        didSet {
            self.setMovie()
        }
    }
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setMovie() {
        if let data = movieData {
            movie = Movie(json: data)
            
            movieTitleLabel.text = movie.name
            rightsOwnerLabel.text = movie.rightsOwner
            releaseDateLabel.text = movie.releaseDate
            priceLabel.text = "$\(String(movie.price))"
            
            loadPoster(urlString: movie.poster)
        }
    }
    
    // Updates the image view when passed a url string
    func loadPoster(urlString: String) {
        posterImageView.af_setImage(withURL: URL(string: urlString)!)
    }
    
    @IBAction func viewOniTunesPressed(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: movie.link)!)
    }
    
}

extension DetailViewController: MovieSelectionDelegate {
    func movieSelected(newMovieData: JSON) {
        movieData = newMovieData
    }
}

