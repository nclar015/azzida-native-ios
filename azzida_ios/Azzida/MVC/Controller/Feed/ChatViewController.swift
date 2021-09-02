//
//  ChatViewController.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 10/06/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet var NavView: UIView!
    @IBOutlet weak var txtMsg: UITextView!
    @IBOutlet weak var lblNameTitle: UILabel!
    @IBOutlet weak var userImageTitle: UIImageView!
    @IBOutlet weak var txtHeight: NSLayoutConstraint!
    
    
    var chatType = ""
    var FeedJSOn = JSON()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var MessageArr : [JSON] = []
    var pushData = [String:Any]()
    var placeholderLabel : UILabel!
    var jobID = 0
    var titleStr = ""
    var JobData = JSON()
    var chatValue = "false"
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if chatValue == "true"{
            if appDel.isFromPush{
                self.jobID = Int(pushData["JobId"] as? String ?? "0") ?? 0
            }
            
            print(jobID)
            let apiController : APIController = APIController()
            let param:[String:Any] = [
                "JobId":jobID,
                "UserId":appDel.user_ID
            ]
            apiController.getRequest(methodName: "GetJobDetail", param: param, isHUD: true) { (responce) in
                if responce["message"].stringValue == "success"{
                    DispatchQueue.main.async {
                        self.JobData = responce["data"]
                        print(self.JobData["ListerId"].intValue)
                        print(self.appDelegate.user_ID)
                        if self.appDelegate.user_ID == self.JobData["ListerId"].intValue{
                            self.chatType = "MyListing"
                               }
                        self.FeedJSOn = self.JobData
                        self.chatValue = "false"
                        self.tblView.register(UINib(nibName: "MessageSendCell", bundle: nil), forCellReuseIdentifier: "MessageSendCell")
                        self.tblView.register(UINib(nibName: "ReceiveMessageCell", bundle: nil), forCellReuseIdentifier: "ReceiveMessageCell")
                        self.handleUI()
                        NotificationCenter.default.addObserver(self, selector: #selector(self.getChatPush), name: NSNotification.Name(rawValue: "Receive_Chat"), object: nil)
                        self.placeholderTextView()
                        _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.refreshChat), userInfo: nil, repeats: true)
                    }
                }
            }
            navigationItem.titleView = self.NavView
        }
        else{
            self.tblView.register(UINib(nibName: "MessageSendCell", bundle: nil), forCellReuseIdentifier: "MessageSendCell")
            self.tblView.register(UINib(nibName: "ReceiveMessageCell", bundle: nil), forCellReuseIdentifier: "ReceiveMessageCell")
            self.handleUI()
            NotificationCenter.default.addObserver(self, selector: #selector(self.getChatPush), name: NSNotification.Name(rawValue: "Receive_Chat"), object: nil)
            self.placeholderTextView()
            _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.refreshChat), userInfo: nil, repeats: true)
             navigationItem.titleView = self.NavView
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.appDelegate.isFromPush = false
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        if appDelegate.isFromPush{
            self.navigationController?.popToViewController(ofClass: HomeViewController.self)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handleUI(){
        if appDelegate.isFromPush == true{
            getUserChatByPush()
        }
        else{
            GetUserChat()
            if chatType == "MyListing"{
                lblNameTitle.text = FeedJSOn["SeekerName"].stringValue
                userImageTitle.downloadImage(url: FeedJSOn["Seekerimage"].stringValue)
                
            }
            else{
                lblNameTitle.text = FeedJSOn["ListerName"].stringValue
                userImageTitle.downloadImage(url: FeedJSOn["ListerProfilePicture"].stringValue)
            }
        }
    }
    
    func GetUserChat(){
        var ToId = 0
        if chatType == "MyListing"{
            ToId = FeedJSOn["SeekerId"].intValue
        }
        else{
            ToId = FeedJSOn["ListerId"].intValue
        }
        print(ToId)
        print(self.appDelegate.user_ID)
        
        
        
        
        let apiController : APIController = APIController()
        let param = ["FromId":self.appDelegate.user_ID,
                     "ToId":ToId,
                     "JobId":FeedJSOn["JobId"].intValue,
            ] as [String : Any]
        apiController.getRequest(methodName: "GetUserChat",param: param, isHUD: true) { (responce) in
            if responce["message"].stringValue == "success"{
                self.MessageArr = responce["data"].arrayValue
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                    self.scrollToBottom()
                }
            }
        }
    }
    
    @objc func refreshChat(){
        var ToId = 0
        if chatType == "MyListing"{
            ToId = FeedJSOn["SeekerId"].intValue
        }
        else{
            ToId = FeedJSOn["ListerId"].intValue
        }
       
     print(ToId)
        print(self.appDelegate.user_ID)
        print(FeedJSOn["JobId"].intValue)
        
        let apiController : APIController = APIController()
        let param = ["FromId":self.appDelegate.user_ID,
                     "ToId":ToId,
                     "JobId":FeedJSOn["JobId"].intValue
            ] as [String : Any]
        apiController.getRequest(methodName: "GetUserChat",param: param, isHUD: false) { (responce) in
            if responce["message"].stringValue == "success"{
                if self.MessageArr.count != responce["data"].arrayValue.count{
                    self.MessageArr = responce["data"].arrayValue
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                        self.scrollToBottom()
                    }
                }
            }
        }
    }
    
    func getUserChatByPush(){
        let FromUserId = pushData["FromUserId"] as? String ?? "0"
        let toUserId = pushData["toUserId"] as? String ?? "0"
        print(pushData["FromUserId"] as? String ?? "0")
        print(pushData["toUserId"] as? String ?? "0")
        print("pushData",pushData)
        
        let apiController : APIController = APIController()
        let param : [String:Any] = [
            "FromId":FromUserId,
            "ToId":toUserId,
            "JobId":FeedJSOn["JobId"].intValue
        ]
        apiController.getRequest(methodName: "GetUserChat", param: param, isHUD: true) { (responce) in
            if responce["message"].stringValue == "success"{
                self.MessageArr = responce["data"].arrayValue
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                    self.scrollToBottom()
                }
            }
        }
    }
    
    func sendChatForPush(){
        if (txtMsg.text!.isEmpty){
            // Alert.alert(message:"Please_enter_UserName".localized(), title: "Alert") Id, ToId, FromId, IsTyping, UserMessage, MessageDatetime
            return
        }
        
        let currentTime = NSDate().timeIntervalSince1970 * 1000
        let currantTimeStr: String = String(format: "%.f", currentTime)
        let FromUserId = pushData["FromUserId"] as? String ?? "0"
        let toUserId = pushData["toUserId"] as? String ?? "0"
        print(pushData["FromUserId"] as? String ?? "0")
             print(pushData["toUserId"] as? String ?? "0")
        
        let apiController : APIController = APIController()
        apiController.postRequest(methodName: "SaveChat?Id=0&ToId=\(FromUserId)&FromId=\(toUserId)&IsTyping=false&UserMessage=\(txtMsg.text ?? "")&MessageDatetime=\(currantTimeStr)&JobId=\(FeedJSOn["JobId"].intValue)") { (responce) in
            if responce["message"].stringValue == "success"{
                self.txtMsg.text = ""
                self.getUserChatByPush()
            }
        }
    }
    
    
    func sendChat(){
        if (txtMsg.text!.isEmpty){
            // Alert.alert(message:"Please_enter_UserName".localized(), title: "Alert") Id, ToId, FromId, IsTyping, UserMessage, MessageDatetime
            return
        }
        
        var ToId = 0
        if chatType == "MyListing"{
            ToId = FeedJSOn["SeekerId"].intValue
        }
        else{
            ToId = FeedJSOn["ListerId"].intValue
        }
        print(ToId)
        print(appDelegate.user_ID)
        
        let currentTime = NSDate().timeIntervalSince1970 * 1000
        let currantTimeStr: String = String(format: "%.f", currentTime)
        
        let apiController : APIController = APIController()
        apiController.postRequest(methodName: "SaveChat?Id=0&ToId=\(ToId)&FromId=\(appDelegate.user_ID)&IsTyping=false&UserMessage=\(txtMsg.text ?? "")&MessageDatetime=\(currantTimeStr)&JobId=\(FeedJSOn["JobId"].intValue)") { (responce) in
            if responce["message"].stringValue == "success"{
                self.txtMsg.text = ""
                self.GetUserChat()
            }
        }
        
        
    }
    
    
    @objc func getChatPush(_ notification: NSNotification) {
        
        if (notification.userInfo?["status"] as? Bool) != nil {
            if appDelegate.isFromPush == true{
                self.getUserChatByPush()
            }else{
                self.GetUserChat()
                
            }
        }
    }
    
    @IBAction func BtnSend(_ sender: UIButton) {
        if appDelegate.isFromPush{
            sendChatForPush()
        }
        else{
            sendChat()
        }
    }
    
    func getMessageDateAndTime(datestr:String)->String{
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "MMM dd, yyyy"
        let findDate = formatter.string(from: Date(milliseconds: Int(datestr)!))
        let currentDate = formatter.string(from: Date() as Date)
        
        let myMilliseconds: UnixTime!
        let rowData = datestr
        //  let s = rowData.value(forKey: "CreatedDate")  as! String
        let s = datestr
        let date = Date(timeIntervalSince1970: Double(s)! / 1000)
        // print(date)
        
        
        if findDate == currentDate {
            myMilliseconds = UnixTime(datestr.replacingOccurrences(of: ".", with: "") as String)!
            // print((myMilliseconds/1000).toHour)
            return "\((myMilliseconds/1000).toHour)"
            
        }
        else{
            return "\(findDate)"
        }
        
    }
    
    func scrollToBottom(){
        if self.MessageArr.count == 0 {
            return
        }
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.MessageArr.count-1, section: 0)
            self.tblView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func placeholderTextView(){
        
        txtMsg.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = " Type your message..."
        placeholderLabel.font = txtMsg.font
        placeholderLabel.sizeToFit()
        txtMsg.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtMsg.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.darkGray
        placeholderLabel.isHidden = !txtMsg.text.isEmpty
        
    }
    
}

extension ChatViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if MessageArr[indexPath.row]["SenderId"].intValue == appDelegate.user_ID{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageSendCell", for: indexPath) as! MessageSendCell
            cell.lblMessage.text = MessageArr[indexPath.row]["UserMessage"].stringValue
            cell.userImg.downloadImage(url: MessageArr[indexPath.row]["SenderProfilePic"].stringValue)
            cell.lblDate.text = getMessageDateAndTime(datestr: MessageArr[indexPath.row]["MessageDateTime"].stringValue)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiveMessageCell", for: indexPath) as! ReceiveMessageCell
        cell.lblMessage.text = MessageArr[indexPath.row]["UserMessage"].stringValue
        cell.userImg.downloadImage(url: MessageArr[indexPath.row]["SenderProfilePic"].stringValue)
        cell.lblDate.text = getMessageDateAndTime(datestr: MessageArr[indexPath.row]["MessageDateTime"].stringValue)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let cell = tableView.cellForRow(at: indexPath) as! PlaceTableViewCell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let msg = MessageArr[indexPath.row]["UserMessage"].stringValue
        //        let msg = messageDic["text"] as? String ?? ""
        let sizeOFStr = self.getSizeOfString(msg as NSString)
        return sizeOFStr.height + 60
    }
    
    func getSizeOfString(_ postTitle: NSString) -> CGSize {
        // Get the height of the font
        let constraintSize = CGSize(width: self.tblView.frame.width - 181, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17.0)]
        let labelSize = postTitle.boundingRect(with: constraintSize,
                                               options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                               attributes: attributes,
                                               context: nil)
        return labelSize.size
    }
}

extension ChatViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !txtMsg.text.isEmpty
        
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        if newSize.height > 100{
            txtHeight.constant = 100
            txtMsg.isScrollEnabled = true
        }
        else{
            var newFrame = textView.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            txtHeight.constant = newSize.height
            txtMsg.isScrollEnabled = false
            
        }
    }
    
    
}
