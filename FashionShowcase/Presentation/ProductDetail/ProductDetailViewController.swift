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
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var auxiliaryPriceLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var sizesStackView: UIStackView!
    
    private var radioButtons: [SizeButton] = []
    
    private let saleTag = SaleTag()
    private let backIcon = UIImage(named: "down-arrow")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetails()
        styleView()
        fillView()
    }
    
    private func setupDetails() {
        view.addSubview(saleTag)
        
        saleTag.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saleTag.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            saleTag.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            saleTag.widthAnchor.constraint(equalToConstant: 72),
            saleTag.heightAnchor.constraint(equalToConstant: 32)
            ])
        saleTag.isHidden = true
    }
    
    private func styleView() {
        navItem.title = ""
        navItem.leftBarButtonItem = UIBarButtonItem(image: backIcon, style: .plain, target: self, action: #selector(didPressBackButton(_:)))
        
        navigationBar.tintColor = UIColor.App.smoothRed
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        productImageView.contentMode = .scaleAspectFill
        
        productNameLabel.font = UIFont.gothamMedium(13)
        priceLabel.font = UIFont.gothamBold(15)
        auxiliaryPriceLabel.textColor = UIColor.App.textLightGray
        
        sizesStackView.distribution = .equalSpacing
        sizesStackView.alignment = .center
        
        addToCartButton.layer.cornerRadius = 24
        addToCartButton.titleLabel?.font = UIFont.gothamMedium(15)
        addToCartButton.backgroundColor = UIColor.App.smoothRed
        addToCartButton.setTitleColor(.white, for: .normal)
    }
    
    private func fillView() {
        addToCartButton.addTarget(self, action: #selector(didPressAddToCart(_:)), for: .touchUpInside)
        disableAddToCartButton()
        
        productNameLabel.text = presenter?.viewModel.productName
        priceLabel.text = presenter?.viewModel.productPrice
        auxiliaryPriceLabel.attributedText = presenter?.viewModel.supplementaryPrice
        
        if presenter?.viewModel.isProductOnSale == true {
            saleTag.isHidden = false
            saleTag.text = presenter?.viewModel.discountAmount
            priceLabel.textColor = UIColor.App.textGreen
        } else {
            priceLabel.textColor = .black
        }
        
        // WORKAROUND: - Adding an empty view at the start and end of stack view's arranged subviews prevents horizontal stretching when the stack contains only a single view
        sizesStackView.addArrangedSubview(UIView())
        presenter?.viewModel.availableSizes.enumerated().forEach {
            let sizeButton = makeSizeRadioButton(withTitle: $1.size, index: $0, enabled: $1.isAvailable)
            radioButtons.append(sizeButton)
            sizesStackView.addArrangedSubview(sizeButton)
        }
        sizesStackView.addArrangedSubview(UIView())
        // END WORKAROUND
        
        presenter?.viewModel.productImageData.bindAndUpdate { [weak self] data in
            DispatchQueue.main.async {
                if let imageData = data, let image = UIImage(data: imageData) {
                    self?.productImageView.image = image
                }
            }
        }
        
        presenter?.viewModel.loadProductImage()
    }
    
    @objc
    func didPressBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
    
    private func disableAddToCartButton() {
        addToCartButton.setTitle("Escolha um tamanho", for: .normal)
        addToCartButton.alpha = 0.34
        addToCartButton.isUserInteractionEnabled = false
    }
    
    private func enableAddToCartButton() {
        addToCartButton.setTitle("Adicionar ao carrinho", for: .normal)
        addToCartButton.alpha = 1.0
        addToCartButton.isUserInteractionEnabled = true
    }
    
    private func makeSizeRadioButton(withTitle title: String, index: Int, enabled: Bool) -> SizeButton {
        let sizeButton = SizeButton()
        sizeButton.tag = index
        sizeButton.setTitle(title, for: .normal)
        if enabled {
            sizeButton.addTarget(self, action: #selector(didSelectSize(_:)), for: .touchUpInside)
        } else {
            sizeButton.disableButton()
        }
        return sizeButton
    }
}



// MARK: - Presenter Delegate

extension ProductDetailViewController: ProductDetailPresenterDelegate {
    
    func onSizeSelect(_ index: Int) {
        radioButtons.enumerated().forEach {
            $0 == index ? $1.select() : $1.deselect()
        }
        enableAddToCartButton()
    }
}



// MARK: - Size selection radio button

extension ProductDetailViewController {
    
    class SizeButton: UIButton {
        
        private var identityColor: UIColor {
            return UIColor.App.smoothRed
        }
        
        private var whiteColor: UIColor {
            return UIColor.white
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            titleLabel?.font = UIFont.gothamBold(13)
            layer.borderColor = identityColor.cgColor
            layer.borderWidth = 2
            self.deselect()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            layer.cornerRadius = frame.height / 2
        }
        
        func select() {
            setTitleColor(whiteColor, for: .normal)
            backgroundColor = identityColor
        }
        
        func deselect() {
            setTitleColor(identityColor, for: .normal)
            backgroundColor = whiteColor
        }
        
        func disableButton() {
            self.deselect()
            alpha = 0.34
            isUserInteractionEnabled = false
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
}
