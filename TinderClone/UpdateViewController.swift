//
//  UpdateViewController.swift
//  TinderClone
//
//  Created by Vu Duong on 9/17/18.
//  Copyright © 2018 Vu Duong. All rights reserved.
//

import UIKit
import Parse

class UpdateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userGenderSwitch: UISwitch!
    @IBOutlet weak var interestedGenderSwitch: UISwitch!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
        
        if let isFemale = PFUser.current()?["isFemale"] as? Bool {
            userGenderSwitch.setOn(isFemale, animated: false)
        }
        
        if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] as? Bool {
            interestedGenderSwitch.setOn(isInterestedInWomen, animated: false)
        }
        
        if let photo = PFUser.current()?["photo"] as? PFFile {
            photo.getDataInBackground { (data, error) in
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        self.profileImageView.image = image
                    }
                }
            }
        }
    }
    
    func createWomen() {
        let imageUrls = ["https://tstotopix.files.wordpress.com/2014/01/lindsey_naegle.png","http://www.fanpop.com/images/polls/8619_4_full.jpg?v=1185157299","https://vignette.wikia.nocookie.net/simpsons/images/b/b0/Woman_resembling_Homer.png/revision/latest?cb=20141026204206","https://vignette.wikia.nocookie.net/doblaje/images/e/ee/Selma.png/revision/latest?cb=20131125003227&path-prefix=es","https://upload.wikimedia.org/wikipedia/en/7/76/Edna_Krabappel.png"]
        
        
        var counter = 0
        
        for imageURL in imageUrls {
            counter += 1
            if let url = URL(string: imageURL) {
                if let data = try? Data(contentsOf: url) {
                    let imageFile = PFFile(name: "photo.png", data: data)
                    let user = PFUser()
                    user["photo"] = imageFile
                    user.username = String(counter)
                    user.password = "abc123"
                    user["isFemale"] = true
                    user["isInterestedInWomen"] = false
                    
                    user.signUpInBackground { (success, error) in
                        if success {
                            print("Women User Created")
                        }
                    }
                    
                }
            }
        }
    }
    
    @IBAction func updateImageTapped(_ sender: Any) {
        //Create Vars for Camera
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateTapped(_ sender: Any) {
        
        PFUser.current()?["isFemale"] = userGenderSwitch.isOn
        PFUser.current()?["isInterestedInWomen"] = interestedGenderSwitch.isOn
        
        if let image = profileImageView.image {
            if let  imageData = UIImagePNGRepresentation(image){
                PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData)
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if error != nil {
                        var errorMessage = "Update Failed - Try Again"
                        if let newError = error as NSError? {
                            if let detailedError = newError.userInfo["error"] as? String {
                                errorMessage = detailedError
                            }
                        }
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = errorMessage
                    } else {
                        print("Update Successful")
                        self.performSegue(withIdentifier: "presentSwipeSegues", sender: nil)
                    }
                })
            }
        }
    }
}
