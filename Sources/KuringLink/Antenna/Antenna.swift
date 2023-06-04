//
//  Antenna.swift
//  
//
//  Created by Jaesung Lee on 2023/05/01.
//

import UIKit
import Satellite

// TODO: Actor?
class Antenna {
    let satellite: Satellite
    let appVersion: String
    
    var fcmToken: String?
    
    init(host: String, scheme: Satellite.Scheme = .https, appVersion: String) {
        satellite = Satellite(host: host, scheme: scheme)
        self.appVersion = appVersion
    }
}

