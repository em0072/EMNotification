# EMNotification
Simple iOS 10 style Notifications


**EMNotifications** is a very simple iOS 10 style in-app notifications.

EMNotifications supports pan gesture. If you swipe notification to top it will be dismissed

![EMNotification preview](https://raw.githubusercontent.com/em0072/EMNotification/master/Simulator%20Screen%20Shot%2022%20Aug%202016%2014.59.58.png)

##INSTALLATION 

copy  **EMNotify.swift** in your project

##USAGE

**1. Init** 

```swift
let notifier = EMNotify()
```
**2. Configurate(optional)**

```swift
    var height: CGFloat = 70.0 //height of notification
    var animationTime = 0.4 //time of notification show/dismiss animation
    var shownTime = 3.0 //time to show notification on screen
    let offset: CGFloat = 10 // left/right/top offset
    let titleLabelHeight: CGFloat = 25 // height for titlelabel
    var tapAction: () -> (Void) = {
        print("tap action")
    } // action that is triggered on tap
    var playVibrationOnNotification = true // vibration on/off
    var style = UIBlurEffectStyle.Light / style of notification
```
**3. Delegate.**
You can conform to EMNotifyDelegate.
There are 3 functions that are triggered

```swift
   func notificationDidDismissed()
    func notificationWillBeDisplaied()
    func notificationIsDisplayed()
```
**4. Call**
To call notification Simply use
```swift
   addNotification(withTitle:"Title", andMessage: "Message")
```

