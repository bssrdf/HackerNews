//
//  CommentsOrderOptionViewController.swift
//  HackerNews
//
//  Created by Shanshan Wang on 1/4/20.
//  Copyright © 2020 Amit Burstein. All rights reserved.
//

import UIKit

protocol RBOptionItem {
    var text: String { get }
    var isSelected: Bool { get set }
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
    var font = UIFont.systemFont(ofSize: 10)
    var image: String
    var isSelected: Bool
    var order: CommentsSortOrder
}

extension UITableViewCell {
    func configure(with optionItem: RBOptionItem) {
        textLabel?.text = optionItem.text
        textLabel?.font = optionItem.font
       imageView?.image = UIImage(named: optionItem.image)
      accessoryType = optionItem.isSelected ? .checkmark : .none
      //accessoryView? = UIImageView(image: UIImage(named: optionItem.image))
     // contentView.transform = CGAffineTransform(scaleX: -1,y: 1);
     // imageView?.transform = CGAffineTransform(scaleX: -1,y: 1);
      //textLabel?.transform = CGAffineTransform(scaleX: -1,y: 1);
      // textLabel.textAlignment = NSTextAlignmentRight; // optional
      
        //accessoryType = optionItem.isSelected ? .checkmark : .none
    }
}


class CommentsOrderOptionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    let cellID = "CommentsSortOrder"
  let commentsSortOrder = [[SortByOptionItem(text: "Hierarchy", image:  "SortHierarchy", isSelected: true, order: .hierarchy),
                            SortByOptionItem(text: "Newer", image:  "SortAscending", isSelected: false, order: .dateAscending),
                            SortByOptionItem(text: "Older", image:  "SortDescending", isSelected: false, order: .dateDescending),
                            SortByOptionItem(text: "Less Votes",
                                            image:  "SortAscending", isSelected: false, order: .voteAscending),
                            SortByOptionItem(text: "Most Votes", image:  "SortDescending", isSelected: false, order: .voteDescending)
    
      ]]
   
  
  private(set) weak var tableView: UITableView?
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
     // modalPresentationStyle = .popover
  }
  
  required init?(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)
      //fatalError("init(coder:) has not been implemented")
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
      
      let approxAccessoryViewWidth: CGFloat = 90
      let maxWidth = commentsSortOrder.flatMap{ $0 }.reduce(0) { $1.sizeForDisplayText().width + approxAccessoryViewWidth > $0 ? $1.sizeForDisplayText().width + 90 : $0 }
      let totalItems = CGFloat(commentsSortOrder.flatMap{ $0 }.count)
      let totalHeight = totalItems * 44
      preferredContentSize = CGSize(width: maxWidth, height: totalHeight)
     // preferredContentSize = CGSize(width: 150, height: 250)
      
      
      

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
      
      // var size = self.tableView.contentSize
      // size.width = 80.0 //Here, you can set the width.
      //self.preferredContentSize = size
     //   self.preferredContentSize = CGSize(width: 80, height: 80)
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
      return commentsSortOrder.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      return commentsSortOrder[section].count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: self.cellID)
      if cell == nil {
          cell = UITableViewCell(style: .default, reuseIdentifier: self.cellID)
        
      }
        // Configure the cell...
     let item  = self.commentsSortOrder[indexPath.section][indexPath.row]
      cell!.configure(with:item)
        return cell!
    }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     // let item = items[indexPath.section][indexPath.row]
     // delegate?.optionItemListViewController(self, didSelectOptionItem: item)
  }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
