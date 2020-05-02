## SwiftyNotifications
##### Swift helpers around Foundation's Notification.Name

SwiftyNotifications is an easy way to work with `Notification.Name` in Swift.

### Usage
Notification name objects can be created with string literals:
```swift
let somethingDidChange: Notification.Name = "SomethingChanged"
```

**Add observers** using block syntax...

```swift
somethingDidChange.addObserver() { notification in
	// Do something
}
```

...or @objc selectors:


```swift
somethingDidChange.addObserver(self, selector: #selector(somethingDidChange))
```

**Post notifications** thusly:

```swift
somethingDidChange.post()
```

All functions support overriding use of the default `NotificationCenter`, for example:

```swift
let aCenter = NotificationCenter()
somethingDidChange.post(to: aCenter)
```

A **type-safe generic type** with identical syntax is available when using sender objects:

```swift
let boolDidChange: Notification.Name.TypeSafe<Bool> = "BoolChanged"

boolDidChange.post(true) // Must send a Bool

boolDidChange.addObserver() { notification, object in
	// `object` is guaranteed to be a Bool
}
```