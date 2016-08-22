//
//  ViewController.swift
//  PushNotificationSticker
//
//  Created by Евгений Митько on 19/08/16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, EMNotifyDelegate {
    
    let notifier = EMNotify()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notifier.delegate = self
        
        self.view.backgroundColor = UIColor.blueColor()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func notificationDidDismissed() {
        
    }
    
    func notificationWillBeDisplaied() {

    }

    func notificationIsDisplayed() {
        
    }

    @IBAction func buttonTapped(sender: AnyObject) {
            notifier.addNotification()
            print("Show notification")
    }

}

