# JLCustomPagingView

[![CI Status](http://img.shields.io/travis/José Lucas/JLCustomPagingView.svg?style=flat)](https://travis-ci.org/José Lucas/JLCustomPagingView)
[![Version](https://img.shields.io/cocoapods/v/JLCustomPagingView.svg?style=flat)](http://cocoapods.org/pods/JLCustomPagingView)
[![License](https://img.shields.io/cocoapods/l/JLCustomPagingView.svg?style=flat)](http://cocoapods.org/pods/JLCustomPagingView)
[![Platform](https://img.shields.io/cocoapods/p/JLCustomPagingView.svg?style=flat)](http://cocoapods.org/pods/JLCustomPagingView)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

JLCustomPagingView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JLCustomPagingView"
```

## Initial Configurations

##### *First Step*

Import it on every file that use this framework.

```swift
import JLCustomPagingView
```

##### *Second Step*

Go to the storyboard that has the View Controller you want to have an instace of `JLCustomPagingView` add a view to your view Controller, put all of the constraints you want, after you have to say that view is a `JLCustomPagingView` and create an outlet of this `JLCustomPagingView`.

```swift
@IBOutlet weak var myPagingView: JLCustomPagingView!
```

##### *Third Step*

After you create the corresponding outlet you should implement the protocols `CustomPagingViewDataSource` and `CustomPagingViewDelegate`.

```swift
class ViewController: UIViewController,CustomPagingViewDataSource,CustomPagingViewDelegate
```

## Quick Tips

##### *Reloading Data*
```swift
reloadData()
```

##### *CustomPagingViewDataSource methods*

The number of items you want it to have
```swift
numbOfItems()->Int
```

The item that should stay at index
```swift
itemAtIndex(index:Int)->UIView!
```

##### *CustomPagingViewDelegate methods*

This method is called to know if the item at corresponing index should recognize tap events
```swift
shouldItemReceiveTapEvents(ItemAtIndex index:Int)->Bool
```

This method is called when the user taps on the top item
```swift
didSelectItemWithIndex(index:Int,item:UIView)
```

This method is called when the top visible item, so the actived one changes
```swift
didChangeTopItemIndexTo(newTopItemIndex:Int,lastTopItemIndex:Int)
```

## Author

José Lucas

## License

JLCustomPagingView is available under the MIT license. See the LICENSE file for more info.
