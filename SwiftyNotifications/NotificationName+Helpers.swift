//
//  NotificationName+Helpers.swift
//  SwiftyNotifications
//  Created by Joe Thomson on 02/05/2020.
//  Copyright © 2020 Joe Thomson. All rights reserved.
//

import Foundation

public extension Notification
{
    typealias Block = (Notification) -> Void
}

public extension Notification.Name
{
    /// Adds an entry to the given notification center's dispatch table for this notification name, with an observer and a notification selector and an optional sender.
    func addObserver(_ observer: Any, selector aSelector: Selector, object anObject: Any? = nil, center: NotificationCenter = .default)
    {
        center.addObserver(observer, selector: aSelector, name: self, object: anObject)
    }
    
    /// Adds an entry to the given notification center's dispatch table for this notification name, with a block to add to the queue, and an optional sender.
    @discardableResult func addObserver(object anObject: Any? = nil, queue: OperationQueue? = nil, center: NotificationCenter = .default, using block: @escaping Notification.Block) -> NSObjectProtocol
    {
        center.addObserver(forName: self, object: anObject, queue: queue, using: block)
    }
    
    /// Removes matching entries from the notification center's dispatch table.
    func removeObserver(_ observer: Any, object: Any? = nil, center: NotificationCenter = .default)
    {
        center.removeObserver(observer, name: self, object: object)
    }
    
    /// Creates a notification with this name and the given sender and posts it to the given notification center on the current dispatch queue.
    func post(object anObject: Any? = nil, to center: NotificationCenter = .default)
    {
        center.post(name: self, object: anObject)
    }
    
    /// Creates a notification with this name and the given sender and posts it to the given notification center asynchronously on the main dispatch queue.
    func postOnMainQueue(object anObject: Any? = nil, to center: NotificationCenter = .default)
    {
        DispatchQueue.main.async
        {
            self.post(object: anObject, to: center)
        }
    }
}

extension Notification.Name: ExpressibleByStringLiteral
{
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: Self.StringLiteralType)
    {
        self.init(rawValue: value)
    }
}
