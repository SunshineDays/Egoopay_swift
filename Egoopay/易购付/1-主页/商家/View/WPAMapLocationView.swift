//
//  WPAMapLocationView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/8.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

typealias WPGoToOtherAppType = () -> Void

class WPAMapLocationView: UIView, UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var goToOtherAppType: WPGoToOtherAppType?
    
    /**  驾车距离 */
    var taxiDistance = Float()
    
    /**  公交车距离 */
    var busDistance = Float()
    
    /**  步行距离 */
    var walkDistance = Float()
    
    /**  地址 */
    var address: String! = nil {
        didSet {
            tableView.reloadData()
        }
    }
        
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 192), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.showsHorizontalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.register(UINib.init(nibName: "WPAMapLocationCell", bundle: nil), forCellReuseIdentifier: WPAMapLocationCellID)
        self.addSubview(tableView)
        return tableView
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPAMapLocationCell = tableView.dequeueReusableCell(withIdentifier: WPAMapLocationCellID, for: indexPath) as! WPAMapLocationCell
        
        cell.taxi_button.tag = 1
        cell.taxi_button.addTarget(self, action: #selector(self.selectButtonAction(_:)), for: .touchUpInside)
        cell.bus_button.tag = 2
        cell.bus_button.addTarget(self, action: #selector(self.selectButtonAction(_:)), for: .touchUpInside)
        cell.walk_button.tag = 3
        cell.walk_button.addTarget(self, action: #selector(self.selectButtonAction(_:)), for: .touchUpInside)
        cell.go_button.addTarget(self, action: #selector(self.goToOtherAppAction), for: .touchUpInside)
        
        let distance = taxiDistance > 1000 ? String(format: "%.1fkm", taxiDistance / 1000) : String(format: "%ldm", NSInteger(taxiDistance))
        cell.distance_label.text = distance
        
        cell.address_label.text = address
        
        return cell
    }
    
    
    // MARK: - Action
    
    @objc func selectButtonAction(_ button: UIButton) {
        let cell: WPAMapLocationCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPAMapLocationCell

        cell.taxi_button.setImage(button.tag == 1 ? #imageLiteral(resourceName: "icon_car_selected") : #imageLiteral(resourceName: "icon_car_default"), for: .normal)
        cell.bus_button.setImage(button.tag == 2 ? #imageLiteral(resourceName: "icon_bus_selected") : #imageLiteral(resourceName: "icon_bus_default"), for: .normal)
        cell.walk_button.setImage(button.tag == 3 ? #imageLiteral(resourceName: "icon_walk_selected") : #imageLiteral(resourceName: "icon_walk_default"), for: .normal)
        
        cell.taxi_label.textColor = button.tag == 1 ? UIColor.themeColor() : UIColor.darkGray
        cell.bus_label.textColor = button.tag == 2 ? UIColor.themeColor() : UIColor.darkGray
        cell.walk_label.textColor = button.tag == 3 ? UIColor.themeColor() : UIColor.darkGray
        
        switch button.tag {
        case 1: //驾车
            cell.distance_label.text = taxiDistance > 1000 ? String(format: "%.1fkm", taxiDistance / 1000) : String(format: "%ldm", NSInteger(taxiDistance))
        case 2: //公交
            if busDistance > 0 {
                cell.distance_label.text = busDistance > 1000 ? String(format: "%.1fkm", busDistance / 1000) : String(format: "%ldm", NSInteger(busDistance))
            }
        case 3: //步行
            if walkDistance > 0 {
                cell.distance_label.text = walkDistance > 1000 ? String(format: "%.1fkm", walkDistance / 1000) : String(format: "%ldm", NSInteger(walkDistance))
            }
        default:
            break
        }
    }
    
    /**  跳转到地图app */
    @objc func goToOtherAppAction() {
        goToOtherAppType!()
    }
    
    
}
