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
class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var TableView: UITableView!
    private let DataSource = RingDataModel()
    var num = 0
    
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
        DataSource.delegate = self
        DataSource.setDataWithResponse()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
extension TableViewController:DataModelDelegate{
    func RecieveDataUpdate(data: [DataModelItem]) {
        print("保存した数は\(data.count)です")
        for i in 0..<data.count{
            datacontent.append("\(data[i].date!)\n　　　　　　　運動時間：\(data[i].time!)\n　　　　　　　消費カロリー：\(data[i].cal!)")
        }
        TableView.reloadData()
        
    }
    func didUpdateError(error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
