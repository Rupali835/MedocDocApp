//
//  ViewMoreDetailVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/24/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import Charts

class ViewMoreDetailVC: UIViewController, IAxisValueFormatter, ChartViewDelegate
{
   
    @IBOutlet weak var diabeticChart: LineChartView!
    @IBOutlet weak var collMedicine: UICollectionView!
    @IBOutlet weak var collLabTest: UICollectionView!
    @IBOutlet weak var collChiefComplain: UICollectionView!
    @IBOutlet weak var complainView: UIView!
    @IBOutlet weak var medicineView: UIView!
    @IBOutlet weak var btnBldPressure: UIButton!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var labTestView: UIView!
    @IBOutlet weak var diebeticView: UIView!
    
    var InfoArr = [[String : Any]]()
    var ChiefComplainARR = [String : Int]()
    var toast = JYToast()
    weak var axisFormatDelegate: IAxisValueFormatter?
    let chartView = LineChartView()

    
    var MedicineARR = [String : Int]()
    
    var LabTestARR = [String : Int]()
    
    var months = ["Jan","Feb","Mar","Apr","May","Jun"]
    
    let unitsSold = [10.0, 4.0, 6.0, 3.0, 12.0, 16.0]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setDelegte()

       LayoutView(view: [medicineView, labTestView, graphView, diebeticView, complainView])
        
        if ChiefComplainARR.count != 0
        {
            collChiefComplain.reloadData()
        }
        if MedicineARR.count != 0
        {
            collMedicine.reloadData()
        }
        if LabTestARR.count != 0
        {
            collLabTest.reloadData()
        }
        diabeticChart.delegate = self
        setChart(dataPoints: months, values: unitsSold)
        axisFormatDelegate = self
        
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        return months[Int(value)]
    }
    
    func setChart(dataPoints: [String], values: [Double])
    {
        let xAxis = XAxis()
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i], data: dataPoints as AnyObject)
            
            dataEntries.append(dataEntry)
            
        }
        
        for i in months{
            axisFormatDelegate?.stringForValue(Double(i) ?? 0, axis: xAxis)
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Diabetic Values")
        
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
        diabeticChart.data = lineChartData
        
        let xAxisValue = diabeticChart.xAxis
        
        diabeticChart.xAxis.granularityEnabled = true
       
        diabeticChart.xAxis.granularity = 1.0
        
        diabeticChart.animate(xAxisDuration: 1.0, easingOption: ChartEasingOption.linear)
        
        diabeticChart.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        
        diabeticChart.leftAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        
        diabeticChart.rightAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        
        diabeticChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        lineChartDataSet.valueFont = UIFont.boldSystemFont(ofSize: 10)
        
        xAxisValue.valueFormatter = axisFormatDelegate
        diabeticChart.xAxis.valueFormatter = xAxisValue.valueFormatter
        
    }
    
    
    func setDelegte()
    {
        collChiefComplain.delegate = self
        collChiefComplain.dataSource = self
        collMedicine.dataSource = self
        collMedicine.delegate = self
        collLabTest.delegate = self
        collLabTest.dataSource = self
    }
    
    func LayoutView(view : [UIView])
    {
        for subView in view
        {
            subView.layer.cornerRadius = 10.0
            subView.designCell()
            subView.backgroundColor = UIColor.white
        }
      
    }
    
    @IBAction func btnback_onclick(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnChartOne_onclick(_ sender: Any)
    {
        let vc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "ChartAnalysisVC") as! ChartAnalysisVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnChartTwo_onclick(_ sender: Any)
    {
        let vc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "TemperatureGraphVC") as! TemperatureGraphVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension ViewMoreDetailVC : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == collChiefComplain
        {
            return self.ChiefComplainARR.count
        }else if collectionView == collMedicine
        {
            return self.MedicineARR.count
        }else if collectionView == collLabTest
        {
            return self.LabTestARR.count
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
       if collectionView == collChiefComplain
        {
             let cell = collChiefComplain.dequeueReusableCell(withReuseIdentifier: "ChiefComplainAnalysisCell", for: indexPath) as! ChiefComplainAnalysisCell
            
            let key = Array(self.self.ChiefComplainARR.keys)[indexPath.row]
            let value = Array(self.self.ChiefComplainARR.values)[indexPath.row]
            
            var count = String()
            
            if ((key as? String) != nil)
            {
                if value == 1
                {
                    count = "(\(value) time)"
                }else
                {
                    count = "(\(value) times)"
                }
                
                cell.lblChiefComplain.text = "\(key) \(count)"
            }
            
            return cell
        }
       else if collectionView == collMedicine
       {
        let Mcell = collMedicine.dequeueReusableCell(withReuseIdentifier: "MedicineAnalysisCell", for: indexPath) as! MedicineAnalysisCell
        
        let key = Array(self.MedicineARR.keys)[indexPath.row]
        let value = Array(self.MedicineARR.values)[indexPath.row]
        
        var count = String()
        
        if ((key as? String) != nil)
        {
            if value == 1
            {
                count = "(\(value) time)"
            }else
            {
                count = "(\(value) times)"
            }
            
            Mcell.lblMedicineNm.text = "\(key) \(count)"
        }
        return Mcell
        
        }
        else if collectionView == collLabTest
       {
        let Lcell = collLabTest.dequeueReusableCell(withReuseIdentifier: "LabTestAnalysisCell", for: indexPath) as! LabTestAnalysisCell
        
        let key = Array(self.LabTestARR.keys)[indexPath.row]
        let value = Array(self.LabTestARR.values)[indexPath.row]
        var count = String()
        
        if ((key as? String) != nil) && (key != "")
        {
            if value == 1
            {
                count = "(\(value) time)"
            }else
            {
                count = "(\(value) times)"
            }
            
            Lcell.lblLabTestNm.text = "\(key) \(count)"
        }
        return Lcell
        }
       else
       {
        return UICollectionViewCell()
        }
     }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        return CGSize(width: (self.collChiefComplain.frame.size.width) / 2, height: 120)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    }
    
    //4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    
}
