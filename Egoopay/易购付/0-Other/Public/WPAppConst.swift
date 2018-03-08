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
