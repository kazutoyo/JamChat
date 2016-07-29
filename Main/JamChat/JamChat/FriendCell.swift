//
//  FriendCell.swift
//  JamChat
//
//  Created by Meena Sengottuvelu on 7/21/16.
//  Copyright © 2016 Jammers. All rights reserved.
//

import UIKit

class FriendCell: UICollectionViewCell {

    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBInspectable var selectedColor: UIColor = UIColor(red: 247/255, green: 148/255, blue: 0/255, alpha: 1.0)
    
    
    var presence: Bool = false
    var recording: Bool = true
    
    var user: User! {
        didSet {
            if let nameLabel = nameLabel {
                nameLabel.text = user.name
                nameLabel.textColor = UIColor.darkGrayColor()
            }
            profilePictureView.setImageWithURL(user.profileImageURL)
            
            
            if recording {
                profilePictureView.layer.borderColor = UIColor.redColor().CGColor
                profilePictureView.layer.borderWidth = 2.0
            } else if presence {
                profilePictureView.layer.borderColor = UIColor.greenColor().CGColor
                profilePictureView.layer.borderWidth = 2.0
            } else {
                profilePictureView.layer.borderColor = UIColor.clearColor().CGColor
                profilePictureView.layer.borderWidth = 2.0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Make image circular:
        profilePictureView.layer.cornerRadius = profilePictureView.frame.size.width / 2;
        profilePictureView.clipsToBounds = true;
    }

}
