//
//  ViewController.swift
//  08-WatchKit
//
//  Created by Clay Tinnell on 1/22/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let photoService = FlickrPhotoService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoService.fetchPhotos(processPhotos)
        // Do any additional setup after loading the view, typically from a nib.
    }

    func processPhotos(photos: [Photo]?, error: Error?) {
        print("Photos Processed!!!")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

