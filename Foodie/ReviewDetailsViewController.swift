//
//  ReviewDetailsViewController.swift
//  Foodie
//
//  Created by BryanL on 3/17/23.
//

import UIKit
import CDYelpFusionKit

/*
    ReviewDetailsViewController
        This View controller displays more information about the reviews in an expanded form from the Review List.
 */
class ReviewDetailsViewController: UIViewController {
        
    @IBOutlet weak var ratingImageViewer : UIImageView!
    @IBOutlet weak var reviewDescription: UITextView!
    
    // Review Parameters passed from Table View
    var review: CDYelpReview?
    var ratingImage: UIImage?
    
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        displayReviewDetails()
    }

    // Display Review information on to the screen
    func displayReviewDetails() {
        if let userReview = review{
            if let ratingImg = ratingImage{
                // Displays Yelp stars
                ratingImageViewer.image = ratingImg
            }
            reviewDescription.text = userReview.text
        }
    }
}

