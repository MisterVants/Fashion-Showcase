//
//  ProductCollectionViewCell.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 04/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    static let infoViewHeight: CGFloat = 80
    static let imageAspectRatio: CGFloat = 1.25
    
    static func proportionalHeight(forWidth width: CGFloat) -> CGFloat {
        return width * imageAspectRatio + infoViewHeight
    }
    
    var viewModel: ProductViewModel?
    
    private lazy var productImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.gothamMedium(11)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.gothamMedium(11)
        return label
    }()
    
    private lazy var auxiliaryPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.gothamMedium(11)
        return label
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        layoutView()
    }
    
    private func setupView() {
        clipsToBounds = true
        layer.cornerRadius = 5
        
        contentView.addSubview(productImageView)
        contentView.addSubview(infoView)
        contentView.addSubview(nameLabel)
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
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor, multiplier: ProductCollectionViewCell.imageAspectRatio)
        ]
        
        let infoViewConstraints: [NSLayoutConstraint] = [
            infoView.heightAnchor.constraint(equalToConstant: ProductCollectionViewCell.infoViewHeight),
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        let nameLabelConstraints: [NSLayoutConstraint] = [
            nameLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -8)
        ]
        
        let priceLabelConstraints: [NSLayoutConstraint] = [
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ]
        
        let auxPriceLabelConstraints: [NSLayoutConstraint] = [
            auxiliaryPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            auxiliaryPriceLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -4)
        ]

        let activityIndicatorConstraints: [NSLayoutConstraint] = [
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0)
        ]
        
        let viewConstraints = [imageViewConstraints,
                               infoViewConstraints,
                               nameLabelConstraints,
                               priceLabelConstraints,
                               auxPriceLabelConstraints,
                               activityIndicatorConstraints].flatMap { $0 }
        
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    func setViewModel(_ viewModel: ProductViewModel?) {
        self.viewModel = viewModel
        
        nameLabel.text = viewModel?.productName
        priceLabel.text = viewModel?.productPrice
        auxiliaryPriceLabel.attributedText = viewModel?.supplementaryPrice
        
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
        nameLabel.text = nil
        priceLabel.text = nil
        productImageView.image = nil
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
