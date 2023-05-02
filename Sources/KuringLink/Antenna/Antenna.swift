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
    
    var fcmToken: String?
    
    init(host: String, scheme: Satellite.Scheme = .https) {
        satellite = Satellite(host: host, scheme: scheme)
    }
}

