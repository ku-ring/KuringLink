![Frame 7@3x](https://user-images.githubusercontent.com/53814741/231982450-ffdecc10-9178-493f-be70-8fd40002ace8.png)

KuringLink is a networking module that links between Kuring iOS service and Kuring backend.

## Concepts
| User | Antenna | Communication Satellite | Space probe | Space information |
| ---- | ------- | ----------------------- | ----------- | ----------------- |
| App  | SDK Public Interfaces | API Networking Module | Backend | Database  |

## Code examples
```swift
import Enigma
import KuringLink

let host = Enigma.kuring.decode(key: "{KEY.FOR.HOST}")
KuringLink.setup(host: host)

try await KuringLink.scanEssentials()
let notices = try await KuringLink.notices(startsWith: "2023")
try await KuringLink.sendFeedback(
    "Hi", 
    fcmToken: "{FCM.TOKEN}",
    appVersion: "2.0.0",
    osVersion: "16.0"
)
```

## KuringLink

The singleton class for the public *static* interfaces. It communicates with [TheSatellite/Satellite](https://github.com/KU-Stacks/TheSatellite) via `Antenna`.
```swift
KuringLink.setup(host: "{HOST}")
try await KuringLink.scanEssentials()
```

### Setting up host and scheme to get start KuringLink with its satellite
Create `Antenna` instance. This will create a new `Satellite` instance with API key internally.
```swift
import Enigma
import KuringLink

let host = Enigma.kuring.decode(key: "{KEY.FOR.HOST}")
KuringLink.setup(host: host)

public static func setup(host: String, scheme: Satellite.Scheme = .https) {
    antenna = Antenna(host: host, scheme: scheme)
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
    try await antenna.scanEssentials()
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
}
```

## KuringRouter
The class that contains and manages all publishers. It handles all events from KuringLink.
```swift
MyAppView()
    .receive(on: KuringRouter.noticeNotificationPublisher) { notice in
        print(notice)
    }
```
