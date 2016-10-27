//
//  PrivateChatViewController.swift
//  Harbr
//
//  Created by Flavio Lici on 9/25/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Firebase
import Parse

class PrivateChatViewController: JSQMessagesViewController {
    
    func UIColorFromRGB(colorCode: String, alpha: Float = 1.0) -> UIColor {
        var scanner = NSScanner(string:colorCode)
        var color:UInt32 = 0;
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        
        
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
    

    var avatars = Dictionary<String, UIImage>()

    var messagesRef: Firebase!
    
    var userConnected: String!
    
    var controllerTitle: String!
    
    var myProPic: UIImage!
    var base64String: NSString!
    
    var alreadyInChat = false
    
    var usernames: NSMutableArray! = NSMutableArray()
    var messages: NSMutableArray! = NSMutableArray()
    
    var images: NSMutableArray! = NSMutableArray()
    
    
    var username = ""
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.blackColor())
    
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirebase()
        controllerTitle = "\(PFUser.currentUser()!.username!) and \(userConnected) Chat"
         messagesRef = Firebase(url: "https://harbr.firebaseio.com")
        self.senderId = PFUser.currentUser()!.username!
        self.senderDisplayName = PFUser.currentUser()!.username!
        self.collectionView.collectionViewLayout.springinessEnabled = true
        
        if PFUser.currentUser()?.objectForKey("ProfilePic") != nil {
            let downloadedImage: UIImage = UIImage(data: PFUser.currentUser()!.objectForKey("ProfilePic")!.getData()!)!
                myProPic = downloadedImage
            println("Pic downloaded")
        }
        

       
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .Default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        var data = self.messages.objectAtIndex(indexPath.row) as! JSQMessage
        return data
    }
    

    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        var data = self.messages.objectAtIndex(indexPath.row) as! JSQMessage
        if (data.senderId == self.senderId) {
            return self.outgoingBubble
        } else {
            return self.incomingBubble
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count;
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        var imageData: NSData = UIImagePNGRepresentation(myProPic!)
        base64String = imageData.base64EncodedStringWithOptions(.allZeros)
        
        let post = ["sender": "\(PFUser.currentUser()!.username!)", "text": "\(text)", "picture": "\(base64String)"]
        
        let postRef = messagesRef.childByAutoId()
        postRef.setValue(post)
        println("It sent")
        self.finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
    }
    
    func setupAvatarImage(name: String, imageUrl: String?, incoming: Bool) {
        if let stringUrl = imageUrl {
            if let url = NSURL(string: stringUrl) {
                if let data = NSData(contentsOfURL: url) {
                    let image = UIImage(data: data)
                    let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
                    let avatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(image, diameter: diameter)
                    avatars[name] = avatarImage as? UIImage
                    return
                }
            }
        }
        
        // At some point, we failed at getting the image (probably broken URL), so default to avatarColor
        setupAvatarColor(name, incoming: incoming)
    }
    
    func setupAvatarColor(name: String, incoming: Bool) {
        let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
        
        let rgbValue = name.hash
        let r = CGFloat(Float((rgbValue & 0xFF0000) >> 16)/255.0)
        let g = CGFloat(Float((rgbValue & 0xFF00) >> 8)/255.0)
        let b = CGFloat(Float(rgbValue & 0xFF)/255.0)
        let color = UIColor(red: r, green: g, blue: b, alpha: 0.5)
        
        let nameLength = count(name)
        let initials : String? = name.substringToIndex(advance(PFUser.currentUser()!.username!.startIndex, min(3, nameLength)))
        let userImage = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(initials, backgroundColor: color, textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(13)), diameter: diameter)
        
        avatars[name] = (userImage as! UIImage)
    }
    
    func setupFirebase() {
        // *** STEP 2: SETUP FIREBASE
     
        
        // *** STEP 4: RECEIVE MESSAGES FROM FIREBASE (limited to latest 25 messages)
        messagesRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            if let sender = snapshot.value.objectForKey("sender") as? String {
                self.usernames.addObject(sender)
            }
            
            if let text = snapshot.value.objectForKey("text") as? String {
                self.messages.addObject(text)
            }
            
            if let image = snapshot.value.objectForKey("picture") as? String {
                var decodedData = NSData(base64EncodedString: image, options: NSDataBase64DecodingOptions())
                var decodedImage = UIImage(data: decodedData!)!
                self.images.addObject(decodedImage)
            }
            
            
        })
        
        if PFUser.currentUser()!.objectForKey("myChats") != nil {
            
            var myChats = PFUser.currentUser()?.objectForKey("myChats") as? [String]
            
            for chat in myChats! {
                if chat == "\(controllerTitle)chats" {
                    self.alreadyInChat = true
                }
                
                
            }
            
            if self.alreadyInChat == false {
                PFUser.currentUser()?.addObject("\(controllerTitle)", forKey: "myChats")
               
                PFUser.currentUser()?.saveInBackground()
                
            }
            
        } else {
            PFUser.currentUser()?.setObject(["\(controllerTitle)"], forKey: "myChats")
            PFUser.currentUser()?.saveInBackground()
        }
        
    }
}
