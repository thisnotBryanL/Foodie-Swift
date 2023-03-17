//
//  ClosestRestaurantsViewController.swift
//  Foodie
//
//  Created by BryanL on 3/16/23.
//

import UIKit
import CDYelpFusionKit

class ClosestRestaurantsViewController: UITableViewController {

    var closestRestaurants: [CDYelpBusiness.BusinessSearch] = []




    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return closestRestaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClosestRestaurantCell", for: indexPath)
        let restaurant = closestRestaurants[indexPath.row]
        if let foodTypeStr = restaurant.categories?[0].title, let restaurantName = restaurant.name{
            cell.textLabel?.text = restaurantName  + " (Type: " + foodTypeStr + ")"
        }else{
            cell.textLabel?.text = "Null"
        }
        
        cell.detailTextLabel?.text = "Miles away: " +  String(round((restaurant.distance! * 0.000621)*100)/100.0)
        return cell
    }
}

