//
//  MPCManager.swift
//  SparksyApp
//
//  Created by UserAtom on 10/2/15.
//  Copyright © 2015 Sparksy. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import Parse

protocol MPCManagerDelegate {
	func foundPeer()
	
	func lostPeer()
	
	func invitationWasReceived(fromPeer: String)
	
	func connectedWithPeer(peerID: MCPeerID)
}

class MPCManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate,MCNearbyServiceAdvertiserDelegate {
	
	var delegate: MPCManagerDelegate?
	
	var session: MCSession!
	
	var peer: MCPeerID!
	
	var browser: MCNearbyServiceBrowser!
	
	var advertiser: MCNearbyServiceAdvertiser!
	
	var foundPeers = [MCPeerID]()
	
	var invitationHandler: ((Bool, MCSession)->Void)!
	
	var currentUser: PFUser?
	
	override init() {
		super.init()
		
		currentUser = PFUser.currentUser()
		
		// Show the current user's username
		if let pUserName = currentUser?["username"] as? String {
			peer = MCPeerID(displayName: pUserName)
		}
		else {
			peer = MCPeerID(displayName: UIDevice.currentDevice().name)
		}
		
		session = MCSession(peer: peer)
		session.delegate = self
		
		browser = MCNearbyServiceBrowser(peer: peer, serviceType: "sparksy-mpc")
		browser.delegate = self
		
		advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: "sparksy-mpc")
		advertiser.delegate = self
	}
	
	
	// MCNearbyServiceBrowserDelegate method implementation
	
	func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
		foundPeers.append(peerID)
		
		delegate?.foundPeer()
	}
	
	
	func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
		for (index, aPeer) in foundPeers.enumerate(){
			if aPeer == peerID {
				foundPeers.removeAtIndex(index)
				break
			}
		}
		
		delegate?.lostPeer()
	}
	
	
	func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
		print(error.localizedDescription)
	}
	
	
	// MCNearbyServiceAdvertiserDelegate method implementation
	
	func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: ((Bool, MCSession) -> Void)) {
		self.invitationHandler = invitationHandler
		
		// Pass display name of Peer wanting to chat
		delegate?.invitationWasReceived(peerID.displayName)
	}
	
	// Handles case where advertiser fails to turn on
	func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
		
		print(error.localizedDescription)
	}
	
	// MCSessionDelegate method implementation
	
	func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
		
		switch state{
		case MCSessionState.Connected:
			print("Connected to session: \(session)")
			delegate?.connectedWithPeer(peerID)
			
		case MCSessionState.Connecting:
			print("Connecting to session: \(session)")
			
		default:
			print("Did not connect to session: \(session)")
		}
	}
	
	func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
		let dictionary: [String: AnyObject] = ["data": data, "fromPeer": peerID]
		NSNotificationCenter.defaultCenter().postNotificationName("receivedMPCDataNotification", object: dictionary)
	}
	
	func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) { }
	
	func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) { }
	
	func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
	
	
	// Custom method implementation
	
	func sendData(dictionaryWithData dictionary: Dictionary<String, String>, toPeer targetPeer: MCPeerID) -> Bool {
		let dataToSend = NSKeyedArchiver.archivedDataWithRootObject(dictionary)
		let peersArray = [targetPeer]
		//let error: NSError?
		
		do {
			try session.sendData(dataToSend, toPeers: peersArray, withMode: MCSessionSendDataMode.Reliable)
		}
		catch _	{
			/*print(error?.localizedDescription)
			return false*/
		}
		
		return true
	}
	
}
