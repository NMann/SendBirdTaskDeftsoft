//
//  ChannelsViewController.swift
//  DemoSendBirdChatApp
//
//  Created by IOS22 on 17/02/22.


import UIKit
import SendBirdSDK

class ChannelsViewController: BaseVC {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    private var channels = [kChannelID]
    
    // MARK: - Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        set(title: kChannels)
        tableView.tableFooterView = UIView()
        
    }
    
    
    
}

//MARK: - Extensions UITableViewDelegate,UITableViewDataSource
extension ChannelsViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kChannelsTVCell, for: indexPath) as! ChannelsTVCell
        cell.selectionStyle = .none
        cell.lbl.text = "Test"
        cell.contentView.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint(channels[indexPath.row])
        getChannelWithUrl(index:indexPath.row)
    }
    
    
    
    func getChannelWithUrl(index:Int){
        SBDOpenChannel.getWithUrl(channels[index]) { openChannel, error in
            guard let openChannel = openChannel else{
                //                print("ERROR",error)
                return
            }
            
            openChannel.enter(completionHandler: { error in
                guard let error = error else{
                    let vc = UIStoryboard(name: kMain, bundle: .main).instantiateViewController(withIdentifier: kChatViewController) as! ChatViewController
                    vc.openChannel = openChannel
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                }
                
                print("ERROR",error)
                
            })
            
            
            
        }
    }
}
