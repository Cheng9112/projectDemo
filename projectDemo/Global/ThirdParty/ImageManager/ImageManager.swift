//
//  ImageManager.swift
//  projectDemo
//
//  Created by Cheng on 2022/6/28.
//

import Foundation
import Kingfisher
import UIKit

public typealias ProgressBlock = ((_ receivedSize: Int64, _ totalSize: Int64) -> Void)

/// 图片下载与缓存
class ImageDCManager {
    
    public func downloadImage(urlStr: String, progressBlock: ProgressBlock? = nil, completionHandle: ((UIImage?) -> Void)? = nil) {
        
        if ImageCache.default.isCached(forKey: urlStr) {
            
            ImageCache.default.retrieveImage(forKey: urlStr) { result in
                switch result {
                case .success(let value):
                    if let progress = progressBlock {
                        progress(1, 1)
                    }
                    
                    if let handle = completionHandle, let cgImage = value.image?.cgImage {
                        handle(UIImage.init(cgImage: cgImage))
                    }
                default:
                    if let handle = completionHandle {
                        handle(nil)
                    }
                }
            }
            
        } else if let url = URL.init(string: urlStr) {
            
            ImageDownloader.default.downloadImage(with: url, options: KingfisherManager.shared.defaultOptions) { receivedSize, totalSize in
                if let progress = progressBlock {
                    progress(receivedSize, totalSize)
                }
            } completionHandler: { result in
                switch result {
                case .success(let value):
                if let url = value.url {
                    ImageCache.default.store(value.image, forKey: url.absoluteString)
                    LogInfo("已缓存：key为\(url.absoluteString)")
                }
                default: break
                }
            }
        }
    }
}

/// UIImageView 图片缓存扩展
extension UIImageView {
    
    /// 加载网络图片
    /// - Parameter imageUrlStr: 图片链接
    public func setNetImage(imageUrlStr: String) {
        
        self.setNetImage(imageUrlStr: imageUrlStr, placeholder: nil)
    }
    
    /// 加载网络图片
    /// - Parameters:
    ///   - imageUrlStr: 图片链接
    ///   - placeholder: 占位图
    public func setNetImage(imageUrlStr: String, placeholder: UIImage?) {
        self.setNetImage(imageUrlStr: imageUrlStr, placeholder: placeholder, completionHandler: nil)
    }
    
    /// 加载网络图片
    /// - Parameters:
    ///   - imageUrlStr: 图片链接
    ///   - placeholder: 占位图
    ///   - useIndicator: 是否使用loading图标
    ///   - completionHandler: 加载完成时
    public func setNetImage(imageUrlStr: String,
                            placeholder: UIImage?,
                            _ useIndicator: Bool = false,
                            completionHandler: ((UIImage?) -> Void)?) {
        if let url = URL(string: imageUrlStr) {
            if useIndicator {
                kf.indicatorType = .activity
            }
            kf.setImage(with: url,
                        placeholder: placeholder,
                        options: [.scaleFactor(UIScreen.main.scale), // 设置图片展示scale
                                  .transition(.fade(0.5))]  //  渐变效果
            ) { result in
                switch result {
                case .success(let value):
                    if let handle = completionHandler, let cgImage = value.image.cgImage {
                        handle(UIImage.init(cgImage: cgImage))
                    }
                case .failure(let error):
                    if let handle = completionHandler {
                        handle(nil)
                    }
                    LogInfo("Job failed: \(error.localizedDescription)")
                }
            }
        } else {
            LogInfo("图片链接为空")
        }
    }
}

/// UIButton 图片缓存扩展
extension UIButton {
    
    /// 加载网络图片
    /// - Parameters:
    ///   - imageUrlStr: 图片链接
    ///   - state: button状态
    public func setNetImage(imageUrlStr: String, state: UIControl.State) {
        
        self.setNetImage(imageUrlStr: imageUrlStr, state: state, placeHolder: nil)
    }
    
    /// 加载网络图片
    /// - Parameters:
    ///   - imageUrlStr: 图片链接
    ///   - state: button状态
    ///   - placeHolder: 占位图
    public func setNetImage(imageUrlStr: String, state: UIControl.State, placeHolder: UIImage?) {
        self.setNetImage(imageUrlStr: imageUrlStr, state: state, placeholder: nil, completionHandler: nil)
    }
    
    /// 加载网络图片
    /// - Parameters:
    ///   - imageUrlStr: 图片链接
    ///   - state: button 状态
    ///   - placeholder: 占位图
    ///   - completionHandler: 加载完成闭包
    public func setNetImage(imageUrlStr: String,
                            state: UIControl.State,
                            placeholder: UIImage?,
                            completionHandler: ((UIImage?) -> Void)?) {
        if let url = URL(string: imageUrlStr) {
            kf.setImage(with: url,
                        for: state,
                        placeholder: placeholder,
                        options: [.scaleFactor(UIScreen.main.scale), // 设置图片展示scale
                                  .transition(.fade(0.5))],  //  渐变效果
                        progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    if let handle = completionHandler, let cgImage = value.image.cgImage {
                        handle(UIImage.init(cgImage: cgImage))
                    }
                case .failure(let error):
                    if let handle = completionHandler {
                        handle(nil)
                    }
                    LogInfo("Job failed: \(error.localizedDescription)")
                }
            }
        } else {
            LogInfo("图片链接为空")
        }
    }

}
