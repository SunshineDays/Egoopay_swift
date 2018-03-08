//
//  WPAppConst.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

/********************************  UI相关常量  ************************************/

// MARK: - UI相关常量

var kScreenWidth: CGFloat = UIScreen.main.bounds.size.width

var kScreenHeight: CGFloat = UIScreen.main.bounds.size.height

/**  状态栏高度 */
let WPStatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height

var WPNavigationHeight: CGFloat = WPStatusBarHeight + 44

let WPTabBarHeight: CGFloat = WPStatusBarHeight == 44 ? 83 : 49

let WPTopY: CGFloat = 0

let WPTopMargin: CGFloat = 10

let WPLeftMargin: CGFloat = 15

let WPRowHeight: CGFloat = 50

let WPCornerRadius: CGFloat = 3

let WPLineHeight: CGFloat = 0.5

var WPButtonWidth: CGFloat = kScreenWidth - 2 * WPLeftMargin

let WPButtonHeight: CGFloat = 45

let WPFontDefaultSize: CGFloat = 16

/**  cell之间的间隙 */
let WPCellMargin: CGFloat = 15

/**  弹窗高度 */
let WPpopupViewHeight: CGFloat = kScreenHeight * 51 / 72


/********************************  第三方AppKey ************************************/

// MARK: - 第三方AppKey

// QQ
let kQQ_appID = "1106169312"
let kQQ_appKey = "Dv5lJFRDlu8vSOjz"

// 微信
let kWeChat_appID = "wxa2e49f2b1fd0f1a0"
let kWeChat_appSecret = "c55dd72333184f3cc27c3c0674c1e932"

// 极光推送
let kJPush_appKey = "55f5117c0a951e9a96623403"
let kJPush_masterSecret = "77ba49ce163388addcd23c8a"

//高德地图
let kAMap_apiKey = "45e9b08426aa3a37d1a7dcdb4354a9b7"

//阿里物流
let kAliLogistics_appKey = "23818602"
let kAliLogistics_appSecret = "b0031af10184c1c6d6f37048f28fd8df"
let kAliLogistics_appCode = "26552ceb97bc4022a2cb0e56a0d36563"

/********************************  App常量 ************************************/

// MARK: - App常量

let WPAuthCodeTime: NSInteger = 120

let WPAppTelNumber: String = "400-8536696"

let WPAppQQNumber: String = "2536189787"

let WPAppName = "易购付"

/**  记录最近一次需要返回的界面 */
var WPPopToViewControllerName = UIViewController()

/**  记录最近一次用户输入的验证码 */
var WPUserInputAuthCode = String()

/********************************  静态参数 ************************************/

// MARK: - 静态参数

let WPKeyChain_payPassword: String = "WPKeyChain_payPassword"


/********************************  通知 ************************************/

// MARK: - 通知

let WPNotificationRemovePayInforView = Notification.Name(rawValue: "WPNotificationRemovePayInforView")

/**  选择地址成功 */
let WPNotificationSelectedAddress = Notification.Name(rawValue: "WPNotificationSelectedAddress")

/**  点击了TbaBarItem（消息） */
let WPNotificationSelectedMessageItem = Notification.Name(rawValue: "WPNotificationSelectedMessageItem")

/**  提交了订单 */
let WPNotificationEShopPostOrderSuccess = Notification.Name(rawValue: "WPNotificationEShopPostOrderSuccess")

/**  跳转到订单列表界面（支付） */
let WPNotificationEShopOrderPayUnFinishedPushToOrderList = Notification.Name(rawValue: "WPNotificationEShopOrderPayUnFinishedPushToOrderList")

/********************************  URL ************************************/

// MARK: - URL

let WPBaseURL: String = "http://www.egoopay.com/"

let WPBaseEShopURL: String = "http://shop.egoopay.com/index.php?route="

//let WPBaseURL: String = "http://192.168.1.23:8080"

/***  H5 ***/

// 用户协议
let WPUserProtocolWebURL: String = "http://www.egoopay.com/html/agreement.html"

// 关于我们
let WPAboutOurWebURL: String = "http://www.egoopay.com/html/about/about.html"

// 用户帮助
let WPUserHelpWebURL: String = "http://www.egoopay.com/html/help.html"

// 代理协议
let WPAgencytWebURL: String = "http://www.egoopay.com/html/agent.html"

// 指纹登录／支付协议
let WPTouchIDWebURL: String = "http://www.egoopay.com/html/touchid.html"

/**  信用卡取现流程 */
let WPMp4CreditFlowWebURL: String = "http://www.egoopay.com/movie/test2.mp4"

/**  银行卡支付 */
let WPPayWithBankCardURL: String = "http://www.egoopay.com/bankCardPay/submitPay.jsp"

/**  信用卡申请 */
let WPCreditApplyURL: String = "http://real.izhongyin.com/wxportal/creditCard/bankCards.do?org_id=014100000000"

/**  小额贷款 */
let WPLoansURL: String = "http://real.izhongyin.com/wxportal/loans/loansList?org_id=014100000000"

/*****************/

// 登录
let WPRegisterURL: String = "client_login"

/**  注册并登录 */
let WPEnrollURL: String = "client_register"

// 注册
let WPConfirmEnrollURL: String = "client_regedit"

// 用户退出登录
let WPUserLogoutURL: String = "client_logout"

//  获取验证码
let WPAuthCodeURL: String = "client_ver"

// 充值费率
let WPPoundageURL: String = "client_getTransRate"

// 充值
let WPRechargeURL: String = "client_rechargeAction"

/**  app充值 */
let WPAppRechargeURL = "client_recharge"

/**  信用卡取现A */
let WPCreditRechargeURL = "client_reditCardConsume"

/**  信用卡通道B（填写信息） */
let WPCreditRechargeBURL = "client_cardConsume"

/**  信用卡通道B（进行交易） */
let WPCreditRechargeBInforURL = "client_cardConsumeByMSG"

/**  获取信用卡消费通道 */
let WPCreditChannelURL = "client_getCreditPassway"

// 国际信用卡充值
let WPCreditChargeURL: String = "client_creditPay"

/**  生成带金额的二维码 */
let WPCodeWithMoneyURL = "client_createPayQrAmount"

/**  设置收款码收款银行 */
let WPCodeWithBankCardURL = "client_choseReceiveBank"

/**   判断手机号是否存在易购付中 */
let WPJudgePhoneURL = "client_isExistByPhone"

/**   根据手机号获取用户信息 */
let WPUserInforWithPhoneURL = "client_getMessageByPhone"

/**  根据手机号获取头像 */
let WPUserAvaterWithPhoneURL = "client_getHeadUrl"

// 转账
let WPTransferAccountsURL: String = "client_p2p_transfer"

// 提现
let WPWithdrawURL: String = "client_extractCashApplyAction"

// 分润余额提现
let WPProfitWithdrawURL: String = "client_agExtraCash"

/**  验证身份证号码 */
let wpUserApproveInforJudgeURL: String = "client_states"

/**  提交身份证信息 */
let WPUserApproveInforURL: String = "client_authenticate"

// 获取身份证审核信息
let WPUserApproveIDCardPassURL: String = "client_authenticate_detailAction"

// 提交银行卡照片认证
let WPUserApproveBankCardPhotoURL: String = "client_cardPicAction"

/**  提交商家认证信息 */
let WPSubmitShopCertURL: String = "client_submitShopCert"

// 获取商家认证状态
let WPQueryShopStatusURL: String = "client_queryShopStatus"

// 用户银行卡信息
let WPUserBanKCardURL: String = "client_merBankCard"

/**  验证银行卡信息 */
let WPValiteBankCardInforURL: String = "client_checkCard"

/**  验证身份证信息 */
let WPValiteIDCardInforURL: String = "client_checkIdentity"

// 添加银行卡
let WPUserAddCardURL: String = "client_bandBankCardAction"

// 删除银行卡
let WPUserDeleteCardURL: String = "client_delCard"

// 修改密码
let WPChangePasswordURL: String = "client_changePassword"

// 设置支付密码
let WPSetPayPasswordURL: String = "client_setuppayPasswordAction"

// 判断支付密码是否正确
let WPCheckPayPasswordURL: String = "client_checkPayPwd"

// 判断用户是否设置支付密码／通过实名认证
let WPUserJudgeInforURL: String = "client_issetpwdAction"

// 获取用户信息
let WPUserInforURL: String = "client_detailedInfo"

/**  修改用户头像 */
let WPUserChangeAvatarURL: String = "client_uploadHead"

/**  修改用户昵称 */
let WPUserNicknameURL: String = "client_modifyNickName"

/**  修改性别 */
let WPUserChangeSxeURL: String = "client_changeSex"

/**  修改地址 */
let WPUserChangeAddressURL: String = "client_changeAdress"

/**  修改邮箱 */
let WPUserChangeEmailURL: String = "client_changeEmail"

// 修改用户信息
let WPUserChangeInforURL: String = "client_saveDetailInfo"

// 账单
let WPBillURL: String = "client_queryTradeDetailNew"

// 账单消息
let WPBillNotificationURL: String = "client_successBill"

// 收款纪录
let WPGatheringRecordURL: String = "client_qrCheckBill"

// 代理信息
let WPAgencyURL: String = "client_agent_home"

// 分润提现记录
let wpProfitWithDrawURL: String = "client_getWithdrawal"

// 分润明细
let WPProfitDetailURL: String = "client_beneDetails"

// 今日分润记录
let WPProfitDetailTodayURL: String = "client_beneDetailsToday"

// 每个邀请的人分润明细
let WPProfitDetailRefersURL: String = "client_beneDetailsMerchant"

// 获取代理产品
let WPShowAgUpgradeURL: String = "client_showAgUpgradeNew"

// 获取会员产品
let WPShowMerUpgradeURL: String = "client_showMerUpgradeNew"

// 会员升级
let WPMerchantGradeURL: String = "client_upUserlvAction"

// 代理升级
let WPAgencyGradeURL: String = "client_upagentLvAction"

// 收款码
let WPGatheringCodeURL: String = "client_createPayQr"

// 消息信息
let WPMessageURL: String = "client_pullSysMsg"

// 今日收款
let WPTodayGatheringRecordURL: String = "client_todayQrIncome"

// 邀请的人
let WPMyRefersURL: String = "client_myRecommend"

// 支持银行列表
let WPSupportBankListURL: String = "client_getBanks"

// 城市列表
let WPCityListURL: String = "client_getCities"

// 类别列表
let WPGetCategoryURL: String = "client_getCategory"

// 轮播图
let WPCycleScrollURL: String = "client_getBanner"

// 商家搜索
let WPShowMerShopsURL: String = "client_showMerShops"

// 商家详情
let WPMerShopDetailURL: String = "client_shopInfos"

// 用户反馈
let WPUserFeedBackURL: String = "client_feedback"

// 用户举报
let WPUserToReportURL: String = "client_usreport"

// 分享内容链接
let WPShareToAppURL: String = "client_share"

// 子账户信息
let WPSubAccountInforURL: String = "client_getClerkInfo"

/**  子账户列表 */
let WPSubAccountListURL: String = "client_clerkList"

/**  添加子账户 */
let WPSubAccountAddURL: String = "client_createClerk"

/** 设置子账户权限 */
let WPSubAccountSettingURL: String = "client_assignPerms"

/** 获取子账户权限信息 */
let WPSubAccountJurisdictionURL: String = "client_getClerkPerm"

// 删除子账户
let WPSubAccountDeleteURL: String = "client_deleteClerk"

// 修改子账户头像
let WPSubAccountAvatarURL: String = "client_uploadClerkImg"

// 修改子账户密码
let WPSubAccountChangePasswordURL: String = "client_retClerkPwd"

/**  通过手机号获取归属地和产品信息 */
let WPPhoneGetInforURL = "client_getChargeTrafficDetail"

/**  手机流量充值 */
let WPPhoneTrafficChargeURL = "client_TrafficCharge"

/**  手机话费充值 */
let WPPhoneChargeURL = "client_Mobilerecharge"

/**  生成订单 */
let WPMakeOrderURL = "client_makeOrder"

/**  支付订单 */
let WPPayOrderURL = "client_shoppingByOrder"

/**  判断验证码是否正确 */
let WPChcekPhoneCodeURL = "client_checkPhoneCode"

/**  根据订单编号获取详情 */
let WPBillDetailURL = "client_getOrderMessage"



/*********  商城  *****/

/**  注册商城 */
let WPEShopRegisterURL = "appapi/customer/addCustomer"

/**  全部商品 */
let WPEShopAllURL = "appapi/product/getProducts"

/**  热销商品 */
let WPEShopHotURL = "appapi/product/getBestSellerProducts"

/**  获取最新商品 */
let WPEShopNewURL = "appapi/product/getLatestProducts"

/**  受欢迎商品 */
let WPEShopPopularURL = "appapi/product/getPopularProducts"

/**  商品搜索 */
let WPEShopSearchURL = "appapi/product/search"

/**  获取单个商品 */
let WPEShopCertainURL = "appapi/product/getProduct"

/**  获取单个商品属性 */
let WPEShopCertainSpecificationURL = "appapi/product/getProductOptions"

/**  添加浏览次数 */
let WPEShopLookURL = "appapi/product/updateViewed"

/**  分类列表 */
let WPEShopCategoryURL = "appapi/category/getCategories"

/**  获取banner图 */
let WPEShopBannerURL = "appapi/banner/getBanner"

/**  获取购物车 */
let WPEShopCartListURL = "appapi/cart/getProducts"

/**   添加到添加到购物车 */
let WPEShopCartAddURL = "appapi/cart/add"

/**  修改购物车单个商品数量 */
let WPEShopCartUpdateURL = "appapi/cart/update"

/**  删除购物车中选中的商品 */
let WPEShopCartRemoveURL = "appapi/cart/remove"

/**  获取收藏列表 */
let WPEShopLoveListURL = "appapi/account/getWishlist"

/**  添加到收藏 */
let WPEShopLoveAddURL = "appapi/account/addWishlist"

/**  删除收藏 */
let WPEShopLoveDeleteURL = "appapi/account/deleteWishlist"

/**  获取该商品的收藏状态 */
let WPEShopLoveJudgeURL = "appapi/account/judgeWishlist"

/**  添加收货地址 */
let WPEShopAddressAddURL = "appapi/user/addAddress"

/**  获取收货地址 */
let WPEShopAddressListURL = "appapi/user/getAddress"

/**  删除收货地址 */
let WPEShopAddressDeleteURL = "appapi/user/deleteAddress"

/**  修改收货地址 */
let WPEShopAddressEditURL = "appapi/user/editAddress"

/**  设置为默认收货地址 */
let WPEShopAddressDefaultURL = "appapi/user/editDefault"

/**  生成订单 */
let WPEShopOrderCreateURL = "appapi/order/addOrder"

/**  订单列表 */
let WPEShopOrderListURL = "appapi/order/getOrderList"

/**  获取订单详情 */
let WPEshopOrderDetailURL = "appapi/order/getOrderInfo"

/**  修改订单状态 */
let WPEShopOrderChangeStatusURL = "appapi/order/updateOrderStatus"

/**  删除订单 */
let WPEShopOrderDeleteURL = "appapi/order/deleteOrder"

/**  提交评价 */
let WPEShopEvalutateAddURL = "appapi/review/addReview"

/**  获取商品评价 */
let WPEShopEvalutateListURL = "appapi/review/getReviews"

/** 获取物流信息 */
let WPEShopLogisticsURL = "appapi/order/getShipping"

/**  获取个人中心信息 */
let WPEShopPersonalURL = "appapi/user/getUser"

/**  订单支付 */
let WPEShopPayOrderURL = "client_shopingPay"
