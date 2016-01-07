//
//  TwoColumnViewController.swift
//  06-TextKit
//
//  Created by Clay Tinnell on 1/6/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import UIKit

class TwoColumnViewController: UIViewController {

    var text: String?
    
    @IBOutlet weak var leftTextView: UITextView!
    @IBOutlet weak var rightTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        initializeTextViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeTextViews() {
        initializeLeftTextView()
        initializeRightTextView()
    }

    func initializeLeftTextView() {
        leftTextView.text = text
        leftTextView.scrollEnabled = false
    }
    
    func initializeRightTextView() {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
