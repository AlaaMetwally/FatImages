//
//  ViewController.swift
//  FatImages
//
//  Created by Geek on 2/17/19.
//  Copyright © 2019 Geek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum BigImages: String{
        case whale = "https://d17h27t6h515a5.cloudfront.net/topher/2017/November/59fe5127_whale/whale.jpg"
        case shark = "https://d17h27t6h515a5.cloudfront.net/topher/2017/November/59fe5123_shark/shark.jpg"
        case seaLion = "https://d17h27t6h515a5.cloudfront.net/topher/2017/November/59fe511f_sealion/sealion.jpg"
    }
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBAction func setTransparencyOfImage (sender: UISlider){
        photoView.alpha = CGFloat(sender.value)
    }
    
    @IBAction func synchrnousDownload(sender: UIBarButtonItem){
        self.activityView.startAnimating()
        if let url = URL(string: BigImages.seaLion.rawValue), let imgData = try? Data(contentsOf: url){
            let image = UIImage(data: imgData)
            photoView.image = image
            self.activityView.stopAnimating()
        }
    }
    @IBAction func simpleAsynchronousDownload (sender: UIBarButtonItem){
        self.activityView.startAnimating()

        let downloadQueue = DispatchQueue(label: "download",qos:.userInitiated)
        downloadQueue.async {
            if let url = URL(string: BigImages.shark.rawValue), let imgData = try? Data(contentsOf: url){
                let image = UIImage(data: imgData)
                DispatchQueue.main.async {
                    self.photoView.image = image
                    self.activityView.stopAnimating()
                }
            }
        }
    }
    @IBAction func asynchrnousDownload(sender: UIBarButtonItem){
        activityView.startAnimating()
        downloadBigImage {
            (image) -> Void in
            self.photoView.image = image
            self.activityView.stopAnimating()
        }
    }
    
    func downloadBigImage(completionHander handler: @escaping(UIImage?) -> Void){
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: BigImages.whale.rawValue), let imgData = try? Data(contentsOf: url){
                let image = UIImage(data: imgData)
                DispatchQueue.main.async {
                    handler(image)
                }
            }
        }
    }
}

