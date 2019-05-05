//
//  ShowcaseViewController.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 04/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import UIKit

class ShowcaseViewController: UIViewController {
    
//    var didSelectProduct: (() -> Void)?
    
    var presenter: ShowcasePresenter?
    
    private lazy var collectionView: UICollectionView = {
//        let layout                      =
//        layout.minimumInteritemSpacing  = 10
//        layout.minimumLineSpacing       = 10
        let collectionView              = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor  = .clear
        collectionView.register(ProductCollectionViewCell.self)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layoutView()
        
        presenter?.loadShowcase()
    }
    
    private func setupView() {
        navigationItem.title = "App Title"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
    }
    
    private func layoutView() {
        collectionView.constraintInside(view.safeAreaLayoutGuide)
    }
}

extension ShowcaseViewController: ShowcasePresenterDelegate {
    
    func onLoadFinish() {
        
    }
    
    func onLoadSuccess() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func onAlertableError(_ title: String, message: String) {
        
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
        let height = width * 1.3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return UIEdgeInsets(top: 15, left: 10, bottom: 80, right: 10)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension ShowcaseViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.selectedItem(at: indexPath)
    }
}

