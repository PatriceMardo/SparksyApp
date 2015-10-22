//
//  LoginViewController.swift
//  SparksyApp
//
//  Created by UserAtom on 10/2/15.
//  Copyright © 2015 Sparksy. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
	
	@IBOutlet weak var usernameField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		view.addGestureRecognizer(tap)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func loginAction(sender: AnyObject) {
		let username = self.usernameField.text
		let password = self.passwordField.text
		
		// Validate the text fields
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
			
		} else {
			// Run a spinner to show a task in progress
			let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
			spinner.startAnimating()
			
			// Send a request to login
			PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user, error) -> Void in
				
				// Stop the spinner
				spinner.stopAnimating()
				
				if ((user) != nil) {
					let myAlert = UIAlertController(title:"Success", message:"Logged in", preferredStyle:UIAlertControllerStyle.Alert)
					let okAction = UIAlertAction(title: "Ok", style: .Default) { (_) in }
					myAlert.addAction(okAction)
					
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
						self.presentViewController(viewController, animated: true, completion: nil)
					})
					
				} else {
					let myAlert = UIAlertController(title:"Error", message:"\(error)", preferredStyle:UIAlertControllerStyle.Alert)
					let okAction = UIAlertAction(title: "Ok", style: .Default) { (_) in }
					myAlert.addAction(okAction)
					self.presentViewController(myAlert, animated: true, completion: nil)
				}
			})
		}
	}
	
	@IBAction func unwindToLogInScreen(segue:UIStoryboardSegue) {
	}
	
	// Calls this function when the tap is recognized.
	func DismissKeyboard(){
		// Causes the view (or one of its embedded text fields) to resign the first responder status.
		view.endEditing(true)
	}
	
	func textFieldShouldReturn(sender: AnyObject) -> Bool {
		sender.resignFirstResponder()
		/*usernameField.resignFirstResponder()
		passwordField.resignFirstResponder()*/
		return true
	}
	
	/*
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
}

