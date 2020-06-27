import StoreKit

protocol IAPServiceDelegate: class {
    func successTransactions()
    func failedTransactions()
    func failedRestored()
}

extension SKProduct {
    fileprivate static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }

    var localizedPrice: String {
        if self.price == 0.00 {
            return "Get"
        } else {
            let formatter = SKProduct.formatter
            formatter.locale = self.priceLocale

            guard let formattedPrice = formatter.string(from: self.price) else {
                return "Unknown Price"
            }

            return formattedPrice
        }
    }
}

class IAPService: NSObject {

    private override init() {}
    static let shared = IAPService()

    var products: [SKProduct] = []
    let paymentQueue = SKPaymentQueue.default()

    var productPrice: String?

    weak var iapServiceDelegate: IAPServiceDelegate?

    func getProducts() {

        let products: Set = [IAPProduct.nonConsumable.rawValue]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }

    func purchase(product:  IAPProduct) {

        guard let productToPurchase = products.filter({$0.productIdentifier == product.rawValue}).first else { return }

        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productToPurchase.productIdentifier

            SKPaymentQueue.default().add(paymentRequest)
        }
    }

    func restorePurchases() {
        print("restoring purchases")
        if SKPaymentQueue.canMakePayments() {
            paymentQueue.restoreCompletedTransactions()
        }
    }
}


extension IAPService: SKProductsRequestDelegate {

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        for product in response.products {
            print(product.localizedTitle)
            //for nonConsumable
            productPrice = product.localizedPrice
        }
    }
}

extension IAPService: SKPaymentTransactionObserver {

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {

        for transaction in transactions {
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)

            switch transaction.transactionState {
            case .purchasing: break
            case .purchased:
                UserDefaults.standard.set(true, forKey: IAPProduct.nonConsumable.rawValue)

                iapServiceDelegate?.successTransactions()
                queue.finishTransaction(transaction)

            case .restored:
                iapServiceDelegate?.successTransactions()
                queue.finishTransaction(transaction)


            default: queue.finishTransaction(transaction)

            }

            if transaction.transactionState == .failed {
                guard let error = transaction.error else { return }
                iapServiceDelegate?.failedTransactions()
                queue.finishTransaction(transaction)
                print(error.localizedDescription)
            }
        }
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        iapServiceDelegate?.failedRestored()
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
