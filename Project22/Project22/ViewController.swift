//
//  ViewController.swift
//  Project22
//
//  Created by Denis Andreev on 4/19/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var textLabel: UILabel!
    var locationManager: CLLocationManager?
    var isFirstDetect = false
    @IBOutlet var circlrView: UIView!
    
    @IBOutlet weak var position: NSLayoutConstraint!
    @IBOutlet weak var circlDiametr: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        view.backgroundColor = .lightGray
        
        circlrView.layer.masksToBounds = true
        circlrView.layer.cornerRadius = 50.0
        circlrView.isHidden = true
    }


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScan()
                }
            }
        }
    }
    
    func startScan() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor:  456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.textLabel.text = "FAR"
                self.position.constant = 0
                self.circlDiametr.constant = 100
                self.circlrView.layer.cornerRadius = 50.0
                self.circlrView.isHidden = false
            case .near:
                self.view.backgroundColor = .orange
                self.textLabel.text = "NEAR"
                self.position.constant = (UIScreen.main.bounds.height/6) - 50
                self.circlDiametr.constant = 150
                self.circlrView.layer.cornerRadius = 75.0
                self.circlrView.isHidden = false
            case .immediate:
                self.view.backgroundColor = .white
                self.textLabel.text = "RIGHT HERE"
                self.position.constant = ((UIScreen.main.bounds.height/6) * 2) - 20
                self.circlDiametr.constant = 200
                self.circlrView.layer.cornerRadius = 100.0
                self.circlrView.isHidden = false
            default:
                self.view.backgroundColor = .lightGray
                self.textLabel.text = "UNKNOWN"
                self.circlrView.isHidden = true
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
       print("\(beacons)")
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
            if !isFirstDetect {
                isFirstDetect = true
                let ac = UIAlertController(title: "Beacon detected!", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                present(ac, animated: true, completion: nil)
            }
        } else {
            update(distance: .unknown)
        }
    }
}

