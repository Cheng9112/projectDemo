//
//  ImageManager.swift
//  projectDemo
//
//  Created by Cheng on 2022/6/28.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    public func setNetImage(imageUrlStr: String) {
        
        self.setNetImage(imageUrlStr: imageUrlStr, placeholder: UIImage.init())
    }
    
    public func setNetImage(imageUrlStr: String, placeholder: UIImage) {
        
        if let url = URL(string: imageUrlStr) {
            
            let processor = DownsamplingImageProcessor(size: bounds.size) |> RoundCornerImageProcessor(cornerRadius: 20)
            kf.indicatorType = .activity
            kf.setImage(with: url,
                        placeholder: placeholder,
                        options: [.processor(processor),.scaleFactor(UIScreen.main.scale),.transition(.fade(1)),.cacheOriginalImage]) { result in
                switch result {
                case .success(let value):
                    LogInfo("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    LogInfo("Job failed: \(error.localizedDescription)")
                }
            }
        } else {
            
            LogInfo("图片链接为空")
        }
    }
}
