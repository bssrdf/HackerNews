//
//  MainViewController.swift
//  HackerNews
//
//  Copyright (c) 2015 Amit Burstein. All rights reserved.
//  See LICENSE for licensing information.
//

import UIKit
import SafariServices


class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate, PageGuideCellDelegate {
  
  // MARK: Properties
  
  let PostCellIdentifier = "PostCell"
  let ShowBrowserIdentifier = "ShowBrowser"
  let PullToRefreshString = "Pull to Refresh"
  let FetchErrorMessage = "Could Not Fetch Posts"
  let ErrorMessageLabelTextColor = UIColor.gray
  let ErrorMessageFontSize: CGFloat = 16
  let FirebaseRef = "https://hacker-news.firebaseio.com/v0/"
  let ItemChildRef = "item"
  let StoryTypeChildRefMap = [StoryType.top: "topstories", .new: "newstories", .show: "showstories", .ask: "askstories"]
  let StoryLimit: UInt = 30
  let DefaultStoryType = StoryType.top
  
  var firebase: Firebase!
  var stories: [Story]! = []
  var page: Int = 0
  var storyType: StoryType!
  var retrievingStories: Bool!
  var refreshControl: UIRefreshControl!
  var errorMessageLabel: UILabel!
  var storyLimitByCategory: [StoryType:Int]!
  var storyIdsByCategory: [StoryType:[Int]]!
  var lastPage = false
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: Enums
  
  enum StoryType {
    case top, new, show, ask
  }
  
  // MARK: Structs
  
  /*struct Story {
    let id: Int
    let title: String
    let url: String?
    let by: String
    let kids : [Int]?
    let score: Int
    let descendants: Int
  }*/
  
  // MARK: Initialization
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    firebase = Firebase(url: FirebaseRef)
    stories = []
    storyLimitByCategory = [.top : 500, .new : 500, .show: 200, .ask: 200]
    storyIdsByCategory = [.top : [], .new : [], .show: [], .ask: []]
    storyType = DefaultStoryType
    retrievingStories = false
    refreshControl = UIRefreshControl()
  }
  
  // MARK: UIViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    page = 0
    lastPage = false
    retrieveStories()
  }
  
  // MARK: Functions
  
  func configureUI() {
    refreshControl.addTarget(self, action: #selector(MainViewController.retrieveStories), for: .valueChanged)
    refreshControl.attributedTitle = NSAttributedString(string: PullToRefreshString)
    tableView.insertSubview(refreshControl, at: 0)
    
    
    // Have to initialize this UILabel here because the view does not exist in init() yet.
    errorMessageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
    errorMessageLabel.textColor = ErrorMessageLabelTextColor
    errorMessageLabel.textAlignment = .center
    errorMessageLabel.font = UIFont.systemFont(ofSize: ErrorMessageFontSize)
  }
  
  
  @objc func retrieveStoriesByPage(direction: Int) {
    if retrievingStories! {
      return
    }
    
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    retrievingStories = true
    var storiesMap = [Int:Story]()
    let storyIds = self.storyIdsByCategory[self.storyType]!
    let sp = Int(self.StoryLimit)
    let startIdIdx = self.page*sp
    var endIdIdx = (self.page+1)*sp
    if endIdIdx > storyIds.count {
       endIdIdx = storyIds.count
       lastPage = true
    }
    else{
       lastPage = false
    }
    
    let storySlice = storyIds[startIdIdx..<endIdIdx]
    let storyPage = Array(storySlice)
    for storyId in storyPage{
        let query = self.firebase.child(byAppendingPath: self.ItemChildRef).child(byAppendingPath: String(storyId))
            query?.observeSingleEvent(of: .value, with: { snapshot in
           
          storiesMap[storyId] = self.extractStory(snapshot!)
              
          if storiesMap.count == (endIdIdx - startIdIdx) {
            var sortedStories = [Story]()
            for storyId in storyPage {
              sortedStories.append(storiesMap[storyId]!)
            }
            self.stories = sortedStories
            self.tableView.reloadData()
            // scrollToRow call must be run by the main thread;
            // otherwise scroll stops in the middle somewhere
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
              self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)})
            self.refreshControl.endRefreshing()
            self.retrievingStories = false
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
          }
          }, withCancel: self.loadingFailed)
    }
  
  }
  
  @objc func retrieveStories() {
    if retrievingStories! {
      return
    }
    
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    retrievingStories = true
    var storiesMap = [Int:Story]()
    
   
    let query = firebase.child(byAppendingPath: StoryTypeChildRefMap[storyType]).queryLimited(toFirst: UInt(storyLimitByCategory[storyType]!))
    
    query?.observeSingleEvent(of: .value, with: { snapshot in
       let storyIds = snapshot?.value as! [Int]
     // print("storytype is \(self.storyType) with \(storyIds.count) stories")
      //storyIds[0] = 21602437
       self.storyIdsByCategory[self.storyType] = storyIds
       
       let storySlice = storyIds[0..<Int(self.StoryLimit)]
       let storyPage = Array(storySlice)
       for storyId in storyPage {
         let query = self.firebase.child(byAppendingPath: self.ItemChildRef).child(byAppendingPath: String(storyId))
        query?.observeSingleEvent(of: .value, with: { snapshot in
           
          storiesMap[storyId] = self.extractStory(snapshot!)
          
          if storiesMap.count == Int(self.StoryLimit) {
            var sortedStories = [Story]()
            //for storyId in storyIds {
            for storyId in storyPage{
              sortedStories.append(storiesMap[storyId]!)
            }
            self.stories = sortedStories
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.retrievingStories = false
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
          }
          }, withCancel: self.loadingFailed)
      }
      }, withCancel: self.loadingFailed)
  
  }
  
  
  func extractStory(_ snapshot: FDataSnapshot) -> Story? {
    if snapshot.value is NSNull {
      return Story(id: 0, title: "", url: nil, by: "", text: nil, kids: nil, score: 0, time: 0, prettyTime: "", descendants: 0)
    }
    let data = snapshot.value as! Dictionary<String, Any>
    let title = data["title"] as! String
    let url = data["url"] as? String
    var text: String? = nil
    if let htmltext = data["text"] as? String {
      text = String.stringByRemovingHTMLEntities(htmltext)
    }
    let by = data["by"] as! String
    let kids = data["kids"] as? [Int]
    let score = data["score"] as! Int
    let id = data["id"] as! Int
    let time = data["time"] as! Int
    let prettyTime = Double(time).timeIntervalAgo()
    let numdes = data["descendants", default: 0] as! Int
    
    return Story(id:id, title: title, url: url, by: by, text: text, kids: kids, score: score, time: time, prettyTime: prettyTime, descendants: numdes)
  }
  
  func loadingFailed(_ error: Error?) -> Void {
    self.retrievingStories = false
    self.stories.removeAll()
    self.tableView.reloadData()
    self.showErrorMessage(self.FetchErrorMessage)
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
  
  func showErrorMessage(_ message: String) {
    errorMessageLabel.text = message
    self.tableView.backgroundView = errorMessageLabel
    self.tableView.separatorStyle = .none
  }
  
  // MARK: UITableViewDataSource
  
  func numberOfSections(in tableView: UITableView) -> Int {
         // #warning Incomplete implementation, return the number of sections
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if section == 0 {
        return stories.count
      }
      return 1
    }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if (indexPath.section == 0) {
        let story = stories[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCellIdentifier) else{
          fatalError("The dequeued cell is not an instance of UITableViewCell")
        }
        cell.textLabel?.text = story.title
        let num_comments = story.descendants
        cell.detailTextLabel?.text = "\(story.score) points by \(story.by) with \(num_comments) comments"
        return cell
    }
    let identifier = "PageGuideCell"
    guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? PageGuideCell else{
      fatalError("The dequeued cell is not an instance of PageGuideCell")
    }
    cell.pageNumber = page
    cell.lastPage = lastPage
    cell.cellDelegate = self
    return cell
    
  }
  
  //MARK: PageGuideCellDelegate
  func pageGuideDidSelectButton(_ cell: PageGuideCell, actionType: Int){
    if actionType == PageGuideActionType.Next.rawValue{
      page += 1
      cell.pageNumber = page
      
      self.retrieveStoriesByPage(direction: actionType)
    }
    if actionType == PageGuideActionType.Prev.rawValue{
      page -= 1
      cell.pageNumber = page
      
      self.retrieveStoriesByPage(direction: actionType)
    }
    cell.lastPage = lastPage
    
  }
  
  /*func tableView(_ tableView: UITableView,
             heightForRowAt indexPath: IndexPath) -> CGFloat {
      if (indexPath.section == 1) {
          return 50
      }
      return UITableView.automaticDimension
  }*/
  
  // MARK: UITableViewDelegate
  /*
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let story = stories[indexPath.row]
    print("story id is: \(story.id)")
    self.comments.removeAll()
    if let kids = story.kids{
      //var sortedComments = [Comment]()
      for id in kids{
         //print("first story's comment # \(id)")
         let query = self.firebase.child(byAppendingPath: self.ItemChildRef).child(byAppendingPath: String(id))
         query?.observeSingleEvent(of: .value, with: { snapshot in
          let comment = self.extractComment(snapshot!)
          /*sortedComments.append(comment)
          if sortedComments.count == kids.count{
             self.comments = sortedComments
          }*/
          self.retrieveComments(root: comment)
          }, withCancel: self.loadingFailed)
      }
     
      //print("there are \(self.comments.count) in story # \(indexPath.row)")
    }
    if let url = story.url {
      let webViewController = SFSafariViewController(url: URL(string: url)!)
      webViewController.delegate = self
      present(webViewController, animated: true, completion: nil)
    }
  }
  */
  // MARK: SFSafariViewControllerDelegate
  
  /*func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    controller.dismiss(animated: true, completion: nil)
  }*/
  
  // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         super.prepare(for:segue, sender: sender)
         if (segue.identifier ?? "" == "ShowComment"){
            
               guard let commentDetailViewController = segue.destination as? DetailTableViewController else {
                 fatalError("Unexpected destination: \(segue.destination)")
             }

               guard let selectedStoryCell = sender as? UITableViewCell else {
                 fatalError("Unexpected sender: \(sender)")
             }

               guard let indexPath = tableView.indexPath(for: selectedStoryCell) else {
                 fatalError("The selected cell is not being displayed by the table")
             }

               let selectedStory = stories[indexPath.row]
                
               commentDetailViewController.story = selectedStory
           
         }
     }

  // MARK: IBActions
  
  @IBAction func changeStoryType(_ sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 {
      storyType = .top
    } else if sender.selectedSegmentIndex == 1 {
      storyType = .new
    } else if sender.selectedSegmentIndex == 2 {
      storyType = .show
    } else if sender.selectedSegmentIndex == 3 {
      storyType = .ask
    }
    else {
      print("Bad segment index!")
    }
    page = 0
    lastPage = false
    retrieveStories()
  }
}
