//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate  {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var originalImage:UIImage?
    var editedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Create a region surround SF downtown
        let sfGPS = CLLocationCoordinate2D(latitude: 37.783333, longitude: -122.416667)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let sfRegion = MKCoordinateRegion(center: sfGPS, span: coordinateSpan)
        
        self.mapView.delegate = self
        self.mapView.setRegion(sfRegion, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func userTapCamera(_ sender: Any) {
        
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //Camera VC
            
            imagePickerVC.sourceType = .camera
        }
        else {
            
            imagePickerVC.sourceType = .photoLibrary
        }
        
        self.present(imagePickerVC, animated: true) {
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage ?? nil
        
        self.editedImage = info[UIImagePickerControllerEditedImage] as? UIImage ?? nil
        
        self.dismiss(animated: true) {
            self.performSegue(withIdentifier: "tagSegue", sender: self)
        }
    }
    
    
    func userPinedLocation(lat: NSNumber, long: NSNumber, name:String) {
        print("Got lat\(lat) and long \(long)")
        
        self.addAnnotationAt(lat: lat, long: long, name:name, image:self.editedImage)
    }
    
    
    
    // MARK: - Map View Methods
    func addAnnotationAt(lat:NSNumber, long:NSNumber, name:String, image:UIImage?) {
    
//  BEFORE BOUNS 1
//        let mkAnnotation = MKPointAnnotation()
        let mkAnnotation = CustomAnnotationView()
        mkAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat.doubleValue, longitude: long.doubleValue)
        mkAnnotation.title = name
        mkAnnotation.image = image!
        
        self.mapView.addAnnotation(mkAnnotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        let customAnnotation = annotation as! CustomAnnotationView
        let id = "AnnotationView"
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: id)
        
        if annotationView == nil {

//Bonus 3
//            annotationView = MKPinAnnotationView(annotation: customAnnotation, reuseIdentifier: id)
            annotationView = MKAnnotationView(annotation: customAnnotation, reuseIdentifier: id)
            
            annotationView?.canShowCallout = true
            annotationView?.leftCalloutAccessoryView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
//Bonus 2
//            var button = UIButton(frame: CGRect(x:0, y:0, width:50, height:50))
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
            
        }
        
        let imageView = annotationView!.leftCalloutAccessoryView as! UIImageView

//Before Bouns 1
//        imageView.image = #imageLiteral(resourceName: "camera")
        imageView.image = self.resizeImageForAnnotation(customAnnotation.image)
        
        //Bonus 3
        annotationView?.image = imageView.image
        
        return annotationView
    }
    
    func resizeImageForAnnotation(_ image:UIImage) -> UIImage?  {
        
        var resizeRenderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        resizeRenderImageView.layer.borderColor = UIColor.white.cgColor
        resizeRenderImageView.layer.borderWidth = 3.0
        resizeRenderImageView.contentMode = .scaleAspectFill
        resizeRenderImageView.image = image
        
        UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
        resizeRenderImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        var thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        return thumbnail
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        self.performSegue(withIdentifier: "fullImageSegue", sender: self)
    }
    
    public func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
    
    
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepareForSegue")
        
        if segue.identifier == "tagSegue" {
            
            let locationVC = segue.destination as! LocationsViewController
            locationVC.delegate = self
        }
        
        if segue.identifier == "fullImageSegue" {
        
            let fullImageVC = segue.destination as! FullImageViewController
            
            fullImageVC.fullScreenImage = self.editedImage
        }
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
    //        // Get the new view controller using segue.destinationViewController.
    //        // Pass the selected object to the new view controller.
    //        print("prepareForSegue")
    //
    //
    //        if segue.identifier == "tagSegue" {
    //
    //            let locationVC = segue.destination as! LocationsViewController
    //            locationVC.delegate = self
    //        }
    //        
    //    }
    
    
}
