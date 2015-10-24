//
//  SignUpViewController.swift
//  SparksyApp
//
//  Created by UserAtom on 10/2/15.
//  Copyright © 2015 Sparksy. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
	
	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var usernameField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var phoneField: UITextField!
	var phoneNumber: String = ""
	var preferredLanguage: String! = "en"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		phoneField.hidden = true
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		view.addGestureRecognizer(tap)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		emailField.resignFirstResponder()
		usernameField.resignFirstResponder()
		passwordField.resignFirstResponder()
		return true
	}
	
	@IBAction func signUpAction(sender: AnyObject) {
		let username = self.usernameField.text
		let password = self.passwordField.text
		let email = self.emailField.text
		let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
		
		// Validate input fields
		/*if phoneField.text?.characters.count != 10 {
			let myAlert = UIAlertController(title:"Phone login", message:"You must enter a 10-digit US phone number including area code.", preferredStyle:UIAlertControllerStyle.Alert)
			let okAction = UIAlertAction(title: "Ok", style: .Default) { (_) in }
			myAlert.addAction(okAction)
			self.presentViewController(myAlert, animated: true, completion: nil)
		}*/
		if username?.characters.count < 5 {
			
			let myAlert = UIAlertController(title:"Invalid", message:"Username must be greater than 5 characters", preferredStyle:UIAlertControllerStyle.Alert)
			let okAction = UIAlertAction(title: "Ok", style: .Default) { (_) in }
			myAlert.addAction(okAction)
			self.presentViewController(myAlert, animated: true, completion: nil)
			
		} else if password?.characters.count < 8 {
			
			let myAlert = UIAlertController(title:"Invalid", message:"Password must be greater than 8 characters", preferredStyle:UIAlertControllerStyle.Alert)
			let okAction = UIAlertAction(title: "Ok", style: .Default) { (_) in }
			myAlert.addAction(okAction)
			self.presentViewController(myAlert, animated: true, completion: nil)
			
		} else if email?.characters.count < 8 {
			
			let myAlert = UIAlertController(title:"Invalid", message:"Please enter a valid email address", preferredStyle:UIAlertControllerStyle.Alert)
			let okAction = UIAlertAction(title: "Ok", style: .Default) { (_) in }
			myAlert.addAction(okAction)
			self.presentViewController(myAlert, animated: true, completion: nil)
			
		} else {
			// Run a spinner to show a task in progress
			let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
			spinner.startAnimating()
			
			
		/*	if phoneNumber == "" {
				self.editing = false
				let params = ["phoneNumber" : phoneField.text, "language" : preferredLanguage]
				PFCloud.callFunctionInBackground("sendCode", withParameters: params) { response, error in
					self.editing = true
					if let error = error {
						var description = error.description
						if description.characters.count == 0 {
							description = NSLocalizedString("warningGeneral", comment: "Something went wrong. Please try again.") // "There was a problem with the service.\nTry again later."
						} else if let message = error.userInfo["error"] as? String {
							description = message
						}
						let myAlert = UIAlertController(title:"Login Error", message:description, preferredStyle:UIAlertControllerStyle.Alert)
						let okAction = UIAlertAction(title: "Ok", style: .Default) { (_) in }
						myAlert.addAction(okAction)
						self.presentViewController(myAlert, animated: true, completion: nil)
					}
					return
				}
			} else {
				if phoneField.text!.characters.count == 4, let code = Int(phoneField.text!) {
					self.editing = false
					let params = ["phoneNumber": phoneNumber, "codeEntry": code] as [NSObject:AnyObject]
					PFCloud.callFunctionInBackground("logIn", withParameters: params) { response, error in
						if let description = error?.description {
							let myAlert = UIAlertController(title:"Login Error", message:description, preferredStyle:UIAlertControllerStyle.Alert)
							let okAction = UIAlertAction(title: "Ok", style: .Default) { (_) in }
							myAlert.addAction(okAction)
							self.presentViewController(myAlert, animated: true, completion: nil)
							return
						}
						if let token = response as? String {
							PFUser.becomeInBackground(token) { user, error in
								if let _ = error {
									let myAlert = UIAlertController(title:"Login Error", message:"Something went wrong, please try again", preferredStyle:UIAlertControllerStyle.Alert)
									let okAction = UIAlertAction(title: "Ok", style: .Default) { (_) in }
									myAlert.addAction(okAction)
									self.presentViewController(myAlert, animated: true, completion: nil)
									return
								}
								return self.dismissViewControllerAnimated(true, completion: nil)
							}
						} else {
							self.editing = true
							let myAlert = UIAlertController(title:"Login Error", message:"Something went wrong, please try again", preferredStyle:UIAlertControllerStyle.Alert)
							let okAction = UIAlertAction(title: "Ok", style: .Default) { (_) in }
							myAlert.addAction(okAction)
							self.presentViewController(myAlert, animated: true, completion: nil)
							return
						}
					}

				} */

			let newUser = PFUser()
			
			newUser.username = username
			newUser.password = password
			newUser.email = finalEmail
		
			// Sign up the user asynchronously
			newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
				
				// Stop the spinner
				spinner.stopAnimating()
				if ((error) != nil) {
					let alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
					alert.show()
					
				} else {
					let alert = UIAlertView(title: "Success", message: "Signed Up", delegate: self, cancelButtonTitle: "OK")
					alert.show()
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home") 
						self.presentViewController(viewController, animated: true, completion: nil)
					})
				}
			})
			
			
				/*if ((error) != nil) {
					let myAlert = UIAlertController(title:"Error", message:error!.localizedDescription, preferredStyle:UIAlertControllerStyle.Alert)
					let okAction = UIAlertAction(title: "Ok", style: .Default) { (_) in }
					myAlert.addAction(okAction)
					self.presentViewController(myAlert, animated: true, completion: nil)
					
				} else {
					newUser.setObject(self.phoneField.text!, forKey: "phone_number")
					let myAlert = UIAlertController(title:"Success", message:"Signed up!", preferredStyle:UIAlertControllerStyle.Alert)
					let okAction = UIAlertAction(title: "Ok", style: .Default) { (_) in }
					myAlert.addAction(okAction)
					self.presentViewController(myAlert, animated: true, completion: nil)
					
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
						self.presentViewController(viewController, animated: true, completion: nil)
					})
				}
			})*/
		}
	
	}
	
	/*func step2() {
		phoneNumber = phoneField.text!
		phoneField.text = ""
		phoneField.placeholder = "1234"
		questionLabel.text = NSLocalizedString("enterCode", comment: "Enter the 4-digit confirmation code:")
		subtitleLabel.text = NSLocalizedString("enterCodeExtra", comment: "It was sent in an SMS message to +1" + phoneNumber) + phoneNumber
		sendCodeButton.enabled = true
	}*/

	
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

