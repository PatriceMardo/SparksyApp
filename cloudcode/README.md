### AnyPhone
##### An example iOS (Swift) and Android app for phone-based user accounts with Twilio + Parse

---

#### Requirements

* Parse account (Sign up at [Parse.com](https://parse.com))
* Twilio account & phone number (Sign up at [Twilio.com](https://twilio.com))

#### iOS Setup

* Create a new Parse App, and [set up a Cloud Code folder](https://parse.com/docs/js/guide#cloud-code) for the project.  
* Copy the contents of the `cloud/` folder from this repository into the `cloud/` folder in your Cloud Code folder.  
* Edit `main.js` to include your Twilio Account Sid, Auth Token, and phone number.  Generate some random string to use as the password token.
* Pull all required iOS dependencies from `Cocoapods` by running `pod install` under `AnyPhone` folder.
* Open the `AnyPhone/AnyPhone.xcworkspace`, and put your Parse Application Id and Client Key in `AppDelegate.swift`.
* Deploy your Cloud Code by running `parse deploy` from the root of your Cloud Code folder.

#### Android Setup

The Android project demonstrates you how to use Twilio and Parse for phone number account creation together. With this sample app, you can learn how to build phone-based login with Parse using a simple, step-by-step example. Here’s how it works:

* Create a new Parse App, and [set up a Cloud Code folder](https://parse.com/docs/js/guide#cloud-code) for the project.  
* Copy the contents of the `cloud/` folder from this repository into the `cloud/` folder in your Cloud Code folder.  
* Edit `main.js` to include your Twilio Account Sid, Auth Token, and phone number.  Generate some random string to use as the password token.
* Add your Parse application id and client key in `Application.java`.
* Deploy your Cloud Code by running parse deploy from the root of your Cloud Code folder.

##### Setting Up AnyPhone Web
* Enable Hosting on your Parse App by going to the Settings > Hosting page. Add a subdomain name (ex. "anyphonetest123") that will allow you to access AnyPhone for Web.  
* Delete 'index.html' from the generated Cloud Code folder to allow rendering of our 'index.ejs' instead
* Visit the hosted pages using the subdomain you created. http://*.parseapp.com


##### Localization
* Japanese mobile phone and language localization support added.
* Korean mobile phone and language localization support added.
* Portuguese (Brazil) mobile phone and language localization support added.

#### Optionally

* Lock down the User class in the Data Browser.  Remove all permissions except Update from the Public role.  This is a good idea even though we're already setting a restrictive ACL on each User we create through this process.  You can remove the "Add Field" permission only after using the app, or after manually creating the additional columns.
* Get involved and contribute to the project:
  * Enhance the input validation to support more countries and number formats
  * Improvements to the flow and user experience
  * Add brute-force protection, resetting the code after a few failed attempts
