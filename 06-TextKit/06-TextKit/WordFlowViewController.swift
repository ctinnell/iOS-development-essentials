//
//  WordFlowViewController.swift
//  06-TextKit
//
//  Created by Clay Tinnell on 1/3/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import UIKit

class WordFlowViewController: UIViewController {

    var text: String?
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        configureTextView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureTextView() {
        textView.text = text
        if let textView = textView, imageView = imageView {
            var imageFrame = textView.convertRect(imageView.bounds, fromCoordinateSpace: self.imageView)
            imageFrame.origin.x -= textView.textContainerInset.left
            imageFrame.origin.y -= textView.textContainerInset.top
            let path = UIBezierPath(rect: imageFrame)
            self.textView.textContainer.exclusionPaths = [path]
        }
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
