////
////  TemperatureGraphVC.swift
////  Medoc
////
////  Created by Prajakta Bagade on 2/8/19.
////  Copyright © 2019 Kanishka. All rights reserved.
////
//
import UIKit
import Charts

class TemperatureGraphVC: UIViewController, ChartViewDelegate, IAxisValueFormatter
{

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tempChart: LineChartView!
    
    @IBOutlet var sliderX: UISlider!
    @IBOutlet var sliderY: UISlider!
    @IBOutlet var sliderTextX: UITextField!
    @IBOutlet var sliderTextY: UITextField!
    
    var chartX = [Double]()
    var chartY = [Double]()
    var datePresc = [String]()
    weak var axisFormatDelegate: IAxisValueFormatter?
    var months = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        tempChart.delegate = self
        tempChart.chartDescription?.enabled = false
        tempChart.dragEnabled = true
        tempChart.setScaleEnabled(true)
        tempChart.pinchZoomEnabled = true
        
        let l = tempChart.legend
        l.form = .line
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.textColor = .white
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        let xAxis = tempChart.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelTextColor = .white
        xAxis.drawAxisLineEnabled = false
        
        let leftAxis = tempChart.leftAxis
        leftAxis.labelTextColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        leftAxis.axisMaximum = 200
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        
        let rightAxis = tempChart.rightAxis
        rightAxis.labelTextColor = .red
        rightAxis.axisMaximum = 900
        rightAxis.axisMinimum = -200
        rightAxis.granularityEnabled = false
        
//        sliderX.value = 20
//        sliderY.value = 30
        tempChart.animate(xAxisDuration: 2.5)
        
     //   setDataCount(5, range: 10)
        
    }
    
    func setChartValue(Months: [String], xArr : [Double], yArr : [Double])
    {
       self.chartX = xArr
       self.chartY = yArr
       self.months = Months
        
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        return datePresc[Int(value) % datePresc.count]
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.setDataCount(dataPoints : months, value1: self.chartX, value2: self.chartY)
    }
 
    func setDataCount(dataPoints : [String], value1 : [Double], value2 : [Double])
    {
        var dataEntries: [ChartDataEntry] = []
        var dataEntries2: [ChartDataEntry] = []

        
        var dataEntriesDate: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {

            let dataEntry = ChartDataEntry(x: Double(i), y: value1[i], data: dataPoints as AnyObject)

            dataEntriesDate.append(dataEntry)

        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntriesDate, label: "Date")
        
        for (i,_) in value1.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(i), y: value1[i])
            dataEntries.append(dataEntry)
        }
        if value2 != nil{
            for (i,_) in value2.enumerated() {
                let dataEntry = ChartDataEntry(x: Double(i), y: value2[i])
                dataEntries2.append(dataEntry)
            }
        }
        
        
        let set1 = LineChartDataSet(values: dataEntries, label: "Systolic")
        set1.axisDependency = .left
        set1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        set1.setCircleColor(.red)
        set1.lineWidth = 2
        set1.circleRadius = 3
        set1.fillAlpha = 65/255
        set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set1.drawCircleHoleEnabled = true
        
        let set2 = LineChartDataSet(values: dataEntries2, label: "Diastolic")
        set2.axisDependency = .left
        set2.setColor(.red)
        set2.setCircleColor(.blue)
        set2.lineWidth = 2
        set2.circleRadius = 3
        set2.fillAlpha = 65/255
        set2.fillColor = .red
        set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set2.drawCircleHoleEnabled = true
        
        let data = LineChartData(dataSets: [set2, set1])
        data.setValueTextColor(.black)
        data.setValueFont(.systemFont(ofSize: 15))
        
        tempChart.data = data
        
        
//        let xAxisValue = tempChart.xAxis
//
//        tempChart.xAxis.granularityEnabled = true
//
//        tempChart.xAxis.granularity = 1.0
//
//        tempChart.animate(xAxisDuration: 1.0, easingOption: ChartEasingOption.linear)
//
//        xAxisValue.valueFormatter = axisFormatDelegate
        tempChart.xAxis.labelPosition = .bottom
        tempChart.xAxis.labelTextColor = UIColor.black
    
    }
    

    
    @IBAction func btnback_onclick(_ sender: Any)
    {
       self.navigationController?.popViewController(animated: true)
    }
    
}
