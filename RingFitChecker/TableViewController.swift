//
//  TableViewController.swift
//  RingFitChecker
//
//  Created by 宮下翔伍 on 2020/01/09.
//  Copyright © 2020 宮下翔伍. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

var datacontent:[String] = []
class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let ref = Database.database().reference()
    @IBOutlet weak var TableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datacontent.count
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            datacontent.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルを取得する
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Datecell",for: indexPath)
        cell.textLabel?.numberOfLines=0
        cell.textLabel!.text = datacontent[indexPath.row]
        return cell
    }
    
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
                    datacontent.append("\(snap.key) \n　　　　　　　　運動時間:\(time!)\n　　　　　　　　消費カロリー: \(cal!)")
                    self.TableView.reloadData() //データを受信したら更新
                }
            }
            // Do any additional setup after loading the view.
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
