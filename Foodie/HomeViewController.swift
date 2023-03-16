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
    
    @IBOutlet weak var zipCodeButton: UIButton!
    @IBOutlet weak var nearestRestaurantButton: UIButton!
    @IBOutlet weak var myLikes: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    let locationManager = CLLocationManager()

    
    private var restaurants: [CDYelpBusiness.BusinessSearch] = []
    private var currentIndex = 0
    private var currentZip = "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
        
        title = "Home"
        view.backgroundColor = UIColor.systemBackground


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


    }
    
    func loadRestaurants(_ zipcode:String) {
        let apiClient = CDYelpAPIClient(apiKey: YelpAPIConfig.apiKey)
        apiClient.searchBusinesses(byTerm: "restaurants",
                                    location: zipcode,
                                    latitude: nil,
                                    longitude: nil,
                                    radius: 80000,
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
                print(self.restaurants)
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
        print("Heeeer")
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocode error: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first, let postalCode = placemark.postalCode {
                self.currentZip = postalCode
            }
        }
        if let initialZipCode = UserDefaults.standard.string(forKey: "initialZipCode") {
            print("Initial zip code: \(initialZipCode)")
        }
    }

    
    func displayRestaurant() {
        let restaurant = restaurants[currentIndex]
        restaurantNameLabel.text = restaurant.name
        // Load the image from the imageURL and display it in the restaurantImageView
    }

    @IBAction func likeButtonTapped(_ sender: UIButton) {
        // Add the current restaurant to the list of liked restaurants
        // Increment currentIndex and display the next restaurant
    }
    
    @IBAction func dislikeButtonTapped(_ sender: UIButton) {
        // Increment currentIndex and display the next restaurant
    }
    
    @IBAction func unwindFromZipCode(_ unwindSegue: UIStoryboardSegue) {
        // Perform any additional actions needed when returning from ZipCodeViewController
    }
    
    func didUpdateZipCode(zipCode: String) {
        // Handle the updated zip code, e.g., update the list of restaurants
        // based on the new zip code and reload the home screen
        
        print(zipCode)
        restaurantNameLabel.text = zipCode
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//           if segue.identifier == "showMyLikes" {
//               let myLikesVC = segue.destination as! MyLikesViewController
//               myLikesVC.likedRestaurants = likedRestaurants
//           } else
        if segue.identifier == "showZipCode" {
               let zipCodeVC = segue.destination as! ZipCodeViewController
               zipCodeVC.delegate = self
//           } else if segue.identifier == "showMoreDetails" {
//               let moreDetailsVC = segue.destination as! MoreDetailsViewController
//               moreDetailsVC.restaurant = currentRestaurant
           } // Add more cases for other segues if needed
       }
    
    
}

