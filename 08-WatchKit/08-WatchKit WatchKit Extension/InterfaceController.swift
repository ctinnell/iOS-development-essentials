//
//  InterfaceController.swift
//  08-WatchKit WatchKit Extension
//
//  Created by Clay Tinnell on 1/22/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import ClockKit


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var photoImage: WKInterfaceImage!
    @IBOutlet var photoPicker: WKInterfacePicker!
    
    var photos = [Photo]()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        let session = WCSession.defaultSession()
        session.delegate = self
        session.activateSession()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func updatePicker() {
        var pickerItems = [WKPickerItem]()
        
        for photo in photos {
            let item = WKPickerItem()
            item.title = photo.title
            if let image = photo.image {
                item.contentImage = WKImage(image: image)
            }
            pickerItems.append(item)
        }
        
        photoPicker.setItems(pickerItems)
        pickerDidChange(0)
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        if let array = applicationContext["photos"] as? [[String:AnyObject]] {
            photos.removeAll()
            
            for item in array {
                let photo = Photo(dictionary: item)
                photos.append(photo)
            }
            
            updatePicker()
        }
    }

    @IBAction func pickerDidChange(value: Int) {
        
    }
}
