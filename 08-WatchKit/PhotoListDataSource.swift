//
//  PhotoListDataSource.swift
//  08-WatchKit
//
//  Created by Clay Tinnell on 2/7/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import UIKit

class PhotoListDataSource: NSObject, UICollectionViewDataSource {

    var photos = [Photo]()
    private let reuseIdentifier = "PhotoCell"

    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
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

}
