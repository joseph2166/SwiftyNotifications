//
//  NotificationName+Publisher.swift
//  Copyright © 2024 NatureGuides. All rights reserved.
//

import Foundation
import Combine

public extension Notification.Name
{
    /// A combine publisher for this notification name on the default notification center.
    var publisher: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: self)
    }
}
