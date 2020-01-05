//
//  CommentsOrderOptionViewController.swift
//  HackerNews
//
//  Created by Shanshan Wang on 1/4/20.
//  Copyright © 2020 Amit Burstein. All rights reserved.
//

import UIKit

protocol CommentOrderOptionDelegate {
  func userPicked(_ order: CommentsSortOrder)
}

protocol RBOptionItem {
    var text: String { get }
    var image: String { get }
    var order: CommentsSortOrder { get }
    var font: UIFont { get set }
}

extension RBOptionItem {
    func sizeForDisplayText() -> CGSize {
      return text.size(withAttributes: [NSAttributedString.Key.font: font])
    }
}

struct SortByOptionItem: RBOptionItem {
    var text: String
    var font = UIFont.systemFont(ofSize: 15)
    var image: String
    var order: CommentsSortOrder
}

extension UITableViewCell {
  func configure(with optionItem: RBOptionItem, padlength: Int, pickedOrder: CommentsSortOrder) {
      
      //Create Attachment
      let imageAttachment =  NSTextAttachment()
      imageAttachment.image = UIImage(named: optionItem.image)
      //Set bound to reposition
       let lFontSize = round(optionItem.font.pointSize * 1.32)
       let lRatio = imageAttachment.image!.size.width / imageAttachment.image!.size.height
       imageAttachment.bounds = CGRect(x: 0, y: ((optionItem.font.capHeight - lFontSize) / 2).rounded(), width: lRatio * lFontSize, height: lFontSize)
      //Create string with attachment
      let attachmentString = NSAttributedString(attachment: imageAttachment)
      //Initialize mutable string
      let completeText = NSMutableAttributedString(string: "    ", attributes: [NSAttributedString.Key.font: optionItem.font])
      //Add image to mutable string
      completeText.append(attachmentString)
      //Add your text to mutable string
      let padText = optionItem.text.padding(toLength: padlength, withPad: " ", startingAt: 0)
      let  textAfterIcon = NSMutableAttributedString(string: padText, attributes: [NSAttributedString.Key.font: optionItem.font])
      textAfterIcon.append(completeText)
      textLabel?.textAlignment = .left
      textLabel?.attributedText = textAfterIcon
      accessoryType = optionItem.order == pickedOrder ? .checkmark : .none
    }
}

extension UILabel {
    /**
     This function adding image with text on label.

     - parameter text: The text to add
     - parameter image: The image to add
     - parameter imageBehindText: A boolean value that indicate if the imaga is behind text or not
     - parameter keepPreviousText: A boolean value that indicate if the function keep the actual text or not
     */
    func addTextWithImage(text: String, image: UIImage, imageBehindText: Bool, keepPreviousText: Bool) {
                    let lAttachment = NSTextAttachment()
        lAttachment.image = image

        // 1pt = 1.32px
        let lFontSize = round(self.font.pointSize * 1.32)
        let lRatio = image.size.width / image.size.height

        lAttachment.bounds = CGRect(x: 0, y: ((self.font.capHeight - lFontSize) / 2).rounded(), width: lRatio * lFontSize, height: lFontSize)

        let lAttachmentString = NSAttributedString(attachment: lAttachment)

        if imageBehindText {
            let lStrLabelText: NSMutableAttributedString

            if keepPreviousText, let lCurrentAttributedString = self.attributedText {
                lStrLabelText = NSMutableAttributedString(attributedString: lCurrentAttributedString)
                lStrLabelText.append(NSMutableAttributedString(string: text))
            } else {
                lStrLabelText = NSMutableAttributedString(string: text)
            }

            lStrLabelText.append(lAttachmentString)
            self.attributedText = lStrLabelText
        } else {
            let lStrLabelText: NSMutableAttributedString

            if keepPreviousText, let lCurrentAttributedString = self.attributedText {
                lStrLabelText = NSMutableAttributedString(attributedString: lCurrentAttributedString)
                lStrLabelText.append(NSMutableAttributedString(attributedString: lAttachmentString))
                lStrLabelText.append(NSMutableAttributedString(string: text))
            } else {
                lStrLabelText = NSMutableAttributedString(attributedString: lAttachmentString)
                lStrLabelText.append(NSMutableAttributedString(string: text))
            }

            self.attributedText = lStrLabelText
        }
    }

    func removeImage() {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}

class CommentsOrderOptionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
  
    let cellID = "CommentsSortOrder"
    var longestText = [Int]()
    var userPickedOrder = CommentsSortOrder.hierarchy
    let commentsSortOrder = [[SortByOptionItem(text: "Hierarchy", image:                         "SortHierarchy", order: .hierarchy),
                              SortByOptionItem(text: "Newest", image:  "SortAscending", order: .dateAscending),
                             SortByOptionItem(text: "Oldest", image:  "SortDescending", order: .dateDescending)
                             ]]
   
  
  private(set) weak var tableView: UITableView?
  var delegate: CommentOrderOptionDelegate?
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)
     for sec in commentsSortOrder{
        var l = 0
        for row in sec {
          l = max(l, row.text.count)
        }
        longestText.append(l)
     }
  }
  
  override func loadView() {
     view = UITableView(frame: .zero, style: UITableView.Style.plain)
      tableView = view as? UITableView
      tableView?.isScrollEnabled = false
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      tableView?.dataSource = self
      tableView?.delegate = self
      tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
      
      
      // from https://medium.com/@rohanbhale/simple-options-popover-14392eccb9f4
      // properly calculate the preferred content size
      let approxAccessoryViewWidth: CGFloat = 100
      let maxWidth = commentsSortOrder.flatMap{ $0 }.reduce(0) { $1.sizeForDisplayText().width + approxAccessoryViewWidth > $0 ? $1.sizeForDisplayText().width + 100 : $0 }
      let totalItems = CGFloat(commentsSortOrder.flatMap{ $0 }.count)
      let totalHeight = totalItems * 44
      preferredContentSize = CGSize(width: maxWidth, height: totalHeight)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
      
      
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return commentsSortOrder.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsSortOrder[section].count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: self.cellID)
      if cell == nil {
          cell = UITableViewCell(style: .value1, reuseIdentifier: self.cellID)
        
      }
        // Configure the cell...
      let item  = self.commentsSortOrder[indexPath.section][indexPath.row]
      cell!.configure(with: item, padlength: longestText[indexPath.section], pickedOrder:  self.userPickedOrder)
      return cell!
    }
  
   // MARK: UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let item = commentsSortOrder[indexPath.section][indexPath.row]
      delegate?.userPicked(item.order)
      dismiss(animated: true, completion: nil)
  }
    

}
