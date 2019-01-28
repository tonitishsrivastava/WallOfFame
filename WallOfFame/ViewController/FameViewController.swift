//
//  FameViewController.swift
//  WallOfFame
//
//  Created by Nitish Srivastava on 22/01/19.
//  Copyright © 2019 Nitish Srivastava. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import AVKit
import AVFoundation

class FameViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var hasNext: Bool = false
    var page = 1
    var posts = [Post]()
    var toReloadSection: Int?
    var rowsInEachSection = [[Int:Int]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Wall of Fame"
        DispatchQueue.main.async {
            self.parseJsonUsingAlamofire(page: self.page)
        }
        self.tableView.rowHeight = 300
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

    func parseJsonUsingAlamofire(page: Int = 1) {
        self.activityIndicator.startAnimating()
        if (Reachability.isConnectedToNetwork()) {
            let url = "\(AppConstant.BLOG_URL)\(page)"
            Alamofire.request(url).validate().responseJSON { response in
                guard response.result.isFailure else {
                    let data = response.result.value
                    self.blogFromOnlineData(data as Any){(posts) in
                       
                        self.posts.append(contentsOf: posts)
                        self.activityIndicator.stopAnimating()
                        self.tableView.reloadData()
                    }
                    return
                }
                let alert = UIAlertController(title: "Failed", message: "Failed to get data. Please retry.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: { action in
                    DispatchQueue.main.async {
                        self.parseJsonUsingAlamofire(page: self.page)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "No Internet Connection", message: "Please connect to Internet and retry.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: { action in
                DispatchQueue.main.async {
                    self.parseJsonUsingAlamofire(page: self.page)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func blogFromOnlineData(_ data: Any, completion: @escaping (_ reaction: [Post]) -> Void) {
        
        var posts = [Post]()
        
        if(Reachability.isConnectedToNetwork()){
            
            do {
                let rootObject = data as! [String: Any]
                
                if let data = rootObject["data"] as? [String: Any] {
                    if let hasMore = data["hasMore"] as? Int{
                        if hasMore == 1{
                            self.hasNext = true
                        }else{
                            self.hasNext = false
                        }
                    }
                    
                    // Do other fetching here
                    
                    guard let postObjects = data["feed"] as? [[String: AnyObject]] else {
                        return
                    }
                    
                    for post in postObjects{
                        
                        // Post
                        
                        var post_id: String = ""
                        var postName: String = ""
                        var pub_date: Date = Date();
                        var pub_dt_str: String = "2016-08-05 04:30:33"
                        var user: User?
                        var reaction: Reaction?
                        var comments = [Comment]()

                        // post_id
                        if let post_id1 = (post["id"] as? String){
                            post_id = post_id1
                        }
                        // post_name
                        if let title1 = (post["name"] as? String){
                            postName = title1
                        }
                        
                        // post_date_str
                        let dateFormatter = DateFormatter()
                        if let pub_dt: String = (post["created"] as? String){
                            pub_dt_str = pub_dt
                        }
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

                        if let tz = TimeZone.current.abbreviation(){
                            dateFormatter.timeZone = TimeZone(abbreviation: tz)

                        }
                        // post_date
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        if let pub_dt1: Date = dateFormatter.date(from: pub_dt_str){
                            pub_date = pub_dt1
                        }
                        
                        // reaction
                        fetchReaction(post: post) { (rection) in
                            reaction = rection
                        }
                        
                        // Comment
                        
                        guard let commentObjects = post["comments"] as? [[String: AnyObject]] else {
                            return
                        }
                        
                        for cmnt in commentObjects{
                            
                            var comment_id: String = ""
                            var comment: String = ""
                            var cmt_user: User?
                            var cmt_reaction: Reaction?
                            var cmnt_date: Date = Date()
                            var cmnt_dt_str: String = "2016-08-05 04:30:33"
                            
                            if let comment_id1 = (cmnt["id"] as? String){
                                comment_id = comment_id1
                            }
                            
                            if let comment1 = (cmnt["text"] as? String){
                                comment = comment1
                            }
                            
                            fetchUser(post: cmnt) { (usr) in
                                cmt_user = usr!
                            }
                            
                            
                            fetchReaction(post: cmnt) { (rection) in
                                cmt_reaction = rection
                            }
                            
                            // cmnt_date_str
                            let dateFormatter = DateFormatter()
                            if let cmt_dt: String = (cmnt["created"] as? String){
                                cmnt_dt_str = cmt_dt
                            }
                            
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            
                            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
                                
                            // cmnt_date
                            
                            if let cmnt_date1: Date = dateFormatter.date(from: cmnt_dt_str){
                                cmnt_date = cmnt_date1
                            }
                            
                            let cmnt = Comment(comment_id: comment_id, comment: comment, user: cmt_user!, reaction: cmt_reaction!, date: cmnt_date)
                            comments.append(cmnt)
                        }
                        
                        // User
                        fetchUser(post: post) { (usr) in
                            user = usr!
                        }
                       
                        
                        let post = Post(date: pub_date, name: postName, reaction: reaction!, user: user!, id: post_id, comments: comments)
                        posts.append(post)
                        
                    }
                    
                    
                    
                }
                
            }
            
            
        }
        completion(posts)
    }
    
    
    func fetchReaction(post: [String : AnyObject], completion: @escaping (_ reaction: Reaction?) -> Void){
        var reaction: Reaction?
        
        guard let reactionObjects = post["reactions"] else {
            return
        }
        
        var like: Int = 0
        var haha: Int = 0
        var dab: Int = 0
        var crazy: Int = 0
        var meh: Int = 0
        var takeMyMoney: Int = 0
        
        
        if let like1 = (reactionObjects["like"] as? [String]){
            like = like1.count
        }
        
        if let crazy1 = (reactionObjects["crazy"] as? [String]){
            crazy = crazy1.count
        }
        
        if let dab1 = (reactionObjects["dab"] as? [String]){
            dab = dab1.count
        }
        
        if let haha1 = (reactionObjects["haha"] as? [String]){
            haha = haha1.count
        }
        
        if let meh1 = (reactionObjects["meh"] as? [String]){
            meh = meh1.count
        }
        
        if let takeMyMoney1 = (reactionObjects["takeMyMoney"] as? [String]){
            takeMyMoney = takeMyMoney1.count
        }
        
        reaction = Reaction(like: like, haha: haha, dab: dab, crazy: crazy, meh: meh, takeMyMoney: takeMyMoney)
        completion(reaction)
    }
    
    
    func fetchUser(post: [String : AnyObject], completion: @escaping (_ user: User?) -> Void){
        var user: User?
        guard let userObjects = post["user"] as? [String: AnyObject] else {
            return
        }
        
        var user_id: String = ""
        var name: String = ""
        var img_url: String = ""
        var video_url: String = ""
        var user_date: Date = Date()
        var user_dt_str: String = "2016-08-05 04:30:33"
        
        if let user_id1 = (userObjects["id"] as? String){
            user_id = user_id1
        }
        
        if let name1 = (userObjects["fullname"] as? String){
            name = name1
        }
        
        if let img_url1 = (userObjects["imageUrl"] as? String){
            img_url = img_url1
        }
        
        if let video_url1 = (userObjects["videoUrl"] as? String){
            video_url = video_url1
        }
        
        // cmnt_date_str
        let dateFormatter1 = DateFormatter()
        if let user_dt: String = (userObjects["created"] as? String){
            user_dt_str = user_dt
        }
        dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        dateFormatter1.timeZone = TimeZone.autoupdatingCurrent
        // cmnt_date
        dateFormatter1.locale = Locale(identifier: "en_US_POSIX")
        if let user_date1: Date = dateFormatter1.date(from: user_dt_str){
            user_date = user_date1
        }
        
        user = User(user_id: user_id, name: name, videoUrl: video_url, imageUrl: img_url, date: user_date)
        completion(user)
    }
    
}


extension FameViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(self.posts.count > 0){
            return self.posts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        
        if(self.toReloadSection != nil){
            switch section {
            case self.toReloadSection!:
                if((self.posts[section].comments?.count)! > 0){
                    count += (self.posts[section].comments?.count)!
                }
            default:
                if (self.posts[section].comments?.count)! > 2{
                    count += 3
                }else{
                    count += (self.posts[section].comments?.count)! + 1
                }
                count += 0
            }
        }else{
            if (self.posts[section].comments?.count)! > 2{
                count += 3
            }else{
                count += (self.posts[section].comments?.count)! + 1
            }
        }
        
        self.rowsInEachSection.append([section:count])
        return count
        
    }
    
    func getNumberOfRows(section: Int) -> Int{
        if(rowsInEachSection.count > 0){
            for rowKeyPair in rowsInEachSection{
                if(rowKeyPair.keys.first == section){
                    return rowKeyPair.values.first!
                }
            }
        }
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var nCell = UITableViewCell()
        let lastCellNumber = self.getNumberOfRows(section: indexPath.section)
        let post = posts[indexPath.section]
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! PostTableViewCell
            let post = post
            cell.setViewData(post: post)
            cell.postCardView.clipsToBounds = true
            cell.postCardView.layer.cornerRadius = 20
            
            if(lastCellNumber == 2 && self.toReloadSection != nil && self.toReloadSection == indexPath.section){
                cell.postCardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            }else{
                cell.postCardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
            
            
            cell.selectionStyle = .none
            nCell = cell
        }else if((self.toReloadSection == nil || self.toReloadSection != indexPath.section) &&  indexPath.row == (lastCellNumber - 1) ){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cmnt_btn_cell", for: indexPath) as! CommentButtonTableViewCell
            
            cell.seeCommentButton.tag = indexPath.section
            cell.seeCommentButton.addTarget(self, action: #selector(didTapCellButton(sender:)), for: .touchUpInside)
            cell.commentContainerView.clipsToBounds = true
            cell.commentContainerView.layer.cornerRadius = 20
            cell.commentContainerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            
            nCell = cell
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "comments", for: indexPath) as! CommentTableViewCell
            if ((post.comments?.count)!>0 && indexPath.row < lastCellNumber && indexPath.row > 0 ){
                let comment = post.comments?[indexPath.row-1]
                cell.comment_user_name.attributedText = getAttributedText(firstString: comment!.user!.name!, secondString: comment!.comment!, color: AppConstant.blueColor)
                if let url1 = URL(string: ((comment!.user?.imageUrl)!)){
                    cell.comment_user_image.af_setImage(withURL: url1)
                }else{
                    cell.comment_user_image.image = UIImage(named: "placeHolder")
                }
                
                if(self.toReloadSection != nil && self.toReloadSection == indexPath.section && indexPath.row == lastCellNumber-2){
                    cell.commentContainer.layer.cornerRadius = 20
                }else{
                    cell.commentContainer.layer.cornerRadius = 0
                }
                cell.commentContainer.clipsToBounds = true
                cell.commentContainer.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                let commentDate = comment!.date!
                let todayDate = Date()
                
                let formatter = DateComponentsFormatter()
                formatter.unitsStyle = .full
                formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
                formatter.maximumUnitCount = 1  
                
                let dateDifference = formatter.string(from: commentDate, to: todayDate)! + " " + "ago"
                
                cell.comment_user_reply.attributedText = getAttributedText(firstString: "Reply", secondString: dateDifference, color: AppConstant.orangeColor)
                
                cell.setBadgeButton(comment: comment)
                
            }
            
            nCell = cell
        }
        return nCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    @objc func didTapCellButton(sender: UIButton) {
        self.toReloadSection = sender.tag
        let rowsNumber = posts[self.toReloadSection ?? 0].comments!.count + 2
        tableView.numberOfRows(inSection: rowsNumber)
        tableView.reloadData()
    }
    
    
    
    func getAttributedText(firstString: String, secondString: String, color: UIColor ) -> NSAttributedString{
        let main_string = firstString + " " + secondString
        let string_to_color = firstString
        
        let range1 = (main_string as NSString).range(of: string_to_color)
        let range2 = (main_string as NSString).range(of: secondString)
        
        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttribute(NSAttributedString.Key.font,
                               value: UIFont.boldSystemFont(ofSize: 16),
                               range: range1)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range1)
        attribute.addAttribute(NSAttributedString.Key.font,
                               value: UIFont.systemFont(ofSize: 14),
                               range: range2)
        return attribute
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == tableView{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height){
                if hasNext{
                    DispatchQueue.main.async {
                        self.page += 1
                        self.parseJsonUsingAlamofire(page: self.page)
                    }
                }
            }
            
        }
    }
    
    
}
