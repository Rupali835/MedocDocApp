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
    
    var chartValues = [Double]()
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    var months = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        axisFormatDelegate = self
        backView.designCell()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        setChart(dataPoints: months, values: self.chartValues)
    }
    
    func setChart(dataPoints: [String], values: [Double])
    {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {

            let dataEntry = ChartDataEntry(x: Double(i), y: values[i], data: dataPoints as AnyObject)

            dataEntries.append(dataEntry)

        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Temperature")
        
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
        chartOne.data = lineChartData
    
        let xAxisValue = chartOne.xAxis
        
        chartOne.xAxis.granularityEnabled = true
        
        chartOne.xAxis.granularity = 1.0
        
        xAxisValue.spaceMin = 0.5
        xAxisValue.spaceMax = 0.5
        
        chartOne.xAxis.labelPosition = .bottom

        chartOne.animate(xAxisDuration: 1.0, easingOption: ChartEasingOption.linear)
        
        chartOne.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        
        chartOne.leftAxis.labelFont = UIFont.boldSystemFont(ofSize: 12)
        
        chartOne.rightAxis.labelFont = UIFont.boldSystemFont(ofSize: 12)
        
        lineChartDataSet.valueFont = UIFont.boldSystemFont(ofSize: 12)
        chartOne.xAxis.labelTextColor = UIColor.black
        xAxisValue.valueFormatter = axisFormatDelegate
        
        self.chartOne.notifyDataSetChanged()
        lineChartData.notifyDataChanged()
    }
    
    @IBAction func btnBack_onclick(_ sender: Any)
    {
       self.navigationController?.popViewController(animated: true)
    }
    
}
extension ChartAnalysisVC: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        return months[Int(value) % months.count]
        
    }
    
}

