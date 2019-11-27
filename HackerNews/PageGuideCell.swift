//
//  PageGuideCell.swift
//  HackerNews
//
//  Created by Shanshan Wang on 11/26/19.
//  Copyright © 2019 Amit Burstein. All rights reserved.
//

import UIKit

class PageGuideCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var prevButton: BorderedButton!
    
    @IBOutlet weak var nextButton: BorderedButton!
  
    var pageNumber: Int!{
      didSet{
        if self.pageNumber == 0 {
          self.prevButton.isHidden = true
        }
        else{
          self.prevButton.isHidden = false
        }
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    override func layoutSubviews() {
      super.layoutSubviews()

      
    }

}
