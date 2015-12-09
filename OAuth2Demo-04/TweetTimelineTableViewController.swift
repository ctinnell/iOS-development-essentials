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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = timelineEntries?.count ?? 0
        if rowCount > 50 { rowCount = 50 }
        return rowCount
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        if let entry = timelineEntries?[indexPath.row] {
            cell.textLabel?.text = entry.userName
            cell.detailTextLabel?.text = entry.text
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
