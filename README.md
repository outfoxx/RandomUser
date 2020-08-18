# RandomUser

Simple library for fetching & transforming random user data from [randomuser.me](https://randomuser.me) and supplying it to SwiftUI previews.

Fetching Standard Data:
```swift

RandomUserFetch<MyViewData>()
  .execute(count: 100)
  .map { user in 
    // do something with user data
  }

```

Fetching Custom Formatted Data:
```swift

struct MyViewData {
  let name: String
  let avatar: String
}

RandomUserFetch<MyViewData>()
  .execute(count: 100) { user, _ in
    MyViewData(name: "\(user.name!.last), \(user.name!.first)", avatar: user.picture!.large)    
  }
  .sink(...)

```
