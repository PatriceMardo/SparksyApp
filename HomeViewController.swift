//
//  HomeViewController.swift
//  SparksyApp
//
//  Created by UserAtom on 10/2/15.
//  Copyright © 2015 Sparksy. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class HomeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {
	
	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var aboutField: UITextView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var switchButton: UISwitch!
	
	var currentUser: PFUser!
	let imagePicker = UIImagePickerController()
	var kbHeight: CGFloat!
	var switchState: String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		currentUser = PFUser.currentUser()
		
		// Show the current user's username
		if let pUserName = currentUser?["username"] as? String {
			self.userNameLabel.text = "@" + pUserName
		}
		
		if let profilePictureObject = currentUser?.objectForKey("profile_picture") as? PFFile {
			profilePictureObject.getDataInBackgroundWithBlock { (imageData:NSData?, error:NSError?) -> Void in
				
			if (imageData != nil) {
				self.imageView.contentMode = .ScaleAspectFit
				self.imageView.image = UIImage(data:imageData!)
				}
			}
		}
		
		if let aboutMeText = currentUser?.objectForKey("profile_description") as? String {
			self.aboutField.text = aboutMeText
		}
		
		if let switchValue = currentUser?.objectForKey("chat_state") as? String {
			self.switchState = switchValue
			if (switchValue == "ON") {
				switchButton.on = true
			}
			else {
				switchButton.on = false
			}
		}
		else if (currentUser != nil){
			switchButton.on = true
			self.switchState = "ON"
			currentUser.setObject(self.switchState, forKey: "chat_state")
			currentUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
				if (error != nil) {
					print("Error saving initial/default chat_state to parse")
				}
				if (success) {
					print("Successfully saved initial/default chat_state to parse")
				}
			})
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func switchAction(switchButton: UISwitch) {
		//let profileFileObject = PFObject(data:switchButton)
	//	currentUser.setObject(profileFileObject, forKey: "profile_picture")
		if switchButton.on {
			self.switchState = "ON"
		}
		else {
			self.switchState = "OFF"
		}
		currentUser.setObject(self.switchState, forKey: "chat_state")
		
		//Display activity indicator
		let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
		loadingNotification.labelText = "Saving..."

		currentUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
			if (error != nil) {
				let myAlert = UIAlertController(title:"", message:error!.localizedDescription, preferredStyle:UIAlertControllerStyle.Alert)
				let okAction = UIAlertAction(title: "Ok", style: .Default) { (_) in }
				myAlert.addAction(okAction)
				self.presentViewController(myAlert, animated: true, completion: nil)
				
				return
			}
			if (success) {
				//Hide activity indicator
				loadingNotification.hide(true)
				
				var userMessage: String!
				if (self.switchState == "ON") {
					userMessage = "Chat successfully enabled"
				}
				else {
					userMessage = "Chat successfully disabled"
				}
				let myAlert = UIAlertController(title:"", message:userMessage, preferredStyle:UIAlertControllerStyle.Alert)
				let okAction = UIAlertAction(title: "Ok", style: .Default) { (_) in }
				myAlert.addAction(okAction)
				self.presentViewController(myAlert, animated: true, completion: nil)
			}
		})

	}
	@IBAction func logoutAction(sender: AnyObject) {
		// Send a request to log out a user and
		//Display activity indicator
		let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
		loadingNotification.labelText = "Logging out..."
		PFUser.logOut()
		loadingNotification.hide(true)
		
		dispatch_async(dispatch_get_main_queue(), { () -> Void in
			let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
			self.presentViewController(viewController, animated: true, completion: nil)
		})
	}
	
	// Instantiate the Login View Controller with the Storyboard Id "Login"
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		if (PFUser.currentUser() == nil) {
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				
				let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
				self.presentViewController(viewController, animated: true, completion: nil)
			})
		}
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
		if identifier == "home_to_browser" {
			
			if ((currentUser?.objectForKey("profile_picture") as? PFFile) != nil) {
				return true
			}
				
			else {
				let myAlert = UIAlertController(title:"No Profile Picture", message:"A profile picture is required before browsing for peers", preferredStyle:UIAlertControllerStyle.Alert)
				let okAction = UIAlertAction(title: "Ok", style: .Default) { (_) in }
				myAlert.addAction(okAction)
				self.presentViewController(myAlert, animated: true, completion: nil)
				return false
			}
		}
		
		// by default, transition
		return true
	}

}

	/*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

	}*/
