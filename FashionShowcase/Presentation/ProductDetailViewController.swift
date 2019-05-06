//
//  ProductDetailViewController.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 05/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    var presenter: ProductDetailPresenter?
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var auxiliaryPriceLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var sizesStackView: UIStackView!
    
    private var radioButtons: [SizeButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addToCartButton.addTarget(self, action: #selector(didPressAddToCart(_:)), for: .touchUpInside)
        styleView()
        fillView()
    }
    
    func styleView() {
        
        productImageView.contentMode = .scaleAspectFill
        
        sizesStackView.distribution = .equalSpacing
        sizesStackView.alignment = .center
    }
    
    func fillView() {
        productNameLabel.text = presenter?.viewModel.productName
        priceLabel.text = presenter?.viewModel.productPrice
        auxiliaryPriceLabel.attributedText = presenter?.viewModel.supplementaryPrice
        
        // Workaround: Adding an empty view at the start and end of stack arranged subviews prevents horizontal stretching when the stack contains only a single view
        sizesStackView.addArrangedSubview(UIView())
        presenter?.viewModel.availableSizes.enumerated().forEach {
            let sizeButton = SizeButton()
            sizeButton.tag = $0
            sizeButton.setTitle($1.size, for: .normal)
            sizeButton.setTitleColor(.blue, for: .normal)
            sizeButton.addTarget(self, action: #selector(didSelectSize(_:)), for: .touchUpInside)
            radioButtons.append(sizeButton)
            sizesStackView.addArrangedSubview(sizeButton)
        }
        sizesStackView.addArrangedSubview(UIView())
        
        presenter?.viewModel.productImageData.bindAndUpdate { [weak self] data in
            DispatchQueue.main.async {
                if let imageData = data, let image = UIImage(data: imageData) {
                    self?.productImageView.image = image
                }
            }
        }
        
        presenter?.selectSize(index: 0)
        presenter?.viewModel.loadProductImage()
    }
    
    @objc
    func didSelectSize(_ sender: UIButton) {
        presenter?.selectSize(index: sender.tag)
    }
    
    @objc
    func didPressAddToCart(_ sender: UIButton) {
        presenter?.addProductToCart()
        dismiss(animated: true) {
            self.presenter?.didFinishDismissingView()
        }
    }
}

extension ProductDetailViewController: ProductDetailPresenterDelegate {
    
    func onSizeSelect(_ index: Int) {
        radioButtons.enumerated().forEach {
            $0 == index ? $1.select() : $1.deselect()
        }
    }
}

class SizeButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderColor = UIColor.blue.cgColor
        layer.borderWidth = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
    
    func select() {
        backgroundColor = .red
    }
    
    func deselect() {
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
