//
//  FeedViewController.swift
//  JamChat
//
//  Created by Simon Posada Fishman on 7/12/16.
//  Copyright © 2016 Jammers. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Parse
import ParseUI

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var chats: [Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!User.isLoggedIn()) {
            User.login(self, success: nil, failure: nil)
        }
    }
    
    func loadFeed() {
        Chat.downloadActiveUserChats({ (chats: [Chat]) in
            self.chats = chats
            self.tableView.reloadData()
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatCell") as! ChatCell
        cell.chat = chats[indexPath.row]
        return cell
    }

    @IBAction func onNewChat(sender: AnyObject) {
        let newChatController = ChatCreationViewController()
        presentViewController(newChatController, animated: true, completion: nil)
    }
    
    func createNewChat(userIDs: [String]) {
        let chat = Chat(messageDuration: 10, userIDs: userIDs)
        chat.push { (success: Bool, error: NSError?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.tableView.reloadData()
            }
        }
        chats.append(chat)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
