# Pre-work - SuperCoolTipCalculator (with Yelp functionality)

SuperCoolTipCalculator is a tip calculator application for iOS.

Submitted by: Eden Shapiro

Time spent: ~25 hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [x] Remembering the bill amount across app restarts (if <10mins)
* [x] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

- [x] After calculating the tip (or before), a user can click a button to leave a Yelp review of the establishment they are in. (This was done using LocationManager from CoreLocation to find a user's current location, and Yelp's API to find business establishments at that location. The specific Yelp page to leave a review for that business was then scraped and loaded into a UIWebView. This was done because there was no way to open the Yelp app directly to the leave-a-review window.)
- [x] If for some reason the business name populated into the leave-a-review button is not the correct establishment (sometimes GPS isn't completely accurate, or maybe the user walked a small distance away), there is a button (titled "Not the right location?") that opens a tableview controller of other nearby businesses, which the user can then click on and leave a review for.
- [x] Default tip percentages, their order on the segmented control, and the currently selected segment on the segmented control are persisted across app restarts. 

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

Basic functionality (enter bill amount, choose tip percentage, see tip and total values, adjust tip percentage on settings page):
<img src='http://i.imgur.com/xSYbUk0.gif' title='Basic functionality' width='' alt='Basic functionality' />

Yelp functionality (click on the leave-a-review button to leave review of current establishment, if incorrect business, view other nearby businesses)
<img src='http://i.imgur.com/D0Bpvsz.gif' title='Yelp functionality' width='' alt='Yelp functionality' />
Alternative location:
<img src='http://i.imgur.com/jXo3xIR.gif' title='Alternative location' width='' alt='Alternative location' />

Persistence functionality (using UserDefaults)
<img src='http://i.imgur.com/kSmINg3.gif' title='Persistence functionality' width='' alt='Persistence functionality' />

GIFs created with [LiceCap](http://www.cockos.com/licecap/).

## Project Analysis

As part of your pre-work submission, please reflect on the app and answer the following questions below:

**Question 1**: "What are your reactions to the iOS app development platform so far? How would you describe outlets and actions to another developer? Bonus: any idea how they are being implemented under the hood? (It might give you some ideas if you right-click on the Storyboard and click Open As->Source Code")

**Answer:** I've really enjoyed using Xcode and the iOS development platform. The interface is clean and user-friendly, the documentation is very organized and understandle, the simulator runs quickly and smoothly, and Apple's optional frameworks (CoreLocation, etc.) are easy to implement. Overall it's been a very positive experience.   
    Outlets, in code, are a representation of a UIElement and are properties of the view controller that they’re in. They in turn have attributes that can be changed, and those changes are reflected in the UI as we use the app. Actions, in code, are a representation of a physical action that a user takes (like clicking a button or pinching two fingers together). They are always connected with a method in the view controller and can be triggerd by different user actions. My guess as to how both work is that the UI element is issued an ID in storyboard that is then specifically matched with a code property within the viewcontroller by that same ID. There seem to be some additional components, like "destination", "selector", and "eventType", which appear to signal where changes should take place, which methods should be trigger, and by what specific user action, respectively.

Question 2: "Swift uses [Automatic Reference Counting](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html#//apple_ref/doc/uid/TP40014097-CH20-ID49) (ARC), which is not a garbage collector, to manage memory. Can you explain how you can get a strong reference cycle for closures? (There's a section explaining this concept in the link, how would you summarize as simply as possible?)"

**Answer:** Swift can only deallocate an instance in memory if there are no "strong" references pointing to that instance. When a closure is created in Swift, depending on what that closure's body contains, it can possibly capture elements from its surroundings and create strong references to them. For instance, a closure that captures self.someProperty or self.someMethod() ends up creating a strong reference to self. This can result in a strong reference cycle, where memory is unable to be deallocated because two items are strongly referencing one another. In this case, because closures are reference types like classes, the closure is strongly referencing the instance self, and self has a strong pointer to that closure. This issue can be resolved by making that closure's references to self weak instead of strong, which can be done through the use of a capture list.

## Extras
I had created a light/dark color theme customization for a UserDefaults demo I'd made, which might be relevant. It can be found [here](https://github.com/EdenShapiro/UserDefaults-example), but a gif demo is below:
<img src='http://i.imgur.com/DgoVOIp.gif' title='Color theme' width='' alt='Color theme' />



## License

Copyright 2017 Eden Shapiro

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
