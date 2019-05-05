//
//  ProductCollectionViewCell.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 04/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    var viewModel: ProductViewModel?
    
    private lazy var productImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var auxiliaryPriceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        layoutView()
    }
    
    private func setupView() {
        layer.cornerRadius = 5
        
        backgroundColor = .white
        
        contentView.addSubview(productImageView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(auxiliaryPriceLabel)
        contentView.addSubview(activityIndicator)
    }
    
    private func layoutView() {
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let imageViewConstraints: [NSLayoutConstraint] = [
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50)
        ]
        
        let priceLabelConstraints: [NSLayoutConstraint] = [
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ]
        
        let activityIndicatorConstraints: [NSLayoutConstraint] = [
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0)
        ]
        
        let viewConstraints = [imageViewConstraints,
                               priceLabelConstraints,
                               activityIndicatorConstraints].flatMap { $0 }
        
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    func setViewModel(_ viewModel: ProductViewModel?) {
        self.viewModel = viewModel
        
        priceLabel.text = viewModel?.productPrice
        
        viewModel?.isLoadingImage.bindAndUpdate { [weak self] loading in
            DispatchQueue.main.async {
                loading ? self?.showActivityIndicator() : self?.hideActivityIndicator()
            }
        }
        
        viewModel?.productImageData.bindAndUpdate { [weak self] data in
            DispatchQueue.main.async {
                if let imageData = data, let image = UIImage(data: imageData) {
                    self?.productImageView.image = image
                }
            }
        }
        
        viewModel?.loadProductImage()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.productImageData.free()
        viewModel?.isLoadingImage.free()
        viewModel = nil
    }
    
    private func showActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
