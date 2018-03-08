//
//  WPMyMemberDetailChannelCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/12.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPMyMemberDetailChannelCellID = "WPMyMemberDetailChannelCellID"

class WPMyMemberDetailChannelCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var channelName_label: UILabel!
    
    @IBOutlet weak var channelDesc_label: UILabel!
 
    var model: WPMemberChannelModel! = nil {
        didSet {
            channelName_label.text = model.chanleName
            channelDesc_label.text = model.mdesp
        }
    }
    
    var agency_model: WPAgencyProductChanelMessageModel! = nil {
        didSet {
            channelName_label.text = agency_model.chanleName
            channelDesc_label.text = agency_model.descMessage
        }
    }
    
}
