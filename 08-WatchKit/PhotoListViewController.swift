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

    private let photoService = FlickrPhotoService()
    private let dataSource = PhotoListDataSource()
    private var refreshOnAppear = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.dataSource = dataSource
        photoService.fetchPhotos(processPhotos)
   }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if refreshOnAppear {
            photoService.fetchPhotos(processPhotos)
        }
        else {
            refreshOnAppear = true
        }
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let photo = dataSource.photos[indexPath.row]
        if let urlDetail = photo.urlDetail {
            refreshOnAppear = false
            presentPhotoDetailViewController(urlDetail)
        }
    }

    func presentPhotoDetailViewController(url: NSURL) {
        let vc = SFSafariViewController(URL: url)
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func processPhotos(photos: [Photo]?, error: Error?) {
        if let photos = photos {
            self.dataSource.photos = photos
            photoService.fetchImagesForPhotos(photos, imageCompletion: imageDidLoad, completion: imagesDidLoad)
            print("fetch photos")
        }
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.collectionView?.reloadData()
        }
     }
    
    func imageDidLoad(photo: Photo) {
        guard let index = self.dataSource.photos.indexOf({$0.id == photo.id}),
            cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? PhotoCell else {
                return
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.dataSource.photos[index] = photo
            cell.imageView?.image = photo.image
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
        for photo in self.dataSource.photos[0..<10] {
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
