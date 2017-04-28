//
//  User.swift
//  Snapstayak
//
//  Created by Tejen Hasmukh Patel on 4/27/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import Foundation
import UIKit

class User: Snapstayak {
    // Hold currently logged-in user and protect write-access from other classes.
    // No other class besides User can modify this private variable.
    // If/when modified, this variable saves itself to the iOS Keychain to persist its contents.
    // Default value is either nil or the persisted value from the Keychain.
    static private var _currentUser: User? = User(dictionary: (NSKeyedUnarchiver.unarchiveObject(with: (Keychain.getData("snapstayakCurrentUser") != nil ? Keychain.getData("snapstayakCurrentUser")! : NSData()) as Data) as? NSDictionary) ?? nil) {
        didSet {
            if(_currentUser != nil) {
                // persist new current user
                _ = Keychain.set("snapstayakCurrentUser", value: NSKeyedArchiver.archivedData(withRootObject: _currentUser!.toDictionary()!));
            } else {
                _ = Keychain.delete("snapstayakCurrentUser");
            }
        }
    }
    // Only way to change this variable's value is by using the User.login() or User.logout() functions.
    static var currentUser: User? { // return read-only variable to a global scope
        return _currentUser;
    }
    
    static var currentUserProfileImageCache: UIImage?
    
    var id: Int? {
        didSet {
            if(self.id != nil && self.id != 0) {
                delay(0.1, closure: {
                    //TODO: populate any other user data needed
                });
            }
        }
    }
    
    var email: String? //TODO: why is this optional?
    
    // This function is the only way to change the currentUser variable.
    // Provide the desired email to be logged in
    class func login(user: User) -> Bool {
        if(true){ // TODO: if user login succeeded
            _currentUser = user; // This will also persist the user, until manually Signed Out using User.logout();
            print("\(user.email) is now signed in as the current user.");
            return true;
        }
    }
    
    class func logout() {
        User.currentUserProfileImageCache = nil;
        _currentUser = nil;
    }
    
    func signup(email: String, completion: ((User?) -> ())? = nil) {
        self.email = email;
        
        api(Export(), endpoint: "users/create/") { (response: User?) -> () in
            self.id = response!.id;
            completion?(self);
        }
    }
    
    // completion parameter first, else Swift won't allow function overloading
    class func get(completion: @escaping ((User?) -> ()), id: Int) {
        User().api(["id": "\(id)"], endpoint: "users/get/", completion: completion)
    }
    
    class func get(completion: @escaping ((User?) -> ()), email: String) {
        User().api(["email": email], endpoint: "users/get/", completion: completion)
    }
    
    func update(key: String, value: String, completion: ((User?) -> ())? = nil) {
        api(["id": id!, key: value], endpoint: "users/modify/", completion: completion);
    }
    
    func cacheCurrentUserProfileImageIfPossible() {
        //TODO: complete this func
    }
    
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
    
    func toDictionary() -> NSDictionary? {
        if(id == nil || id! <= 0) {
            return nil;
        }
        let exported = Export();
        exported.setValue(String(id!), forKey: "id")
        return exported;
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
        email = dictionary["email"] as? String
    }
    
    private func Export() -> NSDictionary {
        return [
            "email": email!
        ];
    }
    
    // overload Snapstayak API to cast returned objects as type User
    func api(_ parameters: NSDictionary, endpoint: String, completion: ((User?) -> ())?){
        Snapstayak.api(parameters, endpoint: endpoint) { (dictionary: NSDictionary?) in
            if(completion != nil) {
                completion?(User(dictionary: dictionary!))
            }
        }
    }
    
}
