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
        
        xAxisValue.spaceMin = 0.5
        xAxisValue.spaceMax = 0.5
        graph.xAxis.labelPosition = .bottom
        
        
        graph.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        
        graph.leftAxis.labelFont = UIFont.boldSystemFont(ofSize: 12)
        
        graph.rightAxis.labelFont = UIFont.boldSystemFont(ofSize: 12)
        
        lineChartDataSet.valueFont = UIFont.boldSystemFont(ofSize: 12)
        graph.xAxis.labelTextColor = UIColor.black
        graph.animate(xAxisDuration: 1.0, easingOption: ChartEasingOption.linear)

        xAxisValue.valueFormatter = axisFormatDelegate
        graph.animate(xAxisDuration: 1.0, easingOption: ChartEasingOption.linear)

        self.graph.notifyDataSetChanged()
        lineChartData.notifyDataChanged()
    }
    
    @IBAction func btnBack_onclick(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}

