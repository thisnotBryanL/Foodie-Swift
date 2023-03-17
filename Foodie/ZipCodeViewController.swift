//
//  ZipCodeViewController.swift
//  Foodie
//
//  Created by BryanL on 3/15/23.
//

import UIKit
import CoreLocation


protocol ZipCodeDelegate: AnyObject {
    func didUpdateZipCode(zipCode: String)
}

class ZipCodeViewController: UIViewController {

    @IBOutlet weak var zipCodeTextField: UITextField!

    weak var delegate: ZipCodeDelegate?

    // Clears numpad if background is touched when it's open
    @IBAction func backgroundTouched(_ sender: UIControl){
        zipCodeTextField.resignFirstResponder()
    }
    
    func isValidZipCode(zipCode: String) -> Bool {
        let zipCodeRegex = "^[0-9]{5}(-[0-9]{4})?$"
        let zipCodePredicate = NSPredicate(format: "SELF MATCHES %@", zipCodeRegex)
        return zipCodePredicate.evaluate(with: zipCode)
    }
    
    func isValidLocation(zipCode: String, completion: @escaping (Bool) -> Void) {
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(zipCode) { (placemarks, error) in
            if let _ = error {
                // The geocoding failed, probably not a valid location
                completion(false)
            } else if let placemarks = placemarks, !placemarks.isEmpty {
                // The geocoding succeeded, location is valid
                completion(true)
            } else {
                // No placemarks were found, probably not a valid location
                completion(false)
            }
        }
    }

    
    func showErrorAlert(_ errorType : String) {
        var alertTitle = "Invalid Zip Code"
        if(errorType == "LocationError"){
            alertTitle = "Invalid Location"
        }
        let alertController = UIAlertController(title: alertTitle, message: "Please enter a valid 5-digit zip code.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func updateZipCodeButtonTapped(_ sender: UIButton) {
        if let zipCode = zipCodeTextField.text, isValidZipCode(zipCode: zipCode) {
            isValidLocation(zipCode: zipCode, completion: {isValid in
                if isValid {
                    self.delegate?.didUpdateZipCode(zipCode: zipCode)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.showErrorAlert("LocationError")
                }
            })
        } else {
            showErrorAlert("InvalidStr")
        }
    }
}
