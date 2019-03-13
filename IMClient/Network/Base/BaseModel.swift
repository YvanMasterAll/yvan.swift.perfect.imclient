//
//  BaseModel.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/7.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import Foundation
import ObjectMapper

protocol BaseModel: Mappable { }

extension BaseModel {
    
    /// 转换类别
    func transfromOfType<T>() -> TransformOf<T, String> where T: BaseType {
        return TransformOf<T, String>.init(fromJSON: { map -> T? in
            if let data = map {
                return T.init(data)
            }
            return nil
        }, toJSON: { map -> String? in
            if let data = map {
                return data.value
            }
            return nil
        })
    }
    
    /// 转换时间
    func transfromOfDate() -> TransformOf<Date , String> {
        return TransformOf<Date, String>.init(fromJSON: { map -> Date? in
            if let data = map {
                return Date.toDate(dateString: data)
            }
            return nil
        }, toJSON: { map -> String? in
            if let data = map {
                return Date.toString(date: data)
            }
            return nil
        })
    }
}
