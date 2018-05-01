
import UIKit
import PINRemoteImage

protocol TagCollectionViewCellDelegate {
    func removeTapped(tag: String)
}

class TagCollectionViewCell: UICollectionViewCell, ReusableCell {
    
    // Outlets
    let containerView = UIView.autolayoutView()
    let tagLabel = TagLabel.autolayoutView()
    let removeButton = UIButton.autolayoutView()
    
    // Delegate
    var delegate: TagCollectionViewCellDelegate?
    
    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
    }
    
    var tagString: String? {
        didSet {
            setupUI()
        }
    }
}

// MARK: - Setup
fileprivate extension TagCollectionViewCell {
    
    func setupViews() {
        
        //Content View
        contentView.backgroundColor = UIColor.pink
        contentView.layer.cornerRadius = 5
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(tagLabel)
        
        removeButton.setImage(#imageLiteral(resourceName: "tagRemove"), for: .normal)
        removeButton.sizeToFit()
        removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
        containerView.addSubview(removeButton)
        
        contentView.addSubview(containerView)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        
        let views: [String: UIView] = [
            "tagLabel": tagLabel,
            "removeButton": removeButton,
            "containerView": containerView
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tagLabel]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[removeButton(20)]-5-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[tagLabel]-3-[removeButton(20)]-5-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }
}

//MARK: - Private Functions
fileprivate extension TagCollectionViewCell {
    func setupUI() {
        tagLabel.text = tagString!
        layoutSubviews()
    }
    
    @objc func removeTapped(sender: AnyObject) {
        delegate?.removeTapped(tag: tagString!)
    }
}
