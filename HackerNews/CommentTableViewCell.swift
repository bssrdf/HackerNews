//
//  CommentTableViewCell.swift
//  HackerNews
//
//  Created by Shanshan Wang on 11/12/19.
//  Copyright © 2019 Amit Burstein. All rights reserved.
//

import UIKit

let CommentsCellId = "commentCellId"
let CommentCellMarginConstant: CGFloat = 10.0
let CommentCellTopMargin: CGFloat = 10.0
let CommentCellFontSize: CGFloat = 16.0
let CommentCellUsernameHeight: CGFloat = 25.0
let CommentCellBottomMargin: CGFloat = 10.0


class CommentTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var comment: Comment! {
        didSet {
          let username = comment.by
          let date = " - " + comment.prettyTime!

          let usernameAttributed = NSAttributedString(string: username,
                        attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: CommentCellFontSize),
                      NSAttributedString.Key.foregroundColor: UIColor.HNColor()])
          let dateAttribute = NSAttributedString(string: date,
                                                 attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CommentCellFontSize),
                                                              NSAttributedString.Key.foregroundColor: UIColor.DateLighGrayColor()])
          let fullAttributed = NSMutableAttributedString(attributedString: usernameAttributed)
          fullAttributed.append(dateAttribute)

          let indentation = CommentCellMarginConstant + (CommentCellMarginConstant * CGFloat(self.comment.level))
          self.usernameLeftMarginContraint.constant = indentation
          self.commentLeftMarginContraint.constant = indentation
          

          self.authorLabel.attributedText = fullAttributed
          self.commentTextView.attributedText = self.URLAttributedText(input: comment.text!)
          self.commentTextView.linkTextAttributes = [NSAttributedString.Key.font: //UIFont.systemFont(ofSize: CommentCellFontSize),
            UIFont.systemFont(ofSize: 25),
          NSAttributedString.Key.foregroundColor: UIColor.ReadingListColor()]
          
      }
  }

  
    
    //@IBOutlet weak var authorLabel: UILabel!
    
    // The key to get Auto Layout working on a UITableViewCell is to ensure that you have constraints to pin each subview on all sides — that is, each subview should have leading, top, trailing and bottom constraints. Then, the intrinsic height of the subviews will be used to dictate the height of each cell.
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    
    // These constraints are used to indent deeper level comments
    @IBOutlet weak var usernameLeftMarginContraint: NSLayoutConstraint!
  
    @IBOutlet weak var commentLeftMarginContraint: NSLayoutConstraint!
    
  
  
    
  
 /* var indentation: CGFloat {
      didSet {
          self.commentLeftMarginConstraint.constant = indentation
         // self.usernameLeftMarginConstrain.constant = indentation
         /* self.commentHeightConstrain.constant =
              self.contentView.frame.size.height - CommentCellUsernameHeight - CommentCellTopMargin -
                  CommentCellMarginConstant + 5.0*/
            
          //self.contentView.setNeedsUpdateConstraints()
      }
  }*/
  
  /*required init?(coder aDecoder: NSCoder) { // required for Xcode6-Beta5
     // self.indentation = CommentCellMarginConstant
      super.init(coder: aDecoder)
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    //  self.indentation = CommentCellMarginConstant
      super.init(style: style, reuseIdentifier: reuseIdentifier)
  }*/


    
    /*override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.commentTextView.layer.borderColor = UIColor.black.cgColor
        //self.commentTextView.layer.borderWidth = 1
        self.commentTextView.font = UIFont.systemFont(ofSize: CommentCellFontSize)
      self.commentTextView.textColor = UIColor.CommentLightGrayColor()
      self.commentTextView.linkTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: //CommentCellFontSize),
          25),
         NSAttributedString.Key.foregroundColor: UIColor.ReadingListColor()]

    }*/
  
  /* override func layoutSubviews() {
      super.layoutSubviews()

      //self.commentTextView.text = comment.text
    //print("coment id: \(comment.id) with text: \(String(describing: comment.text))")

      /*self.commentTextView.textContainer.lineFragmentPadding = 0
      self.commentTextView.textContainerInset = UIEdgeInsets.zero
      self.commentTextView.contentInset = UIEdgeInsets.zero*/
    
      
      //if comment.by == "williamdclt"{
      /*if comment.by == "colllectorof"{
         let x = self.contentView.bounds.width - (self.commentLeftMarginConstraint.constant * 2) - (CommentCellMarginConstant * CGFloat(self.comment.level))
        print("layoutSubviews : \(comment.text!.count) - \(comment.level) - \(x)")
        print("layoutSubviews : \(self.contentView.bounds.width) - \(self.commentLeftMarginConstraint.constant)")
      }*/
      /*self.commentTextView.frame.size.width = self.contentView.bounds.width - (self.commentLeftMarginConstraint.constant * 1) -
         (CommentCellMarginConstant * CGFloat(self.comment.level))*/
    
   //   self.indentation = CommentCellMarginConstant + (CommentCellMarginConstant * CGFloat(self.comment.level))
     /*if comment.by == user_debug{
       print("layoutSubviews const: \(self.commentHeightConstrain.constant)")
      print("layoutSubviews size.height : \(self.commentTextView.frame.size.height)")
      print("layoutSubviews author height: \(self.authorLabel.frame.size.height)")
     }*/
    
  }*/


    /*override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  */
  
   func URLAttributedText(input: String) -> NSMutableAttributedString {
    //let input = comment.text!
    let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
    let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
    let commentAttributed = NSAttributedString(string: input,
                           attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CommentCellFontSize),
                         NSAttributedString.Key.foregroundColor: UIColor.CommentLightGrayColor()])
    let attributedString = NSMutableAttributedString(attributedString: commentAttributed)
    
      for match in matches {
        guard let range = Range(match.range, in: input) else { continue }
        let url = String(input[range])
        if let link = URL(string: url) {
         
          let startPos = input.distance(from: url.startIndex, to: range.lowerBound)

          let nsrange = NSMakeRange(startPos, url.count)
            attributedString.setAttributes([.link: link], range: nsrange)
        }
       }
    return attributedString
  }
  
  class func heightForText(text: String, bounds: CGRect, level: Int, author: String) -> CGFloat {
      
          let size = text.boundingRect(with: CGSize(width: bounds.width - (CommentCellMarginConstant * 1) -
            
              (CommentCellMarginConstant * CGFloat(level)),
                      height: CGFloat.greatestFiniteMagnitude),
                  //options: NSStringDrawingOptions.usesLineFragmentOrigin,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
                  attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CommentCellFontSize)
                       ],
              context: nil)
      
    return CommentCellMarginConstant + CommentCellUsernameHeight + CommentCellTopMargin + ceil(size.height) + CommentCellBottomMargin
  }
  

}
