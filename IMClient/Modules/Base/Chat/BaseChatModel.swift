//
//  BaseChatModel.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/10.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit

class BaseChatModel: IMUIMessageModel {
    
    //MARK: - 声明区域
    var _text       : String = ""   //文本消息
    var mediaPath   : String = ""   //媒体目录
    var imageUrl    : String = ""   //图片地址
    
    override func text() -> String {
        return self._text
    }
    
    override func mediaFilePath() -> String {
        return mediaPath
    }
    
    override func webImageUrl() -> String {
        return imageUrl
    }
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - msgId           : 消息标识
    ///   - messageStatus   : 消息状态
    ///   - fromUser        : 用户对象
    ///   - isOutGoing      : 消息方向, true, 发送消息
    ///   - date            : 发送时间
    ///   - type            : 消息类型
    ///   - text            : 文本内容
    ///   - mediaPath       : 媒体目录
    ///   - layout          : 消息布局
    ///   - duration        : 延迟时间
    init(msgId: String,
         messageStatus: IMUIMessageStatus,
         fromUser: ChatUser,
         isOutGoing: Bool,
         date: Date,
         type: ChatMessageType,
         text: String,
         mediaPath: String,
         layout: IMUIMessageCellLayoutProtocol,
         duration: CGFloat?) {
        self._text = text
        self.mediaPath = mediaPath
        super.init(msgId: msgId,
                   messageStatus: messageStatus,
                   fromUser: fromUser,
                   isOutGoing: isOutGoing,
                   time: Date.toString(date: date),
                   type: type.value,
                   cellLayout: layout,
                   duration: duration)
    }
    
    //MARK: - 文本消息
    convenience init(msgId: String,
                     text: String,
                     fromUser: ChatUser,
                     isOutGoing: Bool,
                     date: Date,
                     status: IMUIMessageStatus) {
        let layout = ChatCellLayout(isOutGoingMessage: isOutGoing,
                                    isNeedShowTime: true,
                                    bubbleContentSize: BaseChatModel
                                        .calculateTextContentSize(text: text),
                                    bubbleContentInsets: UIEdgeInsets.zero,
                                    timeLabelContentSize: CGSize(width: 200, height: 20),
                                    type: ChatMessageType.text)
        self.init(msgId: msgId,
                  messageStatus: status,
                  fromUser: fromUser,
                  isOutGoing: isOutGoing,
                  date: date,
                  type: ChatMessageType.text,
                  text: text,
                  mediaPath: "",
                  layout:  layout,
                  duration: 10)
    }
    
    //MARK: - 音频消息
    convenience init(voicePath: String,
                     fromUser: ChatUser,
                     duration: CGFloat,
                     isOutGoing: Bool) {
        let layout = ChatCellLayout(isOutGoingMessage: isOutGoing,
                                    isNeedShowTime: false,
                                    bubbleContentSize: CGSize(width: 80, height: 37),
                                    bubbleContentInsets: UIEdgeInsets.zero,
                                    timeLabelContentSize: CGSize.zero,
                                    type: ChatMessageType.voice)
        let msgId = "\(NSDate().timeIntervalSince1970 * 1000)"
        self.init(msgId: msgId,
                  messageStatus: .sending,
                  fromUser: fromUser,
                  isOutGoing: isOutGoing,
                  date: Date(),
                  type: ChatMessageType.voice,
                  text: "",
                  mediaPath: voicePath,
                  layout:  layout,
                  duration: duration)
    }
    
    //MARK: - 图片消息, 本地
    convenience init(msgId: String,
                     imagePath: String,
                     fromUser: ChatUser,
                     isOutGoing: Bool) {
        var imgSize = CGSize(width: 120, height: 160)
        if let img = UIImage(contentsOfFile: imagePath) {
            imgSize = BaseChatModel
                .coverImageSize(with: CGSize(width: (img.cgImage?.width)!,
                                              height: (img.cgImage?.height)!))
        }
        let layout = ChatCellLayout(isOutGoingMessage: isOutGoing,
                                    isNeedShowTime: false,
                                    bubbleContentSize: imgSize,
                                    bubbleContentInsets: UIEdgeInsets.zero,
                                    timeLabelContentSize: CGSize.zero,
                                    type: ChatMessageType.image)
        self.init(msgId: msgId,
                  messageStatus: .sending,
                  fromUser: fromUser,
                  isOutGoing: isOutGoing,
                  date: Date(),
                  type: ChatMessageType.image,
                  text: "",
                  mediaPath: imagePath,
                  layout:  layout,
                  duration: nil)
    }
    
    //MARK: - 图片消息, URL
    convenience init(msgId: String,
                     imageUrl: String,
                     fromUser: ChatUser,
                     isOutGoing: Bool) {
        let layout = ChatCellLayout(isOutGoingMessage: isOutGoing,
                                           isNeedShowTime: true,
                                           bubbleContentSize: CGSize(width: 120, height: 160),
                                           bubbleContentInsets: UIEdgeInsets.zero,
                                           timeLabelContentSize: CGSize(width: 200, height: 20),
                                           type: ChatMessageType.image)
        self.init(msgId: msgId,
                  messageStatus: .sending,
                  fromUser: fromUser,
                  isOutGoing: isOutGoing,
                  date: Date(),
                  type: ChatMessageType.image,
                  text: "",
                  mediaPath: "",
                  layout:  layout,
                  duration: nil)
        self.imageUrl = imageUrl
    }
    
    //MARK: - 视频消息
    convenience init(videoPath: String,
                     fromUser: ChatUser,
                     isOutGoing: Bool) {
        let layout = ChatCellLayout(isOutGoingMessage: isOutGoing,
                                    isNeedShowTime: false,
                                    bubbleContentSize: CGSize(width: 120, height: 160),
                                    bubbleContentInsets: UIEdgeInsets.zero,
                                    timeLabelContentSize: CGSize.zero,
                                    type: ChatMessageType.voice)
        let msgId = "\(NSDate().timeIntervalSince1970 * 1000)"
        self.init(msgId: msgId,
                  messageStatus: .sending,
                  fromUser: fromUser,
                  isOutGoing: isOutGoing,
                  date: Date(),
                  type: ChatMessageType.voice,
                  text: "",
                  mediaPath: videoPath,
                  layout:  layout,
                  duration: nil)
    }
    
    //MARK: - 文本尺寸
    static func calculateTextContentSize(text: String) -> CGSize {
        let textSize  = text.sizeWithConstrainedWidth(with: IMUIMessageCellLayout.bubbleMaxWidth, font: UIFont.systemFont(ofSize: 18))
        return textSize
    }
    
    //MARK: - 图片尺寸
    static func coverImageSize(with size: CGSize) -> CGSize {
        let maxSide = 160.0
        var scale = size.width / size.height
        if size.width > size.height {
            scale = scale > 2 ? 2 : scale
            return CGSize(width: CGFloat(maxSide), height: CGFloat(maxSide) / CGFloat(scale))
        } else {
            scale = scale < 0.5 ? 0.5 : scale
            return CGSize(width: CGFloat(maxSide) * CGFloat(scale), height: CGFloat(maxSide))
        }
    }
}

//MARK: - Chat Message Type
enum ChatMessageType {
    
    case text   //文本
    case image  //图片
    case voice  //音频
    case video  //视频
    
    var value: String {
        switch self {
        case .text : return "text"
        case .image: return "image"
        case .voice: return "voice"
        case .video: return "video"
        }
    }
}

//MARK: - IMUIMessageCellLayoutProtocol
class ChatCellLayout: IMUIMessageCellLayout {
    
    var type: ChatMessageType    //消息类型
    
    override var bubbleContentType: String {
        return type.value
    }
    
    init(isOutGoingMessage: Bool,
         isNeedShowTime: Bool,
         bubbleContentSize: CGSize,
         bubbleContentInsets: UIEdgeInsets,
         timeLabelContentSize: CGSize,
         type: ChatMessageType) {
        self.type = type
        super.init(isOutGoingMessage: isOutGoingMessage,
                   isNeedShowTime: isNeedShowTime,
                   bubbleContentSize: bubbleContentSize,
                   bubbleContentInsets: UIEdgeInsets.zero,
                   timeLabelContentSize: timeLabelContentSize)
    }
    
    //MARK: - 消息边距
    override var bubbleContentInset: UIEdgeInsets {
        if type != ChatMessageType.text { return UIEdgeInsets.zero }
        if isOutGoingMessage {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 15)
        } else {
            return UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 10)
        }
    }
    
    //MARK: - 消息对象
    override var bubbleContentView: IMUIMessageContentViewProtocol {
        switch type {
        case .text:
            return IMUITextMessageContentView()
        case .image:
            return IMUIImageMessageContentView()
        case .voice:
            return IMUIVoiceMessageContentView()
        case .video:
            return IMUIVideoMessageContentView()
        }
        //return IMUIDefaultContentView()
    }
}

//MARK: - 用户
class ChatUser: NSObject, IMUIUserProtocol {
    
    //MARK: - 声明区域
    var id      : Int       //用户标识
    var name    : String    //用户名称
    var avatar  : String    //用户头像
    
    init(id: Int, name: String, avatar: String) {
        self.id = id
        self.name = name
        self.avatar = avatar
    }
    
    func userId() -> String {
        return "\(id)"
    }
    
    func displayName() -> String {
        return name
    }
    
    func avatarUrlString() -> String? {
        return avatar
    }
    
    func Avatar() -> UIImage? {
        return nil
    }
}

