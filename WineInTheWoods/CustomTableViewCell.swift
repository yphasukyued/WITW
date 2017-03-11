import UIKit

class MyTableViewCell: UITableViewCell {
    
    var myLabel1: UILabel!
    var myLabel2: UILabel!
    var myDetail: UILabel!
    var myButton1 : UIButton!
    var mapButton : UIButton!
    var webButton : UIButton!
    var phoneButton : UIButton!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        myLabel1 = UILabel()
        myLabel1.textColor = UIColor.white
        myLabel1.font = UIFont(name: "TrebuchetMS", size: 16)
        contentView.addSubview(myLabel1)
        
        myLabel2 = UILabel()
        myLabel2.textColor = UIColor.white
        myLabel2.font = UIFont(name: "TrebuchetMS", size: 12)
        contentView.addSubview(myLabel2)
        
        myDetail = UILabel()
        myDetail.textColor = UIColor.white
        myDetail.font = UIFont(name: "TrebuchetMS", size: 12)
        contentView.addSubview(myDetail)
        
        myButton1 = UIButton()
        contentView.addSubview(myButton1)
        
        mapButton = UIButton()
        contentView.addSubview(mapButton)
        
        webButton = UIButton()
        contentView.addSubview(webButton)

        phoneButton = UIButton()
        contentView.addSubview(phoneButton)
    }
    
    var isObserving = false;
    class var expandedHeight: CGFloat { get { return 100 } }
    class var defaultHeight: CGFloat  { get { return 50  } }
    
    func checkHeight() {
        myDetail.isHidden = (frame.size.height < MyTableViewCell.expandedHeight)
        mapButton.isHidden = (frame.size.height < MyTableViewCell.expandedHeight)
        webButton.isHidden = (frame.size.height < MyTableViewCell.expandedHeight)
        phoneButton.isHidden = (frame.size.height < MyTableViewCell.expandedHeight)
    }
    
    func watchFrameChanges() {
        if !isObserving {
            addObserver(self, forKeyPath: "frame", options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.initial], context: nil)
            isObserving = true;
        }
    }
    
    func ignoreFrameChanges() {
        if isObserving {
            removeObserver(self, forKeyPath: "frame")
            isObserving = false;
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
}
