//
//  MatchesViewController.swift
//  TinderClone
//
//  Created by Vu Duong on 9/19/18.
//  Copyright © 2018 Vu Duong. All rights reserved.
//

import UIKit
import Parse

class MatchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var images: [UIImage] = []
    var userIds : [String] = []
    var messages : [String] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        if let query = PFUser.query() {
            query.whereKey("accepted", contains: PFUser.current()?.objectId)
            if let acceptedPeeps = PFUser.current()?["accepted"] as? [String] {
                query.whereKey("objectId", containedIn:acceptedPeeps )
                query.findObjectsInBackground { (objects, error) in
                    if let users = objects {
                        for user in users {
                            if let theUser = user as? PFUser {
                                if let imageFile = theUser["photo"] as? PFFile {
                                    imageFile.getDataInBackground(block: { (data, error) in
                                        if let imageData = data {
                                            if let image = UIImage(data: imageData) {
                                               
                                                if let objectId = theUser.objectId {
                                                    
                                                    let messageQuery = PFQuery(className: "Message")
                                                    
                                                    messageQuery.whereKey("recipient", equalTo: PFUser.current()?.objectId as Any)
                                                    messageQuery.whereKey("sender", equalTo: theUser.objectId as Any)
                                                    messageQuery.findObjectsInBackground(block: { (objects, error) in
                                                        var messageText = "No messages from this user"
                                                        if let objects = objects {
                                                            for message in objects {
                                                                if let content = message["content"] as? String {
                                                                    messageText = content
                                                                }
                                                            }
                                                        }
                                                        
                                                        self.messages.append(messageText)
                                                        self.userIds.append(objectId)
                                                        self.images.append(image)
                                                        self.tableView.reloadData()
                                                    })
                                                    
                                                }
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as? MatchTableViewCell {
            cell.messageLabel.text = "You havent recieved a message yet"
            cell.profileImageView.image = images[indexPath.row]
            cell.recipientIdObjectId = userIds[indexPath.row]
            cell.messageLabel.text = messages[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
    
}
