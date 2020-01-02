//
//  User.swift
//  HackerNews
//
//  Created by Shanshan Wang on 12/16/19.
//  Copyright © 2019 Amit Burstein. All rights reserved.
//

import Foundation
//import LCLib

class User {
   let name: String
   let id: Int
   var submitted = [Int]()
   init(name: String, id: Int){
     self.name = name
     self.id = id
   }
}
