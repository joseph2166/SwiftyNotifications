//
//  NotificationName+Helpers.swift
//  Copyright © 2024 Joe Thomson. All rights reserved.
//

import Foundation

public extension Notification
{
    typealias Block = @Sendable (Notification) -> Void
    typealias AsyncBlock = @MainActor @Sendable (Notification.Name) async -> Void
}

public extension Notification.Name
{
    /// Adds an entry to the default notification center's dispatch table for this notification name, with a block that will run on the main thread.
    @discardableResult func addObserver(using block: @escaping Notification.Block) -> NSObjectProtocol
    {
        NotificationCenter.default.addObserver(forName: self, object: nil, queue: .main) { notification in
            block(notification)
        }
    }
    
    /// Adds an entry to the default notification center's dispatch table for this notification name, with a block that will run on the main actor.
    @discardableResult func addAsyncObserver(using block: @escaping Notification.AsyncBlock) -> NSObjectProtocol
    {
        NotificationCenter.default.addObserver(forName: self, object: nil, queue: .main) { notification in
            Task { @MainActor in
                await block(self)
            }
        }
    }
    
    /// Removes matching entries from the default notification center's dispatch table.
    func removeObserver(_ observer: NSObjectProtocol)
    {
        NotificationCenter.default.removeObserver(observer, name: self, object: nil)
    }
    
    /// Creates a notification with this name and the given object and posts it to the default notification center on the main dispatch queue.
    func post()
    {
        NotificationCenter.default.post(name: self, object: nil)
    }
    
    /// An `AsyncStream` that yields every time a notification with this name is posted to the default notification center.
    @available(iOS 15, macCatalyst 15, macOS 12, tvOS 15, watchOS 8, *)
    var asyncStream: AsyncStream<Notification.Name> {
        AsyncStream { continuation in
            let task = Task {
                for await notification in NotificationCenter.default.notifications(named: self)
                {
                    continuation.yield(self)
                }
            }
            continuation.onTermination = { _ in task.cancel() }
        }
      }
}

extension Notification.Name: @retroactive ExpressibleByStringLiteral
{
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: Self.StringLiteralType)
    {
        self.init(rawValue: value)
    }
}
