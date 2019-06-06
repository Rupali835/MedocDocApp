//
//  thirdGraphVc.swift
//  Medoc
//
//  Created by Rupali Patil on 05/06/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import Charts


class thirdGraphVc: UIViewController, IAxisValueFormatter
{

    @IBOutlet weak var graph: LineChartView!
    
    weak var axisFormatDelegate: IAxisValueFormatter?

    var months = [String]()
    var chartValues = [Double]()

    override func viewDidLoad() {
        super.viewDidLoad()
        axisFormatDelegate = self

    }
    func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        return months[Int(value) % months.count]
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
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Weight")
        
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
        graph.data = lineChartData
        
        let xAxisValue = graph.xAxis
        
        graph.xAxis.granularityEnabled = true
        
        graph.xAxis.granularity = 1.0
        
        graph.animate(xAxisDuration: 1.0, easingOption: ChartEasingOption.linear)
        
        graph.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        
        graph.leftAxis.labelFont = UIFont.boldSystemFont(ofSize: 12)
        
        graph.rightAxis.labelFont = UIFont.boldSystemFont(ofSize: 12)
        
        lineChartDataSet.valueFont = UIFont.boldSystemFont(ofSize: 12)
        
        xAxisValue.valueFormatter = axisFormatDelegate
        graph.xAxis.labelPosition = .bottom
        graph.xAxis.labelTextColor = UIColor.black
        
    }
    
    @IBAction func btnBack_onclick(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}

