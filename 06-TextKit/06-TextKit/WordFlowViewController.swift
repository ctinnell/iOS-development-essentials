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
        
        var imageFrame = textView.convertRect(imageView.bounds, fromCoordinateSpace: self.imageView)
        imageFrame.origin.x -= textView.textContainerInset.left
        imageFrame.origin.y -= textView.textContainerInset.top
        
        let path = UIBezierPath(rect: imageFrame)
        self.textView.textContainer.exclusionPaths = [path]
    }
}
