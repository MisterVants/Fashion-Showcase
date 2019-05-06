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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addToCartButton.addTarget(self, action: #selector(didPressAddToCart(_:)), for: .touchUpInside)
        styleView()
        fillView()
    }
    
    func styleView() {
        
        productImageView.contentMode = .scaleAspectFill
    }
    
    func fillView() {
        productNameLabel.text = presenter?.viewModel.productName
        priceLabel.text = presenter?.viewModel.productPrice
        auxiliaryPriceLabel.attributedText = presenter?.viewModel.supplementaryPrice
        
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
    func didPressAddToCart(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
