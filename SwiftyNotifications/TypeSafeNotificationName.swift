//
//  TypeSafeNotificationName.swift
//  SwiftyNotifications
//  Created by Joe Thomson on 02/05/2020.
//  Copyright © 2020 Joe Thomson. All rights reserved.
//

import Foundation

extension Notification
{
    /// A wrapper around `Notification.Name`, with additional functions to guarantee the resulting notification's object type.
    public struct TypeSafeName<T>: Hashable, Equatable, RawRepresentable
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

public extension Notification.TypeSafeName
{
    /// Adds an entry to the given notification center's dispatch table for this notification name, with a block to add to the queue, and an optional sender.
    /// - Warning: The `block` closure has an extra parameter of guaranteed type `T`. If a notification with this name is posted using the standard `NotificationCenter` functions you must ensure the type of the sender object is also of type `T` or you will encounter fatal errors. To avoid this issue you should use the special type-safe `post(object:)` and `postOnMainQueue(object:)` functions on `Notification.TypeSafeName`.
    @discardableResult func addObserver(object anObject: T? = nil, queue: OperationQueue? = nil, center: NotificationCenter = .default, using block: @escaping @Sendable (Notification, T) -> Void) -> NSObjectProtocol?
    {
        let observer = center.addObserver(forName: self.underlyingName, object: anObject, queue: queue) { notification in
            block(notification, notification.object as! T)
        }
        return observer
    }
    
    /// Removes matching entries from the notification center's dispatch table.
    func removeObserver(_ observer: Any, object: T? = nil, center: NotificationCenter = .default)
    {
        center.removeObserver(observer, name: self.underlyingName, object: object)
    }
    
    /// Creates a notification with this name and the given sender and posts it to the given notification center on the current dispatch queue.
    func post(object anObject: T, to center: NotificationCenter = .default)
    {
        center.post(name: self.underlyingName, object: anObject)
    }
}

extension Notification.TypeSafeName: Sendable where T: Sendable
{
    /// Creates a notification with this name and the given sender and posts it to the default notification center asynchronously on the main dispatch queue.
    @available(iOS 13.0, *)
    func postOnMainQueue(object anObject: T)
    {
        Task { @MainActor in
            self.post(object: anObject)
        }
    }
}

public extension Notification.TypeSafeName where T: ExpressibleByNilLiteral
{
    /// Adds an entry to the given notification center's dispatch table for this notification name, with a block to add to the queue, and an optional sender.
    /// - Warning: The `block` closure has an extra parameter of guaranteed type `T`. If a notification with this name is posted using the standard `NotificationCenter` functions you must ensure the type of the sender object is also of type `T` or you will encounter fatal errors. To avoid this issue you should use the special type-safe `post(object:)` and `postOnMainQueue(object:)` functions on `Notification.TypeSafeName`.
    @discardableResult func addObserver(object anObject: T? = nil, queue: OperationQueue? = nil, center: NotificationCenter = .default, using block: @escaping @Sendable (Notification, T) -> Void) -> NSObjectProtocol?
    {
        let observer = center.addObserver(forName: self.underlyingName, object: anObject, queue: queue) { notification in
            if let object = notification.object, object is NSNull == false
            {
                block(notification, object as! T)
            }
            else
            {
                block(notification, nil)
            }
        }
        return observer
    }
    
    /// Creates a notification with this name and posts it to the given notification center on the current dispatch queue.
    func post(to center: NotificationCenter = .default)
    {
        self.post(object: nil, to: center)
    }
}

extension Notification.TypeSafeName: ExpressibleByStringLiteral
{
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: Self.StringLiteralType)
    {
        self.init(rawValue: value)
    }
}
