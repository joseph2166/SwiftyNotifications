//
//  TypeSafeNotificationName.swift
//  Copyright © 2024 Joe Thomson. All rights reserved.
//

import Foundation

extension Notification
{
    /// A wrapper around `Notification.Name`, with additional functions to guarantee the resulting notification's object type.
    public struct TypeSafeName<T>: Hashable, Equatable, RawRepresentable, Sendable
    {
        public typealias Block = @Sendable (Notification, T) -> Void
        
        /// The underlying `Notification.Name` object represented by this `TypeSafeName` struct.
        private let underlyingName: Notification.Name
        
        public var rawValue: String { self.underlyingName.rawValue }
        
        public init(rawValue: String)
        {
            self.underlyingName = Notification.Name(rawValue)
        }
    }
}

public extension Notification.TypeSafeName
{
    /// Adds an entry to the default notification center's dispatch table for this notification name, with a block that will run on the main thread.
    @discardableResult func addObserver(using block: @escaping Block) -> any NSObjectProtocol
    {
        NotificationCenter.default.addObserver(forName: self.underlyingName, object: nil, queue: .main) { notification in
            block(notification, notification.object as! T)
        }
    }
    
    /// Removes matching entries from the default notification center's dispatch table.
    func removeObserver(_ observer: Any)
    {
        NotificationCenter.default.removeObserver(observer, name: self.underlyingName, object: nil)
    }
    
    /// Creates a notification with this name and the given object and posts it to the default notification center on the main dispatch queue.
    func post(object anObject: T)
    {
        NotificationCenter.default.post(name: self.underlyingName, object: anObject)
    }
}

public extension Notification.TypeSafeName where T: Sendable
{
    typealias AsyncBlock = @MainActor @Sendable (Notification.TypeSafeName<T>, T) async -> Void
    
    /// Adds an entry to the default notification center's dispatch table for this notification name, with a block that will run on the main actor.
    @discardableResult func addAsyncObserver(using block: @escaping AsyncBlock) -> any NSObjectProtocol
    {
        NotificationCenter.default.addObserver(forName: self.underlyingName, object: nil, queue: .main) { notification in
            let sendableObject = notification.object as! T
            Task { @MainActor in
                await block(self, sendableObject)
            }
        }
    }
}

public extension Notification.TypeSafeName where T: ExpressibleByNilLiteral
{
    /// Adds an entry to the default notification center's dispatch table for this notification name, with a block that will run on the main thread.
    @discardableResult func addObserver(using block: @escaping Block) -> any NSObjectProtocol
    {
        NotificationCenter.default.addObserver(forName: self.underlyingName, object: nil, queue: .main) { notification in
            if let object = notification.object, object is NSNull == false
            {
                block(notification, object as! T)
            }
            else
            {
                block(notification, nil)
            }
        }
    }
    
    /// Creates a notification with this name and posts it to the default notification center on the main dispatch queue.
    func post()
    {
        self.post(object: nil)
    }
}

public extension Notification.TypeSafeName where T: ExpressibleByNilLiteral & Sendable
{
    /// Adds an entry to the default notification center's dispatch table for this notification name, with a block that will run on the main actor.
    @discardableResult func addObserver(using block: @escaping AsyncBlock) -> any NSObjectProtocol
    {
        NotificationCenter.default.addObserver(forName: self.underlyingName, object: nil, queue: .main) { notification in
            if let object = notification.object, object is NSNull == false
            {
                let sendableObject = object as! T
                Task { @MainActor in
                    await block(self, sendableObject)
                }
            }
            else
            {
                Task { @MainActor in
                    await block(self, nil)
                }
            }
        }
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
