//
//  Comment.swift
//  HackerNews
//
//  Created by Shanshan Wang on 11/10/19.
//  Copyright © 2019 Amit Burstein. All rights reserved.
//

import Foundation


class Comment{
  let id: Int
  let by: String
  let kids : [Int]?
  
  let text: String?

  
  init(id: Int, by: String, kids: [Int]?, text: String?){
    self.id = id
    self.by = by
    self.kids = kids
    
    self.text = text
    
  }
}
