//
//  ViewController.swift
//  projectDemo
//
//  Created by cheng on 2021/5/19.
//

import UIKit
import SnapKit
import Regift
import Photos
import Gallery

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        let button = UIButton(type: .custom)
        button.setTitle("视频转gif", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(videoCoverToGif), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 200, height: 50))
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
    }
}

extension ViewController: GalleryControllerDelegate {
    
    @objc func videoCoverToGif() {
        
        let gallery = GalleryController()
        gallery.delegate = self
        present(gallery, animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        video.fetchAVAsset { [weak self] (avasset) in
            if let avurlasset = avasset as? AVURLAsset {
                let videoUrl = avurlasset.url.standardizedFileURL
                let videoDuration = Int(avurlasset.duration.value / Int64(avurlasset.duration.timescale))
                
                let frameCount = 60
                let delayTime  = Double(videoDuration) / Double(frameCount)
                if videoDuration > 10 {
                    DispatchQueue.main.async {
                        self?.view.makeCommonToast("视频时间:\(videoDuration)秒，已超过10秒")
                    }
                    return
                }
                Regift.createGIFFromSource(videoUrl, frameCount: frameCount, delayTime: Float(delayTime), size:CGSize(width: 300, height: 300)) { (result) in
                    if let fileUrl = result {
                        
                        PHPhotoLibrary.shared().performChanges {
                            PHAssetCreationRequest.forAsset().addResource(with: .photo, fileURL: fileUrl, options: nil)
                        } completionHandler: { (finished, error) in
                            if finished {
                                DispatchQueue.main.async {
                                    if let data = try?Data(contentsOf: fileUrl) {
                                        self?.view.makeCommonToast("保存成功,Gif图片大小为：\(data.count/1024)kb")
                                    } else {
                                        self?.view.makeCommonToast("保存成功")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        controller.dismiss(animated: true, completion: nil)

    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }

}

