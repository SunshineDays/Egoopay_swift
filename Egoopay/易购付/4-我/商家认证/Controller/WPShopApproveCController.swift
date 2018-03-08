//
//  WPShopApproveCController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/5.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPShopApproveCController: WPBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "商家认证"
        image_array.addObjects(from: [#imageLiteral(resourceName: "icon_touming_touming"), #imageLiteral(resourceName: "icon_touming_touming"), #imageLiteral(resourceName: "icon_touming_touming"), #imageLiteral(resourceName: "icon_touming_touming"), #imageLiteral(resourceName: "icon_touming_touming")])
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = footer_view
        tableView.register(UINib.init(nibName: "WPTitleImageCell", bundle: nil), forCellReuseIdentifier: WPTitleImageCellID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  存储用户输入的信息的字典 */
    var infor_dic = NSMutableDictionary()
    
    /**  记录选中的行 */
    var selectedRow = NSInteger()
    
    let title_array = ["营业执照照片", "店铺封面照片", "店铺内部照片1", "店铺内部照片2", "特殊资质许可证照片(可选)"]

    let image_array =  NSMutableArray()

    lazy var footer_view: WPNextFooterView = {
        let view = WPNextFooterView()
        view.backgroundColor = UIColor.white
        view.title = "提交认证资料"
        view.next_button.addTarget(self, action: #selector(self.postAction), for: .touchUpInside)
        return view
    }()
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return title_array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPTitleImageCell = tableView.dequeueReusableCell(withIdentifier: WPTitleImageCellID, for: indexPath) as! WPTitleImageCell
        cell.title_label.text = title_array[indexPath.row]
        cell.content_imageView.image = image_array[indexPath.row] as? UIImage
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRow = indexPath.row
        self.alertController(showPhoto: true, allowsEditing: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        weak var weakSelf = self
        picker.dismiss(animated: true) {
            let image: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
            let cell: WPTitleImageCell = weakSelf?.tableView.cellForRow(at: IndexPath.init(row: (weakSelf?.selectedRow)!, section: 0)) as! WPTitleImageCell
            cell.content_imageView.image = image
            weakSelf?.image_array.replaceObject(at: (weakSelf?.selectedRow)!, with: image)
        }
    }
    
    
    // MARK: - Action
    
    @objc func postAction() {
        var isNext = false
        for i in 0 ..< image_array.count - 1 {
            if image_array[i] as! UIImage == #imageLiteral(resourceName: "icon_touming_touming") {
                WPProgressHUD.showInfor(status: "请选择" + title_array[i])
                isNext = false
                break
            }
            else {
                isNext = true
            }
        }
        if isNext {
            postShopApproveData()
        }
    }

    
    // MARK: - Request
    
    /**  提交认证信息 */
    func postShopApproveData() {
        let parameter = ["busilicenceImg" : WPPublicTool.imageToString(image: image_array[0] as! UIImage),
                         "shopCoverImg" : WPPublicTool.imageToString(image: image_array[1] as! UIImage),
                         "shopInsideImg_1" : WPPublicTool.imageToString(image: image_array[2] as! UIImage),
                         "shopInsideImg_2" : WPPublicTool.imageToString(image: image_array[3] as! UIImage),
                         "permitsImg" : image_array[4] as! UIImage != #imageLiteral(resourceName: "icon_touming_touming") ? WPPublicTool.imageToString(image: image_array[4] as! UIImage) : ""]
        infor_dic.addEntries(from: parameter)
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPSubmitShopCertURL, parameters: (infor_dic as! [String : Any]), success: { (success) in
            WPProgressHUD.showSuccess(status: "提交认证成功")
            WPInterfaceTool.popToViewController(popCount: 3)
        }) { (error) in
            
        }
    }
    
}
