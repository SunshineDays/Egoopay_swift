//
//  WPEShopSearchController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/5.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

typealias WPEShopSearchType = (_ search: String) -> Void

class WPEShopSearchController: WPBaseViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UICollectionViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(searchBar)
        self.view.addSubview(cancel_button)
        self.view.addSubview(line_view)
        reloadTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTableView() {
        searchHistory_array.removeAllObjects()
        searchHistory_array.addObjects(from: WPUserDefaults.userDefaultsRead(key: WPUserDefaults_searchHistory))
        tableView.reloadData()
    }
    
    var eShopSearchType: WPEShopSearchType?
    
    var isPush = true
    
    let searchHistory_array = NSMutableArray()

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar.init(frame: CGRect.init(x: 15, y: WPStatusBarHeight + 5, width: kScreenWidth - 65, height: 34))
        searchBar.backgroundColor = UIColor.lineColor()
        searchBar.placeholder = "搜索商品"
        searchBar.subviews[0].subviews[0].removeFromSuperview()
        searchBar.layer.cornerRadius = 12
        searchBar.subviews[0].subviews[0].backgroundColor = UIColor.clear
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var cancel_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: kScreenWidth - 50, y: self.searchBar.frame.minY, width: 50, height: 34))
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(self.cancelAction), for: .touchUpInside)
        return button
    }()
    
    lazy var line_view: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: WPNavigationHeight - 0.5, width: kScreenWidth, height: 0.5))
        view.backgroundColor = UIColor.lineColor()
        return view
    }()
    
    
    lazy var header_view: WPEShopSearchHotView = {
        let view = WPEShopSearchHotView.init(frame: CGRect.init(x: 0, y: WPNavigationHeight, width: kScreenWidth, height: 150))
        view.collectionView.delegate = self
        view.clear_buton.addTarget(self, action: #selector(self.clearAllAction), for: .touchUpInside)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: WPNavigationHeight, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight))
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableHeaderView = self.header_view
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.register(UINib.init(nibName: "WPEShopSearchHistoryCell", bundle: nil), forCellReuseIdentifier: WPEShopSearchHistoryCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPEShopSearchHistoryCell = tableView.dequeueReusableCell(withIdentifier: WPEShopSearchHistoryCellID, for: indexPath) as! WPEShopSearchHistoryCell
        let count = searchHistory_array.count
        cell.title_label.text = searchHistory_array[count - indexPath.row - 1] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        searchHistory_array.removeObject(at: searchHistory_array.count - indexPath.row - 1)
        tableView.deleteRows(at: [IndexPath.init(row: indexPath.row, section: 0)], with: .automatic)
        WPUserDefaults.userDefaultsSave(key: WPUserDefaults_searchHistory, value: searchHistory_array as! Array<Any>)
        UserDefaults.standard.synchronize()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        goToSearchVC(search: (searchHistory_array[searchHistory_array.count - indexPath.row - 1] as? String)!)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToSearchVC(search: header_view.hotSearch_array[indexPath.row])
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            goToSearchVC(search: searchBar.text!)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    // MARK: - Action
    
    @objc func cancelAction() {
        UIApplication.shared.keyWindow?.endEditing(true)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @objc func goToSearchVC(search: String) {
        eShopSearchType?(search)
        if isPush {
            WPInterfaceTool.rootViewController().pushViewController(WPEShopSearchResultController(), animated: true)
        }
        self.dismiss(animated: false, completion: nil)
        
        var removeIndex = -1
        
        for i in 0 ..< searchHistory_array.count {
            if searchHistory_array[i] as! String == search {
                removeIndex = i
                break
            }
        }
        if removeIndex >= 0 {
            searchHistory_array.removeObject(at: removeIndex)
        }
        
        searchHistory_array.add(search)
        if searchHistory_array.count > 20 {
            searchHistory_array.removeObject(at: 0)
        }
        WPUserDefaults.userDefaultsSave(key: WPUserDefaults_searchHistory, value: searchHistory_array as! Array<Any>)
        UserDefaults.standard.synchronize()
    }

    @objc func clearAllAction() {
        WPUserDefaults.userDefaultsSave(key: WPUserDefaults_searchHistory, value: [])
        reloadTableView()
    }
    
    
    // MARK: - Reauest
    

    
}
