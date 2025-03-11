//
//  RepositoryDetailsViewController.swift
//  Repositories
//
//  Created by hirrasalim on 11/03/2025.
//
import UIKit
import Combine
class RepositoryDetailsViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var ownerAvatarImageView: UIImageView!
    @IBOutlet weak var ownerProfileButton: UIButton!
    
    var viewModel: RepositoryDetailsViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    static func create(with viewModel: RepositoryDetailsViewModel) -> RepositoryDetailsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RepositoryDetailsViewController") as! RepositoryDetailsViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        bookmarkButton.addTarget(self, action: #selector(toggleBookmark), for: .touchUpInside)
        ownerProfileButton.addTarget(self, action: #selector(openOwnerProfile), for: .touchUpInside)
        
        // Customize profile button
        ownerProfileButton.addTarget(self, action: #selector(openOwnerProfile), for: .touchUpInside)
        
        // Add corner radius and border to profile button
        ownerProfileButton.layer.cornerRadius = 8 // Adjust the radius as needed
        ownerProfileButton.layer.borderWidth = 1
        ownerProfileButton.layer.borderColor = UIColor.black.cgColor // Adjust the color as needed
        ownerProfileButton.setTitleColor(.black, for: .normal) // Match text color with border
        
        // Round the avatar image
        ownerAvatarImageView.layer.cornerRadius = ownerAvatarImageView.frame.size.width / 2
        ownerAvatarImageView.clipsToBounds = true
        
    }
    
    private func bindViewModel() {
        // Bind repositoryName to nameLabel
        viewModel.$repositoryName
            .receive(on: RunLoop.main)
            .sink { [weak self] name in
                self?.nameLabel.text = "Name: \(name)"
            }
            .store(in: &cancellables)
        
        // Bind repositoryStars to starsLabel
        viewModel.$repositoryStars
            .receive(on: RunLoop.main)
            .sink { [weak self] stars in
                self?.starsLabel.text = "Stars: \(stars)"
            }
            .store(in: &cancellables)
        
        // Bind isBookmarked to bookmarkButton
        viewModel.$isBookmarked
            .receive(on: RunLoop.main)
            .sink { [weak self] isBookmarked in
                let imageName = isBookmarked ? "bookmark.fill" : "bookmark"
                self?.bookmarkButton.setImage(UIImage(systemName: imageName), for: .normal)
            }
            .store(in: &cancellables)
        // Bind owner details
        
        viewModel.$ownerAvatarURL
            .receive(on: RunLoop.main)
            .sink { [weak self] urlString in
                if let url = URL(string: urlString) {
                    self?.loadImage(from: url)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    @objc private func toggleBookmark() {
        // Toggle bookmark state
        viewModel.toggleBookmark()
        
        // Bounce animation
        UIView.animate(withDuration: 0.2, animations: {
            self.bookmarkButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.bookmarkButton.transform = .identity
            }
        })
    }
    
    @objc private func openOwnerProfile() {
        // Scale animation
        UIView.animate(withDuration: 0.2, animations: {
            self.ownerProfileButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.ownerProfileButton.transform = .identity
            }
            
            // Open profile URL
            if let url = URL(string: self.viewModel.ownerProfileURL) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
    }
    // MARK: - Helper Methods
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.ownerAvatarImageView.image = image
                }
            }
        }.resume()
    }
}
