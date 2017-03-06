//
//  ViewController.swift
//  Photos-App
//
//  Created by Cal Stephens on 3/5/17.
//  Copyright © 2017 iOS Club. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var assets: PHFetchResult<PHAsset>?
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { newStatus in
                
                //switch back to the main UI thread
                DispatchQueue.main.sync {
                    self.loadImagesIfPossible()
                }
                
            }
        }
        
        else {
            loadImagesIfPossible()
        }
        
    }
    
    
    func loadImagesIfPossible() {
        if PHPhotoLibrary.authorizationStatus() == .denied {
            let alert = UIAlertController(title: "Cannot Access Photo Library", message: "Please give the app permission to access your photos.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        else if PHPhotoLibrary.authorizationStatus() == .authorized {
            self.assets = PHAsset.fetchAssets(with: .image, options: nil)
            self.collectionView.reloadData()
        }
    }
    
    
    //MARK: - UICollectionView data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as! ImageCell
        
        if let asset = self.assets?.object(at: indexPath.item) {
            cell.decorate(for: asset)
        }
        
        return cell
    }
    
    
    //MARK: - UICollectionView flow layout delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalWidth = self.view.frame.width - 2
        let cellWidth = totalWidth / 3
        return CGSize(width: cellWidth, height: cellWidth)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    //MARK: - User Interaction
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let asset = self.assets?.object(at: indexPath.item) {
            ImageViewController.present(for: asset, in: self.navigationController!)
        }
    }
    
}


//MARK: - Custom UICollectionViewCell

class ImageCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func decorate(for asset: PHAsset) {
        
        PHImageManager.default().requestImage(for: asset, targetSize: self.frame.size, contentMode: .aspectFill, options: nil, resultHandler: { image, data in
            self.imageView.image = image
        })
        
    }
    
}
