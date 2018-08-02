# Add performAndWait Swift Variant that Throws and Returns a Value

rdar://42826517

[OpenRadar](https://openradar.appspot.com/42826517)

## Summary

There have been a number of times in this recent project I'm working on where I've wanted to get a value out of a block passed to performAndWait, as well as a way to propagate errors up the call stack. It would be really great if NSManagedObjectContext had a variant of performAndWait that could throw and return a value, similar to one of DispatchQueue's sync methods. For example, the method would look something like this:

```swift
func performAndWait<T>(_ block: () throws -> T) rethrows -> T
```

I've been able to achieve this functionality by adding this extension to NSManagedObjectContext, but having a system-provided implementation would be great.

```swift
private enum Something<T> {
    case nothing
    case value(T)
    case error(Error)
}

extension NSManagedObjectContext {
    
    func performAndWait<T>(_ block: () throws -> T) throws -> T {
        var value: Something<T> = .nothing
        
        performAndWait {
            do {
                value = .value(try block())
            } catch let caughtError {
                value = .error(caughtError)
            }
        }
        
        switch value {
        case .nothing:
            fatalError("Somehow got nothing. System error where our block was not called?")
        case let .error(error):
            throw error
        case let .value(value):
            return value
        }
    }
    
}
```

The common use case for me has been executing a fetch request, performing some transformation on the returned objects, and then passing those transformed objects back. Here's a little bit of a contrived example, but it shows off how this might work:

```swift
func getActiveUsers() throws -> [User] {
    return try viewContext.performAndWait {
         let userObjects = try viewContext.execute(usersFetchRequest)
         let users = userObjects.filter({ $0.isActive == true })
         return users
    }
}
```
