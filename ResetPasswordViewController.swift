//
//  ResetPasswordViewController.swift
//  SparksyApp
//
//  Created by UserAtom on 10/2/15.
//  Copyright © 2015 Sparksy. All rights reserved.
//

import UIKit
import Parse

class ResetPasswordViewController: UIViewController {
	
	@IBOutlet weak var emailField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		// Looks for single or multiple taps.
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		view.addGestureRecognizer(tap)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		emailField.resignFirstResponder()
		return true
	}
	
	@IBAction func passwordReset(sender: AnyObject) {
		let email = self.emailField.text
		let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
		
		// Send a request to reset a password
		PFUser.requestPasswordResetForEmailInBackground(finalEmail)
		
		let alert = UIAlertController (title: "Password Reset", message: "An email containing information on how to reset your password has been sent to " + finalEmail + ".", preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
		self.presentViewController(alert, animated: true, completion: nil)
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

