//
//  ViewController.swift
//  DemoSendBirdChatApp
//
//  Created by IOS22 on 17/02/22.
//

import UIKit
import SendBirdSDK
import SendBirdUIKit

class ViewController: BaseVC, UITextFieldDelegate,SBDChannelDelegate  {
    
    // MARK: - IBOutlets
    @IBOutlet weak var connectBtn: UIButton!
    @IBOutlet weak var userIdTextField: UITextField!
    
    // MARK: - Varaibles
    let delegateIdentifier = NSUUID().uuidString
    
    // MARK: - Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        userIdTextField.text = kEmptyString
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userIdTextField.delegate = self
        connectBtn.layer.cornerRadius = 10
        self.hideNavigationBar()
    }
    
    
    // MARK: - Private Function Validate Data
    
    private func validateData() -> String? {
        let userTextField = userIdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if userTextField == kEmptyString {
            return kEnterUserId
        }
        if userTextField == kJohn || userTextField == kPeter {
            return nil
        } else {
            return kEnterValidUserId
        }
    }
    
    
    // MARK: - IBActions
    @IBAction func didTapConnectButton(_ sender: Any) {
        if let message = validateData() {
            self.showalertControl(title: kAlert, message: message)
        } else {
            SBDMain.connect(withUserId: userIdTextField.text ?? kEmptyString) { user, error in
                guard let _ = user, error == nil else {
                    return
                }
                
                let vc = UIStoryboard(name: kMain, bundle: .main).instantiateViewController(withIdentifier: kChannelsViewController)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

