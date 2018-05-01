
import UIKit

class TagLabel: UILabel {
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
fileprivate extension TagLabel {
    
    func setupLabel() {
        
        // Tag Label
        textAlignment = .center
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
        textColor = UIColor.white
        translatesAutoresizingMaskIntoConstraints = false
    }
}
