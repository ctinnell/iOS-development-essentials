//
//  PhotoListViewController.swift
//  08-WatchKit
//
//  Created by Clay Tinnell on 1/30/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import UIKit
import SafariServices
import WatchConnectivity

class PhotoListViewController: UICollectionViewController {
    private let reuseIdentifier = "PhotoCell"
    private var photos = [Photo]()
    private let photoService = FlickrPhotoService()

    override func viewDidLoad() {
        super.viewDidLoad()
        photoService.fetchPhotos(processPhotos)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoCell
        cell.imageView?.image = nil
        cell.label?.text = nil
        let photo = self.photos[indexPath.row]
        cell.label?.text = photo.title
        if let image = photo.image {
            cell.imageView?.image = image
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let photo = photos[indexPath.row]
        if let urlDetail = photo.urlDetail {
            presentPhotoDetailViewController(urlDetail)
        }
    }


    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    func presentPhotoDetailViewController(url: NSURL) {
        let vc = SFSafariViewController(URL: url)
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func processPhotos(photos: [Photo]?, error: Error?) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.collectionView?.reloadData()
        }
        if let photos = photos {
            self.photos = photos
            photoService.fetchImagesForPhotos(photos, imageCompletion: imageDidLoad, completion: imagesDidLoad)
        }
     }
    
    func imageDidLoad(photo: Photo) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let index = self.photos.indexOf({$0.id == photo.id}) {
               self.photos[index] = photo
               if let cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? PhotoCell {
                     cell.imageView?.image = photo.image
                }
            }
        })
    }
    
    func imagesDidLoad(photos: [Photo]?, error: Error?) {
        self.updateWatchPhotos()
    }
    
    func updateWatchPhotos() {
        let session = WCSession.defaultSession()
        session.delegate = self
        session.activateSession()
        
        var context = session.applicationContext
        var array = [[String:AnyObject]]()
        for photo in self.photos[0..<10] {
            array.append(photo.toDictionary())
        }
        context["photos"] = array
        
        do {
            try session.updateApplicationContext(context)
        } catch let error {
            print ("Error updating Watch Photos: ", error)
        }
    }
}

extension PhotoListViewController:WCSessionDelegate {
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        updateWatchPhotos()
    }
}
