//
//  SwiftTImer.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/19.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

/// https://github.com/100mango/SwiftTimer

/*
 ####single timer, self must be strong
    self.timer = SwiftTimer(interval: .seconds(2)) {
        print("fire")
    }
    self.timer.start()

 ####repeatic timer
    timer = SwiftTimer.repeaticTimer(interval: .seconds(1)) {
        print("fire")
    }
    timer.start()

 ####dynamically changing interval
    timer = SwiftTimer.repeaticTimer(interval: .seconds(5)) { timer in
        print("doSomething")
    }
    timer.start()  // print doSomething every 5 seconds

    func speedUp(timer: SwiftTimer) {
        timer.rescheduleRepeating(interval: .seconds(1))
    }
    speedUp(timer) // print doSomething every 1 second

 ####throttle
    The closure will be called after interval you specified. It is invalid to call again in the interval.

    SwiftTimer.throttle(interval: .seconds(0.5), identifier: "refresh") {
        refresh();
    }

 ####debounce
    The closure will be called after interval you specified. Calling again in the interval cancels the previous call.

    SwiftTimer.debounce(interval: .seconds(0.5), identifier: "search") {
        search(inputText)
    }

 ####count down timer
    timer = SwiftCountDownTimer(interval: .fromSeconds(0.1), times: 10) { timer , leftTimes in
        label.text = "\(leftTimes)"
    }
    timer.start()
 */


import Foundation

public class SwiftTimer {
    
    private let internalTimer: DispatchSourceTimer
    
    private var isRunning = false
    
    public let repeats: Bool
    
    public typealias SwiftTimerHandler = (SwiftTimer) -> Void
    
    private var handler: SwiftTimerHandler
    
    public init(interval: DispatchTimeInterval, repeats: Bool = false, leeway: DispatchTimeInterval = .seconds(0), queue: DispatchQueue = .main , handler: @escaping SwiftTimerHandler) {
        
        self.handler = handler
        self.repeats = repeats
        internalTimer = DispatchSource.makeTimerSource(queue: queue)
        internalTimer.setEventHandler { [weak self] in
            if let strongSelf = self {
                handler(strongSelf)
            }
        }
        
        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval, leeway: leeway)
        } else {
            internalTimer.schedule(deadline: .now() + interval, leeway: leeway)
        }
    }
    
    public static func repeaticTimer(interval: DispatchTimeInterval, leeway: DispatchTimeInterval = .seconds(0), queue: DispatchQueue = .main , handler: @escaping SwiftTimerHandler ) -> SwiftTimer {
        return SwiftTimer(interval: interval, repeats: true, leeway: leeway, queue: queue, handler: handler)
    }
    
    deinit {
        if !self.isRunning {
            internalTimer.resume()
        }
    }
    
    //You can use this method to fire a repeating timer without interrupting its regular firing schedule. If the timer is non-repeating, it is automatically invalidated after firing, even if its scheduled fire date has not arrived.
    public func fire() {
        if repeats {
            handler(self)
        } else {
            handler(self)
            internalTimer.cancel()
        }
    }
    
    public func start() {
        if !isRunning {
            internalTimer.resume()
            isRunning = true
        }
    }
    
    public func suspend() {
        if isRunning {
            internalTimer.suspend()
            isRunning = false
        }
    }
    
    public func rescheduleRepeating(interval: DispatchTimeInterval) {
        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval)
        }
    }
    
    public func rescheduleHandler(handler: @escaping SwiftTimerHandler) {
        self.handler = handler
        internalTimer.setEventHandler { [weak self] in
            if let strongSelf = self {
                handler(strongSelf)
            }
        }
        
    }
}

//MARK: Throttle
public extension SwiftTimer {
    
    private static var workItems = [String:DispatchWorkItem]()
    
    ///The Handler will be called after interval you specified
    ///Calling again in the interval cancels the previous call
    public static func debounce(interval: DispatchTimeInterval, identifier: String, queue: DispatchQueue = .main , handler: @escaping () -> Void ) {
        
        //if already exist
        if let item = workItems[identifier] {
            item.cancel()
        }
        
        let item = DispatchWorkItem {
            handler();
            workItems.removeValue(forKey: identifier)
        };
        workItems[identifier] = item
        queue.asyncAfter(deadline: .now() + interval, execute: item);
    }
    
    ///The Handler will be called after interval you specified
    ///It is invalid to call again in the interval
    public static func throttle(interval: DispatchTimeInterval, identifier: String, queue: DispatchQueue = .main , handler: @escaping () -> Void ) {
        
        //if already exist
        if workItems[identifier] != nil {
            return;
        }
        
        let item = DispatchWorkItem {
            handler();
            workItems.removeValue(forKey: identifier)
        };
        workItems[identifier] = item
        queue.asyncAfter(deadline: .now() + interval, execute: item);
        
    }
    
    public static func cancelThrottlingTimer(identifier: String) {
        if let item = workItems[identifier] {
            item.cancel()
            workItems.removeValue(forKey: identifier)
        }
    }
    
    
    
}

//MARK: Count Down
public class SwiftCountDownTimer {
    
    private let internalTimer: SwiftTimer
    
    private var leftTimes: Int
    
    private let originalTimes: Int
    
    private let handler: (SwiftCountDownTimer, _ leftTimes: Int) -> Void
    
    public init(interval: DispatchTimeInterval, times: Int,queue: DispatchQueue = .main , handler:  @escaping (SwiftCountDownTimer, _ leftTimes: Int) -> Void ) {
        
        self.leftTimes = times
        self.originalTimes = times
        self.handler = handler
        self.internalTimer = SwiftTimer.repeaticTimer(interval: interval, queue: queue, handler: { _ in
        })
        self.internalTimer.rescheduleHandler { [weak self]  swiftTimer in
            if let strongSelf = self {
                if strongSelf.leftTimes > 0 {
                    strongSelf.leftTimes = strongSelf.leftTimes - 1
                    strongSelf.handler(strongSelf, strongSelf.leftTimes)
                } else {
                    strongSelf.internalTimer.suspend()
                }
            }
        }
    }
    
    public func start() {
        self.internalTimer.start()
    }
    
    public func suspend() {
        self.internalTimer.suspend()
    }
    
    public func reCountDown() {
        self.leftTimes = self.originalTimes
    }
    
}

public extension DispatchTimeInterval {
    
    public static func fromSeconds(_ seconds: Double) -> DispatchTimeInterval {
        return .milliseconds(Int(seconds * 1000))
    }
}
