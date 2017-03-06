//
//  ImageViewController.swift
//  Photos-App
//
//  Created by Cal Stephens on 3/5/17.
//  Copyright © 2017 iOS Club. All rights reserved.
//

import UIKit
import Photos

class ImageViewController : UIViewController {
    
    
    //MARK: - Presentation
    
    static func present(for asset: PHAsset, in navigationController: UINavigationController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "image") as! ImageViewController
        
        controller.asset = asset
        navigationController.pushViewController(controller, animated: true)
    }
    
    
    //MARK: - View Setup
    
    var asset: PHAsset!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        
        PHImageManager.default().requestImage(for: self.asset, targetSize: self.view.frame.size, contentMode: .aspectFit, options: options, resultHandler: { image, options in
        
            DispatchQueue.main.async {
                self.imageView.image = image
            }
            
        })
        
    }
    
}
