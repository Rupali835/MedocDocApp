//
//  ChartAnalysisVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 2/8/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import Charts

class ChartAnalysisVC: UIViewController {

    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var chartOne: LineChartView!
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    var months = ["Jan","Feb","Mar","Apr","May","Jun"]
    
    let unitsSold = [10.0, 4.0, 6.0, 3.0, 12.0, 16.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setChart(dataPoints: months, values: unitsSold)
        axisFormatDelegate = self
        
        backView.designCell()
    }
    
    func setChart(dataPoints: [String], values: [Double])
    {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i], data: dataPoints as AnyObject)
            
            dataEntries.append(dataEntry)
            
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Test")
        
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
        chartOne.data = lineChartData
        
        let xAxisValue = chartOne.xAxis
        
        chartOne.xAxis.granularityEnabled = true
        
        chartOne.xAxis.granularity = 1.0
        
        chartOne.animate(xAxisDuration: 1.0, easingOption: ChartEasingOption.linear)
        
        chartOne.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        
        chartOne.leftAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        
        chartOne.rightAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        
        lineChartDataSet.valueFont = UIFont.boldSystemFont(ofSize: 10)
        
        xAxisValue.valueFormatter = axisFormatDelegate
        
    }
    
    @IBAction func btnBack_onclick(_ sender: Any)
    {
       self.navigationController?.popViewController(animated: true)
    }
    
}
extension ChartAnalysisVC: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        return months[Int(value)]
        
    }
    
}

