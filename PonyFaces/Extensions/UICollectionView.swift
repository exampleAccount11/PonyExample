
import UIKit


//MARK - Styles
extension UICollectionView {
    func ponyCollectionView() {
        backgroundColor = UIColor.lightPink
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        alwaysBounceVertical = true
        alwaysBounceHorizontal = false
        layer.cornerRadius = 10
        sizeToFit()
        
        register(PonyCollectionViewCell.self)
    }
    
    func tagsCollectionView() {
        layer.cornerRadius = 5
        backgroundColor = UIColor.lightPurple
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        alwaysBounceVertical = false
        alwaysBounceHorizontal = true
        
        register(TagCollectionViewCell.self)
    }
}

// MARK: - ReusableCell Protocol
extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ type: T.Type) where T: ReusableCell {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    func dequeueCell<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T where T: ReusableCell {
        if let dequeuedCell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T {
            return dequeuedCell
        }
        return type.init(frame: CGRect.zero)
    }
}
