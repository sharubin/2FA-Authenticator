//
//  MainScreenViewController.swift
//  Authenticator 2FA OTP
//
//  Created by Artsem Sharubin on 06.05.2022.
//

import UIKit
import SPQRCode

class MainViewController: UIViewController {
    
    var array = [Password]()
    
    var diffableDataSource: UICollectionViewDiffableDataSource<Section, Password>!
    
    var rootView: MainScreenView {
        self.view as! MainScreenView
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = MainScreenView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(reload), userInfo: nil, repeats: true)
        setupDiffableDataSource()
        updateDataSource()
    }
    
    private func setupDiffableDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: rootView.timePasswordCollectionView, cellProvider: { collectionView, indexPath, model in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimePasswordCollectionViewCell.identifier, for: indexPath) as! TimePasswordCollectionViewCell
            cell.updateCell(model: model)
            
            return cell
        })
    }
    
    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Password>()
        snapshot.appendSections([.first])
        snapshot.appendItems(array)
        
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }

    private func setup() {
        navigationItem.title = "Authenticator"
        navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.isHidden = true
        rootView.scrollView.delegate = self
        
        rootView.timePasswordCollectionView.delegate = self
        rootView.scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .primaryActionTriggered)
    }
        
    @objc private func reload() {
        rootView.timePasswordCollectionView.reloadData()
        updateDataSource()
    }
    
    private func cutSymbols(model: SPQRCodeData) -> String {
        var string = "\(model)"
        for _ in 0...3 {
            string.remove(at: string.startIndex)
        }
        string.remove(at: string.index(before: string.endIndex))
        
        return string
    }
    
    private func cutStringToLoginAndWebsite(string: String) -> [String] {
        var cuttedString = string
        cuttedString.remove(at: cuttedString.startIndex)
        let array = cuttedString.components(separatedBy: ":")
        
        return array
    }
    
    private func alertWithError(controller: UIViewController) {
        let alert = UIAlertController(title: "Error", message: "This code doesn't contain token for authentication", preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(actionOK)
        controller.present(alert, animated: true, completion: nil)
    }
    
    @objc func scanButtonTapped() {
        SPQRCode.scanning(
            detect: { data, controller in
                return data
            },
            handled: { [weak self] data, controller in
                guard let self = self else { return }
                let tranformedData = self.cutSymbols(model: data)
                var arrayWithLoginAndWebsite = [String]()
                var login = ""
                var website = ""
                guard let components = URLComponents(string: tranformedData) else {
                    self.alertWithError(controller: controller)
                    return
                }
                guard components.scheme != nil else {
                    self.alertWithError(controller: controller)
                    return
                }
                guard "\(components)".contains("secret") else {
                    self.alertWithError(controller: controller)
                    return
                }
                guard "\(components)".contains("totp") else {
                    self.alertWithError(controller: controller)
                    return
                }
                arrayWithLoginAndWebsite = self.cutStringToLoginAndWebsite(string: components.path)
                if arrayWithLoginAndWebsite.count > 1 {
                    website = arrayWithLoginAndWebsite[0]
                    login = arrayWithLoginAndWebsite[1]
                }
                self.array.append(Password(oneTimePassword: tranformedData, website: website, login: login))
                self.updateDataSource()
                controller.dismiss(animated: true)
            },
            on: self
        )
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("scrolling")
        navigationItem.searchController?.searchBar.isHidden = false
    }
}
