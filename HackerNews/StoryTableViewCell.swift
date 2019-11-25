//
//  StoryTableViewCell.swift
//  HackerNews
//
//  Created by Shanshan Wang on 11/17/19.
//  Copyright © 2019 Amit Burstein. All rights reserved.
//

import UIKit

let NewsCellsId = "newsCellId"
let NewsCellHeight: CGFloat = 110.0
let NewsCellTitleMarginConstant: CGFloat = 16.0
let NewsCellTitleFontSize: CGFloat = 16.0
let NewsCellTitleDefaultHeight: CGFloat = 20.0

class StoryTableViewCell: UITableViewCell {
    
    //MARK: Properties
     
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var voteLabel: BorderedButton!
    @IBOutlet weak var commentsLabel: BorderedButton!
    @IBOutlet weak var usernameLabel: BorderedButton!
    
    
  var post: Story! {
      didSet{
          self.titleLabel.text = self.post.title
        //if let _time = self.post.time {
            //  let date = Date(timeIntervalSince1970: TimeInterval(_time))
          self.urlLabel.text = self.post.url!
            //  self.urlLabel.text = self.post.domain! + " - " + date.timeAgo
          //}
          //else {
          //    self.urlLabel.text = self.post.domain! + " - " + self.post.prettyTime!
          //}
          self.voteLabel.labelText = String(self.post.score) + " votes"
          self.commentsLabel.labelText = String(self.post.descendants) + " comments"
          self.usernameLabel.labelText = self.post.by

          /*self.voteLabel.onButtonTouch = {(sender: UIButton) in
              self.selectedAction(action: .Vote)
          }

          self.commentsLabel.onButtonTouch = {(sender: UIButton) in
              self.selectedAction(action: .Comment)
          }

          self.usernameLabel.onButtonTouch = {(sender: UIButton) in
              self.selectedAction(action: .Username)
          }
          if self.readLaterIndicator != nil {
              self.readLaterIndicator.isHidden = !Preferences.sharedInstance.isInReadingList(uid: self.post.postId!)
          }*/
      }
  }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  class func heightForText(text: NSString, bounds: CGRect) -> CGFloat {
      let size = text.boundingRect(with: CGSize(width: bounds.width - (NewsCellTitleMarginConstant * 2), height: CGFloat.greatestFiniteMagnitude),
                                   options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                   attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: NewsCellTitleFontSize)],
          context: nil)
      return size.height > NewsCellTitleDefaultHeight ?  NewsCellHeight + size.height - NewsCellTitleDefaultHeight : NewsCellHeight
  }

}
