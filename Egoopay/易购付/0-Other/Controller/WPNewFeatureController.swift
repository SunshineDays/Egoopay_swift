//
//  WPNewFeatureController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/12.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPNewFeatureCellID = "WPNewFeatureCellID"

class WPNewFeatureController: WPBaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
            if UIApplication.shared.statusBarFrame.size.height == 44 {
                image_array = [#imageLiteral(resourceName: "iphoneX_login_A"), #imageLiteral(resourceName: "iphoneX_login_B"), #imageLiteral(resourceName: "iphoneX_login_C"), #imageLiteral(resourceName: "iphoneX_login_D")]
            }
            else {
                image_array = [#imageLiteral(resourceName: "iphone_login_A"), #imageLiteral(resourceName: "iphone_login_B"), #imageLiteral(resourceName: "iphone_login_C"), #imageLiteral(resourceName: "iphone_login_D")]
            }
        }
        else {
            image_array = [#imageLiteral(resourceName: "iphone_login_A"), #imageLiteral(resourceName: "iphone_login_B"), #imageLiteral(resourceName: "iphone_login_C"), #imageLiteral(resourceName: "iphone_login_D")]
        }
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var image_array = NSArray()

    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: kScreenWidth, height: kScreenHeight)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        return flowLayout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true

        collectionView.register(UINib.init(nibName: "WPNewFeatureCell", bundle: nil), forCellWithReuseIdentifier: WPNewFeatureCellID)
        self.view.addSubview(collectionView)
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return image_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WPNewFeatureCell = collectionView.dequeueReusableCell(withReuseIdentifier: WPNewFeatureCellID, for: indexPath) as! WPNewFeatureCell
        cell.imageView.image = image_array[indexPath.row] as? UIImage
        cell.register_button.isHidden = indexPath.row != image_array.count - 1
        cell.register_button.addTarget(self, action: #selector(registerAction), for: UIControlEvents.touchUpInside)
        return cell
    }

    
    @objc func registerAction() {
        UIApplication.shared.keyWindow?.rootViewController = WPNavigationController(rootViewController: WPRegisterViewController())
        
    }
    
}
