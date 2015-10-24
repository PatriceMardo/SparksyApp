//
//  ViewController.swift
//  SparksyApp
//
//  Created by UserAtom on 10/2/15.
//  Copyright © 2015 Sparksy. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import MBProgressHUD

class BrowserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MPCManagerDelegate {
	
	@IBOutlet weak var tblPeers: UITableView!
	
	let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	
	var isAdvertising: Bool!
	
	var otherPeer: String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		tblPeers.delegate = self
		tblPeers.dataSource = self
		
		appDelegate.mpcManager.delegate = self
		
		appDelegate.mpcManager.browser.startBrowsingForPeers()
		
		appDelegate.mpcManager.advertiser.startAdvertisingPeer()
		
		isAdvertising = true
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	//BAction method implementation
	
	@IBAction func startStopAdvertising(sender: AnyObject) {
		let actionSheet = UIAlertController(title: "", message: "Change Visibility", preferredStyle: UIAlertControllerStyle.ActionSheet)
		
		var actionTitle: String
		if isAdvertising == true {
			actionTitle = "Make me invisible to others"
		}
		else{
			actionTitle = "Make me visible to others"
		}
		
		let visibilityAction: UIAlertAction = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default) { (alertAction) -> Void in
			if self.isAdvertising == true {
				self.appDelegate.mpcManager.advertiser.stopAdvertisingPeer()
			}
			else{
				self.appDelegate.mpcManager.advertiser.startAdvertisingPeer()
			}
			
			self.isAdvertising = !self.isAdvertising
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
			
		}
		
		actionSheet.addAction(visibilityAction)
		actionSheet.addAction(cancelAction)
		
		self.presentViewController(actionSheet, animated: true, completion: nil)
	}
	
	//UITableView related method implementation
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return appDelegate.mpcManager.foundPeers.count
	}
	
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("idCellPeer") as UITableViewCell?
		
		cell!.textLabel?.text = appDelegate.mpcManager.foundPeers[indexPath.row].displayName
		
		return cell!
	}
	
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 60.0
	}
	
	//Selecting a peer
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let selectedPeer = appDelegate.mpcManager.foundPeers[indexPath.row] as MCPeerID

		let actionSheet = UIAlertController(title: "Options", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
		
		let viewProfileAction: UIAlertAction = UIAlertAction(title: "View Profile", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
			
			self.otherPeer = selectedPeer.displayName
			self.performSegueWithIdentifier("to_peer_profile", sender: self)
		}
		
		let chatAction: UIAlertAction = UIAlertAction(title: "Chat", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
			
			self.appDelegate.mpcManager.browser.invitePeer(selectedPeer, toSession: self.appDelegate.mpcManager.session, withContext: nil, timeout: 20)
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
		}
		
		actionSheet.addAction(viewProfileAction)
		actionSheet.addAction(chatAction)
		actionSheet.addAction(cancelAction)
		
		self.presentViewController(actionSheet, animated: true, completion: nil)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
		if (segue.identifier == "to_peer_profile") {
			let theNextViewController = (segue.destinationViewController as! PeerProfileViewController)
			theNextViewController.peerName = self.otherPeer
		}
	}
	
	//MPCManagerDelegate method implementation
	
	func foundPeer() {
		tblPeers.reloadData()
	}
	
	func lostPeer() {
		tblPeers.reloadData()
	}
	
	//Used to reply to the inviter
	func invitationWasReceived(fromPeer: String) {
		let alert = UIAlertController(title: "", message: "\(fromPeer) wants to chat with you.", preferredStyle: UIAlertControllerStyle.Alert)
		
		let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
			self.appDelegate.mpcManager.invitationHandler(true, self.appDelegate.mpcManager.session)
		}
		
		let declineAction = UIAlertAction(title: "Decline", style: UIAlertActionStyle.Cancel) {
		(alertAction) -> Void in
		self.appDelegate.mpcManager.invitationHandler(false, self.appDelegate.mpcManager.session)
		}
		
		
		alert.addAction(acceptAction)
		alert.addAction(declineAction)
		
		NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	func connectedWithPeer(peerID: MCPeerID) {
		NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
			self.performSegueWithIdentifier("idSegueChat", sender: self)
		}
	}
}
