//
//  AudioCell.swift
//  DemoSendBirdChatApp
//
//  Created by IOS22 on 19/02/22.
//

import UIKit

class AudioCell: UITableViewCell {
    
    @IBOutlet weak var bgVIew: UIView!
    @IBOutlet weak var pausePlayBtn: UIButton!
    @IBOutlet weak var lblAudioName: UILabel!
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
