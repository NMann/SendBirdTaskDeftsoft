//
//  AppDelegate.swift
//  DemoSendBirdChatApp
//
//  Created by IOS22 on 17/02/22.

import UIKit
import SendBirdSDK
import SendBirdUIKit
import IQKeyboardManagerSwift
import AVKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        enableIQKeyBoard()
        SBDMain.initWithApplicationId(AppId)
        enableAVPlayerAudioOnSpeaker()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


// MARK: - Extension
extension AppDelegate {
    
    func enableIQKeyBoard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    func enableAVPlayerAudioOnSpeaker() {
        let audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.setCategory(.playAndRecord,
                                         mode: .videoChat,
                                         options: [.defaultToSpeaker,
                                                   .allowAirPlay,
                                                   .allowBluetooth])
            try audioSession.setActive(true)
            let engine = AVAudioEngine()
            try engine.inputNode.setVoiceProcessingEnabled(true)
            try audioSession.overrideOutputAudioPort(.speaker)
        }catch{
            
        }
        
    }
    
    
}

