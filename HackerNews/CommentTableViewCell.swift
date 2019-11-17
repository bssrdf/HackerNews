//
//  CommentTableViewCell.swift
//  HackerNews
//
//  Created by Shanshan Wang on 11/12/19.
//  Copyright © 2019 Amit Burstein. All rights reserved.
//

import UIKit

let CommentsCellId = "commentCellId"
let CommentCellMarginConstant: CGFloat = 8.0
let CommentCellTopMargin: CGFloat = 5.0
let CommentCellFontSize: CGFloat = 13.0
let CommentCellUsernameHeight: CGFloat = 25.0
let CommentCellBottomMargin: CGFloat = 5.0

class CommentTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var comment: Comment! {
        didSet {
          let username = comment.by+"  at level \(comment.level)"
          //let date = " - " + comment.prettyTime!

          let usernameAttributed = NSAttributedString(string: username,
                        attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: CommentCellFontSize),
                      NSAttributedString.Key.foregroundColor: UIColor.HNColor()])
          /*let dateAttribute = NSAttributedString(string: date,
                                                 attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CommentCellFontSize),
                                                              NSAttributedString.Key.foregroundColor: UIColor.DateLighGrayColor()])*/
          let fullAttributed = NSMutableAttributedString(attributedString: usernameAttributed)
          //fullAttributed.append(dateAttribute)

          self.commentTextView.font = UIFont.systemFont(ofSize: CommentCellFontSize)

          self.authorLabel.attributedText = fullAttributed
          self.commentTextView.text = comment.text
      }
  }

  
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var commentHeightConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var commentLeftMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var usernameLeftMarginConstrain: NSLayoutConstraint!
    
    
    //@IBOutlet weak var commentHeightConstrain: NSLayoutConstraint!
    
    //@IBOutlet weak var commentLeftMarginConstraint: NSLayoutConstraint!
    
    //@IBOutlet weak var usernameLeftMarginConstrain: NSLayoutConstraint!
    
  
  var indentation: CGFloat {
      didSet {
          self.commentLeftMarginConstraint.constant = indentation
          self.usernameLeftMarginConstrain.constant = indentation
          self.commentHeightConstrain.constant =
              self.contentView.frame.size.height - CommentCellUsernameHeight - CommentCellTopMargin - CommentCellMarginConstant + 5.0
          self.contentView.setNeedsUpdateConstraints()
      }
  }
  
  required init?(coder aDecoder: NSCoder) { // required for Xcode6-Beta5
      self.indentation = CommentCellMarginConstant
      super.init(coder: aDecoder)
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      self.indentation = CommentCellMarginConstant
      super.init(style: style, reuseIdentifier: reuseIdentifier)
  }


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.commentTextView.font = UIFont.systemFont(ofSize: CommentCellFontSize)
      //self.commentTextView.textColor = UIColor.CommentLightGrayColor()
      self.commentTextView.textColor = UIColor.black
      /*self.commentTextView.linkTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.font.rawValue: UIFont.systemFont(ofSize: CommentCellFontSize),
        NSAttributedString.Key.foregroundColor.rawValue: UIColor.ReadingListColor()] as [String:Any])*/

    }
  
   override func layoutSubviews() {
      super.layoutSubviews()

      self.commentTextView.text = comment.text
    //print("coment id: \(comment.id) with text: \(String(describing: comment.text))")

      self.commentTextView.textContainer.lineFragmentPadding = 0
      self.commentTextView.textContainerInset = UIEdgeInsets.zero
      self.commentTextView.contentInset = UIEdgeInsets.zero
    
      self.commentTextView.frame.size.width = self.contentView.bounds.width - (self.commentLeftMarginConstraint.constant * 2) - (CommentCellMarginConstant * CGFloat(self.comment.level))
    
      self.indentation = CommentCellMarginConstant + (CommentCellMarginConstant * CGFloat(self.comment.level))
  }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  
  class func heightForText(text: String, bounds: CGRect, level: Int) -> CGFloat {
          let size = text.boundingRect(with: CGSize(width: bounds.width - (CommentCellMarginConstant * 2) -
              (CommentCellMarginConstant * CGFloat(level)),
                      height: CGFloat.greatestFiniteMagnitude),
                  options: NSStringDrawingOptions.usesLineFragmentOrigin,
                  attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CommentCellFontSize)],
              context: nil)
          return CommentCellMarginConstant + CommentCellUsernameHeight + CommentCellTopMargin + size.height + CommentCellBottomMargin
  }
  
  // Helper function inserted by Swift 4.2 migrator.
  fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
      guard let input = input else { return nil }
      return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
  }

}
