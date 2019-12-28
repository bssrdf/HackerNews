//
//  DetailTableViewController.swift
//  HackerNews
//
//  Created by Shanshan Wang on 11/12/19.
//  Copyright © 2019 Amit Burstein. All rights reserved.
//

import UIKit
import SafariServices

class DetailTableViewController: UITableViewController,
      SFSafariViewControllerDelegate {
  
    //MARK: Properties
  
    let FirebaseRef = "https://hacker-news.firebaseio.com/v0/"
    let ItemChildRef = "item"
    var story: Story?
    var comments = [Comment]()
    var commentsMap = [Int:Comment]()
    var firebase: Firebase!
    var retrievingComments: Bool!
    var cellHeightCache: [CGFloat] = []
    
  
  
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
        if story!.descendants == 0 {
          self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        }
        // https://www.raywenderlich.com/8549-self-sizing-table-view-cells
        // When you set the row height as UITableViewAutomaticDimension, the table view is told to use the Auto Layout constraints and the contents of its cells to determine each cell’s height.

        //In order for the table view to do this, you must also provide an estimatedRowHeight. In this case, 600 is just an arbitrary value that works well in this particular instance. For your own projects, you should pick a value that better conforms to the type of data that you’ll display.
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      if section == 0 {
        return 1
      }
        // #warning Incomplete implementation, return the number of rows
      //if let comments = comments{
      //print("# of comments is \(comments.count)")
      return comments.count
      //}
      //return 0
    }
  
    /*override func tableView(_ tableView: UITableView,
             heightForRowAt indexPath: IndexPath) -> CGFloat {
      if (indexPath.section == 0) {
          let title: NSString = self.story!.title as NSString
          return StoryTableViewCell.heightForText(text: title, bounds: self.tableView.bounds)
      }
       //let comment = comments[indexPath.row]
      //print("\(comment.by): \(self.cellHeightCache[indexPath.row])")
      return self.cellHeightCache[indexPath.row] as CGFloat
     
   }*/
   /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
      if (indexPath.section == 0) {
          let title: NSString = self.post.title! as NSString
          return NewsCell.heightForText(text: title, bounds: self.tableView.bounds)
      }
      return self.cellHeightCache[indexPath.row] as CGFloat
  }*/

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
          let cellIdentifier = "StoryTableViewCell"
          guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? StoryTableViewCell else{
            fatalError("The dequeued cell is not an instance of StoryTableViewCell")
          }
            cell.post = self.story
            //cell!.cellDelegate = self;
            return cell
        }
      
        let cellIdentifier = "CommentTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CommentTableViewCell else{
            fatalError("The dequeued cell is not an instance of CommentTableViewCell")
        }
      if comments.count > 0 {
         let comment = comments[indexPath.row]
         cell.comment = comment
        // Configure the cell...
      }
      return cell
    }
  
  // MARK: UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if (indexPath.section == 0) {
      tableView.deselectRow(at: indexPath, animated: true)
      
      let story = self.story!
      if let url = story.url {
        let webViewController = SFSafariViewController(url: URL(string: url)!)
        webViewController.delegate = self
        present(webViewController, animated: true, completion: nil)
      }
    }
  }
  
  // MARK: SFSafariViewControllerDelegate
  
  func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    controller.dismiss(animated: true, completion: nil)
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
  
  func cacheHeight() {
    cellHeightCache = []
    for comment in self.comments{
      let height = CommentTableViewCell.heightForText(text: comment.text!, bounds: self.tableView.bounds, level: comment.level, author: comment.by)
      //let height = CGFloat(0.0)
      cellHeightCache.append(height)
    }
  }
  
  func extractComment(_ snapshot: FDataSnapshot) -> Comment? {
    if snapshot.value is NSNull {
       return nil
    }
    let data = snapshot.value as! Dictionary<String, Any>
    let id = data["id"] as! Int
    let time = data["time"] as! Int
    let prettyTime = Double(time).timeIntervalAgo()
    var by: String
    if let author = data["by"] as? String {
       by = author
    }
    else{ // most likely the comment has been deleted by the author
          // make up a deleted comment
       return Comment(id: id, by: "deleted", kids: [], text: "", time: time, prettyTime: prettyTime)
    }
    let kids = data["kids"] as? [Int]
    var text = ""
    if let htmltext = data["text"] as? String {
      text = String.stringByRemovingHTMLEntities(htmltext)
    }
    return Comment(id: id, by: by, kids: kids, text: text, time: time, prettyTime: prettyTime)
  }
  
  func loadingFailed(_ error: Error?) -> Void {
    self.retrievingComments = false
    self.comments.removeAll()
    self.tableView.reloadData()
    //self.showErrorMessage(self.FetchErrorMessage)
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
  
  func addChildComment(_ comment: Comment, depth: Int){
      comment.level = depth
      self.comments.append(comment)
      self.commentsMap.removeValue(forKey: comment.id)
      if let kids = comment.kids {
        for id in kids {
          if let childcomment = self.commentsMap[id] {
            self.addChildComment(childcomment, depth: depth+1)
          }
        }
    }
    
  }
  
  
  func retrieveComment(root comment: Comment) -> Void{
    
    self.commentsMap[comment.id] = comment
    
    if let kids = comment.kids{
       for kid in kids{
          let query = self.firebase.child(byAppendingPath: self.ItemChildRef).child(byAppendingPath: String(kid))
          query?.observeSingleEvent(of: .value, with: { snapshot in
            if let childcomment = self.extractComment(snapshot!){
               self.retrieveComment(root: childcomment)
            }else{
              print("failed to extract comment with id \(kid)")
            }
            if self.commentsMap.count == self.story!.descendants{
              for id in self.story!.kids! {
                if let childcomment = self.commentsMap[id] {
                  self.addChildComment(childcomment, depth: 0)
                }
                else{
                  print("problem id is \(id)")
                }
              }
              self.retrievingComments = false
              self.tableView.reloadData()
              UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
        }, withCancel: self.loadingFailed)
       }
    }
    
  }
  

  
  @objc func retrieveComments(){
    if retrievingComments! {
      return
    }
    
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    retrievingComments = true
    
    if let story = story {
      comments.removeAll()
      commentsMap.removeAll()
      if let kids = story.kids{
        for id in kids{
         let query = self.firebase.child(byAppendingPath: self.ItemChildRef).child(byAppendingPath: String(id))
         query?.observeSingleEvent(of: .value, with: { snapshot in
          if let comment = self.extractComment(snapshot!) {
            self.retrieveComment(root: comment)
          }
          if self.commentsMap.count == self.story!.descendants{
            if self.comments.isEmpty {
              for (_,com) in self.commentsMap {
                self.comments.append(com)
              }
            }
            self.retrievingComments = false
            self.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
          }
          }, withCancel: self.loadingFailed)
       }
      }
    }
    
  }

}
