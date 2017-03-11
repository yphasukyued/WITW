import Foundation

class LocationModel: NSObject {
    
    //properties
    var name: String?
    var desc: String?
    var locTime: String?
    var url: String?
    var phone: String?
    var pin: String?
    var latitude: Double?
    var longitude: Double?
    
    //empty constructor
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, and @longitude parameters
    init(name: String, desc: String, locTime: String, url: String, phone: String, pin: String, latitude: Double, longitude: Double) {
        
        self.name = name
        self.desc = desc
        self.locTime = locTime
        self.url = url
        self.phone = phone
        self.pin = pin
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "Name: \(name), Desc: \(desc), LocTime: \(locTime), Url: \(url), Phone: \(phone), Pin: \(pin), Latitude: \(latitude), Longitude: \(longitude)"
        
    }
    
    
}