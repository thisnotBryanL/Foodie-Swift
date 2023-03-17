//
//  YelpRestaurant.swift
//  Foodie
//
//  Created by BryanL on 3/16/23.
//

import Foundation
import CDYelpFusionKit
import UIKit

// Wrapper class used to store image with Business API object
struct YelpRestaurant {
    let business: CDYelpBusiness.BusinessSearch
    var image: UIImage?
    
    init(business: CDYelpBusiness.BusinessSearch, image: UIImage? = nil){
        self.business = business
        self.image = image
    }
}
