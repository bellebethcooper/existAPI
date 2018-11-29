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
- An Exist account

### Getting started

First, you'll need to create an Exist developer client. Follow these steps to create your client:

To quickly get started, you can simply copy and paste your personal auth token from this page. This will let you start testing your app with the Exist API immediately, and save building the authorisation flow for your users until later.

### Creating a client

Create an instance of ExistAPI with your token, and optionally set a specific timeout period for network requests:

```swift
let existAPI = ExistAPI(token: yourToken, timeout: 40)
```
