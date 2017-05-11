//
//  SendButton.swift

//  Snapstayak
//
//  Created by Nick McDonald on 4/30/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit

class SendButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setUpButton() {
        self.layer.cornerRadius = self.frame.height/2.0 // This will make the button round.
        self.clipsToBounds = false  // This will clip the buttom frame to the corner radius.
        self.setImage(#imageLiteral(resourceName: "Next_send"), for: .normal)
        self.backgroundColor = UIColor.green
    }
}
