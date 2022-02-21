//
//  ChatViewController.swift
//  DemoSendBirdChatApp
//
//  Created by IOS22 on 17/02/22.
//

import UIKit
import SendBirdSDK
import AVKit
import MobileCoreServices
import AVFoundation




typealias alertAction = ((UIAlertAction) -> Void)?

class ChatViewController: BaseVC,AVAudioRecorderDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(TextMessageCell.self, forCellReuseIdentifier: kTextMessageCell)
        }
    }
    @IBOutlet weak var messageField: GrowingTextView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var recordingView: UIView!
    @IBOutlet weak var sendRecordBtn: UIButton!
    @IBOutlet weak var recordLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    
    //MARK: - Variables
    
    var audioFilename:URL?
    private var permissionCheck:Bool = false
    private var audioRecorder: AVAudioRecorder!
    private var player : AVPlayer?
    private var playerURL:String?
    private var isPlaying = false
    private var currentPlayButton : UIButton?
    var timer:Timer?
    var counter = 0
    var openChannel:SBDOpenChannel?
    private var messages = Array<SBDBaseMessage>(){
        didSet{
            tableView.reloadData()
            if messages.count > 1  {
                tableView.scrollToRow(at: .init(row: 0 , section: 0), at: .top, animated: true)
            }
            
        }
    }
    
    
    
    //MARK: -  Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        set(title: kChat)
        SBDMain.add(self, identifier: description)
        longPressGesture()
        getMessageListing()
        setUpTableView()
        checkMicroPhonePermissions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
        player = nil
    }
    
    
    //MARK: - Functions
    
    func setUpTableView() {
        tableView.register(UINib(nibName: kAudioCell, bundle: nil), forCellReuseIdentifier: kAudioCell)
        tableView.register(UINib(nibName: kInComingAudioCell, bundle: nil), forCellReuseIdentifier: kInComingAudioCell)
        tableView.tableFooterView = UIView()
        tableView.transform = CGAffineTransform(rotationAngle: (-.pi))
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        view.layoutSubviews()
        view.layoutIfNeeded()
        if let v = messageField.superview{
            v.layer.borderWidth = 1
            v.layer.borderColor = UIColor.black.cgColor
            let height = v.frame.height
            v.layer.cornerRadius = height/2
            v.clipsToBounds = true
            messageField.centerVertically()
        }
    }
    
    func checkMicroPhonePermissions() {
        switch AVAudioSession.sharedInstance().recordPermission {
            
        case AVAudioSession.RecordPermission.granted:
            permissionCheck = true
            
        case AVAudioSession.RecordPermission.denied:
            permissionCheck = false
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                if granted
                {
                    self.permissionCheck = true
                } else {
                    self.permissionCheck = false
                }
            })
        default:
            break
        }
    }
    
    func getMessageListing() {
        let messages = openChannel?.createPreviousMessageListQuery()
        messages?.load(completionHandler: { messages, error in
            
            self.messages = messages?.reversed() ?? []
        })
    }
    
    func longPressGesture() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        recordBtn.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        
        if permissionCheck {
            switch sender.state{
            case .began:
                startRecording()
            case .possible:
                debugPrint("possible")
            case .changed:
                debugPrint("changed")
            case .ended:
                debugPrint("Finished")
                recordLbl.text = kAudioRecorded
                timerLbl.text = ""
                self.timer?.invalidate()
                if audioRecorder != nil {
                    finishRecording()
                }
                self.sendRecordBtn.isEnabled = true
            case .cancelled:
                debugPrint("cancelled")
            case .failed:
                debugPrint("failed")
            @unknown default:
                print("default")
            }
        } else {
            showalertControl(title: kAlert, message: SettingAlert) { alert in
                self.openSettings()
            }
        }
    }
    
    func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings: \(success)") // Prints true
            })
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func startRecording() {
        self.sendRecordBtn.isEnabled = false
        recordingView.isHidden = false
        recordBtn.isUserInteractionEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        recordLbl.text = kAudioRecording
        timerLbl.text = "00:0"+"\(counter)"
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename!, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            finishRecording()
        }
    }
    
    
    @objc func updateCounter(){
        if counter < 30 {
            debugPrint("\(counter) seconds")
            counter += 1
            recordLbl.text = kAudioRecorded
            if counter >= 10 {
                self.timerLbl.text = "00:\(self.counter)"
            } else {
                self.timerLbl.text = "00:0"+"\( self.counter)"
            }
            
        } else {
            recordLbl.text = kAudioRecorded
            timerLbl.text = ""
            self.timer?.invalidate()
            finishRecording()
            counter = 0
            self.sendRecordBtn.isEnabled = true
        }
    }
    
    
    func finishRecording() {
            audioRecorder.stop()
            audioRecorder = nil
//            recordBtn.isUserInteractionEnabled = true
    }
    
    
    //MARK: - IBActions
    @IBAction func sendAction(_ sender: Any){
        if let message = validate() {
            self.showalertControl(title: kAlert, message: message)
        } else {
            
            guard let messageText = self.messageField.text else {
                
                return
            }
            self.messageField.text = kEmptyString
            openChannel?.sendUserMessage(messageText, completionHandler: { message, error in
                
                self.btnSend.isEnabled = true
                guard let message = message else{
                    debugPrint("ERROR",error as Any)
                    return
                }
                //                self.messages.append(message)
                self.messages.insert(message, at: 0)
            })
        }
    }
    
    
    
    @IBAction func recordSendBtnAction(_ sender: UIButton) {
        
        guard let data = try? Data(contentsOf: audioFilename!) else {
            return
        }
        
        guard let params = SBDFileMessageParams(file: data) else {
            return
        }
        
        params.fileName = "voice\(Int.random(in: 0...1000))"
        params.mimeType = "audio/mpeg"
        params.fileSize = UInt(data.count)
        params.data = nil
        params.customType = nil
        openChannel?.sendFileMessage(with: params, completionHandler: { message, error in
            self.sendRecordBtn.isEnabled = true
            guard let message = message else{
                self.recordingView.isHidden = true
                self.recordBtn.isUserInteractionEnabled = true
                debugPrint("ERROR",error as Any)
                return
            }
            self.messages.insert(message, at: 0)
            self.recordingView.isHidden = true
            self.recordBtn.isUserInteractionEnabled = true
        })
        
        
    }
    
    
    func validate() -> String? {
        if messageField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == kEmptyString {
            return kEnterMessage
        }
        return nil
    }
    
    
    
    
}



//MARK: - Extension UITableViewDelegate,UITableViewDataSource
extension ChatViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = messages[indexPath.row]
        if let filemessage = item as? SBDFileMessage {
            if item.sender?.userId == SBDMain.getCurrentUser()!.userId {
                let cell = tableView.dequeueReusableCell(withIdentifier: kAudioCell, for: indexPath) as! AudioCell
                cell.bgVIew.backgroundColor = .green
                cell.bgVIew.layer.cornerRadius = 5
                cell.pausePlayBtn.tag = indexPath.row
                cell.pausePlayBtn.addTarget(self, action: #selector(playPauseAction(sender:)), for: .touchUpInside)
                cell.lblAudioName.text = filemessage.name
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: kInComingAudioCell, for: indexPath) as! InComingAudioCell
                cell.bgView.backgroundColor = .gray
                cell.bgView.layer.cornerRadius = 5
                cell.audioBtn.tag = indexPath.row
                cell.selectionStyle = .none
                cell.audioBtn.addTarget(self, action: #selector(playPauseAction(sender:)), for: .touchUpInside)
                cell.lblAUdioName.text = filemessage.name
                return cell
            }
        } else {
            
            let textCell = tableView.dequeueReusableCell(withIdentifier: kTextMessageCell, for: indexPath) as! TextMessageCell
            textCell.message = item
            return textCell
        }
    }
    
    @objc func playPauseAction(sender:UIButton){
        
        let message = messages[sender.tag]
        guard let filemessage = message as? SBDFileMessage else { return }
        if currentPlayButton != sender {
            currentPlayButton?.isSelected = false
        }
        
        sender.isSelected = !sender.isSelected
        if player == nil || playerURL != filemessage.url{
            let fileUrl = URL(string: filemessage.url)
            let playerItem = AVPlayerItem(url: fileUrl!)
            player = AVPlayer(playerItem: playerItem)
            player?.volume = 100
            player?.play()
            playerURL = filemessage.url
            isPlaying = true
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        } else if playerURL == filemessage.url{
            if isPlaying{
                player?.pause()
                isPlaying = false
            }else{
                player?.play()
                isPlaying = true
            }
        }else{
            isPlaying = false
            player?.pause()
            player = nil
        }
        currentPlayButton = sender
    }
    
    @objc func playerItemDidPlayToEndTime() {
        currentPlayButton?.isSelected = false
        isPlaying = false
        player = nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = messages[indexPath.row]
        
        if let filemessage = item as? SBDFileMessage {
            debugPrint(filemessage)
        }
    }
}

//MARK: - Extension SBDChannelDelegate
extension ChatViewController:SBDChannelDelegate{
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        messages.insert(message, at: 0)
    }
}


//MARK: - Audio record delegate method
extension ChatViewController:AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        debugPrint("audioPlayerDidFinishPlaying \(player)= \(flag)")
    }
    
    private func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!){
        debugPrint("Audio Play Decode Error \(error.localizedDescription)")
        debugPrint(#function)
    }
    
    private func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!, error: NSError!) {
        debugPrint("Audio Record Encode Error")
        debugPrint("\(error.localizedDescription)")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording()
        }
    }
}
