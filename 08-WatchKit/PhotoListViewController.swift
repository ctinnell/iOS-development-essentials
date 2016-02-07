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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.dataSource = dataSource
        photoService.fetchPhotos(processPhotos)
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let photo = dataSource.photos[indexPath.row]
        if let urlDetail = photo.urlDetail {
            presentPhotoDetailViewController(urlDetail)
        }
    }

    func presentPhotoDetailViewController(url: NSURL) {
        let vc = SFSafariViewController(URL: url)
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func processPhotos(photos: [Photo]?, error: Error?) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.collectionView?.reloadData()
        }
        if let photos = photos {
            self.dataSource.photos = photos
            photoService.fetchImagesForPhotos(photos, imageCompletion: imageDidLoad, completion: imagesDidLoad)
        }
     }
    
    func imageDidLoad(photo: Photo) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let index = self.dataSource.photos.indexOf({$0.id == photo.id}) {
               self.dataSource.photos[index] = photo
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
