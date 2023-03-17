//
//  ReviewDetailsViewController.swift
//  Foodie
//
//  Created by BryanL on 3/17/23.
//

import UIKit
import CDYelpFusionKit

class ReviewDetailsViewController: UIViewController {
    
    var review: CDYelpReview?
    var ratingImage: UIImage?
    
    @IBOutlet weak var ratingImageViewer : UIImageView!
    @IBOutlet weak var reviewDescription: UITextView!
    
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        displayReviewDetails()
    }

    func displayReviewDetails() {
        if let userReview = review{
            if let ratingImg = ratingImage{
                ratingImageViewer.image = ratingImg
            }
            reviewDescription.text = userReview.text
        }
    }
}

