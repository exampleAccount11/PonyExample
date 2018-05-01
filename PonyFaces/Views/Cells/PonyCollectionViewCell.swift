
import UIKit
import PINRemoteImage

protocol PonyCollectionViewCellDelegate {
    func heartTapped(for: Pony)
}

class PonyCollectionViewCell: UICollectionViewCell, ReusableCell {
    
    // Outlets
    fileprivate let iconImageView = UIImageView.autolayoutView()
    fileprivate let heartImageView = UIImageView.autolayoutView()
    
    // Delegate
    var delegate: PonyCollectionViewCellDelegate?
    
    var favorited: Bool = false {
        didSet {
            setupUI()
        }
    }
    
    var pony: Pony? {
        didSet {
            setupUI()
        }
    }
    
    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
fileprivate extension PonyCollectionViewCell {
    
    func setupViews() {
        
        // Content View
        contentView.layer.shadowRadius = 3
        contentView.layer.shadowOpacity = 0.25
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowColor = UIColor.black.cgColor
        
        // Icon Image View
        iconImageView.layer.cornerRadius = 10
        iconImageView.layer.borderColor = UIColor(red: 238/255, green: 180/255, blue: 204/255, alpha: 1.0).cgColor
        iconImageView.layer.borderWidth = 3
        iconImageView.clipsToBounds = true
        contentView.addSubview(iconImageView)
        
        // Heart Image View
        heartImageView.image = #imageLiteral(resourceName: "heartFilledRed")
        heartImageView.isUserInteractionEnabled = true
        heartImageView.layer.shadowRadius = 3
        heartImageView.layer.shadowOpacity = 0.25
        heartImageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        heartImageView.layer.shadowColor = UIColor.white.cgColor
        let tapHeartGesture = UITapGestureRecognizer(target: self, action: #selector(heartTapped))
        heartImageView.addGestureRecognizer(tapHeartGesture)
        contentView.addSubview(heartImageView)
    }
    
    func setupConstraints() {
        
        let views: [String: UIView] = [
            "iconImageView": iconImageView,
            "heartImageView": heartImageView
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[iconImageView]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[iconImageView]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[heartImageView(40)]-2-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[heartImageView(40)]-2-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }
}

// MARK: - Private Functions
fileprivate extension PonyCollectionViewCell {
    
    func setupUI() {
        guard let pony = pony else { return }
        
        iconImageView.pin_setImage(from: URL(string: pony.thumb)!)
        heartImageView.image = favorited ? #imageLiteral(resourceName: "heartFilled") : #imageLiteral(resourceName: "heartFilledRed")
    }
    
    @objc func heartTapped(sender: AnyObject) {
        guard let pony = pony else { return }
        
        favorited = favorited ? false : true
        if favorited {
            Favorites.shared.addPony(pony: pony)
        } else {
            Favorites.shared.remove(removePony: pony)
        }
        
        delegate?.heartTapped(for:pony)
    }
}
