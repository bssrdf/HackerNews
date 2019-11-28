//
//  StoryTableViewCell.swift
//  HackerNews
//
//  Created by Shanshan Wang on 11/17/19.
//  Copyright © 2019 Amit Burstein. All rights reserved.
//

import UIKit

let NewsCellsId = "newsCellId"
//let NewsCellHeight: CGFloat = 110.0
let NewsCellHeight: CGFloat = 100.0
let NewsCellTitleMarginConstant: CGFloat = 16.0
let NewsCellTitleFontSize: CGFloat = 25.0
let NewsCellUrlFontSize: CGFloat = 16.0
let NewsCellButtonFontSize: CGFloat = 11.0
let NewsCellTitleDefaultHeight: CGFloat = 20.0

class StoryTableViewCell: UITableViewCell {
    
    //MARK: Properties
     
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var voteLabel: BorderedButton!
    @IBOutlet weak var commentsLabel: BorderedButton!
    @IBOutlet weak var usernameLabel: BorderedButton!
    
    @IBOutlet weak var titleMarginConstrain: NSLayoutConstraint!
    
  var post: Story! {
      didSet{
          self.titleLabel.text = self.post.title
          self.titleLabel.numberOfLines = 0
        //if let _time = self.post.time {
            //  let date = Date(timeIntervalSince1970: TimeInterval(_time))
          if let link = self.post.url{
            //self.urlLabel.text = url
            let url = URL(string: link)
            if let domain = url?.host {
            //let domain = self.extractDomainFromURL(url)
               let input = domain + " - " + self.post.prettyTime!
               let commentAttributed = NSAttributedString(string: input,
                                   attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: NewsCellUrlFontSize),
                                 NSAttributedString.Key.foregroundColor: UIColor.CommentLightGrayColor()])
               let attributedString = NSMutableAttributedString(attributedString: commentAttributed)
               //let nsrange = NSMakeRange(0, domain.count)
               //attributedString.setAttributes([.link: url!], range: nsrange)
              self.urlLabel.attributedText = attributedString
              
            }
            else{
              self.urlLabel.text = link+" - " + self.post.prettyTime!
              self.urlLabel.font = UIFont.systemFont(ofSize: NewsCellUrlFontSize)
              self.urlLabel.textColor = UIColor.CommentLightGrayColor()
            }
          }
          else{
             self.urlLabel.text = " - " + self.post.prettyTime!
             self.urlLabel.font = UIFont.systemFont(ofSize: NewsCellUrlFontSize)
             self.urlLabel.textColor = UIColor.CommentLightGrayColor()
          }
          
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
  
  required init?(coder aDecoder: NSCoder) { // required for Xcode6-Beta5
      super.init(coder: aDecoder)
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
  }



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      self.voteLabel.labelFontSize = NewsCellButtonFontSize
      self.commentsLabel.labelFontSize = NewsCellButtonFontSize
      self.usernameLabel.labelFontSize = NewsCellButtonFontSize
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  override func layoutSubviews() {
      super.layoutSubviews()

      self.titleLabel.preferredMaxLayoutWidth = self.contentView.bounds.width - (self.titleMarginConstrain.constant * 2)
  }


  class func heightForText(text: NSString, bounds: CGRect) -> CGFloat {
      let size = text.boundingRect(with: CGSize(width: bounds.width - (NewsCellTitleMarginConstant * 2), height: CGFloat.greatestFiniteMagnitude),
                                   options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                   attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: NewsCellTitleFontSize)],
          context: nil)
      return size.height > NewsCellTitleDefaultHeight ?  NewsCellHeight + size.height - NewsCellTitleDefaultHeight : NewsCellHeight
  }

}
