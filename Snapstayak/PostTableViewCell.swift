//
//  PostTableViewCell.swift
//  Snapstayak
//
//  Created by Nick McDonald on 5/22/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    fileprivate static var NewPostTextViewPlaceHolderText: String = "#Something..."
    @IBOutlet weak var postTitleTextView: UITextView!
    @IBOutlet weak var postInfoContainerView: UIView!
    @IBOutlet weak var postTitleLabel: UILabel!
    var onTextViewTextUpdate: (()->Swift.Void)?
    
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
    
    func textViewDidChange(_ textView: UITextView) {
        self.onTextViewTextUpdate?()
        let normalizedText = textView.text.replacingOccurrences(of: "#", with: "")
        let textViewWords = normalizedText.components(separatedBy: " ")   // Separate the textView.text into separate words
        var replacementString = String()
        for word in textViewWords {
            replacementString.append("#\(word)")
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

