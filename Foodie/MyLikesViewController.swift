//
//  MyLikesViewController.swift
//  Foodie
//
//  Created by BryanL on 3/16/23.
//

import UIKit
import CDYelpFusionKit

class MyLikesViewController: UITableViewController {

    var likedRestaurants: [YelpRestaurant] = []
    var selectedRestaurant: YelpRestaurant?
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedRestaurants.count
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRestaurant = likedRestaurants[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let moreDetailsVC = storyboard.instantiateViewController(withIdentifier: "MoreDetailsViewController") as? MoreDetailsViewController {
            moreDetailsVC.restaurant = selectedRestaurant
            navigationController?.pushViewController(moreDetailsVC, animated: true)
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikedRestaurantCell", for: indexPath)
        let restaurant = likedRestaurants[indexPath.row].business
        cell.textLabel?.text = restaurant.name
        cell.detailTextLabel?.text = restaurant.location?.addressOne
        if let image = likedRestaurants[indexPath.row].image{
            cell.imageView?.image = image
        }
        
        return cell
    }
    

}

