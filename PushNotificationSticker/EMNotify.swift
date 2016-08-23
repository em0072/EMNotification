//
//  EMNotify.swift
//  PushNotificationSticker
//
//  Created by Евгений Митько on 19/08/16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import UIKit
import AudioToolbox

protocol EMNotifyDelegate {
    func notificationDidDismissed()
    func notificationWillBeDisplaied()
    func notificationIsDisplayed()
}

class EMNotify: UIView {
    var delegate: EMNotifyDelegate?
    var height: CGFloat = 70.0
    private let screenWidth = UIScreen.mainScreen().bounds.width
    private let screenHeight = UIScreen.mainScreen().bounds.height
    var animationTime = 0.4
    var shownTime = 3.0
    private var viewNumber = 0
    private var bounce = false
    let offset: CGFloat = 10
    private var titleLabel = UILabel()
    let titleLabelHeight: CGFloat = 25
    private var messageLabel = UILabel()
    var tapAction: () -> (Void) = {
        print("tap action")
    }
    var playVibrationOnNotification = true
    var style = UIBlurEffectStyle.Light

    
    private var dismissed = true

    private func configurateView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(EMNotify.tap))
        self.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(EMNotify.handlePan(_:)))
        self.addGestureRecognizer(pan)
        
        self.frame.size = CGSize(width: getNotificationWidth(), height: height)
        self.center = CGPoint(x: self.getScreenCenter() , y: -(self.getNotificationHeight() / 2))
//        self.backgroundColor = UIColor.redColor()

        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        self.addSubview(blurEffectView)
        
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = self.bounds
        blurEffectView.contentView.addSubview(vibrancyEffectView)

        
        titleLabel.frame = CGRect(x: 0, y: 0, width: self.getNotificationWidth(), height: titleLabelHeight)
        titleLabel.backgroundColor = UIColor(white: 1, alpha: 0.4)
        titleLabel.font = UIFont.boldSystemFontOfSize(UIFont.systemFontSize()) //UIFont.systemFontOfSize(UIFont.systemFontSize())
        titleLabel.numberOfLines = 1
        self.addSubview(titleLabel)
        messageLabel.frame = CGRect(x: 0, y: 25, width: self.getNotificationWidth(), height: height - titleLabelHeight)
        messageLabel.font = UIFont.systemFontOfSize(UIFont.systemFontSize())
        messageLabel.numberOfLines = 2
        self.addSubview(messageLabel)
        
        
        let pullView = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 25, height: 3)))
        pullView.frame.size = CGSize(width: 20, height: 3)
        pullView.center = CGPoint(x: getScreenCenter(), y: height - 5)
        pullView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        pullView.layer.cornerRadius = pullView.frame.height
        pullView.layer.masksToBounds = true
        
        self.addSubview(pullView)
        
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
    }

    func addNotification(withTitle title: String = "This is a test Title", andMessage message: String = "This is a test Message") {
        if dismissed {
            dismissed = false
            
            configurateView()
            let currentWindow = UIApplication.sharedApplication().keyWindow!
            currentWindow.addSubview(self)
            if playVibrationOnNotification {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            delegate?.notificationIsDisplayed()

            
            titleLabel.text = "  \(title)"
            messageLabel.text = "  \(message)"
            
            
            UIView.animateWithDuration(animationTime, delay: 0, options: .CurveEaseOut, animations: {
                self.center = CGPoint(x: self.getScreenCenter(), y: self.getNotificationHeight() / 2)
                }) { (finished) in
                    self.dismissNotificationWithDelay(self.shownTime)

            }
            currentWindow.windowLevel = (UIWindowLevelStatusBar + 1)
            
            currentWindow.makeKeyAndVisible()
        }


    }
    
    
    @objc private func tap() {
        dismissNotification()
        tapAction()
    }
    
    private func dismissNotification() {
        viewNumber += 1
        dismissed = true
        UIView.animateWithDuration(animationTime, delay: 0, options: [.CurveEaseIn, .AllowUserInteraction], animations: {
            self.self.center = CGPoint(x: self.getScreenCenter(), y: -(self.getNotificationHeight() / 2))
        }) { (finished) in
            let currentWindow = UIApplication.sharedApplication().keyWindow!
            currentWindow.windowLevel = (UIWindowLevelStatusBar - 1)
            self.self.removeFromSuperview()
            self.delegate?.notificationDidDismissed()
        }
        
    }
    
    private func dismissNotificationWithDelay(delay: Double) {
        let waitNumber = self.viewNumber
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            if !self.dismissed && waitNumber == self.viewNumber {
                self.dismissNotification()
            }
        }
        
    }
    
    
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        viewNumber += 1
        dismissed = true
        switch recognizer.state {
            case .Began:
               break
            case .Changed:
                if self.center.y + recognizer.translationInView(self).y > self.getNotificationHeight() / 2 {
                    bounce = true
                    self.center.y += (recognizer.translationInView(self).y / 20)
                    recognizer.setTranslation(CGPointZero, inView: self)
                    break
                }
                
                self.center.y += recognizer.translationInView(self).y
                recognizer.setTranslation(CGPointZero, inView: self)

            
            case .Ended:
                if bounce {
                    self.setInitialPosition()
                } else if self.center.y + recognizer.translationInView(self).y < self.getNotificationHeight() / 4 {
                    dismissNotification()
                } else {
                    self.setInitialPosition()
                }
            default:
                break
        }
    }
    
    private func setInitialPosition() {
        UIView.animateWithDuration(0.33, delay: 0, options: [.CurveEaseOut], animations: {
            self.center.y = self.getNotificationHeight() / 2
            }, completion: { (_) in
                self.dismissed = false
                self.bounce = false
                self.dismissNotificationWithDelay(self.shownTime)
        })
    }
    
    private func getNotificationWidth() -> CGFloat {
        return min(screenWidth - offset, screenHeight - offset)
    }
    
    private func getNotificationHeight() -> CGFloat {
        return self.height + self.offset
    }
    
    private func getScreenCenter() -> CGFloat {
        return UIScreen.mainScreen().bounds.width / 2
    }

    
    
}
