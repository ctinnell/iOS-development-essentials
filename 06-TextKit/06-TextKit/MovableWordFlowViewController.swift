//
//  MovableWordFlowViewController.swift
//  06-TextKit
//
//  Created by Clay Tinnell on 1/5/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import UIKit

class MovableWordFlowViewController: UIViewController {
 
    var text: String?
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: "imageViewMoved:")
        imageView.addGestureRecognizer(panGesture)
        imageView.userInteractionEnabled = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   func imageViewMoved(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(self.view)
        gesture.view!.center = CGPointMake(gesture.view!.center.x + translation.x, gesture.view!.center.y + translation.y)
        gesture.setTranslation(CGPointZero, inView: self.view)
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
