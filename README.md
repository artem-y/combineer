# Combineer
Lightweight collection of helpers and tools to make working with Apple's Combine framework more convenient and decrease the amount of Combine-related boilerplate code.  
Please feel free to request some nice-to-have features or point out the things that need improvement.
## What's included
### BindingObject
Protocol that provides a `bind` method to use instead of the standard `sink`+`store` to make the call sites cleaner.  
Example, instead of this
```swift5
somePublisher
    .sink { [weak self] value in
        self?.doSomething(with: value)
    }
    .store(in: cancellables)
```
objects that conform to `BindingObject` can now bind the received value as follows:
```swift5
bind(somePublisher) { [weak self] value in
    self?.doSomething(with: value)
}
