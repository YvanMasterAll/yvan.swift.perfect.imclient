//
//  Date+Extension.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/7.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import Foundation

/// 日期扩展
extension Date {
    
    /// 日期转字符串
    /// - parameter date: 日期
    /// - parameter dateFormat: 格式字符串
    static func toString(date: Date = Date(), dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        
        return formatter.string(from: date)
    }
    
    /// 字符串转日期
    /// - parameter dateString: 日期字符串
    /// - parameter dateFormat: 格式字符串
    static func toDate(dateString: String, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        
        return formatter.date(from: dateString)!
    }
    
    /// 判断两个日期是否是同一天
    /// - parameter dateA: 日期一
    /// - parameter dateB: 日期二
    static func isInSameDay(_ dateA: Date, _ dateB: Date) -> Bool {
        let calendar = NSCalendar.current
        let comA = calendar.dateComponents([.year, .month, .day], from: dateA)
        let comB = calendar.dateComponents([.year, .month, .day], from: dateB)
        return comA.year == comB.year && comA.month == comB.month && comA.day == comB.day
    }
}
