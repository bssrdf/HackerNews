//
//  CommentTableViewCell.swift
//  HackerNews
//
//  Created by Shanshan Wang on 11/12/19.
//  Copyright © 2019 Amit Burstein. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
