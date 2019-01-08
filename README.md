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

Acquire an attribute:

```swift
existAPI.acquire(names: ["steps"])
	.done { attributeResponse, urlResponse in
	// deal with data here
	}.catch { error in
	// handle error
	}
```

Update data for some attributes:

```swift
let steps = IntAttributeUpdate(name: "steps", date: Date(), value: 3158)
let distance = FloatAttributeData(name: "steps_distance", date: Date(), value: 1.2)
existAPI.update(attributes: [steps, distance])
	.done { attributeResponse, urlResponse in
	// if some attributes failed but some succeeded, check failures here
	}.catch { error in
	// handle error
	}
```

## Usage

ExistAPI uses [PromiseKit](https://github.com/mxcl/PromiseKit) to handle asynchronous networking tasks. If you haven't used promises before, the PromiseKit docs are very good, and will help you understand the basic usage. Essentially, promises let you act on the result of an asynchronous task as if it were synchronous, making your code easier to write, read, and maintain.

Each of the public functions available in the ExistAPI class returns a Promise. You can chain these together, but the most simple use is to use a `.done` closure for handling the result and a `.catch` closure for handling errors.

Please see the examples below for more ideas on how to use ExistAPI's promises.

### Requirements

- Swift 4.0
- iOS 12
- An [Exist](https://exist.io) account
- Cocoapods

### Getting started

First, you'll need to [create an Exist developer client](https://exist.io/account/apps/). [This blog post](https://exist.io/blog/how-to-get-api-token/) has detailed instructions on how to create a developer client.

To quickly get started, you can simply copy and paste your personal auth token from your developer client details page. This will let you start testing your app with the Exist API immediately, and save building the authorisation flow for your users until later.

### Important notes

- When using `Date`s with `ExistAPI`, always use the local device time.

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

```swift
public func acquire(names: [String]) -> Promise<(attributeResponse: AttributeResponse, response: URLResponse)>
```

Returns an `AttributeResponse`:

```swift
public struct AttributeResponse: Codable {
    var success: [SuccessfulAttribute]?
    var failed: [FailedAttribute]?
}

public struct SuccessfulAttribute: Codable {
    var name: String
    var active: Bool?
}

public struct FailedAttribute: Codable {
    var name: String
    var errorCode: String
    var error: String
}
```

```swift
public func release(names: [String]) -> Promise<(attributeResponse: AttributeResponse, response: URLResponse)>
```

```swift
public func update<T: AttributeUpdate>(attributes: [T]) -> Promise<(attributeResponse: AttributeUpdateResponse, response: URLResponse)>
```

Takes an array of objects conforming to the `AttributeUpdate` protocol:

```swift
public protocol AttributeUpdate: Codable {
    associatedtype Value: Codable
    var name: String { get }
    var date: Date { get }
    var value: Value { get }
    func dictionaryRepresentation() throws -> [String: Any]?
}
```

There are three concrete implementations of `AttributeUpdate`:
```swift
public struct StringAttributeUpdate: AttributeUpdate {
    public typealias Value = String
}

public struct FloatAttributeUpdate: AttributeUpdate {
    public typealias Value = Float
}

public struct IntAttributeUpdate: AttributeUpdate {
    public typealias Value = Int
}
```

The `update` function returns an `AttributeUpdateResponse`:

```swift
public struct AttributeUpdateResponse: Codable {
    var success: [SuccessfullyUpdatedAttribute]?
    var failed: [FailedToUpdateAttribute]?
}

public struct SuccessfullyUpdatedAttribute: Codable {
    var name: String
    var date: Date
    var value: String?
}

public struct FailedToUpdateAttribute: Codable {
    var name: String?
    var date: Date?
    var value: String?
    var errorCode: String
    var error: String
}
```

### Chaining

Because ExistAPI uses PromiseKit, you can chain multiple calls together. Here are some examples:

Since we need to first acquire attributes in a user's Exist account before we're able to update those attributes, we can chain these two steps together the first time we want to update an attribute with data:

```swift
existAPI.acquire(names: ["weight"]
	.then { attributeResponse, urlResponse in
     	guard let success = attributeResponse.success,
        	success.contains("weight") else { return }
     	let update = FloatAttributeUpdate(name: "weight", date: Date(), value: 65.8)
		existAPI.update(attributes: updates)
    		.done { attributeUpdateResponse, urlResponse in
        		// handle success
    		}.catch { error in
        		// handle error
    		}
```

PromiseKit lets us use `when` to only act on a bunch of promises when they're all completed, and to handle errors in this chain of promises just once. Using `when` lets us compile a bunch of calls to the Exist API and act on all the returned data at once:

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
- [x] POST requests
- [ ] Create a convenience `func` for accessing only today's attributes
- [ ] Support appending custom tags
- [ ] Add tests for including queries in requests
