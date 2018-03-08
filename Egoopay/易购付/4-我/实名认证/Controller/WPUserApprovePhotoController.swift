//
//  WPUserApprovePhotoController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/4.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPUserApprovePhotoController: WPBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "实名认证"
//        self.tableView.backgroundColor = UIColor.white
        self.tableView.register(UINib.init(nibName: "WPUserApprovePhotoCell", bundle: nil), forCellReuseIdentifier: WPUserApprovePhotoCellID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**  上个界面传过来的字典 */
    var infor_dic = NSMutableDictionary()
    
    /**  选择的是哪一个 */
    var selected = 0
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPUserApprovePhotoCell = tableView.dequeueReusableCell(withIdentifier: WPUserApprovePhotoCellID, for: indexPath) as! WPUserApprovePhotoCell
        
        cell.name_label.text = infor_dic["fullName"] as? String
        
        cell.front_button.tag = 1
        cell.front_button.addTarget(self, action: #selector(self.selectPictureAction(_:)), for: .touchUpInside)

        cell.contrary_button.tag = 2
        cell.contrary_button.addTarget(self, action: #selector(self.selectPictureAction(_:)), for: .touchUpInside)
        
        cell.hand_button.tag = 3
        cell.hand_button.addTarget(self, action: #selector(self.selectPictureAction(_:)), for: .touchUpInside)
        
        cell.standard_button.addTarget(self, action: #selector(self.standardAction), for: .touchUpInside)
        
        cell.confirm_button.addTarget(self, action: #selector(self.confirmAction), for: .touchUpInside)
        
        return cell
    }
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        weak var weakSelf = self
        picker.dismiss(animated: true) {
            let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let cell: WPUserApprovePhotoCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPUserApprovePhotoCell
            switch weakSelf?.selected {
            case 1?:
                cell.front_button.setImage(image, for: .normal)
            case 2?:
                cell.contrary_button.setImage(image, for: .normal)
            default:
                cell.hand_button.setImage(image, for: .normal)
            }
        }
    }
    

    // MARK: - Action
    
    @objc func selectPictureAction(_ button: UIButton) {
        selected = button.tag
        self.alertController(showPhoto: false, allowsEditing: false)
    }

    @objc func standardAction() {
        let message = "1、请上传本人清晰、完整的彩色身份证照片，确保证件在有效期内" + "\n" + "2、身份证各项信息及头像清晰可见，易于识别" + "\n" + "3、身份证必须真实拍摄，不得使用复印件和扫描件" + "\n" + "4、手持照需免冠，五官可见，露出完整的手臂和耳朵" + "\n" + "5、建议横屏拍摄，以满足照片上传要求"
        let alertController = UIAlertController.init(title: "上传证件照片要求", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "知道了", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func confirmAction() {
        let cell: WPUserApprovePhotoCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPUserApprovePhotoCell
        if cell.front_button.imageView?.image == #imageLiteral(resourceName: "icon_approveFront") {
            WPProgressHUD.showInfor(status: "请选择身份证正面照")
        }
        else if cell.contrary_button.imageView?.image == #imageLiteral(resourceName: "icon_approveContrary") {
            WPProgressHUD.showInfor(status: "请选择身份证背面照")
        }
        else if cell.hand_button.imageView?.image == #imageLiteral(resourceName: "icon_approveHand") {
            WPProgressHUD.showInfor(status: "请选择手持身份证照")
        }
        else {
            postApproveInfor(fileA: (cell.front_button.imageView?.image!)!, fileB: (cell.contrary_button.imageView?.image!)!, fileC: (cell.hand_button.imageView?.image!)!)
        }
    }
    
    
    // MARK: - Request
    
    /**  提交实名认证信息 */
    @objc func postApproveInfor(fileA: UIImage, fileB: UIImage, fileC: UIImage) {
        let parameter = ["fileA" : WPPublicTool.imageToString(image: fileA),
                         "fileB" : WPPublicTool.imageToString(image: fileB),
                         "fileC" : WPPublicTool.imageToString(image: fileC)]
        infor_dic.addEntries(from: parameter)
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(baseUrl: WPBaseURL, url: WPUserApproveInforURL, parameters: infor_dic as? [String : Any], success: { (success) in
            WPProgressHUD.showSuccess(status: "提交成功，请耐心等待")
            WPInterfaceTool.popToViewController(popCount: 2)
        }) { (error) in
            
        }
    }
    
}
