//
//  WPBankCardDetailController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/10.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPBankCardDetailController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的银行卡"
//        self.view.backgroundColor = UIColor.colorConvert(colorString: "36353A")
        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_setting"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.setAction))
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageFromColor(color: UIColor.colorConvert(colorString: "36353A")), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageFromColor(color: UIColor.themeColor()), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        
    }
    
    /** 功能数组 */
    let data_array = ["去消费","去提现"]
    
    /**  图片数组 */
    let image_array = [#imageLiteral(resourceName: "icon_bankCard"), #imageLiteral(resourceName: "icon_d")]
    
    var card_model = WPBankCardModel()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView (frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = self.more_collectionView
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.register(UINib.init(nibName: "WPBankCardDetailHeaderCell", bundle: nil), forCellReuseIdentifier: WPBankCardDetailHeaderCellID)
        self.view.addSubview(tableView)
        let view = WPThemeColorView()
        view.backgroundColor = UIColor.colorConvert(colorString: "36353A")
        tableView.addSubview(view)
        return tableView
    }()
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPBankCardDetailHeaderCell = tableView.dequeueReusableCell(withIdentifier: WPBankCardDetailHeaderCellID, for: indexPath) as! WPBankCardDetailHeaderCell
        cell.model = self.card_model
        cell.set_button.addTarget(self, action: #selector(self.setGatheringCard), for: .touchUpInside)
        return cell
    }
    
    lazy var more_collectionView: WPClassCollectionView = {
        let collectionView = WPClassCollectionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 130))
        collectionView.initData(iconCount: 4, titleArray: self.data_array as NSArray, imageArray: self.image_array as NSArray)
        collectionView.collectionView.delegate = self
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(WPCreditSelectChannelController(), animated: true)
        case 1:
            self.navigationController?.pushViewController(WPBalanceController(), animated: true)
        default:
            break
        }
    }
    
    // MARK: - Action
    
    /**  设置为收款银行卡 */
    @objc func setGatheringCard() {
        weak var weakSelf = self
        WPInterfaceTool.alertController(title: "设置为二维码收款银行卡,预计1-3个工作日内审核完成", confirmTitle: "确定", confirm: { (alertAction) in
            weakSelf?.postSetDespoitData()
        }) { (alertAction) in
            
        }
    }
    
    @objc func setAction() {
        weak var weakSelf = self
        WPInterfaceTool.alertController(title: nil, rowOneTitle: "解除绑定", rowTwoTitle: "", rowOne: { (alertAction) in
            WPPayTool.pay(password: { (password) in
                weakSelf?.postDeleteCardData(password: password)
            })
        }) { (alertAction) in
            
        }
    }

    // MARK: - Request
    
    /**  设置为收款银行卡 */
    func postSetDespoitData() {
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPCodeWithBankCardURL, parameters: ["bankId" : card_model.id], success: { (success) in
            WPProgressHUD.showSuccess(status: "设置成功")
        }) { (error) in
            
        }
    }
    
    /**  解绑银行卡 */
    func postDeleteCardData(password: String) {
        weak var weakSelf = self
        let parameter = ["cardId" : card_model.id, "payPassword" : password] as [String : Any]
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPUserDeleteCardURL, parameters: parameter, success: { (result) in
            WPProgressHUD.showSuccess(status: "解绑银行卡成功")

            weakSelf?.navigationController?.popViewController(animated: true)
        }) { (error) in
            
        }
    }
    
}
