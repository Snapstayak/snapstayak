//
//  PostTableViewCell.swift
//  Snapstayak
//
//  Created by Nick McDonald on 5/22/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit

// TODO: - talk to the 

class PostTableViewCell: UITableViewCell {
    var onTextViewTextUpdate: (()->Swift.Void)?
    @IBOutlet weak var postTitleTextView: UITextView!
    @IBOutlet weak var postInfoContainerView: UIView!
    @IBOutlet weak var postTitleLabel: UILabel!
    fileprivate var userCanBackspaceHashTag: Bool = false
    fileprivate static var NewPostTextViewPlaceHolderText: String = "#Something..."
    
    var postData: Post? {
        didSet {
            // Show the textView if we are entering a new post (i.e. title or someting in the post is nil) so the user can input their requested title. Hide the label.
            // Otherwise, show it normally, (i.e. hide/nil the textView).
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.postTitleTextView.delegate = self
        self.postTitleTextView.text = PostTableViewCell.NewPostTextViewPlaceHolderText
        self.postTitleTextView.textColor = UIColor.lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension PostTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        textView.text = "#"
    }
    
    // This is called after a textView.text inserts the new text.
    func textViewDidChange(_ textView: UITextView) {
        self.onTextViewTextUpdate?()
        var replacementString = textView.text
        // The following is for if the user completely removes all text.
        if textView.text == "" {
            textView.text = "#"
            return
        }
        
        // TODO: Fix the user backspacing a hashtag.
        // Replacement string needs to have a '#' before each new word.
        if replacementString?.characters.last == " " {
            if self.userCanBackspaceHashTag {
                // This means the user backspaced the hashtag.
                replacementString?.characters.removeLast()
                replacementString?.characters.removeLast()
                self.userCanBackspaceHashTag = false
            } else {
                replacementString?.append(" #")
            }
        }
        
        if textView.text.characters.last == "#" {
            self.userCanBackspaceHashTag = true
        } else {
            self.userCanBackspaceHashTag = false
        }
        textView.text = replacementString
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = PostTableViewCell.NewPostTextViewPlaceHolderText
            textView.textColor = UIColor.lightGray
        }
    }
}
