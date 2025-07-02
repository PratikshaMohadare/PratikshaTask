//
//  PortfolioViewController.swift
//  PratikshaTask
//
//  Created by Pratiksha on 01/07/25.
//

import UIKit

class PortfolioViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = PortfolioViewModel(holdings: [])
    private var summaryViewHeightConstraint: NSLayoutConstraint!

    // MARK: - UI Components
    private lazy var segmentedControl = CustomSegmentedControl(buttonTitles: ["POSITIONS", "HOLDINGS"])
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let summaryView = PortfolioSummaryView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let errorLabel = UILabel(font: .systemFont(ofSize: 16), textColor: .gray, textAlignment: .center)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupBindings()
        fetchData()
    }

    // MARK: - UI Setup
    private func setupNavigationBar() {
        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(profileTapped))
        
        let titleLabel = UILabel(text: "Portfolio", font: .systemFont(ofSize: 22, weight: .bold), textColor: .white)
        self.navigationItem.leftBarButtonItems = [profileButton, UIBarButtonItem(customView: titleLabel)]
        
        // Set right bar button items
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(filterTapped))
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchTapped))
        navigationItem.rightBarButtonItems = [searchButton, filterButton]
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 1/255, green: 45/255, blue: 102/255, alpha: 1.0)
        appearance.shadowColor = .clear // No shadow for a flat look
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white // Make icons white
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.backgroundColor = .white
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HoldingTableViewCell.self, forCellReuseIdentifier: "HoldingCell")
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.dataSource = self
        
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.isHidden = true
        errorLabel.numberOfLines = 0
        
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        view.addSubview(summaryView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)

        summaryViewHeightConstraint = summaryView.heightAnchor.constraint(equalToConstant: 90)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 44),

            // **FIX: Add spacing between segmented control and table view**
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: summaryView.topAnchor),
            
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            summaryView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            summaryViewHeightConstraint,
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Data Handling
    private func fetchData() {
        activityIndicator.startAnimating()
        errorLabel.isHidden = true
        tableView.isHidden = true
        summaryView.isHidden = true
        
        viewModel.fetchUserHoldings { [weak self] result in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            
            switch result {
            case .success:
                self.tableView.isHidden = false
                self.summaryView.isHidden = false
                self.tableView.reloadData()
                self.summaryView.update(with: self.viewModel)
            case .failure(let error):
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Failed to load holdings.\n(\(error.localizedDescription))"
            }
        }
    }
    
    // MARK: - Bindings & Actions
    private func setupBindings() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleSummaryView))
        summaryView.addGestureRecognizer(tapGesture)
        summaryView.isUserInteractionEnabled = true
    }

    @objc private func toggleSummaryView() {
        let isExpanded = summaryView.isExpanded
        let newHeight: CGFloat = isExpanded ? 90 : 230
        summaryViewHeightConstraint.constant = newHeight

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.summaryView.toggleState()
        }, completion: nil)
    }

    @objc private func filterTapped() { /* Placeholder */ }
    @objc private func searchTapped() { /* Placeholder */ }
    @objc private func profileTapped() { /* Placeholder */ }
}

// MARK: - UITableViewDataSource
extension PortfolioViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.holdingsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HoldingCell", for: indexPath) as? HoldingTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .white
        if let holding = viewModel.getHolding(at: indexPath.row) {
            cell.configure(with: holding)
        }
        return cell
    }
}
