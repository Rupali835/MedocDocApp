

import UIKit

class JYToast: UILabel {
	
	private let alphaMAX: CGFloat = 0.7
	private let alphaMIN: CGFloat = 0.0
	
	private var message: String = "" {
		didSet {
			if message != text && isToasting {
				text = message
				willDisappearImmediately()
				willAppear()
			} else if !isToasting {
				text = message
				willAppear()
			}
		}
	}
	
	override var text: String? {
		didSet {
			reSizing()
		}
	}
	
	private var isToasting = false
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		initUi()
	}
	
	init(message: String) {
		super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		self.message = message
		initUi()
	}
	
	init() {
		super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		
		initUi()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		initUi()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		initUi()
	}
	
	private func initUi() {
		
		self.textColor = .white
		self.font = UIFont.boldSystemFont(ofSize: 30)
		self.numberOfLines = 0
		self.backgroundColor = UIColor.black
		self.textAlignment = NSTextAlignment.center
		self.alpha = alphaMIN
		self.layer.cornerRadius = 5
		self.clipsToBounds  =  true
		self.bounds.size = CGSize(width: 0, height: 0)
	}
	
	func isShow(_ message: String)
    {
        self.message = message
		willAppear()
	}
	
	override func drawText(in rect: CGRect) {
        _ = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
       super.drawText(in: rect)
    }
	
	private func reSizing() {
		
		let size = self.getSize()
		self.bounds.size = CGSize(width: size.width + 30, height: size.height + 20)
		reloacateCenter()
	}
	
	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceOrientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
		reloacateCenter()
	}
	
	override func removeFromSuperview() {
		super.removeFromSuperview()
		NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
	}
	
	@objc private func onDeviceOrientationDidChange() {
		self.center = CGPoint(x: UIScreen.main.bounds.width / 2,
		                      y: UIScreen.main.bounds.height - 150)
	}
	
	private func reloacateCenter() {
		self.center = CGPoint(x: UIScreen.main.bounds.width / 2,
		                      y: UIScreen.main.bounds.height - 150)
	}
	
	private func willDisappearWithAnimation()
    {
		UIView.animate(withDuration: 1.0,
		               delay: 2.0,
		               options: .curveEaseOut,
		               animations: { self.alpha = 0.0 },
		               completion: {(finished:Bool) in
						self.isToasting = false
		})
	}
	
	private func willAppear() {
		
		if let window = UIApplication.shared.windows.last
        {
			window.addSubview(self)
            window.bringSubviewToFront(self)
        }
		
		self.alpha = alphaMAX
		self.isToasting = true
		willDisappearWithAnimation()
	}
	
	private func willDisappearImmediately() {
		self.alpha = alphaMIN
		self.isToasting = false
	}
	
	private func getSize() -> CGSize {
		
		guard let string = text else {
			return CGSize(width: 0, height: 0)
		}
		
		let screenSize = UIScreen.main.bounds.size
		let constrainedSize = CGSize(width: screenSize.width - 100, height: screenSize.height - 100)
		let boundingBox = string.boundingRect(with: constrainedSize,
		                                      options: .usesLineFragmentOrigin,
                                              attributes: [NSAttributedString.Key.font: self.font],
		                                      context: nil)
		
		return boundingBox.size
	}
}
