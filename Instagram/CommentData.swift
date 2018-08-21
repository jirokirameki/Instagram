//
//  CommentData.swift
//  Instagram
//
//  Created by 浅尾栄志 on 2018/08/20.
//  Copyright © 2018年 jirokirameki. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CommentData: NSObject {
    var id: String?
    var uid: String?
    var name: String?
    var comment: String?
    var date: Date?
    
    init(snapshot: DataSnapshot) {
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: Any]

        self.uid = valueDictionary["uid"] as? String
        
        self.name = valueDictionary["name"] as? String
        
        self.comment = valueDictionary["comment"] as? String
        
        let time = valueDictionary["time"] as? String
        self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
    }
}
