
import UIKit

protocol PonyModalViewControllerDelegate {
    func heartTapped(for: Pony)
}

class PonyModalViewController: UIViewController {
    
    // Outlets
    let containerView = UIView.autolayoutView()
    let ponyImageView = UIImageView.autolayoutView()
    let heartImageView = UIImageView.autolayoutView()
    
    // Delegate
    var delegate: PonyModalViewControllerDelegate?
    
    //Mutable Properties
    var favorited: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    var pony: Pony? = nil {
        didSet {
            favorited = Favorites.shared.isFavorited(pony: pony!)
        }
    }
}

// MARK: - Life Cycle
extension PonyModalViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
}

// MARK: - Setup
extension PonyModalViewController {
    
    func setupViews() {
        // Container View
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 10
        view.addSubview(containerView)
        
        // Pony Image View
        ponyImageView.layer.cornerRadius = 10
        ponyImageView.clipsToBounds = true
        ponyImageView.sizeToFit()
        containerView.addSubview(ponyImageView)
        
        // Heart Image View
        heartImageView.tintColor = UIColor.white
        heartImageView.isUserInteractionEnabled = true
        let tapHeartGesture = UITapGestureRecognizer(target: self, action: #selector(heartTapped))
        heartImageView.addGestureRecognizer(tapHeartGesture)
        containerView.addSubview(heartImageView)
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        view.addGestureRecognizer(dismissTap)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    func setupConstraints() {
        
        let views: [String: UIView] = [
            "containerView": containerView,
            "ponyImageView": ponyImageView,
            "heartImageView": heartImageView
        ]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[containerView]-120-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[containerView]-40-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[ponyImageView]-60-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[heartImageView]-5-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[ponyImageView]-15-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-125-[heartImageView]-125-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
    }
}

//MARK: - Private Functions
fileprivate extension PonyModalViewController {
    
    func updateUI() {
        heartImageView.image = favorited ? #imageLiteral(resourceName: "heartRedWhite") : #imageLiteral(resourceName: "heartFilledRed")
        
        guard let urlString = pony?.full, let url = URL(string: urlString) else { return }
        
        ponyImageView.pin_setImage(from: url)
    }
    
    @objc func heartTapped() {
        guard let pony = pony else { return }
        favorited = favorited ? false : true
        
        if favorited {
            Favorites.shared.addPony(pony: pony)
        } else {
            Favorites.shared.remove(removePony: pony)
        }
        
        delegate?.heartTapped(for: pony)
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}
