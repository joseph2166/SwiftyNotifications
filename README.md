## SwiftyNotifications
##### Swift helpers around Foundation's Notification.Name

SwiftyNotifications is an easy and type-safe way to work with `Notification.Name` in Swift.

### Usage
Notification name objects can be created with string literals:
```swift
let somethingDidChange: Notification.Name = "SomethingChanged"
```

**Add observers** using block syntax; blocks are guaranteed to always run on the main thread, even if notifications are posted on a different thread.

```swift
somethingDidChange.addObserver() { notification in
	// Do something
}
```

**Post notifications** thusly:

```swift
somethingDidChange.post()
```

A **type-safe generic type** with identical syntax is available when using sender objects:

```swift
let boolDidChange: Notification.TypeSafeName<Bool> = "BoolChanged"

boolDidChange.post(true) // Must send a Bool

boolDidChange.addObserver() { notification, object in
	// `object` is guaranteed to be a Bool
}
```
