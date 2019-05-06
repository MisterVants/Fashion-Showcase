//
//  ProductsShoppingCartSpec.swift
//  FashionShowcaseTests
//
//  Created by André Vants Soares de Almeida on 03/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Quick
import Nimble

@testable import FashionShowcase

class ProductsShoppingCartSpec: QuickSpec {

    override func spec() {
        
        var products: [Product]!
        
        var cart: ProductShoppingCart!
        var targetProduct: ShoppingCartProduct!
        
        beforeSuite {
            products = ProductsAPIStub().mockProducts()
        }
        
        beforeEach {
            cart = ProductShoppingCart(withCapacity: 10)
            targetProduct = ShoppingCartProduct(product: products.first!, selectedSize: products.first!.sizes.first!)
        }
        
        describe("init") {
            it("should be empty") {
                expect(cart.items).to(beEmpty())
                expect(cart.isEmpty).to(beTrue())
                expect(cart.count).to(equal(0))
                expect(cart.totalPriceFull).to(equal(0.0))
                expect(cart.totalPriceDiscounted).to(equal(0.0))
            }
        }
        
        describe("items counting") {
            it("should return the amount of all different items in the cart") {
                let targetQuantity = 5
                let expectedCount = products.count
                let productsDict = products.reduce(into: [ShoppingCartProduct : Int](), { $0[ShoppingCartProduct(product: $1, selectedSize: $1.sizes.first!)] = targetQuantity })
                cart = ProductShoppingCart(products: productsDict)
                expect(cart.count).to(equal(expectedCount))
            }
        }
        
        describe("total price") {
            it("should be the summed price of the items in the cart") {
                let targetQuantity = 5
                let expectedPriceRegular = (targetProduct.regularPriceValue ?? 0.0) * Double(targetQuantity)
                let expectedPriceActual = (targetProduct.actualPriceValue ?? 0.0) * Double(targetQuantity)
                cart = ProductShoppingCart(products: [targetProduct : targetQuantity])
                expect(cart.totalPriceFull).toNot(equal(0.0))
                expect(cart.totalPriceFull).to(equal(expectedPriceRegular))
                expect(cart.totalPriceDiscounted).toNot(equal(0.0))
                expect(cart.totalPriceDiscounted).to(equal(expectedPriceActual))
            }
        }
        
        describe("get items ammount") {
            
            context("when the cart is empty") {
                it("should be zero") {
                    expect(cart.getTotalAmount(of: targetProduct)).to(equal(0))
                }
            }
            
            context("when there are items in the cart") {
                it("should return the correct amount of a given item that is in the cart") {
                    let targetQuantity = 5
                    cart = ProductShoppingCart(products: [targetProduct : targetQuantity])
                    expect(cart.getTotalAmount(of: targetProduct)).to(equal(targetQuantity))
                }
            }
        }
        
        describe("get total price for item") {
            
            let targetQuantity = 5
            
            context("when the cart is empty") {
                it("should return 'zero moneys'") {
                    expect(cart.getTotalPrice(for: targetProduct, discounted: true)).to(equal(0.0))
                    expect(cart.getTotalPrice(for: targetProduct, discounted: false)).to(equal(0.0))
                }
            }
            
            context("when there is only one item") {
                it("should return the original price") {
                    cart = ProductShoppingCart(products: [targetProduct : 1])
                    expect(cart.getTotalPrice(for: targetProduct, discounted: true)).to(equal(targetProduct.actualPriceValue))
                    expect(cart.getTotalPrice(for: targetProduct, discounted: false)).to(equal(targetProduct.regularPriceValue))
                }
            }
            
            context("when there are multiple items") {
                it("should return the summed price of all items") {
                    cart = ProductShoppingCart(products: [targetProduct : targetQuantity])
                    let expectedDiscountedPrice = (targetProduct.actualPriceValue ?? 0.0) * Double(targetQuantity)
                    let expectedFullPrice = (targetProduct.regularPriceValue ?? 0.0) * Double(targetQuantity)
                    expect(cart.getTotalPrice(for: targetProduct, discounted: true)).to(equal(expectedDiscountedPrice))
                    expect(cart.getTotalPrice(for: targetProduct, discounted: false)).to(equal(expectedFullPrice))
                }
            }
        }
        
        describe("add items") {
            
            context("when the cart is empty") {
                
                beforeEach {
                    cart.addItem(targetProduct)
                }
                
                it("should not be empty anymore") {
                    expect(cart.isEmpty).to(beFalse())
                }
                
                it("should contain that item") {
                    expect(cart.items).to(contain(targetProduct))
                }
            }
            
            context("when the cart already have some items") {
                it("should update the quantity of that item") {
                    cart = ProductShoppingCart(withCapacity: 10, products: [targetProduct : 5])
                    let previousAmount = cart.getTotalAmount(of: targetProduct)
                    cart.addItem(targetProduct)
                    let newAmount = cart.getTotalAmount(of: targetProduct)
                    expect(newAmount).to(equal(previousAmount + 1))
                }
            }
            
            context("when the cart is full of an item") {
                it("should not overflow") {
                    cart = ProductShoppingCart(withCapacity: 10, products: [targetProduct : 10])
                    let previousAmount = cart.getTotalAmount(of: targetProduct)
                    cart.addItem(targetProduct)
                    expect(cart.getTotalAmount(of: targetProduct)).to(equal(previousAmount))
                }
            }
        }
        
        describe("remove items") {
            
            context("when the cart already have some items") {
                it("should update the quantity of that item") {
                    cart = ProductShoppingCart(withCapacity: 10, products: [targetProduct : 5])
                    let previousAmount = cart.getTotalAmount(of: targetProduct)
                    cart.removeItem(targetProduct)
                    let newAmount = cart.getTotalAmount(of: targetProduct)
                    expect(newAmount).to(equal(previousAmount - 1))
                }
            }
            
            context("when the cart have exactly one item") {
                
                beforeEach {
                    cart = ProductShoppingCart(withCapacity: 10, products: [targetProduct : 1])
                    cart.removeItem(targetProduct)
                }
                
                it("should become empty") {
                    expect(cart.isEmpty).to(beTrue())
                }
                
                it("should not contain that item anymore") {
                    expect(cart.items).toNot(contain(targetProduct))
                }
            }
            
            context("when the cart is empty") {
                it("should not underflow") {
                    cart.removeItem(targetProduct)
                    expect(cart.getTotalAmount(of: targetProduct)).to(equal(0))
                }
            }
        }
        
        describe("delete items") {
            it("should not contain that item anymore") {
                cart = ProductShoppingCart(withCapacity: 10, products: [targetProduct : 5])
                cart.deleteItem(targetProduct)
                expect(cart.items).toNot(contain(targetProduct))
                expect(cart.getTotalAmount(of: targetProduct)).to(equal(0))
            }
        }
        
        describe("delete all items") {
            it("should empty the cart") {
                let productsDict = products.reduce(into: [ShoppingCartProduct : Int](), { $0[ShoppingCartProduct(product: $1, selectedSize: $1.sizes.first!)] = 5 })
                cart = ProductShoppingCart(products: productsDict)
                cart.deleteAllItems()
                expect(cart.isEmpty).to(beTrue())
            }
        }
    }
}
