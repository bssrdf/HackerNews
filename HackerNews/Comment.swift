//
//  Comment.swift
//  HackerNews
//
//  Created by Shanshan Wang on 11/10/19.
//  Copyright © 2019 Amit Burstein. All rights reserved.
//

import Foundation


class Comment{
  let by: String
  let kids : [Int]?
  
  let text: String?

  
    init(by: String, kids: [Int]?, text: String?){
    
    self.by = by
    self.kids = kids
    
    self.text = text
    
  }
}
