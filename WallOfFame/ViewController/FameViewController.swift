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

class FameViewController: UIViewController, UITabBarDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var hasNext: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parseJsonUsingAlamofire(page: 1)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! PostTableViewCell
        return cell
    }

    func parseJsonUsingAlamofire(page: Int = 1) {
        if (Reachability.isConnectedToNetwork()) {
            print("yes")
            
            let url = "https://beta-api.betterbydesign.in/feed/wall-of-fame?page=1"
            Alamofire.request(url).validate().responseJSON { response in
                guard response.result.isFailure else {
                    let data = response.result.value
                    self.blogFromOnlineData(data as Any)
                    return
                }
                
                print("failed to parse data")
                
            }
            
            
        }
    }
    
    func blogFromOnlineData(_ data: Any) {
        
        var page = 0
        
        if(Reachability.isConnectedToNetwork()){
            
            print("data has \(data)")
            
            do {
                let rootObject = data as! [String: Any]
                
                if let data = rootObject["data"] as? [String: Any] {
                    if let hasMore = data["hasMore"] as? Int{
                        if hasMore == 1{
                            self.hasNext = true
                            print("data has more \(true)")
                        }else{
                            self.hasNext = false
                            print("data has more \(false)")
                        }
                        
                        print("data has more \(hasMore)")
                    }
                    
                    // Do other fetching here
                    
                }
                
            }
                
            catch {
                print(error)
                //return artists
            }
            
        }
        
        print("Executed Downloading")
        self.tableView.reloadData()
    }
    
}
