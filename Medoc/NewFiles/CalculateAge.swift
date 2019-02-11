func calculateAge(dob : String) -> (year :Int, month : Int){
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    let date = df.date(from: dob)
    guard let val = date else{
        return (0, 0)
    }
    var years = 0
    var months = 0
    var days = 0
    
    let cal = NSCalendar.current
    years = cal.component(.year, from: NSDate() as Date) -  cal.component(.year, from: val)
    
    let currMonth = cal.component(.month, from: NSDate() as Date)
    let birthMonth = cal.component(.month, from: val)
    
    //get difference between current month and birthMonth
    months = currMonth - birthMonth
    //if month difference is in negative then reduce years by one and calculate the number of months.
    if months < 0
    {
        years = years - 1
        months = 12 - birthMonth + currMonth
        if cal.component(.day, from: NSDate() as Date) < cal.component(.day, from: val){
            months = months - 1
        }
    } else if months == 0 && cal.component(.day, from: NSDate() as Date) < cal.component(.day, from: val)
    {
        years = years - 1
        months = 11
    }
    
    //Calculate the days
    if cal.component(.day, from: NSDate() as Date) > cal.component(.day, from: val){
        days = cal.component(.day, from: NSDate() as Date) - cal.component(.day, from: val)
    }
    else if cal.component(.day, from: NSDate() as Date) < cal.component(.day, from: val)
    {
        let today = cal.component(.day, from: NSDate() as Date)
      //  let date = cal.dateByAddingUnit(.Month, value: -1, toDate: NSDate(), options: [])
        
        let date = cal.date(byAdding: .month, value: -1, to: NSDate() as Date)
        
        days = (cal.component(.day, from: date!) - cal.component(.day, from: val)) + today
    } else
    {
        days = 0
        if months == 12
        {
            years = years + 1
            months = 0
        }
    }
    
    return (years, months)
}
