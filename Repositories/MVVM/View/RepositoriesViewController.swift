//
//  RepositoriesViewController.swift
//  Repositories
//
//  Created by hirrasalim on 11/03/2025.
//
import UIKit
import Combine

class RepositoriesViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    private let viewModel = RepositoriesViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let refreshControl = UIRefreshControl()
    
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshRepositories), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        viewModel.refreshRepositories()
        setupRefreshControl()
        navigationController?.delegate = self
        navigationController?.title = "Repositories"
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func refreshRepositories() {
        viewModel.refreshRepositories()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
    private func bindViewModel() {
        viewModel.$repositories
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if !isLoading {
                    self?.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        
        
        viewModel.$error
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.showError(error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension RepositoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath)
        
        
        let repository = viewModel.repositories[indexPath.row]
        cell.textLabel?.text = repository.name?.capitalized
        cell.detailTextLabel?.text = "Stars: \(repository.star)"
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.repositories.count - 1 {
            viewModel.fetchRepositories()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get the selected repository
        // Scale animation
        if let cell = tableView.cellForRow(at: indexPath) {
            UIView.animate(withDuration: 0.2, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }, completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    cell.transform = .identity
                }
            })
        }
        let repository = viewModel.repositories[indexPath.row]
        let detailsViewModel = RepositoryDetailsViewModel(repository: repository)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = storyboard.instantiateViewController(withIdentifier: "RepositoryDetailsViewController") as! RepositoryDetailsViewController
        detailsViewController.viewModel = detailsViewModel
        
        if let navigationController = navigationController {
            navigationController.pushViewController(detailsViewController, animated: true)
        } else {
            print("Navigation controller is nil")
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransitionAnimator()
    }
    
}
