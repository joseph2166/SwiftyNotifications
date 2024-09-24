//
//  NotificationName+AsyncStream.swift
//  Copyright © 2024 NatureGuides. All rights reserved.
//

import Foundation

public extension Notification.Name
{
    /// An `AsyncStream` that yields every time a notification with this name is posted to the default notification center.
    @available(iOS 15, macCatalyst 15, macOS 12, tvOS 15, watchOS 8, *)
    var asyncStream: AsyncStream<Notification.Name> {
        AsyncStream { continuation in
            let task = Task {
                for await _ in NotificationCenter.default.notifications(named: self)
                {
                    continuation.yield(self)
                }
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }
}
