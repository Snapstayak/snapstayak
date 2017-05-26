//
//  PostsViewController.swift
//  Snapstayak
//
//  Created by Tejen Hasmukh Patel on 4/26/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {
    
    @IBOutlet weak var postsTableView: UITableView!
    fileprivate var posts: [Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postsTableView.dataSource = self
        self.postsTableView.rowHeight = UITableViewAutomaticDimension
        self.postsTableView.estimatedRowHeight = 70
        // Do any additional setup after loading the view.
        
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            let storyboard = UIStoryboard(name: "Login", bundle: nil)
//            self.present(storyboard.instantiateInitialViewController()!, animated: true)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // getPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: 
    
    @objc fileprivate func swipeOnTableViewCell(_ sender: UIPanGestureRecognizer) {
        
    }
}

extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.postsTableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        
        cell.postData = self.posts?[indexPath.row] ?? nil
        cell.onTextViewTextUpdate = {
            // Might need the following commented-out code. For now, it's working fine though.
            
            /*
            let currentOffset = self.postsTableView.contentOffset
            UIView.setAnimationsEnabled(false)
             */
            
            // However, these are necessary ------------|
            self.postsTableView.beginUpdates()  //<-----|
            self.postsTableView.endUpdates()    //<-----|
            
            /*
            UIView.setAnimationsEnabled(true)
            self.postsTableView.setContentOffset(currentOffset, animated: false)
            */
        }
        cell.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.swipeOnTableViewCell(_:))))
        return cell
    }
}

extension PostsViewController: NewPostDelegate {
    func newPostWithCapturedMedia(_ capturedMedia: CapturedMedia) {
        print("New Post!")
        // Insert a new tableViewCell.
    }
}
