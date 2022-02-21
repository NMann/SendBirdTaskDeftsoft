//
//  BaseVC.swift
//  Charmed Visions
//
//  Created by IOS22 on 05/08/21.
//
import Foundation
import UIKit
import Photos
import MobileCoreServices

class BaseVC: UIViewController{
    
    //MARK: - Variables

    
    //MARK: -  Class Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        debugPrint("********** MEMORY WARNING **********")
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.memoryCapacity = 0
        URLCache.shared.diskCapacity = 0
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}

//MARK:- Navigation Methods
extension BaseVC {
    func hideNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.barStyle = .black
        
    }
    
    //MARK:- Navigation Title
    func set(title:String, showBack: Bool = true) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIColor.clear.as1ptImage()
        
        let titleButton = UIButton(frame: CGRect(x: 0, y:0, width:110, height:30))
        titleButton.titleLabel?.textAlignment = .center
        titleButton.setTitle(title, for: .normal)
        titleButton.isUserInteractionEnabled = false
        titleButton.titleEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 7, right: 0)
        titleButton.setTitleColor(.black, for: .normal)
        titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleButton.titleLabel?.adjustsFontSizeToFitWidth = true
        titleButton.titleLabel?.minimumScaleFactor = 0.5 // Font for Small devices
        self.navigationItem.titleView = titleButton
        
        
        
        if showBack {
            self.setBackButton()
        } else {
            self.navigationItem.hidesBackButton = true
        }
        
    }
    
    //MARK:- Back Button
    func setBackButton(){
        let backButton = UIButton()
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let origImage = UIImage(named: "back arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(tintedImage, for: .normal)
        backButton.tintColor = .black
        
        backButton.addTarget(self, action: #selector(self.backButtonAction), for: UIControl.Event.touchUpInside)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem()
        
        leftBarButton.customView = backButton
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func backButtonAction() {
        self.view.endEditing(true)
        let backDone = self.navigationController?.popViewController(animated: true)
        if backDone == nil {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - Custom Alert Methods
extension BaseVC {
    
    func showalertControl(title:String?,message:String?,okAction: alertAction = nil){
        let alertController = UIAlertController(title: title, message:message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: kOkay, style: .default, handler: okAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
