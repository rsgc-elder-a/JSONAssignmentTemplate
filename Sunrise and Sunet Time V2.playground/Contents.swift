//: Playground - noun: a place where people can play

// ALL the json values are currently in greenwich time must subtract 4 in order to obtaint the right times

import UIKit
import XCPlayground

class ViewController : UIViewController {
    
    
    var finalSunrise : String = ""
    var finalSunSet : String = ""
    var finalDaylength : String = ""
    var finalSolorNoon : String = ""
    
    // Views that need to be accessible to all methods
    let jsonSunrise = UILabel()
    let jsonSunset = UILabel()
    let jsonDaylegnth = UILabel()
    var jsonSolorNoon = UILabel()
    var sunnyDay = UILabel()
    
    // If data is successfully retrieved from the server, we can parse it here
    func parseMyJSON(theData : NSData) {
        
        // Print the provided data
        print("")
        print("====== the data provided to parseMyJSON is as follows ======")
        print(theData)
        
        // De-serializing JSON can throw errors, so should be inside a do-catch structure
        do {
            
            // Do the initial de-serialization
            // Source JSON is here:
            // http://www.learnswiftonline.com/Samples/subway.json
            //
            let json = try NSJSONSerialization.JSONObjectWithData(theData, options: NSJSONReadingOptions.AllowFragments) as! AnyObject
            
            
            // Print retrieved JSON
            print("")
            print("====== the retrieved JSON is as follows ======")
            print(json)
            
            // Now we can parse this...
            print("")
            print("Now, add your parsing code here...")
            
            
            if let jsonDictionary = json as? [String: AnyObject]
            {
                print("Dictionary")
                print(jsonDictionary)
                
                print("HERE SHOULD BE SUNRISE AND SET")
                //not acessing the value
                if let results = jsonDictionary["results"] as? [String: AnyObject]{
                    print(results)
                    
                    var hour = ""
                    var restValue = ""
                    //sunset
                    if let sunset = results["sunset"]{
                        
                        
                        let sunsetS : String = sunset as! String
                        
                        var count = 0
                        for char in sunsetS.characters {
                            count += 1
                            if(count < 3){
                                let charS : String = String(char)
                                hour += charS
                                
                            } else if(count < 10) {
                                let charS : String = String(char)
                                restValue += charS
                            }
                        }
                        
                        var hourI:Int = Int(hour)!
                        hourI = hourI - 4
                        
                        var fullSunset = String(hourI)
                        fullSunset += restValue
                        fullSunset += "PM"
                        print("Sunset:")
                        print(fullSunset)
                        
                        finalSunSet = fullSunset
                        
                    } else{
                        print("nah")
                    }
                    
                    
                    
                    
                    var hour2 = ""
                    var restValue2 = ""
                    
                    //sunset
                    if let sunrise = results["sunrise"]{
                        
                        let sunsetS : String = sunrise as! String
                        
                        var count = 0
                        for char in sunsetS.characters {
                            count += 1
                            if(count < 2){
                                let charS : String = String(char)
                                hour2 += charS
                                
                            } else {
                                let charS : String = String(char)
                                restValue2 += charS
                            }
                        }
                        
                        var hourI:Int = Int(hour2)!
                        hourI = hourI - 4
                        
                        var fullSunrise = String(hourI)
                        fullSunrise += restValue2
                        print("Sunrise:")
                        print(fullSunrise)
                        
                        finalSunrise = fullSunrise
                        
                    } else{
                        print("nah")
                    }
                    
                    //sunset
                    if let day_length = results["day_length"]{
                        print("day_length: ")
                        print(day_length)
                        
                        finalDaylength = day_length as! String
                    } else{
                        print("nah")
                    }
                    
                    var hour3 = ""
                    var restValue3 = ""
                    //solor NOON
                    if let solornoon = results["solar_noon"]{
                        
                        let solorNoonS : String = solornoon as! String
                        
                        var count = 0
                        for char in solorNoonS.characters {
                            count += 1
                            if(count < 2){
                                let charS : String = String(char)
                                hour3 += charS
                                
                            } else {
                                let charS : String = String(char)
                                restValue3 += charS
                            }
                        }
                        
                        var hourI:Int = Int(hour3)!
                        hourI = hourI - 4
                        
                        var fullSolorNoon = String(hourI)
                        fullSolorNoon += restValue2
                        print("Solor Noon:")
                        print(fullSolorNoon)
                        
                        finalSolorNoon = fullSolorNoon
                        
                    } else{
                        print("nah")
                    }
                    
                } else {
                    print("error: could not get sunrise")
                }
                
                
                
                
                
            }
            
            
            // Now we can update the UI
            // (must be done asynchronously)
            dispatch_async(dispatch_get_main_queue()) {
                
                
                var sunRise = "Sunrise: "
                sunRise += self.finalSunrise
                self.jsonSunrise.text = sunRise
                
                var sunSet = "Sunset: "
                sunSet += self.finalSunSet
                self.jsonSunset.text = sunSet
                
                var dayLength = "Day Length: "
                dayLength += self.finalDaylength
                self.jsonDaylegnth.text = dayLength
                
                var solorNoon = "Solar Noon: "
                solorNoon += self.finalSolorNoon
                self.jsonSolorNoon.text = solorNoon
                
                self.sunnyDay.text = "Have a sunny day!"
                
                //  self.jsonResult.text += self.finalDaylegnth
            }
            
        } catch let error as NSError {
            print ("Failed to load: \(error.localizedDescription)")
        }
        
        
    }
    
    // Set up and begin an asynchronous request for JSON data
    func getMyJSON() {
        
        // Define a completion handler
        // The completion handler is what gets called when this **asynchronous** network request is completed.
        // This is where we'd process the JSON retrieved
        let myCompletionHandler : (NSData?, NSURLResponse?, NSError?) -> Void = {
            
            (data, response, error) in
            
            // This is the code run when the network request completes
            // When the request completes:
            //
            // data - contains the data from the request
            // response - contains the HTTP response code(s)
            // error - contains any error messages, if applicable
            
            // Cast the NSURLResponse object into an NSHTTPURLResponse objecct
            if let r = response as? NSHTTPURLResponse {
                
                // If the request was successful, parse the given data
                if r.statusCode == 200 {
                    
                    // Show debug information (if a request was completed successfully)
                    print("")
                    print("====== data from the request follows ======")
                    print(data)
                    print("")
                    print("====== response codes from the request follows ======")
                    print(response)
                    print("")
                    print("====== errors from the request follows ======")
                    print(error)
                    
                    if let d = data {
                        
                        // Parse the retrieved data
                        self.parseMyJSON(d)
                        
                    }
                    
                }
                
            }
            
        }
        
        // Define a URL to retrieve a JSON file from
        //http://api.sunrise-sunset.org/json?lat=36.7201600&lng=-4.4203400&date=today
        var address : String = "http://api.sunrise-sunset.org/json?"
        //lat=36.7201600&lng=-4.4203400
        //ad the ladittude and londitude later in the project
        let lat = "43.669554"
        //change to toronto
        let lng = "-79.410188"
        address += "lat="
        address += lat
        address += "&lng="
        address += lng
        address += "&date=today"
        print(address)
        
        
        // Try to make a URL request object
        if let url = NSURL(string: address) {
            
            // We have an valid URL to work with
            print(url)
            
            // Now we create a URL request object
            let urlRequest = NSURLRequest(URL: url)
            
            // Now we need to create an NSURLSession object to send the request to the server
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            // Now we create the data task and specify the completion handler
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: myCompletionHandler)
            
            // Finally, we tell the task to start (despite the fact that the method is named "resume")
            task.resume()
            
        } else {
            
            // The NSURL object could not be created
            print("Error: Cannot create the NSURL object.")
            
        }
        
    }
    
    // This is the method that will run as soon as the view controller is created
    override func viewDidLoad() {
        
        // Sub-classes of UIViewController must invoke the superclass method viewDidLoad in their
        // own version of viewDidLoad()
        super.viewDidLoad()
        
        // Make the view's background be gray
        view.backgroundColor = UIColor.redColor()
        
        /*
         * Further define label that will show JSON data
         */
        
        // Set the label text and appearance
        jsonSunrise.text = "..."
        jsonSunrise.textColor = UIColor.whiteColor()
        jsonSunrise.font = UIFont.systemFontOfSize(30)
        jsonSunrise.numberOfLines = 2   // makes number of lines dynamic
        // e.g.: multiple lines will show up
        jsonSunrise.textAlignment = NSTextAlignment.Center
        
        // Required to autolayout this label
        jsonSunrise.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label to the superview
        view.addSubview(jsonSunrise)
        
        // Set the label text and appearance
        jsonSunset.text = "..."
        jsonSunset.textColor = UIColor.whiteColor()
        jsonSunset.font = UIFont.systemFontOfSize(30)
        jsonSunset.numberOfLines = 2   // makes number of lines dynamic
        // e.g.: multiple lines will show up
        jsonSunset.textAlignment = NSTextAlignment.Center
        
        // Required to autolayout this label
        jsonSunset.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label to the superview
        view.addSubview(jsonSunset)
        
        // Set the label text and appearance
        jsonDaylegnth.text = "..."
        jsonDaylegnth.textColor = UIColor.whiteColor()
        jsonDaylegnth.font = UIFont.systemFontOfSize(30)
        jsonDaylegnth.numberOfLines = 2   // makes number of lines dynamic
        // e.g.: multiple lines will show up
        jsonDaylegnth.textAlignment = NSTextAlignment.Center
        
        // Required to autolayout this label
        jsonDaylegnth.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label to the superview
        view.addSubview(jsonDaylegnth)
        
        
        // Set the label text and appearance
        jsonSolorNoon.text = "..."
        jsonSolorNoon.textColor = UIColor.whiteColor()
        jsonSolorNoon.font = UIFont.systemFontOfSize(30)
        jsonSolorNoon.numberOfLines = 2   // makes number of lines dynamic
        // e.g.: multiple lines will show up
        jsonSolorNoon.textAlignment = NSTextAlignment.Center
        
        // Required to autolayout this label
        jsonSolorNoon.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label to the superview
        view.addSubview(jsonSolorNoon)
        
        
        // Set the label text and appearance
        sunnyDay.text = "..."
        sunnyDay.textColor = UIColor.whiteColor()
        sunnyDay.font = UIFont.systemFontOfSize(45)
        sunnyDay.numberOfLines = 2   // makes number of lines dynamic
        // e.g.: multiple lines will show up
        sunnyDay.textAlignment = NSTextAlignment.Center
        
        // Required to autolayout this label
        sunnyDay.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label to the superview
        view.addSubview(sunnyDay)
        
        
        /*
         * Add a button
         */
        let getData = UIButton(frame: CGRect(x: 0, y: 0, width: 160, height: 40))
        
        // Make the button, when touched, run the calculate method
        getData.addTarget(self, action: #selector(ViewController.getMyJSON), forControlEvents: UIControlEvents.TouchUpInside)
        
        getData.titleLabel!.font =  UIFont(name: "Arial", size: 38)
        // Set the button's title
        getData.setTitle("Click to get your data!", forState: UIControlState.Normal)
        // Required to auto layout this button
        getData.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the button into the super view
        view.addSubview(getData)
        
        /*
         * Layout all the interface elements
         */
        
        // This is required to lay out the interface elements
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Create an empty list of constraints
        var allConstraints = [NSLayoutConstraint]()
        
        // Create a dictionary of views that will be used in the layout constraints defined below
        let viewsDictionary : [String : AnyObject] = [
            "jsonSunrise": jsonSunrise,
            "getData": getData,
            "jsonSunset" : jsonSunset,
            "jsonDaylegnth" : jsonDaylegnth,
            "jsonSolorNoon" : jsonSolorNoon,
            "sunnyDay" : sunnyDay]
        
        // Define the vertical constraints
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-30-[getData]-50-[jsonSunrise]-20-[jsonSunset]-20-[jsonDaylegnth]-20-[jsonSolorNoon]-50-[sunnyDay]",
            options: [],
            metrics: nil,
            views: viewsDictionary)
        
        // Add the vertical constraints to the list of constraints
        allConstraints += verticalConstraints
        
        // Activate all defined constraints
        NSLayoutConstraint.activateConstraints(allConstraints)
        
    }
    
}

// Embed the view controller in the live view for the current playground page
XCPlaygroundPage.currentPage.liveView = ViewController()
// This playground page needs to continue executing until stopped, since network reqeusts are asynchronous
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
