//
//  Snapstayak.swift
//  Snapstayak
//
//  Created by Tejen Hasmukh Patel on 4/27/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import Foundation


class Snapstayak: NSObject {
    
    class func api(_ parameters: NSDictionary, endpoint: String, completion: ((NSDictionary?) -> ())? = nil){
        let url: NSURL = NSURL(string: "https://api.snapstayak.tejen.net/" + endpoint)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringCacheData
//        request.addValue(Snapstayak.UUID, forHTTPHeaderField: "X-Auth-Token")
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: []);
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    
        
        let task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("Snapstayak API Network Error Occurred. Retrying...")
                delay(0.25, closure: {
                    api(parameters, endpoint: endpoint, completion: completion);
                });
                return
            }
            
            do {
                let dataObject = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary
                if(dataObject?.value(forKey: "error") != nil) {
                    print("/#/#/#/#/#/#/#/#/#/#/");
                    print(" API ERROR OCCURRED:\n");
                    print(dataObject!["error"]!);
                    print("\n");
                    print("/#/#/#/#/#/#/#/#/#/#/");
                    
                    alert(title: "Uh oh!", message: dataObject!["error"]! as! String, button: "Try Again");
                }
                if(completion != nil) {
                    completion!(dataObject);
                }
            } catch(_) {
                print("Snapstayak API Internal Server Error Occurred:");
                // print out raw http response body
                print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? data as Any);
            }
            
        }
        
        task.resume()
    }

}
