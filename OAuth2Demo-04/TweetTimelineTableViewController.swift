//
//  TweetTimelineTableViewController.swift
//  OAuth2Demo-04
//
//  Created by Clay Tinnell on 12/7/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class TweetTimelineTableViewController: UITableViewController {
    
    var twitterapi: Twitter?
    
    struct TwitterTimelineEntry {
        var text: String
        var userName: String
    }

    var timelineEntries: [TwitterTimelineEntry]?
    
    //PRAGMA: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHomeTimeline()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(timelineEntries?.count ?? 0, 50)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        if let entry = timelineEntries?[indexPath.row] {
            cell.textLabel?.text = entry.userName
            cell.detailTextLabel?.text = entry.text
        }

        return cell
    }
    
    // MARK: - Load Data
    func loadHomeTimeline() {
        timelineEntries = []
        twitterapi?.homeTimeline({ (data, response) -> () in
            do {
                
                if let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [[String:AnyObject]] {
                    for jsonObject in jsonData {
                        var name = "unknown", text = "unknown"
                        
                        if let tweetText = jsonObject["text"] as? String {
                            text = tweetText
                        }
                        if let user = jsonObject["user"] as? [String:AnyObject] {
                            if let screenName = user["screen_name"] as? String {
                                name = screenName
                            }
                        }
                        
                        let entry = TwitterTimelineEntry(text: text, userName: name)
                        self.timelineEntries?.append(entry)
                    }
                }
                
            }
            catch let jsonError as NSError {
                print("Error parsing JSON Response \(jsonError)")
            }
            self.tableView.reloadData()
        })
    }

}
