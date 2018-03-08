//
//  WPPieChartViewController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/13.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit
import Charts


class WPPieChartViewController: WPBaseViewController, ChartViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "月账单"
        self.view.addSubview(pieChartView)
        self.initPieChartData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate lazy var pieChartView: PieChartView = {
        //创建饼状图
        let pieChartView = PieChartView.init(frame: CGRect.init(x: 0, y: 50, width: kScreenWidth, height: kScreenWidth))
        pieChartView.backgroundColor = UIColor.clear
        pieChartView.delegate = self
        
        //基本样式
        pieChartView.setExtraOffsets(left: 40, top: 0, right: 40, bottom: 0)
        pieChartView.usePercentValuesEnabled = true //是否根据所提供的数据, 将显示数据转换为百分比格式
        pieChartView.dragDecelerationEnabled = true //拖拽饼状图后是否有惯性效果
        pieChartView.drawEntryLabelsEnabled = true //是否显示区块文本
        
        //空心饼状图样式
        pieChartView.drawHoleEnabled = false //饼状图是否是空心
        pieChartView.holeRadiusPercent = 0.3 //空心半径占比
        pieChartView.holeColor = UIColor.clear //空心颜色
        pieChartView.transparentCircleRadiusPercent = 0.32 //半透明空心半径占比
        pieChartView.transparentCircleColor = UIColor.clear //半透明空心的颜色
        
        if pieChartView.isDrawHoleEnabled {
            pieChartView.drawCenterTextEnabled = false //是否显示中间文字
            pieChartView.centerText = "饼状图" //中间文字
        }
        
        //饼状图描述
        pieChartView.chartDescription?.text = ""
        pieChartView.chartDescription?.font = UIFont.systemFont(ofSize: 10)
        pieChartView.chartDescription?.textColor = UIColor.gray
        
        //饼状图图例
        pieChartView.legend.maxSizePercent = 1 //图例在饼状图中的大小占比, 这会影响图例的宽高
        pieChartView.legend.formToTextSpace = 5 //文本间隔
        pieChartView.legend.font = UIFont.systemFont(ofSize: 13) //字体大小
        pieChartView.legend.textColor = UIColor.gray //字体颜色
        pieChartView.legend.horizontalAlignment = .center //设置垂直居中
        pieChartView.legend.verticalAlignment = .bottom //设置水平居底部
        pieChartView.legend.form = .circle //图形样式
        pieChartView.legend.formSize = 20 //图形大小
        
        return pieChartView
    }()
    
    func initPieChartData() {
        let statistics = ["买iPhone X" : Double(21),
                          "买衣服" : Double(22),
                          "买电脑" : Double(23),
                          "买鞋" : Double(24),
                          "买娃娃" : Double(10)]
        let values = NSMutableArray()
        
        //获得总数
        var total: Double = 0
        for value in statistics.values {
            total = value + total
        }
        
        for key in statistics.keys {
            let value = statistics[key]
            if Int(value!) != 0 {
                let scale = value! / total * 100 //每个区块所占的比例
                values.add(PieChartDataEntry.init(value: scale, label: key))
            }
        }
        
        if values.count > 0 {
            let dataSet = PieChartDataSet.init(values: values as? [ChartDataEntry], label: "")
            dataSet.colors = [UIColor.blue, UIColor.red, UIColor.yellow, UIColor.purple, UIColor.brown] //区块的颜色
            
            dataSet.sliceSpace = 0.0 //相邻区块的间距
            dataSet.selectionShift = 0 //选中区块时，放大的半径
            dataSet.xValuePosition = .insideSlice //名称位置
            dataSet.yValuePosition = .outsideSlice //数据位置
            
            //数据与区块之间的用于指示的折线样式
            dataSet.valueLinePart1OffsetPercentage = 0.85 //折线中第一段起始位置相对于区块的偏移量, 数值越大, 折线距离区块越远
            dataSet.valueLinePart1Length = 0.9 //折线中第一段长度占比
            dataSet.valueLinePart2Length = 0.15 //折线中第二段长度最大占比
            dataSet.valueLineWidth = 1 //折线粗细
            dataSet.valueLineColor = UIColor.black
            
            //Data
            let data = PieChartData(dataSet: dataSet)
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.maximumFractionDigits = 2 //小数位数
            formatter.multiplier = 1.0
            
            data.setValueFormatter(formatter as? IValueFormatter) //设置显示数据格式
            data.setValueTextColor(UIColor.black)
            data.setValueFont(UIFont.systemFont(ofSize: 16))
            
            //为饼状图提供数据
            self.pieChartView.data = data
            
            //设置饼状图动画效果
            self.pieChartView.animate(xAxisDuration: 2.0, easingOption: .easeOutExpo)
        }
    }
    

}
