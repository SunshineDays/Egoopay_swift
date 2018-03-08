//
//  WPEShopInputPayOrederCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/13.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopInputPayOrederCellID = "WPEShopInputPayOrederCellID"

class WPEShopInputPayOrederCell: UITableViewCell, UICollectionViewDataSource {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var select_button: UIButton!
    
    @IBOutlet weak var name_label: UILabel!
    
    @IBOutlet weak var tel_label: UILabel!
    
    @IBOutlet weak var address_label: UILabel!
    
    @IBOutlet weak var shop_view: UIView!
    
    @IBOutlet weak var number_label: UILabel!
    
    @IBOutlet weak var delivery_label: UILabel!
    
    @IBOutlet weak var message_textField: UITextField!
    
    @IBOutlet weak var shopMoney_label: UILabel!
    
    @IBOutlet weak var deliveryMoney_label: UILabel!
    
    @IBOutlet weak var discounts_label: UILabel!
    
    
    var addressModel: WPEShopMyAddressModel! = nil {
        didSet {
            if addressModel.firstname.count > 0 {
                name_label.isHidden = false
                tel_label.isHidden = false
                address_label.isHidden = false
                name_label.text = addressModel.firstname
                tel_label.text = addressModel.telephone
                address_label.text = addressModel.country + " " + addressModel.zone_name + " " + addressModel.city + " " + addressModel.address_1
                select_button.setTitle("", for: .normal)
            }
            else {
                name_label.isHidden = true
                tel_label.isHidden = true
                address_label.isHidden = true
                select_button.setTitle("    请选择收货地址", for: .normal)
            }
        }
    }
    
    var totalMoney: Double! = nil {
        didSet {
            shopMoney_label.text = String(format: "￥%.2f", totalMoney)
        }
    }
    
    var shopArray: NSMutableArray! = nil {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var number: NSInteger! = nil {
        didSet {
            number_label.text = String(format: "共%d件", number)
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth - 85, height: self.shop_view.frame.size.height), collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib.init(nibName: "WPEShopMyOrderCollectionCell", bundle: nil), forCellWithReuseIdentifier: WPEShopMyOrderCollectionCellID)
        self.shop_view.addSubview(collectionView)
        return collectionView
    }()
    
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize.init(width: self.shop_view.frame.size.height - 20, height: self.shop_view.frame.size.height - 20)
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    // MARK: - UICollectionViewDataSoure
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WPEShopMyOrderCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: WPEShopMyOrderCollectionCellID, for: indexPath) as! WPEShopMyOrderCollectionCell
        let model: WPEShopProductModel = shopArray[indexPath.row] as! WPEShopProductModel
        cell.model = model
        return cell
    }
    
    
}
