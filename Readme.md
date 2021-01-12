# RealmInAppBrowser (WIP)

[![CI Status](https://img.shields.io/travis/matt-bro/RealmInAppBrowser.svg?style=flat)](https://travis-ci.org/matt-bro/RealmInAppBrowser)
[![Version](https://img.shields.io/cocoapods/v/RealmInAppBrowser.svg?style=flat)](https://cocoapods.org/pods/RealmInAppBrowser)
[![License](https://img.shields.io/cocoapods/l/RealmInAppBrowser.svg?style=flat)](https://cocoapods.org/pods/RealmInAppBrowser)
[![Platform](https://img.shields.io/cocoapods/p/RealmInAppBrowser.svg?style=flat)](https://cocoapods.org/pods/RealmInAppBrowser)

<h1 align="center">
  <br>
  <img src="https://raw.githubusercontent.com/matt-bro/RealmInAppBrowser/main/readme-assets/example.gif" alt="App Icon" width="200">
  <br>
  Realm In App Browser
  <br>
</h1>

<h4 align="center"> An easy way to view your Realm DB in your App</h4>

<p align="center">
  <a href="#key-features">Key Features</a> •
  <a href="#example">Example</a> •
  <a href="#installation">Installation</a> •
  <a href="#how-to-use">How To Use</a> •
  <a href="#credits">Credits</a> •
  <a href="#license">License</a>
</p>
<p align="center">
<img src="https://raw.githubusercontent.com/matt-bro/RealmInAppBrowser/main/readme-assets/screenshot.png" width="445" height="334">
</p>

## Description


This View is going to enable you to view your Realm Database in your app,
so you can see and debug your realm db at any time.

The goal of this project is that the browser would roughly work like Realm Browser.

## Key Features

* View your realm database with one call
* (wip) Sort by properties
* (wip) Filter your entities 
* (wip) Long press to see property/value info
* (nice to have) save your queries, so you don't have to type everytime

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

RealmInAppBrowser is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RealmInAppBrowser'
```

## How To Use

Clone this application and install pods

```swift
// Init Realm InAppBrowser (It's a UISplitViewController)
let spvc = RealmInAppBrowser()
// Present the Browser how you like
spvc.modalPresentationStyle = .fullScreen
// Define what happens when the users presses close
spvc.pressedCloseAction = { self.dismiss(animated: true , completion: nil) }

self.present(spvc, animated: true, completion: nil)
```

## Credits

This software uses the following open source packages:

- [RealmSwift](https://github.com/RxSwiftCommunity/RxRealm)

## License

RealmInAppBrowser is available under the MIT license. See the LICENSE file for more info.

---

> GitHub [@matt-bro](https://github.com/matt-bro) 
