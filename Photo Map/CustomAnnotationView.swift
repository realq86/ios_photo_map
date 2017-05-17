//
//  CustomAnnotationView.swift
//  Photo Map
//
//  Created by Developer on 5/3/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
class CustomAnnotationView: NSObject, MKAnnotation{

    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    
    // Title and subtitle for use by selection UI.
    var title: String?     
    var image:UIImage!
    
}
