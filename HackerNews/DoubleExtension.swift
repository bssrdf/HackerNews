//
//  DoubleExtension.swift
//  HackerNews
//
//  Created by Shanshan Wang on 11/25/19.
//  Copyright © 2019 Amit Burstein. All rights reserved.
//

import Foundation

extension Double {
  
  func timeIntervalAgo() -> String {

    let _ts = self
    //let date = NSDate(timeIntervalSince1970: _ts) as Date

//   let dayTimePeriodFormatter = DateFormatter()
   //dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"

 //let dateString = dayTimePeriodFormatter.string(from: date)
    let now = NSDate() as Date
    let timeInterval = now.timeIntervalSince1970
//let dateNowString = dayTimePeriodFormatter.string(from: now)
    let days = Int((timeInterval - (_ts))/86400.0)
    if days >= 1 {
      if days == 1 {
        return "\(days) day ago"
      }
      else{
        return "\(days) days ago"
      }
    }
    
    let hours = Int((timeInterval - (_ts))/3600.0)
    if hours >= 1 {
      if hours == 1 {
        return "\(hours) hour ago"
      }
      else{
        return "\(hours) hours ago"
      }
    }
    
    let minutes = Int((timeInterval - (_ts))/60.0)
       if minutes >= 1 {
         if minutes == 1 {
           return "\(minutes) minute ago"
         }
         else{
           return "\(minutes) minutes ago"
         }
       }
    return ""
 // print( " _ts value is \(_ts)")
  }
}
