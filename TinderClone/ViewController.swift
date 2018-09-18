//
//  ViewController.swift
//  TinderClone
//
//  Created by Vu Duong on 9/11/18.
//  Copyright © 2018 Vu Duong. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var swiftLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:)))
        swiftLabel.addGestureRecognizer(gesture)
        
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        PFUser.logOut()
        performSegue(withIdentifier: "logOutSegue", sender: nil)
    }
    
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        let labelPoint = gestureRecognizer.translation(in: view)
        swiftLabel.center = CGPoint(x: view.bounds.width / 2 + labelPoint.x, y: view.bounds.height / 2 + labelPoint.y)
        
        let xFromCenter = view.bounds.width / 2 - swiftLabel.center.x
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        
        let scale = min(100 / abs(xFromCenter), 1)
        
        var scaledAndRotated = rotation.scaledBy(x: scale, y: scale)
        
        swiftLabel.transform = scaledAndRotated
        
        
        if gestureRecognizer.state == .ended {
            if swiftLabel.center.x < (view.bounds.width / 2 - 100) {
                print("Not interested")
            }
            if swiftLabel.center.x > (view.bounds.width / 2 + 100) {
                print("Interested")
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            
            scaledAndRotated = rotation.scaledBy(x: 1, y: 1)
            
            swiftLabel.transform = scaledAndRotated
        
            swiftLabel.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
            
        }
    }

}

