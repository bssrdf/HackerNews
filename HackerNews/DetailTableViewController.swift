//
//  DetailTableViewController.swift
//  HackerNews
//
//  Created by Shanshan Wang on 11/12/19.
//  Copyright © 2019 Amit Burstein. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
  
    //MARK: Properties
  
    let FirebaseRef = "https://hacker-news.firebaseio.com/v0/"
    let ItemChildRef = "item"
    var story: Story?
    var comments: [Comment]?
    var firebase: Firebase!
    var retrievingComments: Bool!
    
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    firebase = Firebase(url: FirebaseRef)
    
    retrievingComments = false
  
  }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        retrieveComments()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      if let comments = comments{
        return comments.count
      }
      return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cellIdentifier = "CommentTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CommentTableViewCell else{
        fatalError("The dequeued cell is not an instance of CommentTableViewCell")
      }
      if let comments = comments{
         let comment = comments[indexPath.row]
         cell.authorLabel.text = comment.by
         cell.commentTextView.text = comment.text
        // Configure the cell...
      }
      return cell
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
  
  func extractComment(_ snapshot: FDataSnapshot) -> Comment {
    let data = snapshot.value as! Dictionary<String, Any>
    let id = data["id"] as! Int
    let by = data["by", default: "anonymous"] as! String
    let kids = data["kids"] as? [Int]
    let text = data["text"] as? String
    //print("author is "+by)
    return Comment(id: id, by: by, kids: kids, text: text)
  }
  
  func loadingFailed(_ error: Error?) -> Void {
    self.retrievingComments = false
    self.comments?.removeAll()
    self.tableView.reloadData()
    //self.showErrorMessage(self.FetchErrorMessage)
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
  
  func retrieveComment(root comment: Comment) -> Void{
    
    self.comments?.append(comment)
    
    if let kids = comment.kids{
       //var sortedComments = [Comment]()
       for kid in kids{
          let query = self.firebase.child(byAppendingPath: self.ItemChildRef).child(byAppendingPath: String(kid))
          query?.observeSingleEvent(of: .value, with: { snapshot in
           let childcomment = self.extractComment(snapshot!)
            self.retrieveComment(root: childcomment)
            
        }, withCancel: self.loadingFailed)
       }
    }
    
  }
  
  @objc func retrieveComments(){
    if retrievingComments! {
      return
    }
    
    if let story = story {
      comments?.removeAll()
      if let kids = story.kids{
      
      for id in kids{
         //print("first story's comment # \(id)")
         let query = self.firebase.child(byAppendingPath: self.ItemChildRef).child(byAppendingPath: String(id))
         query?.observeSingleEvent(of: .value, with: { snapshot in
          let comment = self.extractComment(snapshot!)
         
          self.retrieveComment(root: comment)
          }, withCancel: self.loadingFailed)
       }
      }
    }
    
  }

}
