import StoreKit

public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

extension Notification.Name {
    static let SuccessPurchaseNotification = Notification.Name("SuccessPurchaseNotification")
    static let FailedPurchaseNotification = Notification.Name("FailedPurchaseNotification")
}

 class IAPService: NSObject {

    private override init() {}
    static let shared = IAPService()

    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    private var productsRequest: SKProductsRequest?
    private var purchasedProductIdentifiers: Set<IAPProduct> = []

    var products: [SKProduct] = []
    let paymentQueue = SKPaymentQueue.default()

    func getProducts() {
        let products: Set = [IAPProduct.nonConsumable.rawValue]

        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)

    }

    func purchase(product:  IAPProduct) {

        print(products.first?.productIdentifier)
        print(product.rawValue)
        guard let productToPurchase = products.filter({$0.productIdentifier == product.rawValue}).first else { return }

        if SKPaymentQueue.canMakePayments() {

            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productToPurchase.productIdentifier
            SKPaymentQueue.default().add(paymentRequest)
        }
    }

    func restorePurchases() {
        print("restoring purchases")
        paymentQueue.restoreCompletedTransactions()
    }
}

//extension IAPService: SKProductsRequestDelegate {
//
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//
//        self.products = response.products
//        for product in response.products {
//            print(product.localizedTitle)
//        }
//    }
//
//}

extension IAPService: SKProductsRequestDelegate {

    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()

        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }

    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products \(error)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }

    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

extension IAPService: SKPaymentTransactionObserver {

    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)

            switch transaction.transactionState {
            case .purchasing: break
            case .purchased:
                UserDefaults.standard.set(true, forKey: IAPProduct.nonConsumable.rawValue)
            default: queue.finishTransaction(transaction)

            }
        }
    }
}

// MARK: - StoreKit API

extension IAPService {

    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler

        let products: Set = [IAPProduct.nonConsumable.rawValue]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)

    }

     func buyProduct(product: IAPProduct) {

         getProducts()
//        let payment = SKPayment(product: product)
//        SKPaymentQueue.default().add(payment)
        guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue }).first else { return }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)

    }


}

extension SKPaymentTransactionState {

    func status() -> String {
        switch self {
        case .deferred: return "deferred"
        case .failed: return "failed"
        case .purchased: return "purchased"
        case .purchasing: return "purchasing"
        case .restored: return "restored"
        @unknown default:
            fatalError()
        }
    }
}
