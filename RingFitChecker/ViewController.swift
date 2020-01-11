//
//  ViewController.swift
//  RingFitChecker
//
//  Created by 宮下翔伍 on 2020/01/08.
//  Copyright © 2020 宮下翔伍. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class ViewController: UIViewController{
   
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = Auth.auth().currentUser?.uid
        self.ref.child("ringdata").observeSingleEvent(of: .value, with: { (snapshot) in
            print("success")
            for folder in snapshot.children {
                if let snap = folder as? DataSnapshot {
                    let datalist = snap.value as? Dictionary<String, String>
                    let time = datalist!["time"]
                    let cal = datalist!["cal"]
                    print(snap.key,time)
                   // print(time)
                }
            }
            // Do any additional setup after loading the view.
        })
        
    }
}

