//
//  ViewController.swift
//  Foodie
//
//  Created by BryanL on 3/15/23.
//

import UIKit
import CoreLocation
import CDYelpFusionKit

class HomeViewController: UIViewController, ZipCodeDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var foodTypeLabel : UILabel!
    
    @IBOutlet weak var zipCodeButton: UIButton!
    @IBOutlet weak var nearestRestaurantButton: UIButton!
    @IBOutlet weak var myLikes: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    let locationManager = CLLocationManager()

    
    private var restaurants: [CDYelpBusiness.BusinessSearch] = []
    private var likedRestaurants: [YelpRestaurant] = []
    
    private var resultRestaurant: [YelpRestaurant] = []
    
    private var currentIndex = 0
    private var currentZip = "0"
    
    let apiClient = CDYelpAPIClient(apiKey: YelpAPIConfig.apiKey)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


    }
    
    func loadRestaurants(_ zipcode:String) {
       
        apiClient.searchBusinesses(byTerm: "Food",
                                    location: zipcode,
                                    latitude: nil,
                                    longitude: nil,
                                    radius: 40000,
                                    categories: nil,
                                    locale: .english_unitedStates,
                                    limit: 50,
                                    offset: 0,
                                    sortBy: .bestMatch,
                                    priceTiers: nil,
                                    openNow: nil,
                                    openAt: nil,
                                    attributes: nil) { (response) in
            if let response = response,
               let businesses = response.businesses {
                self.restaurants = businesses
                DispatchQueue.main.async {
                    self.displayRestaurant()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            // Reverse geocode to get the zip code
            reverseGeocode(latitude: latitude, longitude: longitude)
        }
    }

    
    func reverseGeocode(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocode error: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first, let postalCode = placemark.postalCode {
                self.currentZip = postalCode
                self.loadRestaurants(postalCode)
            }
        }
    }

    
    func displayRestaurant() {
        let restaurant = restaurants[currentIndex]
        restaurantNameLabel.text = restaurant.name
        if let foodTypeStr = restaurant.categories?[0].title{
            foodTypeLabel.text = "Food Type: " + foodTypeStr
        }
        // Load the image from the imageURL and display it in the restaurantImageView
        if let imgStr = restaurant.imageUrl{
            let imgURL = URL(string: imgStr)
            if let unwrappedImgURL = imgURL{
                let session = URLSession(configuration: .default)
                
                // Download image from the URL given by API
                let downloadImageTask = session.dataTask(with: unwrappedImgURL) { (data, response, error) in
                    // The download has finished.
                    if let e = error {
                        print("Error downloading restaurant image: \(e)")
                    } else {
                        // No errors found.
                        if let imageData = data {
                            // Convert that Data into an image
                            DispatchQueue.main.async {
                                let image = UIImage(data: imageData)
                                
                                //Display image
                                self.restaurantImageView.image = image
                                
                                // Add image to wrapper class that will hold YelpBusiness object and Image of business
                                let restaurantWithImage = YelpRestaurant(business: restaurant, image: image)
                                self.resultRestaurant.append(restaurantWithImage)
                            }
                        } else {
                            // Still add wrapper class to result restaurant array bc this is the main array used
                            print("Couldn't get image: Image is nil")
                            let restaurantNoImage = YelpRestaurant(business: restaurant)
                            self.resultRestaurant.append(restaurantNoImage)
                        }
                    }
                }
                
                downloadImageTask.resume()
            }
        }
    }

    @IBAction func likeButtonTapped(_ sender: UIButton) {
        // Add the current restaurant to the list of liked restaurants
        likedRestaurants.append(resultRestaurant[currentIndex])
        
        // Increment currentIndex and display the next restaurant
        currentIndex = currentIndex + 1
        
        displayRestaurant()
    }
    
    @IBAction func dislikeButtonTapped(_ sender: UIButton) {
        // Increment currentIndex and display the next restaurant
        currentIndex = currentIndex + 1
        
        displayRestaurant()
    }
    
    
    func didUpdateZipCode(zipCode: String) {
        // Handle the updated zip code
        // based on the new zip code and reload the home screen
        restaurantNameLabel.text = "Loading new location..."
        
        // Update the list of restaurants
        loadRestaurants(zipCode)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "showMyLikes" {
               let myLikesVC = segue.destination as! MyLikesViewController
               myLikesVC.likedRestaurants = self.likedRestaurants
           }else if segue.identifier == "showZipCode" {
               let zipCodeVC = segue.destination as! ZipCodeViewController
               zipCodeVC.delegate = self}
        else if segue.identifier == "showNearest"{
            let closestVC = segue.destination as! ClosestRestaurantsViewController
            closestVC.closestRestaurants = self.restaurants.sorted {(a,b) -> Bool in
                return a.distance! < b.distance!}
//           } else if segue.identifier == "showMoreDetails" {
//               let moreDetailsVC = segue.destination as! MoreDetailsViewController
//               moreDetailsVC.restaurant = currentRestaurant
           }
       }
    
    
}

