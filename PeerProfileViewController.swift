//
//  PeerProfileViewController.swift
//  SparksyApp
//
//  Created by UserAtom on 10/17/15.
//  Copyright © 2015 Sparksy. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class PeerProfileViewController: UIViewController {

	var peerName: String!
	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var descriptionView: UITextView!
	@IBOutlet weak var profileImageButton: UIButton!
	@IBOutlet weak var chatButton: UIButton!
	var chatState: String!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		let query = PFQuery(className:"_User")
		query.whereKey("username", equalTo: self.peerName)
		
		//Display activity indicator
		let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
		loadingNotification.labelText = "Loading..."
		query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
			if (error == nil) {
				// The find succeeded.
				print("Successfully retrieved \(objects!.count) peers.")
				loadingNotification.hide(true)
				
				// Do something with the found objects
				self.userNameLabel.text = self.peerName

				// Do something with the found objects
				let imageObjects = objects as [PFObject]!
					for object in imageObjects! {
						let PFImageFile = object.objectForKey("profile_picture") as! PFFile
						PFImageFile.getDataInBackgroundWithBlock { (imageData:NSData?, error:NSError?) ->Void in
								if (imageData != nil) {
									self.profileImageButton.contentMode = .ScaleAspectFit
								    self.profileImageButton.setImage(UIImage(data:imageData!), forState: .Normal)
								}
						}
						let aboutMeText = object.objectForKey("profile_description") as! String
						self.descriptionView.text = aboutMeText
						self.chatState = object.objectForKey("chat_state") as! String
						if (self.chatState == "OFF") {
							self.chatButton.hidden = true
						}
					}
			}
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
