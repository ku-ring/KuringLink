![Frame 7@3x](https://user-images.githubusercontent.com/53814741/231982450-ffdecc10-9178-493f-be70-8fd40002ace8.png)

KuringLink is a networking module that links between Kuring iOS service and Kuring backend.

## Concepts
| User | Antenna | Communication Satellite | Space probe | Space information |
| ---- | ------- | ----------------------- | ----------- | ----------------- |
| App  | SDK Public Interfaces | API Networking Module | Backend | Database  |

## Code examples
```swift
KuringLink.setup(key: "{API.KEY}")
try await KuringLink.scanEssentials()
let notices = await KuringLink.searchNotice(keyword: "2023")
try await KuringLink.sendFeedback()
```

## KuringLink

The singleton class for the public *static* interfaces. It communicates with [TheSatellite/Satellite](https://github.com/KU-Stacks/TheSatellite) via `Antenna`.
```swift
KuringLink.setup(key: "{API.KEY}")
try await KuringLink.scanEssentials()
```

### Setting up with API key
Create `Antenna` instance. This will create a new `Satellite` instance with API key internally.
```swift
private static var antenna = Antenna()

public static func setup(key: Stirng) {
    let antenna = Antenna(key: key)
    Self.antenna = antenna
}
```

### Scanning the essentials
Fetch the essential data from the server such as:
- all departments
- Kuring ID with uid provided by Apple / Google
- notices for the timeline
- whether there is any updates for the version or the resources
```swift
public static func scanEssentials() async throws {
    try await Self.antenna.scanEssentials()
}
```

## Antenna (Private)
The main internal class that matches with KuringLink's public interfaces as 1:1. It's kind of a concrete instance. It communicates with `Satellite` intance **DIRECTLY**.

### Scanning the essentials
> **INFO**: Please refer to KuringLink/Scanning the essentials section.

```swift
func scanEssentials() async throws {
    let depts = try await satellite.response(from: DeparmentListRequest())
    
    if let uid = UserDefaults.kuringLink.uid {
        let account = try await satellite.response(from: AccountRequest(uid: uid))
    }
    // fetching subscriptions...
    // checking new version status...
    // checking resources updates...
```

## KuringRouter
The class that contains and manages all publishers. It handles all events from KuringLink.
```swift
MyAppView()
    .receive(on: KuringRouter.myAppPublisher) {
        print($0)
    }
```
