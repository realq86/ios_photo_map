//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var originalImage:UIImage?
    var editedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Create a region surround SF downtown
        let sfGPS = CLLocationCoordinate2D(latitude: 37.783333, longitude: -122.416667)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let sfRegion = MKCoordinateRegion(center: sfGPS, span: coordinateSpan)
        
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
    
    
    func userPinedLocation(lat: NSNumber, long: NSNumber) {
        print("Got lat\(lat) and long \(long)")
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepareForSegue")
        
        if segue.identifier == "tagSegue" {
            
            let locationVC = segue.destination as! LocationsViewController
            locationVC.delegate = self
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
