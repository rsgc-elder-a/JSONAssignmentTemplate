//: Playground - noun: a place where people can play

// ALL the json values are currently in greenwich time must subtract 4 in order to obtaint the right times

import UIKit
import XCPlayground

class ViewController : UIViewController {
    
    
    var finalSunrise : String = ""
    var finalSunSet : String = ""
    var finalDaylegnth : String = ""
    
    // Views that need to be accessible to all methods
    let jsonResult = UILabel()
    
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
                        
                        finalDaylegnth = day_length as! String
                    } else{
                        print("nah")
                    }
                    
                    
                    
                    
                    
                    
                } else {
                    print("error: could not get sunrise")
                }
                
                //                if let sunset = jsonDictionary["day_length"]{
                //                    print(sunset)
                //                }
                
                
            }
            
            
            
            
            // Now we can update the UI
            // (must be done asynchronously)
            dispatch_async(dispatch_get_main_queue()) {
                
            
                self.jsonResult.text = "Sunrise: "
              //  self.jsonResult.text += finalDaylegnth
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
        view.backgroundColor = UIColor.lightGrayColor()
        
        /*
         * Further define label that will show JSON data
         */
        
        // Set the label text and appearance
        jsonResult.text = "..."
        jsonResult.font = UIFont.systemFontOfSize(12)
        jsonResult.numberOfLines = 0   // makes number of lines dynamic
        // e.g.: multiple lines will show up
        jsonResult.textAlignment = NSTextAlignment.Center
        
        // Required to autolayout this label
        jsonResult.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label to the superview
        view.addSubview(jsonResult)
        
        /*
         * Add a button
         */
        let getData = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        
        // Make the button, when touched, run the calculate method
        getData.addTarget(self, action: #selector(ViewController.getMyJSON), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Set the button's title
        getData.setTitle("Get my JSON!", forState: UIControlState.Normal)
        
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
            "title": jsonResult,
            "getData": getData]
        
        // Define the vertical constraints
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-50-[getData]-[title]",
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
