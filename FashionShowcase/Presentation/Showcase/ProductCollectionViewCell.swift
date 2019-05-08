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
    
    private lazy var notFoundLabel: UILabel = {
        let label = UILabel()
        label.text = "Imagem não\ndisponível"
        label.font = UIFont.gothamMedium(13)
        label.textColor = UIColor.App.textLightGray
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
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
        label.textColor = UIColor.App.textLightGray
        return label
    }()
    
    private let saleTag = SaleTag()
    
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        layoutView()
    }
    
    private func setupView() {
        clipsToBounds = true
        layer.cornerRadius = 5
        saleTag.isHidden = true
        notFoundLabel.isHidden = true
        
        contentView.addSubview(notFoundLabel)
        contentView.addSubview(productImageView)
        contentView.addSubview(infoView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(auxiliaryPriceLabel)
        contentView.addSubview(saleTag)
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
        
        let notFoundLabelConstraints: [NSLayoutConstraint] = [
            notFoundLabel.centerXAnchor.constraint(equalTo: productImageView.centerXAnchor),
            notFoundLabel.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor)
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
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ]
        
        let auxPriceLabelConstraints: [NSLayoutConstraint] = [
            auxiliaryPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            auxiliaryPriceLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -4)
        ]
        
        let saleTagConstraints: [NSLayoutConstraint] = [
            saleTag.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            saleTag.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            saleTag.heightAnchor.constraint(equalToConstant: 24),
            saleTag.widthAnchor.constraint(equalToConstant: 64)
        ]

        let activityIndicatorConstraints: [NSLayoutConstraint] = [
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0)
        ]
        
        let viewConstraints = [imageViewConstraints,
                               notFoundLabelConstraints,
                               infoViewConstraints,
                               nameLabelConstraints,
                               priceLabelConstraints,
                               auxPriceLabelConstraints,
                               saleTagConstraints,
                               activityIndicatorConstraints].flatMap { $0 }
        
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    func setViewModel(_ viewModel: ProductViewModel?) {
        self.viewModel = viewModel
        
        nameLabel.text = viewModel?.productName
        priceLabel.text = viewModel?.productPrice
        auxiliaryPriceLabel.attributedText = viewModel?.supplementaryPrice
        
        if viewModel?.isProductOnSale == true {
            saleTag.isHidden = false
            saleTag.text = viewModel?.discountAmount
            priceLabel.textColor = UIColor.App.textGreen
        }
        
        viewModel?.isLoadingImage.bindAndUpdate { [weak self] loading in
            DispatchQueue.main.async {
                loading ? self?.showActivityIndicator() : self?.hideActivityIndicator()
            }
        }
        
        viewModel?.productImageData.bindAndUpdate { [weak self] data in
            DispatchQueue.main.async {
                if let imageData = data, let image = UIImage(data: imageData) {
                    self?.productImageView.image = image
                    self?.notFoundLabel.isHidden = true
                } else {
                    if viewModel?.isLoadingImage.value == false {
                        self?.notFoundLabel.isHidden = false
                    }
                }
            }
        }
        
        viewModel?.loadProductImage()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        priceLabel.textColor = .black
        
        nameLabel.text = nil
        priceLabel.text = nil
        productImageView.image = nil
        saleTag.isHidden = true
        
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

class SaleTag: UIView {
    
    var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.gothamMedium(11)
        label.textColor = .white
        label.textAlignment = NSTextAlignment.center
        label.text = "00% OFF"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.App.smoothRed
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
