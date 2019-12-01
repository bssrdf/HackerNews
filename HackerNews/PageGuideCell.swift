//
//  PageGuideCell.swift
//  HackerNews
//
//  Created by Shanshan Wang on 11/26/19.
//  Copyright © 2019 Amit Burstein. All rights reserved.
//

import UIKit


let PageGuideCellButtonFontSize: CGFloat = 16.0

enum PageGuideActionType: Int{
  case Next = 1
  case Prev = -1
}

@objc protocol PageGuideCellDelegate{
  func pageGuideDidSelectButton(_ cell: PageGuideCell, actionType: Int)
}

class PageGuideCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var prevButton: BorderedButton!
    
    @IBOutlet weak var nextButton: BorderedButton!
  
    weak var cellDelegate: PageGuideCellDelegate?
  
    @IBOutlet weak var nextLeftMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nextRightMarginConstraint: NSLayoutConstraint!
    
    var nextLeftMargin: CGFloat!
    var nextRightMargin: CGFloat!
    
    
    var pageNumber: Int!{
      didSet{
        self.prevButton.isHidden = self.pageNumber == 0
        self.prevButton.onButtonTouch = {(sender: UIButton) in
            self.selectedAction(action: .Prev)
        }
        self.nextButton.onButtonTouch = {(sender: UIButton) in
            self.selectedAction(action: .Next)
        }
        
      }
    }
  
    var lastPage: Bool!{
        didSet {
            self.nextButton.isHidden = lastPage
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
        self.nextButton.labelFontSize = PageGuideCellButtonFontSize
        self.nextButton.borderWidth = 1
      
        self.prevButton.labelFontSize = PageGuideCellButtonFontSize
        self.prevButton.borderWidth = 1
        self.nextLeftMargin = self.nextLeftMarginConstraint.constant
        self.nextRightMargin = self.nextRightMarginConstraint.constant
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    func selectedAction(action: PageGuideActionType){
      self.cellDelegate?.pageGuideDidSelectButton(self, actionType: action.rawValue)
    }
  
    override func layoutSubviews() {
      super.layoutSubviews()
        if pageNumber == 0 {
          nextLeftMarginConstraint.constant = nextLeftMargin - 100
          nextRightMarginConstraint.constant = nextRightMargin + 100
          //CGFloat(self.contentView.bounds.width / 2)
        }
        else{
            nextLeftMarginConstraint.constant = nextLeftMargin
            nextRightMarginConstraint.constant = nextRightMargin
        }
    }

}
