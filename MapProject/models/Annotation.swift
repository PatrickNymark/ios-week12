//
//  Annotation.swift
//  MapProject
//
//  Created by Patrick Nymark on 04/08/2020.
//  Copyright © 2020 Patrick Nymark. All rights reserved.
//

import Foundation

struct Annotation {
    var title:String = ""
    var user:String = ""
    var lat:Double
    var long:Double
    
    var dictionary: [String: Any] {
        return ["title": title, "user": user, "lat": lat, "long": long]
    }
    
    init(title: String, user: String, lat: Double, long: Double) {
        self.title = title
        self.user = user
        self.lat = lat
        self.long = long
    }
    
    
}
