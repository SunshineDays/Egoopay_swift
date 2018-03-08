//
//  WPAgencyProductController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/3.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPAgencyProductController: WPBaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "成为合伙人"
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "userHelp"), style: .plain, target: self, action: #selector(self.rightAction))
        self.view.addSubview(theme_view)
        getAgencyProductData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  用户缴纳的保证金 */
    var depositAmount = Float()
    
    var poundage_model = WPPoundageModel()
    
    var infor_model = WPUserInforModel()
    
    /**  加盟等级数组 */
    var data_array = NSMutableArray()
    
    var width = (kScreenWidth - 2 * WPLeftMargin - 20) / 2
    
    lazy var theme_view: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: WPTopY, width: kScreenWidth, height: 100))
        view.backgroundColor = UIColor.themeColor()
        return view
    }()
    
    
    lazy var header_view: WPProductHeaderView = {
        let view = WPProductHeaderView.init(frame: CGRect.init(x: 0, y: WPTopY, width: kScreenWidth - WPLeftMargin * 2, height: 170))
        view.initData(inforModel: self.infor_model, poundageModel: self.poundage_model)
        return view
    }()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.width, height: self.width)
        flowLayout.minimumLineSpacing = 20
        flowLayout.scrollDirection = .vertical
        flowLayout.headerReferenceSize = CGSize.init(width: kScreenWidth - 2 * WPLeftMargin, height: 170)
        return flowLayout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect(x: WPLeftMargin, y: WPTopY, width: kScreenWidth - 2 * WPLeftMargin, height: kScreenHeight - WPNavigationHeight), collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = UIColor.backgroundColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.cornerRadius = WPCornerRadius
        collectionView.register(UINib.init(nibName: "WPAgencyProductCell", bundle: nil), forCellWithReuseIdentifier: WPAgencyProductCellID)
        collectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        self.view.addSubview(collectionView)
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WPAgencyProductCell = collectionView.dequeueReusableCell(withReuseIdentifier: WPAgencyProductCellID, for: indexPath) as! WPAgencyProductCell
        let model: WPAgencyProductAgUpListModel = data_array[indexPath.row] as! WPAgencyProductAgUpListModel
        cell.model = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
            headerView.addSubview(header_view)
            return headerView
        }
        else {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath)
            
            return footerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let vc = WPAgencyDetailController()

        var inforAgencyModel = WPAgencyProductAgUpListModel()
        
        if infor_model.agentGradeId > 0 {
            inforAgencyModel = data_array[infor_model.agentGradeId - 1] as! WPAgencyProductAgUpListModel
        }

        let agencyModel: WPAgencyProductAgUpListModel = data_array[indexPath.row] as! WPAgencyProductAgUpListModel
        
        vc.initInfor(depositAmount: depositAmount, inforAgencyModel: inforAgencyModel, agencyModel: agencyModel)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - Action
    @objc func rightAction() {
        WPInterfaceTool.showWebViewController(url: WPAgencytWebURL, title: "加盟介绍")
    }
    
    
    // MARK: - Request
    
    /**  获取代理产品信息 */
    @objc func getAgencyProductData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPShowAgUpgradeURL, parameters: nil, superview: self.view, view: self.noResultView, success: { (result) in
            
            let resultModel: WPAgencyProductResultModel = WPAgencyProductResultModel.mj_object(withKeyValues: result)
            
            weakSelf?.depositAmount = resultModel.depositAmount
            
            weakSelf?.data_array.addObjects(from: WPAgencyProductAgUpListModel.mj_objectArray(withKeyValuesArray: resultModel.agUpList) as! [Any])            
            
            weakSelf?.getPoundageData()
        }, networkError: { (button) in
            button.addTarget(self, action: #selector(self.getAgencyProductData), for: .touchUpInside)
        }) { (error) in
            
        }

    }
    
    /**  获取费率 */
    func getPoundageData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPPoundageURL, parameters: ["rateType" : "2"], success: { (result) in
            weakSelf?.poundage_model = WPPoundageModel.mj_object(withKeyValues: result)
            weakSelf?.getUserInforData()
        }) { (error) in
            
        }
    }
    
    func getUserInforData() {
        weak var weakSelf = self
        WPUserInforModel.loadData(success: { (model) in
            weakSelf?.infor_model = model
            weakSelf?.collectionView.reloadData()
        }) { (error) in
            
        }
    }

}
