//
//  ViewController.swift
//  BeaconSwift
//
//  Created by Adriana Carelli on 29/09/15.
//  Copyright © 2015 Adriana Carelli. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var lastProximity: CLProximity?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let uuidString = "ACFD065E-C3C0-11E3-9BBE-1A514932AC01"
        let beaconIdentifier = "BlueBeacon Mini"
        let beaconUUID:NSUUID = NSUUID(UUIDString: uuidString)!
        let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID,
            identifier: beaconIdentifier)
        beaconRegion.notifyEntryStateOnDisplay=true
        beaconRegion.notifyOnEntry=true
        beaconRegion.notifyOnExit=true
        
        locationManager = CLLocationManager()
        
        if(locationManager!.respondsToSelector("requestAlwaysAuthorization")) {
            
                locationManager!.requestAlwaysAuthorization()
        }
        
        locationManager!.delegate = self
        locationManager!.pausesLocationUpdatesAutomatically = false
        
        locationManager!.startMonitoringForRegion(beaconRegion)
        locationManager!.startRangingBeaconsInRegion(beaconRegion)
        locationManager!.startUpdatingLocation()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
    }
    
    func sendLocalNotificationWithMessage(message: String!, playSound: Bool) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        
        if(playSound) {
            // classic star trek communicator beep
            //	http://www.trekcore.com/audio/
            //
            // note: convert mp3 and wav formats into caf using:
            //	"afconvert -f caff -d LEI16@44100 -c 1 in.wav out.caf"
            // http://stackoverflow.com/a/10388263
            
            notification.soundName = "tos_beep.caf";
        }
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func locationManager(manager: CLLocationManager,
        didRangeBeacons beacons: [CLBeacon],
        inRegion region: CLBeaconRegion) {
//            let viewController:UIViewController = window!.rootViewController as! UIViewController
//            viewController.beacons = beacons as [CLBeacon]?
//            viewController.tableView!.reloadData()
            
            NSLog("didRangeBeacons");
            var message:String = ""
            
            var playSound = false
            
            if(beacons.count > 0) {
                let nearestBeacon:CLBeacon = beacons[0]
                
                if(nearestBeacon.proximity == lastProximity ||
                    nearestBeacon.proximity == CLProximity.Unknown) {
                        return;
                }
                lastProximity = nearestBeacon.proximity;
                
                switch nearestBeacon.proximity {
                case CLProximity.Far:
                    message = "You are far away from the beacon"
                    playSound = true
                case CLProximity.Near:
                    message = "You are near the beacon"
                    let detail = self.storyboard?.instantiateViewControllerWithIdentifier("detailBeacon") as? DeatailBeaconViewController
                    self.navigationController?.pushViewController(detail!, animated: true)
                case CLProximity.Immediate:
                    message = "You are in the immediate proximity of the beacon"
                    let detail = self.storyboard?.instantiateViewControllerWithIdentifier("detailBeacon") as? DeatailBeaconViewController
                    self.navigationController?.pushViewController(detail!, animated: true)
                case CLProximity.Unknown:
                    return
                }
            } else {
                
                if(lastProximity == CLProximity.Unknown) {
                    return;
                }
                
                message = "No beacons are nearby"
                playSound = true
                lastProximity = CLProximity.Unknown
            }
            
            NSLog("%@", message)
            sendLocalNotificationWithMessage(message, playSound: playSound)
    }
    
    func locationManager(manager: CLLocationManager,
        didEnterRegion region: CLRegion) {
            manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
            manager.startUpdatingLocation()
            
            NSLog("You entered the region")
            sendLocalNotificationWithMessage("You entered the region", playSound: false)
    }
    
    func locationManager(manager: CLLocationManager,
        didExitRegion region: CLRegion) {
            manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
            manager.stopUpdatingLocation()
            
            NSLog("You exited the region")
            sendLocalNotificationWithMessage("You exited the region", playSound: true)
    }

    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion){
        if (state == .Inside) {
           sendLocalNotificationWithMessage("you're in the region", playSound: true)
        }else if(state == .Outside){
            sendLocalNotificationWithMessage("you is out of the region", playSound: true)
        }else if(state == .Unknown){
            sendLocalNotificationWithMessage("unknown region", playSound: true)
        }
    }


}

