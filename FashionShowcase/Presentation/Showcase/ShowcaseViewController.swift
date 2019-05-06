//
//  ShowcaseViewController.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 04/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import UIKit

class ShowcaseViewController: UIViewController {
    
    var presenter: ShowcasePresenter?
    
    private lazy var collectionView: UICollectionView = {
        let collectionView              = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor  = UIColor.App.backgroundLightGray
        collectionView.register(ProductCollectionViewCell.self)
        return collectionView
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Não foi possível carregar a loja."
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.gothamMedium(15)
        label.textColor = UIColor.App.textDarkGray
        return label
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(refreshIcon, for: .normal)
        button.tintColor = UIColor.App.smoothRed
        return button
    }()
    
    private let activityView = UIActivityIndicatorView(style: .whiteLarge)
    private let backIcon = UIImage(named: "left-arrow")
    private let cartIcon = UIImage(named: "shopping-cart")
    private let refreshIcon = UIImage(named: "refresh")?.withRenderingMode(.alwaysTemplate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layoutView()
        
        startLoadingData()
    }
    
    private func setupView() {
        navigationItem.title = "LOJA"
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.App.smoothRed
        navigationController?.navigationBar.backIndicatorImage = backIcon
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backIcon
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: cartIcon, style: .plain, target: self, action: #selector(didPressShoppingCartButton(_:)))
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        view.addSubview(infoLabel)
        view.addSubview(refreshButton)
        view.addSubview(activityView)
        
        infoLabel.isHidden = true
        refreshButton.isHidden = true
        
        refreshButton.addTarget(self, action: #selector(reloadData), for: .touchUpInside)
    }
    
    private func layoutView() {
        collectionView.constraintInside(view.safeAreaLayoutGuide)
        
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let infoLabelConstraints: [NSLayoutConstraint] = [
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.topAnchor.constraint(equalTo: refreshButton.bottomAnchor, constant: 32)
        ]
        
        let refreshButtonConstraints: [NSLayoutConstraint] = [
            refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            refreshButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -48)
        ]
        
        let activityConstraints: [NSLayoutConstraint] = [
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        let viewConstraints = [infoLabelConstraints,
                               refreshButtonConstraints,
                               activityConstraints].flatMap { $0 }
        
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    private func startLoadingData() {
        activityView.isHidden = false
        activityView.startAnimating()
        presenter?.loadShowcase()
    }
    
    @objc
    func didPressShoppingCartButton(_ sender: UIButton) {
        presenter?.openShoppingCart()
    }
    
    @objc
    func reloadData() {
        infoLabel.isHidden = true
        refreshButton.isHidden = true
        activityView.isHidden = false
        activityView.startAnimating()
        presenter?.loadShowcase()
    }
}

extension ShowcaseViewController: ShowcasePresenterDelegate {
    
    func onLoadFinish() {
        DispatchQueue.main.async {
            self.activityView.stopAnimating()
            self.activityView.isHidden = true
            
            if self.presenter?.numberOfDisplayedItems == 0 {
                self.infoLabel.isHidden = false
                self.refreshButton.isHidden = false
            }
        }
    }
    
    func onLoadSuccess() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func onAlertableError(_ title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension ShowcaseViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setViewModel(presenter?.productViewModel(for: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfDisplayedItems ?? 0
    }
}

extension ShowcaseViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width / 2) - 15
        let height = ProductCollectionViewCell.proportionalHeight(forWidth: width)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 10, bottom: 80, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension ShowcaseViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.selectedItem(at: indexPath)
    }
}

