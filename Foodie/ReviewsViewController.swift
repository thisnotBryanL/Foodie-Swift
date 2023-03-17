//
//  ReviewsViewController.swift
//  Foodie
//
//  Created by BryanL on 3/17/23.
//

import UIKit
import CDYelpFusionKit

class ReviewsViewController: UITableViewController {
    
    private var reviews: [CDYelpReview] = []
    
    var restaurant: YelpRestaurant?
    let apiClient = CDYelpAPIClient(apiKey: YelpAPIConfig.apiKey)
    var selectedReview: CDYelpReview?
    var imgStr = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        loadReviews()
    }
    
    func loadReviews() {
        guard let restaurantId = restaurant?.business.id else { return }
        apiClient.fetchReviews(forBusinessId: restaurantId, locale: .english_unitedStates) { (response) in
            if let response = response,
               let fetchedReviews = response.reviews {
                self.reviews = fetchedReviews
                print(self.reviews)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedReview = reviews[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let reviewDetailsVC = storyboard.instantiateViewController(withIdentifier: "ReviewDetailsViewController") as? ReviewDetailsViewController {
            reviewDetailsVC.review = selectedReview
            reviewDetailsVC.ratingImage = UIImage(named: imgStr)

            navigationController?.pushViewController(reviewDetailsVC, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath)
        let review = reviews[indexPath.row]
        cell.textLabel?.text = review.user?.name
        cell.detailTextLabel?.text = review.text
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        
        let firstNumSpelledOut = formatter.string(for: review.rating)
        
        
        if let firstNumStr = firstNumSpelledOut{
            imgStr = "yelp_stars_" + firstNumStr + "_small"
            cell.imageView?.image = UIImage(named: imgStr)
        }
        return cell
    }
}

