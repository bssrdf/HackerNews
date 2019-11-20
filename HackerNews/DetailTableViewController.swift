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

        /*if var textAttributes = navigationController?.navigationBar.titleTextAttributes {
           textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.orange
           navigationController?.navigationBar.titleTextAttributes = textAttributes
        }*/
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
      //if let comments = comments{
      //print("# of comments is \(comments.count)")
        return comments.count
      //}
      //return 0
    }
  
    override func tableView(_ tableView: UITableView,
             heightForRowAt indexPath: IndexPath) -> CGFloat {
       //let comment = comments[indexPath.row]
      //print("\(comment.by): \(self.cellHeightCache[indexPath.row])")
      return self.cellHeightCache[indexPath.row] as CGFloat
     
   }
   /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
      if (indexPath.section == 0) {
          let title: NSString = self.post.title! as NSString
          return NewsCell.heightForText(text: title, bounds: self.tableView.bounds)
      }
      return self.cellHeightCache[indexPath.row] as CGFloat
  }*/

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cellIdentifier = "CommentTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CommentTableViewCell else{
        fatalError("The dequeued cell is not an instance of CommentTableViewCell")
      }
      //if let comments = comments{
      if comments.count > 0 {
         //print("comments has \(comments.count)")
         let comment = comments[indexPath.row]
        //print("cellForRowAt indexPath: for cell # \(indexPath.row)")
        cell.comment = comment
        //cell.authorLabel.text = comment.by+"  at level \(comment.level)"
        // cell.commentTextView.text = comment.text
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
  
  func cacheHeight() {
    cellHeightCache = []
    for comment in self.comments{
      let height = CommentTableViewCell.heightForText(text: comment.text!, bounds: self.tableView.bounds, level: comment.level, author: comment.by)
      //let height = CGFloat(0.0)
      cellHeightCache.append(height)
    }
  }
  
  func extractComment(_ snapshot: FDataSnapshot) -> Comment {
    let data = snapshot.value as! Dictionary<String, Any>
    let id = data["id"] as! Int
    let by = data["by", default: "anonymous"] as! String
    let kids = data["kids"] as? [Int]
    var text = ""
    if let htmltext = data["text"] as? String {
      text = String.stringByRemovingHTMLEntities(htmltext)
    }
    //if text.contains("http"){
   //   print(text)
   // }
    //print("author is "+by)
    return Comment(id: id, by: by, kids: kids, text: text)
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
      //comment.level = 0
      self.comments.append(comment)
      if let kids = comment.kids {
        for id in kids {
          /*if self.commentsMap[id] == nil{
            print("map has \(self.commentsMap.count) comments" )
            print("\(id) is nil and depth is \(depth)")
          }*/
          //let childcomment = self.commentsMap[id]!
          if let childcomment = self.commentsMap[id] {
            self.addChildComment(childcomment, depth: depth+1)
          }
        }
    }
    
  }
  
  
  func retrieveComment(root comment: Comment) -> Void{
    
    //self.comments.append(comment)
    self.commentsMap[comment.id] = comment
    //print(self.commentsMap.count)
    /*if comment.id == 21541602 {
      print("this comment exists in the map with id \(comment.id)")
      if let ckids = comment.kids{
         print("the kids are \(ckids)")
      }
    }*/
    
    if let kids = comment.kids{
       //var sortedComments = [Comment]()
       for kid in kids{
          let query = self.firebase.child(byAppendingPath: self.ItemChildRef).child(byAppendingPath: String(kid))
          query?.observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot!.value is NSNull {
              print("nil found for id \(kid)")
              return
            }
           let childcomment = self.extractComment(snapshot!)
            /*if childcomment.id == 21541859 {
              print("this comment exists with id \(childcomment.id)")
              if let ckids = childcomment.kids{
                 print("the kids are \(ckids)")
              }
            }*/
            //print("comment with id: \(childcomment.id)")
            self.retrieveComment(root: childcomment)
            if self.commentsMap.count == self.story!.descendants{
              //print("total # of comments is \(self.commentsMap.count)")
              
              for id in self.story!.kids! {
                let childcomment = self.commentsMap[id]!
                self.addChildComment(childcomment, depth: 0)
              }
              self.cacheHeight()
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
      
      //print(" story id is \(story.id)")
      //print("story title is \(story.title)")
      comments.removeAll()
      commentsMap.removeAll()
      if let kids = story.kids{
      
      for id in kids{
        // print("first story's comment # \(id)")
         let query = self.firebase.child(byAppendingPath: self.ItemChildRef).child(byAppendingPath: String(id))
         query?.observeSingleEvent(of: .value, with: { snapshot in
          let comment = self.extractComment(snapshot!)
         
          self.retrieveComment(root: comment)
          //print("comment id is \(id) \(self.comments.count) and \(self.commentsMap.count)")
          if self.commentsMap.count == self.story!.descendants{
            if self.comments.isEmpty {
              for (_,com) in self.commentsMap {
                self.comments.append(com)
              }
            }
            self.cacheHeight()
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
