//
//  TextMessageCell.swift
//  ADChat
//
//  Created by Aquib on 14/08/19.
//  Copyright © 2019 Aquib. All rights reserved.
//

import UIKit
import SendBirdSDK

class TextMessageCell: UITableViewCell {
    private var iv = UIImageView()
    private var bubbleIV = UIImageView()
    private var label = UILabel()
    private var timeLabel = UILabel()
    
    private var labelLeadingAnchor:NSLayoutConstraint?
    private var labelTrailingAnchor:NSLayoutConstraint?
    private var ivTrailingAnchor:NSLayoutConstraint?
    private var bubbleTrailingAnchor:NSLayoutConstraint?
    private var bubbleLeadingAnchor:NSLayoutConstraint?
    private var timeLeadingAnchor:NSLayoutConstraint?
    private var timeTrailingAnchor:NSLayoutConstraint?
    private var ivLeadingAnchor:NSLayoutConstraint?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let transfrom = layer.transform
        layer.transform = CATransform3DRotate(transfrom, .pi, 1, 0, 0)
        
        selectionStyle = .none
        
        [iv,bubbleIV,timeLabel,label].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false
            addSubview(v)
        }
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 13)
        label.baselineAdjustment = .alignCenters
        timeLabel.font = UIFont.systemFont(ofSize: 9)
        timeLabel.textColor = .gray
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        iv.image = UIImage(named: "icon")
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        
        iv.heightAnchor.constraint(equalToConstant: 32).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 0).isActive = true
        iv.bottomAnchor.constraint(equalTo: bubbleIV.bottomAnchor,constant: -2).isActive = true
        
        bubbleIV.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: bubbleIV.bottomAnchor, constant: 0).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        
        labelLeadingAnchor = label.leadingAnchor.constraint(equalTo: bubbleIV.leadingAnchor, constant: 0)
        labelLeadingAnchor?.isActive = true
        labelTrailingAnchor = label.trailingAnchor.constraint(equalTo: bubbleIV.trailingAnchor, constant: 0)
        labelTrailingAnchor?.isActive = true
        label.topAnchor.constraint(equalTo: bubbleIV.topAnchor, constant: 6).isActive = true
        label.bottomAnchor.constraint(equalTo: bubbleIV.bottomAnchor, constant: -8).isActive = true
        label.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.6).isActive = true
        
        //INCOMMING
        ivTrailingAnchor = iv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2)
        bubbleTrailingAnchor = bubbleIV.trailingAnchor.constraint(equalTo: iv.leadingAnchor, constant:0)
        timeTrailingAnchor = timeLabel.trailingAnchor.constraint(equalTo: bubbleIV.trailingAnchor,constant: -12)
        
        //OUTGOING
        ivLeadingAnchor = iv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2)
        bubbleLeadingAnchor = bubbleIV.leadingAnchor.constraint(equalTo: iv.trailingAnchor, constant:0)
        timeLeadingAnchor = timeLabel.leadingAnchor.constraint(equalTo: bubbleIV.leadingAnchor,constant: 12)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var message:SBDBaseMessage?{
        didSet{
            //            timeLabel.text = Date().dis
            timeLabel.text = ""
            label.text = message?.message
            setUpDesign(message: message)
            
        }
    }
    
    private func setUpDesign(message:SBDBaseMessage?){
        
        
        
        if message?.sender?.userId == SBDMain.getCurrentUser()!.userId {
            bubbleIV.image = #imageLiteral(resourceName: "BubbleOutgoing").stretchableImage(withLeftCapWidth: 20, topCapHeight: 14)
            ivTrailingAnchor?.isActive = true
            ivLeadingAnchor?.isActive = false
            labelTrailingAnchor?.constant = -16
            labelLeadingAnchor?.constant = 8
            bubbleTrailingAnchor?.isActive = true
            bubbleLeadingAnchor?.isActive = false
            timeTrailingAnchor?.isActive = true
            timeLeadingAnchor?.isActive = false
            
        }else{
            bubbleIV.image = #imageLiteral(resourceName: "BubbleIncoming").stretchableImage(withLeftCapWidth: 20, topCapHeight: 14)
            ivLeadingAnchor?.isActive = true
            ivTrailingAnchor?.isActive = false
            labelTrailingAnchor?.constant = -8
            labelLeadingAnchor?.constant = 16
            bubbleTrailingAnchor?.isActive = false
            bubbleLeadingAnchor?.isActive = true
            timeLeadingAnchor?.isActive = true
            timeTrailingAnchor?.isActive = false
        }
        layoutIfNeeded()
        iv.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
