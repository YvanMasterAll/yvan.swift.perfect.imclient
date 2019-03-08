//
//  BaseUtil.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/7.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import Foundation

struct BaseUtil {
    
    //MARK: - 文件操作
    
    /// 解析Json文件为字典
    ///
    /// - Parameter filePath: 文件路径
    static func fileToDict(filePath: String) -> [String: Any]? {
        guard let path = Bundle.main.path(forResource: filePath, ofType: nil),
            let data = NSData.init(contentsOfFile: path),
            let jsonData = try? JSONSerialization.jsonObject(with: data as Data,
                                                             options: []) as? [String: Any]
            else { return nil }
        return jsonData!
    }
}
