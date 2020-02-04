//
//  RingFitDataModel.swift
//  RingFitChecker
//
//  Created by 宮下翔伍 on 2020/01/19.
//  Copyright © 2020 宮下翔伍. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth


class DataModelItem{
    var cal:String?
    var time:String?
    var date:String?
    init?(datalist:Dictionary<String,String>?){
        if let datalist = datalist, let callory = datalist["cal"], let activetime = datalist["time"]{
            self.cal = callory
            self.time = activetime
        }
        else{
            return nil
        }
    }
}
protocol DataModelDelegate{
    func RecieveDataUpdate(data:[DataModelItem])
    func didUpdateError(error:Error)
}

class RingDataModel:NSObject {
    var delegate: DataModelDelegate?
    func setDataWithResponse(){
        var count = 0
        var data = [DataModelItem]()
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("ringdata").observeSingleEvent(of: .value, with: { (snapshot) in
            print("success")
            for folder in snapshot.children {
                if let snap = folder as? DataSnapshot {
                    if let tableViewModel = DataModelItem(datalist: snap.value as? Dictionary<String,String>){
                        data.append(tableViewModel)
                        data[count].date = snap.key
                        print(data)
                        print(data[count].date)
                        count+=1
                        print(count)
                    }
                }
            }
            print("complete")
            print("installed=\(data)")
            self.delegate?.RecieveDataUpdate(data: data)
            // Do any additional setup after loading the view.
        })
    }
}

extension Notification.Name {
    static let dataInstalled = Notification.Name("datainstalled")
}

