//
//  ShoppingCartViewController.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 05/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import UIKit

class ShoppingCartViewController: UIViewController {
    
    var presenter: ShoppingCartPresenter?
    
    private let tableView = UITableView()
    
    private lazy var checkoutButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layoutView()
    }
    
    private func setupView() {
        tableView.dataSource = self
        tableView.register(ShoppingCartTableViewCell.self)
        view.addSubview(tableView)
    }
    
    private func layoutView() {
        tableView.constraintInside(view.safeAreaLayoutGuide)
    }
}

extension ShoppingCartViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShoppingCartTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfCartItems ?? 0
    }
}
