//
//  MoreDetailsViewController.swift
//  Foodie
//
//  Created by BryanL on 3/17/23.
//

import UIKit

class MoreDetailsViewController: UIViewController {
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var opencloseLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var restaurant: YelpRestaurant?
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        displayRestaurantDetails()
    }

    func displayRestaurantDetails() {
        if let restaurantDetails = restaurant?.business{
            
            // Used to parse rating number from Yelp API response and turn it into a image path
            let formatter = NumberFormatter()
            formatter.numberStyle = .spellOut
            let ratingText = String(format: "%.1f", restaurantDetails.rating!)
            let ratingSplit = ratingText.components(separatedBy: ".")
            let firstNumSpelledOut = formatter.string(for: Int(ratingSplit[0]))
            var secondNumStr : String
            
            if ratingSplit[1] == "0"{
                secondNumStr = ""
            }else{
                secondNumStr = "half_"
            }
            
            
            if let firstNumStr = firstNumSpelledOut{
                let imgStr = "yelp_stars_" + firstNumStr + "_" + secondNumStr + "small"
                ratingImageView.image = UIImage(named: imgStr)
            }
            if let restaurantImg = restaurant?.image{
                restaurantImageView.image = restaurantImg
            }
            nameLabel.text = restaurantDetails.name
            priceLabel.text = restaurantDetails.price
            opencloseLabel.text = (restaurantDetails.isClosed! ? "Closed" : "Open")
            phoneLabel.text = restaurantDetails.displayPhone
            addressLabel.text = restaurantDetails.location?.addressOne
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "showReviews" {
           let reviewsVC = segue.destination as! ReviewsViewController
           reviewsVC.restaurant = self.restaurant
       }
    }
}

