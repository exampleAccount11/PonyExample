
import UIKit

class SearchViewController: UIViewController {
    
    // Mutable Properties
    var searchResults: [String] = []
    var searchTerm: String = ""
    var searchedTags = [String]()
    var tags = [String]()
    var ponies = [Pony]()
    
    // Outlets
    let searchBar = UISearchBar.autolayoutView()
    let searchResultsTableViewController = UITableView.autolayoutView()
    let cancelButton = UIButton.autolayoutView()
    let contentView = UIView.autolayoutView()
    let favoritesButton = UIButton.autolayoutView()
    var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    var ponyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let tagsLabel = UILabel.autolayoutView()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        registerForNotifications()
        getTags()
        updatePonies(with: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if favoritesButton.tag == 1 {
            setPonies(ponies: Favorites.shared.favorites, clear: true)
        } else {
            ponyCollectionView.reloadData()
        }
    }
}

extension SearchViewController {
    func setupViews() {
        
        // View Properties
        view.backgroundColor = UIColor.lightPurple
        
        // Search Bar
        searchBar.delegate = self
        searchBar.placeholder = "Search for tags"
        searchBar.returnKeyType = .search
        searchBar.searchBarStyle = .minimal
        
        let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.attributedPlaceholder = NSAttributedString(string:searchBar.placeholder!,attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightPink])
        searchTextField?.textColor = UIColor.lightPink
        searchTextField?.leftViewMode = .never
        let glassIconView = searchTextField?.rightView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = UIColor.lightPink
        
        searchBar.setShowsCancelButton(false, animated: false)
        view.addSubview(searchBar)
        
        let layoutPill = UICollectionViewFlowLayout()
        layoutPill.estimatedItemSize = CGSize(width: 1, height: 1)
        layoutPill.scrollDirection = .horizontal
        
        // Tags Collection View
         tagCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layoutPill)
         tagCollectionView.dataSource = self
         tagCollectionView.delegate = self
         tagCollectionView.tagsCollectionView()
        
        view.addSubview( tagCollectionView)
        
        // Favorites Button View
        favoritesButton.setImage(#imageLiteral(resourceName: "heartFilledRed"), for: .normal)
        favoritesButton.addTarget(self, action: #selector(favoritesTapped), for: .touchUpInside)
        view.addSubview(favoritesButton)
        
        // Pony Collection View
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 9, bottom: 10, right: 9)
        layout.itemSize = CGSize(width: 115, height: 115)
        layout.scrollDirection = .vertical
        
        ponyCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        ponyCollectionView.ponyCollectionView()
        ponyCollectionView.dataSource = self
        ponyCollectionView.delegate = self
        contentView.addSubview(ponyCollectionView)
        
        // Search Results Table View
        searchResultsTableViewController.dataSource = self
        searchResultsTableViewController.delegate = self
        searchResultsTableViewController.layer.cornerRadius = 10
        searchResultsTableViewController.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(searchResultsTableViewController)
        
        //Content View
        contentView.sizeToFit()
        view.addSubview(contentView)
        
        searchResultsTableViewController.alpha = 0
    }
    
    func setupConstraints() {
        
        let views: [String: UIView] = [
            "searchBar": searchBar,
            "contentView": contentView,
            "searchResultsTableViewController": searchResultsTableViewController,
            "ponyCollectionView": ponyCollectionView,
            "tagCollectionView": tagCollectionView,
            "favoritesButton": favoritesButton
        ]
        let metrics: [String: CGFloat] = [
            "topMargin": 20
        ]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-topMargin-[searchBar][tagCollectionView(35)]-10-[contentView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[searchBar]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[tagCollectionView]-5-[favoritesButton(35)]-15-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[searchBar][favoritesButton(35)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[ponyCollectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[ponyCollectionView]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[searchResultsTableViewController]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[searchResultsTableViewController]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
    }
    
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func getTags() {
        PonyAPIClient.getTags().then { tagsReturned in
            self.tags = tagsReturned.map { $0.lowercased() }
        }
    }
    
    @objc func favoritesTapped() {
        if favoritesButton.tag == 0 {
            favoritesButton.tag = 1
            searchResultsTableViewController.alpha = 0
            ponyCollectionView.alpha = 1
            ponies = [Pony]()
            favoritesButton.setImage(#imageLiteral(resourceName: "heartFilled"), for: .normal)
            searchBar.resignFirstResponder()
            setPonies(ponies:Favorites.shared.favorites, clear: true)
        } else if favoritesButton.tag == 1 {
            favoritesButton.tag = 0
            ponies = [Pony]()
            favoritesButton.setImage(#imageLiteral(resourceName: "heartFilledRed"), for: .normal)
            
            if searchedTags.count == 0 {
                // Fetch All
                updatePonies(with: "")
                return
            }
            
            _ = searchedTags.map { updatePonies(with: $0)}
        }
    }
    
    func setPonies(ponies: [Pony], clear: Bool) {
        
        self.ponies = ponies
        
        if self.ponies.count == 0 && favoritesButton.tag != 1 {
            PonyAPIClient.getPonysByTag(tag: "").then { ponies -> Void in
                self.setPonies(ponies: ponies, clear: true)
            }
            return
        }
        
        updatePonyCollectionView()
    }
    
    func updatePonyCollectionView() {
        self.ponyCollectionView.reloadData()
        self.ponyCollectionView.layoutIfNeeded()
        self.ponyCollectionView.layoutSubviews()
        self.tagCollectionView.reloadData()
        self.tagCollectionView.layoutIfNeeded()
        self.tagCollectionView.layoutSubviews()
    }
    
    func updatePonies(with tag: String) {
        PonyAPIClient.getPonysByTag(tag: tag).then { ponies -> Void in
            var ponyCollection = self.ponies
            for pony in ponies {
                if !self.ponies.contains(pony) {
                    ponyCollection.append(pony)
                }
            }
            self.setPonies(ponies: ponyCollection, clear: false)
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.resignFirstResponder()
        self.searchBar.text = ""
        
        let tag = self.searchResults[indexPath.row]
        
        guard !searchedTags.contains(tag) else { return }
        
        if searchedTags.count <= 0 {
            ponies = [Pony]()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.searchedTags.append(tag)
        updatePonies(with: tag)
    }
    
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, TagCollectionViewCellDelegate {
    
    // TagCollectionViewCellDelegate
    func removeTapped(tag: String) {
        searchedTags = searchedTags.filter {$0 != tag}
        
        PonyAPIClient.getPonysByTag(tag: tag).then { ponies -> Void in
            let ponies = self.ponies.filter { pony in
                let isFavorited = Favorites.shared.isFavorited(pony: pony) && self.favoritesButton.tag == 1
                var isInTags = false
                
                for tag in pony.tags {
                    for searchedTag in self.searchedTags {
                        if tag.contains(searchedTag) {
                            isInTags = true
                        }
                    }
                }
                
                if isFavorited || isInTags {
                    return true
                }
                
                return !ponies.contains(pony)
            }
            self.setPonies(ponies: ponies, clear: true)
        }
        
        tagCollectionView.reloadData()
        tagCollectionView.layoutIfNeeded()
        tagCollectionView.layoutSubviews()
    }
    
    // PonyCollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == ponyCollectionView else { return }
        
        let ponyLargeImageView = PonyModalViewController()
        ponyLargeImageView.pony = ponies[indexPath.row]
        ponyLargeImageView.modalPresentationStyle = .overCurrentContext
        ponyLargeImageView.delegate = self
        self.present(ponyLargeImageView, animated: true, completion: nil)
    }
    
    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == tagCollectionView {
            return searchedTags.count
        }
        
        if collectionView == ponyCollectionView {
            return ponies.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == ponyCollectionView {
            let ponyCell = collectionView.dequeueCell(PonyCollectionViewCell.self, for: indexPath)
            ponyCell.pony = ponies[indexPath.row]
            ponyCell.delegate = self
            ponyCell.favorited = Favorites.shared.isFavorited(pony: ponies[indexPath.row])
            return ponyCell
        }
        
        if collectionView == tagCollectionView {
            let tagCell = collectionView.dequeueCell(TagCollectionViewCell.self, for: indexPath)
            tagCell.tagString = searchedTags[indexPath.row]
            tagCell.delegate = self
            tagCell.setNeedsLayout()
            tagCell.layoutIfNeeded()
            return tagCell
        }
        return UICollectionViewCell()
    }
}

extension SearchViewController: PonyCollectionViewCellDelegate, PonyModalViewControllerDelegate {
    func heartTapped(for: Pony) {
        if favoritesButton.tag == 1 {
            setPonies(ponies: Favorites.shared.favorites, clear: true)
        }
        
        ponyCollectionView.reloadData()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults = tags.filter { $0.hasPrefix(searchText.lowercased())}
        searchResultsTableViewController.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        favoritesButton.setImage(#imageLiteral(resourceName: "heartFilledRed"), for: .normal)
        favoritesButton.tag = 0
        ponyCollectionView.alpha = 0
        searchResultsTableViewController.alpha = 1
        searchResults = tags
        searchResultsTableViewController.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchResultsTableViewController.alpha = 0
        ponyCollectionView.alpha = 1
    }
}

private extension SearchViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        var userInfo = notification.userInfo!
        guard let notificaitonInfo = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        var keyboardFrame = notificaitonInfo.cgRectValue
        
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset = self.searchResultsTableViewController.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.searchResultsTableViewController.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.searchResultsTableViewController.contentInset = UIEdgeInsets.zero
    }
}
