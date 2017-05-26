//
//  Post.swift
//  Snapstayak
//
//  Created by Nick McDonald on 5/10/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit
import CoreLocation

class Post: Snapstayak {
    var id: Int?
    var authorID: Int?
    var media: [Medium]?
    var location: CLLocation!
    
    override init() {
        super.init();
    }
    
    init?(dictionary: NSDictionary?) {
        super.init();
        
        if(dictionary == nil) {
            return nil;
        }
        
        Import(dictionary: dictionary!);
    }
    
    init?(medium: Medium) {
        super.init()
        authorID = User.currentUser!.id
        media = [medium]
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways){
            location = locationManager.location
        }
    }
    
    // toDictionary is similar to Export() except it also includes a mandatory Post ID
    func toDictionary() -> NSDictionary? {
        if(id == nil || id! <= 0) {
            return nil;
        }
        let exported = Export();
        exported.setValue(String(id!), forKey: "id")
        return exported;
    }
    
    // completion parameter first, else Swift won't allow function overloading
    class func get(completion: @escaping ((Post?) -> ()), id: Int) {
        Post().api(["id": "\(id)"], endpoint: "posts/get/", completion: completion)
    }
    
    // get list of all active posts in location
    class func get(completion: @escaping ((Post?) -> ()), location: CLLocation) {
        Post().api(["location": location], endpoint: "posts/get/", completion: completion)
    }
    
    func update(key: String, value: String, completion: ((Post?) -> ())? = nil) {
        api(["id": id!, key: value], endpoint: "posts/modify/", completion: completion);
    }
    
    func update(completion: (() -> ())? = nil) {
        let dictionary = toDictionary();
        if(dictionary == nil) {
            alert(title: "Internal Error", message: "Could not cast Post as an NSDictionary including ID", button: "Dismiss");
            print("toDictionary() gets dictionary from Export(), injects an ID into the dictionary, and returns the dictionary. ERROR: ID not set?");
            return;
        }
        api(dictionary!, endpoint: "posts/modify/") { order in
            if(order == nil || order!.id == nil || order!.id! == 0) {
                alert(title: "Internal Error", message: "Error updating Post information in server.", button: "Ignore");
                completion?();
            }
            completion?();
        }
    }
    
    
    func create(completion: ((_ id: Int?) -> ())? = nil) {
        if(media == nil || media!.count == 0) {
            alert(title: "Internal Error", message: "Prevented attempt to create a Post without a Photo or Video attached.", button: "Ignore");
            print("ERROR: Saving a Post without a photo or video");
        }
        
        if(location == nil) {
            alert(title: "Internal Error", message: "Prevented attempt to create a Post without a Location.", button: "Ignore");
            return;
        }
        
        if(id != nil){
            // the post has already been created before!
            // fault tolerance: just update() it
            print("Snapstayak API\n WARNING: Attempted to INSERT into Posts where an insert is unnecessary. Executing UPDATE instead.");
            update(completion: {
                completion?(self.id);
            });
            return;
        }
        
        let dictionary = Export();
        
        api(dictionary, endpoint: "posts/create/") { post in
            if(post == nil || post!.id == nil || post!.id! == 0) {
                alert(title: "Internal Error", message: "Error saving new Post.", button: "Ignore");
                completion?(nil);
            }
            self.id = post!.id;
            completion?(post!.id!);
        }
    }
    
    /***************************
     Import() and Export()
     below...
     are tightly integrated with
     the Snapstayak SQL DB. Changes
     to SQL structure should be
     reflected in either/both of
     the Import/Export functions
     ***************************/
    
    private func Import(dictionary: NSDictionary) {
        if let testVar = dictionary["id"] as? NSString {
            id = Int(testVar as String);
        }
        if let testVar = dictionary["id"] as? NSNumber {
            id = Int(testVar);
        }
        authorID = dictionary["userid"] as? Int
    }
    
    private func Export() -> NSMutableDictionary {
        return [
            "userid": authorID!,
            "location": ["lat": location.coordinate.latitude.binade, "lon": location.coordinate.longitude.binade],
            "media": media!.map({ medium -> [String: String] in medium.Export() }) as [[String: String]]
        ];
    }
    
    // overload Snapstayak API to cast returned objects as type User
    func api(_ parameters: NSDictionary, endpoint: String, completion: ((Post?) -> ())?){
        Snapstayak.api(parameters, endpoint: endpoint) { (dictionary: NSDictionary?) in
            if(completion != nil) {
                completion?(Post(dictionary: dictionary!))
            }
        }
    }
    
}
