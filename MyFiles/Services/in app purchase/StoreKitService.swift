//
//  StoreKitService.swift
//  Sportina
//
//  Created by Moh_Sawy on 23/01/2024.
//

import Foundation
import StoreKit

class StoreKitService: NSObject{
    
    static let shared = StoreKitService()
    var product: SKProduct!
    
    func fetchProduct(){
        let request = SKProductsRequest(productIdentifiers: ["123456"])
        request.delegate = self
        request.start()
    }
    func purchase(){
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}
extension StoreKitService: SKProductsRequestDelegate{
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("products is", response.products)
        self.product = response.products.first ?? SKProduct()
    }
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach {
            switch $0.transactionState {
            case .purchasing:
                print("purchasing")
            case .purchased:
                print("purchased")
                SKPaymentQueue.default().finishTransaction($0)
            case .failed:
                print("fail to purchase")
                SKPaymentQueue.default().finishTransaction($0)
            case .restored:
                print("rstored")
            case .deferred:
                print("deffered")
            @unknown default:
                break
            }
        }
    }
}
