# ExistAPI

A framework for working with the [Exist](https://exist.io/) API on iOS.

## Installation

via Cocoapods, details to come

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

### Creating a client

Create an instance of ExistAPI with your token, and optionally set a specific timeout period for network requests:

```swift
let existAPI = ExistAPI(token: yourToken, timeout: 40)
```

### GET requests

Get the user's attributes:

```swift
existAPI.attributes()
	.then { attributes in
	// handle data
	}
```

Pass in some parameters when getting attributes:

```swift
existAPI.attributes(names: ["steps", "weight"], limit: 14)
	.then { attributes in
	// handle data
	}
```

Get the user's insights:

```swift
existAPI.insights(limit: 14, minDate: Date())
	.then { insights, response in
	// handle data
	}
```

Get the user's correlations:

```swift
existAPI.correlations(for: "steps", limit: 30, latest: true)
	.then { correlations, response in
	// handle data
	}
```

### POST requests

Not supported yet.

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

### TODO

- [x] GET requests
- [ ] POST requests
