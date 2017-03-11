import Foundation
import MapKit

protocol HomeModelProtocal: class {
    func itemsDownloaded(_ items: NSArray)
}


class HomeModel: NSObject, URLSessionDataDelegate {
    
    //properties
    
    weak var delegate: HomeModelProtocal!
    var data : NSMutableData = NSMutableData()
    var urlPath: String = ""
    var dataType: String = ""
    
    func downloadItems(_ type: String) {
        
        dataType = type
        
        if type == "Winery" {
            urlPath = "https://gis.howardcountymd.gov/iOS/WineInTheWoods/GetWineryList.aspx"
        } else if type == "Food"
            || type == "Crafter"
            || type == "Sponsors" {
            urlPath = "https://gis.howardcountymd.gov/iOS/WineInTheWoods/GetName.aspx?mytype="+type
        } else if type == "Music" {
            urlPath = "https://gis.howardcountymd.gov/iOS/WineInTheWoods/GetEntertainerList.aspx?stage=All"
        } else if type == "Other" {
            urlPath = "https://gis.howardcountymd.gov/iOS/WineInTheWoods/GetOthersList.aspx"
        } else if type == "Points" {
            urlPath = "https://gis.howardcountymd.gov/iOS/WineInTheWoods/GetPointsList.aspx"
        }
        let url: URL = URL(string: urlPath)!
        var session: Foundation.URLSession!
        let configuration = URLSessionConfiguration.default
        
        
        session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let task = session.dataTask(with: url)
        
        task.resume()
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.data.append(data);
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print("Failed to download data")
        }else {
            print("Data downloaded")
            self.parseJSON()
        }
        
    }
    
    func nullToNil(_ value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }
    func parseJSON() {
        
        var jsonResult: NSMutableArray = NSMutableArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: self.data as Data, options:JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableArray
        } catch let error as NSError {
            print(error)
            
        }
        
        //var jsonElement: NSDictionary = NSDictionary()
        let locations: NSMutableArray = NSMutableArray()
        
        //print(jsonResult)
        for item:AnyObject in jsonResult as [AnyObject] {
            let location = LocationModel()
            var name: NSString = ""
            var desc: NSString = ""
            var locTime: NSString = ""
            var url: NSString = ""
            var phone: NSString = ""
            var pin: NSString = ""
            
            
            if dataType == "Winery" {
                name = (item["Wine_Maker"] as? NSString)!
                desc = (item["TentID"] as? NSString)!
                
                let string1: String = (item["City"] as? String)!
                let string2: String = ", "
                let string3: String = (item["State"] as? String)!
                let string4: String = (item["Zip"] as? String)!
                
                locTime = ((string1 + string2 + string3 + string4) as NSString)
                
                if item["URL"] is NSNull {
                    url = ""
                } else {
                    url = (item["URL"] as? NSString)!
                }
                phone = (item["Phone"] as? NSString)!
                pin = (item["TentID"] as? NSString)!
            } else if dataType == "Food"
                || dataType == "Sponsors" {
                name = (item["NAME"] as? NSString)!
                if item["DESCRIPTION"] is NSNull {
                    desc = ""
                } else {
                    desc = (item["DESCRIPTION"] as? NSString)!
                }
                locTime = (item["TYPE"] as? NSString)!
                if item["URL2"] is NSNull {
                    url = ""
                } else {
                    url = (item["URL2"] as? NSString)!
                }
                pin = (item["TEXTLABEL"] as? NSString)!
            } else if dataType == "Crafter" {
                name = (item["NAME"] as? NSString)!
                if item["DESCRIPTION"] is NSNull {
                    desc = ""
                } else {
                    desc = (item["DESCRIPTION"] as? NSString)!
                }
                locTime = (item["TYPE"] as? NSString)!
                if item["URL2"] is NSNull {
                    url = ""
                } else {
                    url = (item["URL2"] as? NSString)!
                }
                let string1: String = "A"
                let string2: String = (item["TEXTLABEL"] as? String)!
                pin = ((string1 + string2) as NSString)
                
            } else if dataType == "Other" || dataType == "Points"{
                name = (item["NAME"] as? NSString)!
                if item["DESCRIPTION"] is NSNull {
                    desc = ""
                } else {
                    desc = (item["DESCRIPTION"] as? NSString)!
                }
                
                locTime = (item["TYPE"] as? NSString)!
                pin = (item["NAME"] as? NSString)!
            } else if dataType == "Music" {
                name = (item["ENTERTAINER"] as? NSString)!
                desc = (item["GENRE"] as? NSString)!
                let string1: String = (item["STAGE_NAME"] as? String)!
                let string2: String = " - "
                let string3: String = (item["DATE_TIME"] as? String)!
                locTime = ((string1 + string2 + string3) as NSString)
                if item["URL"] is NSNull {
                    url = ""
                } else {
                    url = (item["URL"] as? NSString)!
                }
                pin = (item["STAGE_NAME"] as? NSString)!
            }
            
            
            let latitude = item["Y"] as? Double
            let longitude = item["X"] as? Double
            
            location.name = name as String
            location.desc = desc as String
            location.locTime = locTime as String
            location.pin = pin as String
            location.latitude = latitude
            location.longitude = longitude
            location.url = url as String
            location.phone = phone as String
            locations.add(location)
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(locations)
            
        })
    }
}
