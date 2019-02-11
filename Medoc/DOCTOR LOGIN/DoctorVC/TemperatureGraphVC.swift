////
////  TemperatureGraphVC.swift
////  Medoc
////
////  Created by Prajakta Bagade on 2/8/19.
////  Copyright © 2019 Kanishka. All rights reserved.
////
//
//import UIKit
//import Charts
//
//class TemperatureGraphVC: UIViewController, ChartViewDelegate
//{
//
//    @IBOutlet weak var backView: UIView!
//    @IBOutlet weak var tempChart: LineChartView!
//    
//    @IBOutlet var sliderX: UISlider!
//    @IBOutlet var sliderY: UISlider!
//    @IBOutlet var sliderTextX: UITextField!
//    @IBOutlet var sliderTextY: UITextField!
//    
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//
//        
//        tempChart.delegate = self
//        
//        tempChart.chartDescription?.enabled = false
//        tempChart.dragEnabled = true
//        tempChart.setScaleEnabled(true)
//        tempChart.pinchZoomEnabled = true
//        
//        let l = tempChart.legend
//        l.form = .line
//        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
//        l.textColor = .white
//        l.horizontalAlignment = .left
//        l.verticalAlignment = .bottom
//        l.orientation = .horizontal
//        l.drawInside = false
//        
//        let xAxis = tempChart.xAxis
//        xAxis.labelFont = .systemFont(ofSize: 11)
//        xAxis.labelTextColor = .white
//        xAxis.drawAxisLineEnabled = false
//        
//        let leftAxis = tempChart.leftAxis
//        leftAxis.labelTextColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
//        leftAxis.axisMaximum = 200
//        leftAxis.axisMinimum = 0
//        leftAxis.drawGridLinesEnabled = true
//        leftAxis.granularityEnabled = true
//        
//        let rightAxis = tempChart.rightAxis
//        rightAxis.labelTextColor = .red
//        rightAxis.axisMaximum = 900
//        rightAxis.axisMinimum = -200
//        rightAxis.granularityEnabled = false
//        
//        sliderX.value = 20
//        sliderY.value = 30
//        tempChart.animate(xAxisDuration: 2.5)
//    }
//    
//    func setDataCount(_ count: Int, range: UInt32) {
//        let yVals1 = (0..<count).map { (i) -> ChartDataEntry in
//            let mult = range / 2
//            let val = Double(arc4random_uniform(mult) + 50)
//            return ChartDataEntry(x: Double(i), y: val)
//        }
//        let yVals2 = (0..<count).map { (i) -> ChartDataEntry in
//            let val = Double(arc4random_uniform(range) + 450)
//            return ChartDataEntry(x: Double(i), y: val)
//        }
//        let yVals3 = (0..<count).map { (i) -> ChartDataEntry in
//            let val = Double(arc4random_uniform(range) + 500)
//            return ChartDataEntry(x: Double(i), y: val)
//        }
//        
//        let set1 = LineChartDataSet(values: yVals1, label: "DataSet 1")
//        set1.axisDependency = .left
//        set1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
//        set1.setCircleColor(.white)
//        set1.lineWidth = 2
//        set1.circleRadius = 3
//        set1.fillAlpha = 65/255
//        set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
//        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
//        set1.drawCircleHoleEnabled = false
//        
//        let set2 = LineChartDataSet(values: yVals2, label: "DataSet 2")
//        set2.axisDependency = .right
//        set2.setColor(.red)
//        set2.setCircleColor(.white)
//        set2.lineWidth = 2
//        set2.circleRadius = 3
//        set2.fillAlpha = 65/255
//        set2.fillColor = .red
//        set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
//        set2.drawCircleHoleEnabled = false
//        
//        let set3 = LineChartDataSet(values: yVals3, label: "DataSet 3")
//        set3.axisDependency = .right
//        set3.setColor(.yellow)
//        set3.setCircleColor(.white)
//        set3.lineWidth = 2
//        set3.circleRadius = 3
//        set3.fillAlpha = 65/255
//        set3.fillColor = UIColor.yellow.withAlphaComponent(200/255)
//        set3.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
//        set3.drawCircleHoleEnabled = false
//        
//        let data = LineChartData(dataSets: [set1, set2, set3])
//        data.setValueTextColor(.white)
//        data.setValueFont(.systemFont(ofSize: 9))
//        
//        tempChart.data = data
//    }
//    
//    override func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
//    {
//        super.chartValueSelected(chartView, entry: entry, highlight: highlight)
//        
//        self.chartView.centerViewToAnimated(xValue: entry.x, yValue: entry.y,
//                                            axis: self.chartView.data!.getDataSetByIndex(highlight.dataSetIndex).axisDependency,
//                                            duration: 1)
//      
//    }
//    
//    @IBAction func btnback_onclick(_ sender: Any)
//    {
//       self.navigationController?.popViewController(animated: true)
//    }
//    
//}
