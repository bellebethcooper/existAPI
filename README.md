# ExistAPI

A framework for working with the [Exist](https://exist.io/) API on iOS.

ExistAPI wraps the Exist API in promises (via `PromiseKit`) to make it easier to work with API responses imperatively and chain API calls together. It also deserialises all API responses into strongly typed, `Decodable` models.

## Installation

via Cocoapods:

`pod 'ExistAPI', '~> 0.0.7'`

## Quick examples

Get a token from the Exist API to authorise your user ([details in the Exist API docs here](http://developer.exist.io/#oauth2-authentication)). Then create an API instance:

```swift
let token = getTokenFromAuthProcess()
let existAPI = ExistAPI(token: token)
```

Get the user's attributes for the past week:

```swift
existAPI.attributes()
	.done { attributes, response in
	// handle attribute models here
	}.catch { error in
	// deal with errors
	}
```

Get attributes with some params:

```swift
existAPI.attributes(names: ["steps", "mood"], limit: 12)
	.done { attributes, response in
	// handle data here
	}.catch { error in
	// handle error here
	}
```

<!-- Acquire an attribute:

```swift
existAPI.acquire(names: ["steps"])
	.done { successfullyAcquired, response in
	// deal with data here
	}.catch { error in
	// handle error
	}
```

Update data for some attributes:

```swift
let steps = AttributeData(name: "steps", date: "2018-10-05", value: 3158)
let distance = AttributeData(name: "steps_distance", date: "2018-10-05", value: 1.2)
existAPI.update(attributes: [steps, distance])
	.done { successfullyUpdated, failed in
	// if some attributes failed but some succeeded, check failures here
	}.catch { error in
	// handle error
	}
```
-->

## Usage

ExistAPI uses PromiseKit to handle asynchronous networking tasks. If you haven't used promises before, the PromiseKit docs are very good, and will help you understand the basic usage. Essentially, promises let you act on the result of an asynchronous task as if it were synchronous, making your code easier to write, read, and maintain.

Each of the public functions available in the ExistAPI class returns a Promise. You can chain these together, but the most simple use is to use a `.done` closure for handling the result and a `.catch` closure for handling errors.

Please see the examples for more ideas on how to use ExistAPI's promises.

### Requirements

- Swift 4.0
- iOS 12
- An [Exist](https://exist.io) account
- Cocoapods

### Getting started

First, you'll need to create an Exist developer client. Follow these steps to create your client:

To quickly get started, you can simply copy and paste your personal auth token from this page. This will let you start testing your app with the Exist API immediately, and save building the authorisation flow for your users until later.

### Creating an ExistAPI instance

Create an instance of ExistAPI with your token, and optionally set a specific timeout period for network requests:

```swift
let existAPI = ExistAPI(token: yourToken, timeout: 40)
```

### GET requests

```swift
func attributes(names: [String]?, limit: Int?, minDate: Date?, maxDate: Date?) -> Promise<(attributes: [Attribute], response: URLResponse)>
```

Returns an array of `Attribute` models:

```swift
struct Attribute: AttributeValues {
    let name: String
    let label: String
    let group: AttributeGroup
    let priority: Int
    let service: String
    let valueType: ValueType
    let valueTypeDescription: String
    private let values: [AttributeData]
}

public protocol AttributeValues {
    func getIntValues() throws -> [IntValue]
    func getStringValues() throws -> [StringValue]
}
```

```swift
func insights(limit: Int?, pageIndex: Int?, minDate: Date?, maxDate: Date?) -> Promise<(insights: InsightResponse, response: URLResponse)>
```

Returns an `InsightResponse`:

```swift
struct InsightResponse {
    let count: Int
    var next: String?
    var previous: String?
    let results: [Insight]
}

struct Insight: Codable {
    let created: Date
    let targetDate: Date?
    let type: InsightType
    let html: String
    let text: String
}
```

```swift
func averages(for attribute: String?, limit: Int?, pageIndex: Int?, minDate: Date?, maxDate: Date?) -> Promise<(averages: [Average], response: URLResponse)>
```

Returns an array of `Average` models:

```swift
class Average: Codable {
    let attribute: String
    let date: Date
    let overall: Float
    let monday: Float
    let tuesday: Float
    let wednesday: Float
    let thursday: Float
    let friday: Float
    let saturday: Float
    let sunday: Float
}
```

```swift
func correlations(for attribute: String?, limit: Int?, pageIndex: Int?, minDate: Date?, maxDate: Date?, latest: Bool?) -> Promise<(correlations: [Correlation], response: URLResponse)>
```

Returns an array of `Correlation` models:

```swift
class Correlation: Codable {
    let date: Date
    let period: Int
    let attribute: String
    let attribute2: String
    let value: Float
    let p: Float
    let percentage: Float
    let stars: Int
    let secondPerson: String
    let secondPersonElements: [String]
    let strengthDescription: String
    let starsDescription: String
    let description: String?
    let occurrence: String?
    let rating: CorrelationRating?
}
```

```swift
func user() -> Promise<(user: User, response: URLResponse)>
```

Returns a `User` model:

```swift
class User: Codable {
    let id: Int
    let username: String
    let firstName: String
    let lastName: String
    let bio: String
    let url: String
    let avatar: String
    let timezone: String
    let imperialUnits: Bool
    let imperialDistance: Bool
    let imperialWeight: Bool
    let imperialEnergy: Bool
    let imperialLiquid: Bool
    let imperialTemperature: Bool
    let trial: Bool
    let delinquent: Bool
}
```

### POST requests

Not supported yet.

<!--
### Chaining

Because ExistAPI uses PromiseKit, you can chain multiple calls together. Here are some examples:

Since we need to first acquire attributes in a user's Exist account before we're able to update those attributes, we can chain these two steps together the first time we want to update an attribute with data:

```swift
existAPI.acquire(names: ["mood", "mood_note", "weight"]
	.then { successfullyAcquired, response in
		existAPI.update(attributes: successfullyAcquired.map { $0.name }
		.done { successfullyUpdated, failed in
		// handle success
		}.catch { error in
		// handle error
		}
```

PromiseKit lets us use `when` to only act on a bunch of promises when they're all completed, and to handle errors in any of those promises just once. Using `when` lets us compile a bunch of calls to the Exist API and act on all the returned data at once:

```swift
let insightsPromise = existAPI.insights(days: 30)
let averagesPromise = existAPI.averages(limit: 30)
let correlationsPromise = existAPI.correlations

when(fulfilled: [insightsPromise, averagesPromise, correlationsPromise])
	.done { insights, averages, correlations in
	// handle data
	}.catch { error in
	// handle errors just once for all these promises
	}
```
-->

## Building the app

Clone the source and build using Xcode 10.

### Running the tests

Create a new file inside `ExistAPITests` called `TestConstants.swift` and add a string constant called `TEST_TOKEN` with your own API token, like this:

```swift
let TEST_TOKEN = "your_token_string_here"
```

Without this, the tests will fail. You can get your access token by creating a developer client in your [Exist account](https://exist.io/account/).

### TODO

- [x] GET requests
- [ ] POST requests
- [ ] Create a convenience `func` for accessing only today's attributes
