//
//  UIView+Toast.swift
//  projectDemo
//
//  Created by Cheng on 2021/11/15.
//

import Foundation
import Toast_Swift

public extension UIView {
    
    func makeCommonToast(_ toast: String?) {
        let style = ToastStyle()
        makeToast(toast, duration: 2, position: .center, title: nil, image: nil, style: style, completion: nil)
    }
}
