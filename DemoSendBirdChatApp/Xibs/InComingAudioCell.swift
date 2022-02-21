//
//  InComingAudioCell.swift
//  DemoSendBirdChatApp
//
//  Created by IOS22 on 19/02/22.
//

import UIKit

class InComingAudioCell: UITableViewCell {

    @IBOutlet weak var lblAUdioName: UILabel!
    @IBOutlet weak var audioBtn: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let transfrom = layer.transform
        layer.transform = CATransform3DRotate(transfrom, .pi, 1, 0, 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
