//
//  ZipCodeViewController.swift
//  Foodie
//
//  Created by BryanL on 3/15/23.
//

import UIKit

protocol ZipCodeDelegate: AnyObject {
    func didUpdateZipCode(zipCode: String)
}

class ZipCodeViewController: UIViewController {

    @IBOutlet weak var zipCodeTextField: UITextField!

    weak var delegate: ZipCodeDelegate?

    @IBAction func updateZipCodeButtonTapped(_ sender: UIButton) {
        if let zipCode = zipCodeTextField.text, !zipCode.isEmpty {
            delegate?.didUpdateZipCode(zipCode: zipCode)
            navigationController?.popViewController(animated: true)
        } else {
            // Show error message for empty zip code
        }
    }
}
