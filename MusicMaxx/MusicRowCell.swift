//
//  MusicRowCell.swift
//  MusicMaxx
//
//  Created by Smart Castle M1A2009 on 14.04.2024.
//

import UIKit

class MusicRowCell: UICollectionViewCell, UIGestureRecognizerDelegate{
    
    lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "free-icon-font-heart-3916579")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var pan: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer()
        return pan
    }()
    
    lazy var deleteLabel: UILabel = {
        let label = UILabel()
        label.text = "удалить из медиатеки"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        setupUI()
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
    }
    
    
    func setupUI() {
        contentView.addSubview(contentImageView)
        contentImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        contentImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        contentImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        contentImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        contentImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        contentView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: contentImageView.rightAnchor, constant: 10).isActive = true
        
        contentView.addSubview(descLabel)
        descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        descLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor, constant: 0).isActive = true
        
        contentView.addSubview(likeButton)
        likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25)
        likeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        likeButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        likeButton.leftAnchor.constraint(greaterThanOrEqualTo: nameLabel.rightAnchor, constant: 20).isActive = true
        
        backgroundColor = UIColor.red
        contentView.backgroundColor = .white
        insertSubview(deleteLabel, belowSubview: self.contentView)
        
        
        
    }
    override func prepareForReuse() {
        self.contentView.frame = self.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if pan.state == .changed {
                let translation = pan.translation(in: self)
                let width = contentView.frame.width
                let height = contentView.frame.height
                
                // Adjust contentView frame
                contentView.frame = CGRect(x: translation.x, y: 0, width: width, height: height)
                
                // Adjust deleteLabel frame
                let deleteLabelX: CGFloat
                let deleteLabelWidth: CGFloat
                if translation.x > 0 {
                    // Pan to the right
                    deleteLabelX = -width
                    deleteLabelWidth = width
                    print("right")
                    deleteLabel.textAlignment = .left
                } else {
                    // Pan to the left
                    deleteLabelX = frame.width
                    deleteLabelWidth = width
                    print("left")
                    deleteLabel.textAlignment = .right
                }
                deleteLabel.frame = CGRect(x: deleteLabelX, y: 0, width: deleteLabelWidth, height: height)
            }
        }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        if pan.state == UIGestureRecognizer.State.began {
            
        } else if pan.state == UIGestureRecognizer.State.changed {
            self.setNeedsLayout()
        } else {
            if abs(pan.velocity(in: self).x) > 500 {
                let collectionView: UICollectionView = self.superview as! UICollectionView
                let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
                collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            }
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
    }
    
    func configure(_ data: SavedMusicModel?) {
        nameLabel.text = data?.title
        descLabel.text = data?.artistName
        contentImageView.kf.setImage(with: URL(string: data?.avatarUrl ?? ""))
    }
    
    func configure(_ data: SearchResultModel?) {
        nameLabel.text = data?.title
        descLabel.text = data?.user?.name
        contentImageView.kf.setImage(with: URL(string: data?.artworkUrl ?? ""))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension UIImageView {
    func downloaded(from url: URL, contentMode  mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
