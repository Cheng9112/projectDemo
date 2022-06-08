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
import RxSwift

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
//        let button = UIButton(type: .custom)
//        button.setTitle("测试", for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.layer.borderWidth = 0.5
//        button.layer.borderColor = UIColor.black.cgColor
//        button.addTarget(self, action: #selector(videoCoverToGif), for: .touchUpInside)
//        self.view.addSubview(button)
//        button.snp.makeConstraints { (make) in
//            make.size.equalTo(CGSize(width: 200, height: 50))
//            make.top.equalToSuperview().offset(100)
//            make.centerX.equalToSuperview()
//        }
        
        globalProvider.rx.request(.baseConfig).subscribe { event in
            switch event {
            case let .success(response):
                print(response.data)
                break
            case let .failure(error):
                print(error)
                break
            }
        }
        
        
    }

}

extension ViewController {

    @objc func videoCoverToGif() {
        
//        let gallery = GalleryController()
//        gallery.delegate = self
//        present(gallery, animated: true, completion: nil)
        
//        let webvc = WebViewController()
//        webvc.loadRequest(urlString: "http://www.baidu.com")
//        present(webvc, animated: true, completion: nil)
        
        
    }
}

