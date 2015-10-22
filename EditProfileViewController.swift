//
//  EditProfileViewController.swift
//  SparksyApp
//
//  Created by UserAtom on 10/19/15.
//  Copyright © 2015 Sparksy. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {

	@IBOutlet weak var usernameField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var repeatpasswordField: UITextField!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var aboutField: UITextView!
	@IBOutlet weak var emailField: UITextField!
	let myPickerController = UIImagePickerController()
	var currentUser: PFUser!
	var kbHeight: CGFloat!
	var opener: HomeViewController!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		currentUser = PFUser.currentUser()
		
		// Show the current user's username
		if let pUserName = currentUser?.objectForKey("username") as? String {
			self.usernameField.text = pUserName
		}
		// Show the current user's profile pic
		if let profilePictureObject = currentUser?.objectForKey("profile_picture") as? PFFile {
			profilePictureObject.getDataInBackgroundWithBlock { (imageData:NSData?, error:NSError?) -> Void in
				if (imageData != nil) {
					self.imageView.contentMode = .ScaleAspectFit
					self.imageView.image = UIImage(data:imageData!)
				}
			}
		}
		//Show the current user's profile description
		if let aboutMeText = currentUser?.objectForKey("profile_description") as? String {
			self.aboutField.text = aboutMeText
		}
		
		// Looks for single or multiple taps and dissmisses the keyboard
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		view.addGestureRecognizer(tap)
		
		myPickerController.delegate = self
		aboutField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func doneButton(sender: AnyObject) {
		//self.dismissViewControllerAnimated(true, completion: nil)
	}

	@IBAction func chooseProfilePictureButton(sender: AnyObject) {
		let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
		let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
			{
				UIAlertAction in
				self.openCamera()
		}
		let galleryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default)
			{
				UIAlertAction in
				self.openGallery()
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
				UIAlertAction in
		}
		
		// Add the actions
		alert.addAction(cameraAction)
		alert.addAction(galleryAction)
		alert.addAction(cancelAction)
		
		// Present action sheet
		self.presentViewController(alert, animated: true, completion: nil)
		myPickerController.allowsEditing = true
		
		// What the user sees
		self.presentViewController(myPickerController, animated: true, completion: nil)
		
	}
	
	func openCamera() {
		if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
		{
			myPickerController.sourceType = UIImagePickerControllerSourceType.Camera
			self .presentViewController(myPickerController, animated: true, completion: nil)
		}
	}
	
	func openGallery() {
		if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
		{
			myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
			self.presentViewController(myPickerController, animated: true, completion: nil)
		}
	}
	
	// Called after an image has been selected by the user
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
		self.imageView.contentMode = .ScaleAspectFit
		self.imageView.image = chosenImage
		
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func saveButton(sender: AnyObject) {
		let profileImageData = UIImageJPEGRepresentation(self.imageView.image!, 1)
		
		if (profileImageData != nil) {
			//Set profile picture in Parse
			let profileFileObject = PFFile(data:profileImageData!)
			currentUser.setObject(profileFileObject, forKey: "profile_picture")
		}
		if (!self.aboutField.text.isEmpty) {
			currentUser.setObject(self.aboutField.text, forKey: "profile_description")
		}
		if (!self.emailField.text!.isEmpty) {
			let newEmail = self.emailField.text
			currentUser.email = newEmail
		}
		if (!self.passwordField.text!.isEmpty) {
			if (self.passwordField.text != self.repeatpasswordField.text) {
				let myAlert = UIAlertController(title:"", message:"Passwords don't match", preferredStyle: UIAlertControllerStyle.Alert)
				let okAction = UIAlertAction(title:"Ok", style: .Default) { (_) in }
				myAlert.addAction(okAction)
				self.presentViewController(myAlert, animated: true, completion: nil)
				return
			}
			
			let newPassword = self.passwordField.text
			currentUser.password = newPassword
		}
		if (!self.usernameField.text!.isEmpty) {
			let newUserName = self.usernameField.text
			currentUser.username = newUserName
		}
		
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
				
				let userMessage = "Profile Succesfully Updated"
				let myAlert = UIAlertController(title:"", message:userMessage, preferredStyle:UIAlertControllerStyle.Alert)
				let okAction = UIAlertAction(title: "Ok", style: .Default) { (_) in }
				myAlert.addAction(okAction)
				self.presentViewController(myAlert, animated: true, completion: nil)
			}
		})
	}
	
	/*func postImageToParse(chosenImage: UIImage) {
		let profileImageData = UIImageJPEGRepresentation(chosenImage, 1)
		
		//Set profile picture in Parse
		if (profileImageData != nil) {
			let profileFileObject = PFFile(data:profileImageData!)
			currentUser.setObject(profileFileObject, forKey: "profile_picture")
		}
		
		currentUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
			
			if (error != nil) {
				let myAlert = UIAlertController(title:"", message:error!.localizedDescription, preferredStyle:UIAlertControllerStyle.Alert)
				let okAction = UIAlertAction(title: "Ok", style: .Default) { (_) in }
				myAlert.addAction(okAction)
				self.presentViewController(myAlert, animated: true, completion: nil)
				
				return
			}
			if (success) {
				let userMessage = "Profile Picture Succesfully Updated"
				let myAlert = UIAlertController(title:"", message:userMessage, preferredStyle:UIAlertControllerStyle.Alert)
				let okAction = UIAlertAction(title: "Ok", style: .Default) { (_) in }
				myAlert.addAction(okAction)
				self.presentViewController(myAlert, animated: true, completion: nil)
			}
		})
	}*/
	
	/*func postAboutMeToParse(profileDescription: String) {
		currentUser.setObject(profileDescription, forKey: "profile_description")
		
		currentUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
			
			if (error != nil) {
				let myAlert = UIAlertController(title:"", message:error!.localizedDescription, preferredStyle:UIAlertControllerStyle.Alert)
				let okAction = UIAlertAction(title: "Ok", style: .Default) { (_) in }
				myAlert.addAction(okAction)
				self.presentViewController(myAlert, animated: true, completion: nil)
				
				return
			}
			if (success) {
				let userMessage = "Profile Description Succesfully Updated"
				let myAlert = UIAlertController(title:"", message:userMessage, preferredStyle:UIAlertControllerStyle.Alert)
				let okAction = UIAlertAction(title: "Ok", style: .Default) { (_) in }
				myAlert.addAction(okAction)
				self.presentViewController(myAlert, animated: true, completion: nil)
			}
		})
		
	}*/
	
	func keyboardWillShow(notification: NSNotification) {
		if let userInfo = notification.userInfo {
			if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
				kbHeight = keyboardSize.height
				//self.animateTextField(true)
			}
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
		self.animateTextField(false)
	}
	
	func animateTextField(up: Bool) {
		let movement = (up ? -kbHeight : kbHeight)
		
		UIView.animateWithDuration(0.3, animations: {
			self.view.frame = CGRectOffset(self.view.frame, 0, movement)
		})
	}
	
	//Resigns the keyboard from textView when "done" is pressed
	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		if(text == "\n") {
			textView.resignFirstResponder()
			return false
		}
		return true
	}
	
	// Calls this function when the tap is recognized.
	func DismissKeyboard(){
		// Causes the view (or one of its embedded text fields) to resign the first responder status.
		view.endEditing(true)
	}
	
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
