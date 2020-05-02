//
//  TypeSafeNotificationName.swift
//  SwiftyNotifications
//  Created by Joe Thomson on 02/05/2020.
//  Copyright © 2020 Joe Thomson. All rights reserved.
//

import Foundation

extension Notification.Name
{
    /// A wrapper around `Notification.Name`, with additional functions to guarantee the resulting notification's object type.
    public struct TypeSafe<T>: Hashable, Equatable, RawRepresentable
    {
        public typealias RawValue = String
        public let rawValue: String
        
        /// The underlying `Notification.Name` object represented by this `TypeSafe` object.
        public let underlyingName: Notification.Name
        
        public init(rawValue: String)
        {
            self.rawValue = rawValue
            self.underlyingName = Notification.Name(rawValue)
        }
    }
}

extension Notification.Name.TypeSafe
{
    /// Adds an entry to the given notification center's dispatch table for this notification name, with a block to add to the queue, and an optional sender.
    /// - Warning: The `block` closure has an extra parameter of guaranteed type `T`. If a notification with this name is posted using the standard `NotificationCenter` functions you must ensure the type of the sender object is also of type `T` or you will encounter fatal errors. To avoid this issue you should use the special type-safe `post(object:)` and `postOnMainQueue(object:)` functions on `Notification.Name.TypeSafe`.
    @discardableResult func addObserver(object anObject: T, queue: OperationQueue? = nil, center: NotificationCenter = .default, using block: @escaping (Notification, T) -> Void) -> NSObjectProtocol?
    {
        let observer = center.addObserver(forName: self.underlyingName, object: anObject, queue: queue) { notification in
            block(notification, notification.object as! T)
        }
        return observer
    }
    
    /// Creates a notification with this name and the given sender and posts it to the given notification center on the current dispatch queue.
    func post(object anObject: T, to center: NotificationCenter = .default)
    {
        center.post(name: self.underlyingName, object: anObject)
    }
    
    /// Creates a notification with this name and the given sender and posts it to the given notification center synchronously on the main dispatch queue.
    func postOnMainQueue(object anObject: T, to center: NotificationCenter = .default)
    {
        DispatchQueue.main.sync
        {
            self.post(object: anObject, to: center)
        }
    }
}

extension Notification.Name.TypeSafe where T: ExpressibleByNilLiteral
{
    /// Adds an entry to the given notification center's dispatch table for this notification name, with a block to add to the queue, and an optional queue.
    @discardableResult func addObserver(queue: OperationQueue? = nil, center: NotificationCenter = .default, using block: @escaping (Notification, T) -> Void) -> NSObjectProtocol?
    {
        self.addObserver(object: nil, queue: queue, center: center, using: block)
    }
    
    /// Creates a notification with this name and posts it to the given notification center on the current dispatch queue.
    func post(to center: NotificationCenter = .default)
    {
        self.post(object: nil, to: center)
    }
    
    /// Creates a notification with this name and posts it to the given notification center synchronously on the main dispatch queue.
    func postOnMainQueue(to center: NotificationCenter = .default)
    {
        self.postOnMainQueue(object: nil, to: center)
    }
}

extension Notification.Name.TypeSafe: ExpressibleByStringLiteral
{
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: Self.StringLiteralType)
    {
        self.init(rawValue: value)
    }
}
