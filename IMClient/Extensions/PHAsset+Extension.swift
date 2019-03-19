//
//  PHAsset+Extension.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/18.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import Foundation
import Photos

extension PHAsset {
    
    /// 图片对象
    ///
    /// - Returns: 返回图片
    @discardableResult
    class func getImage(asset: PHAsset) -> UIImage? {
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.resizeMode = .none
        options.isNetworkAccessAllowed = false
        options.version = .current
        var image: UIImage? = nil
        _ = PHCachingImageManager().requestImageData(for: asset, options: options) { (imageData, dataUTI, orientation, info) in
            if let data = imageData {
                image = UIImage(data: data)
            }
        }
        
        return image
    }
    
    /// 文件地址
    ///
    /// - Parameter handler: (地址) -> Void
    func getURL(handler : @escaping ((_ responseURL: URL?) -> Void)) {
        let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
        self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, _: [AnyHashable: Any]) -> Void in
            handler(contentEditingInput!.fullSizeImageURL as URL?)
        })
    }
}
