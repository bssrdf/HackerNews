//
//  Story.swift
//  HackerNews
//
//  Created by Shanshan Wang on 11/10/19.
//  Copyright © 2019 Amit Burstein. All rights reserved.
//

import Foundation

struct Story {
  let id: Int
  let title: String
  let url: String?
  let by: String
  let kids : [Int]?
  let score: Int
  let time: Int?
  let prettyTime: String?
  let descendants: Int
}
