//
//  MainViewController.swift
//  InAppPurchase_test10
//
//  Created by 侯懿玲 on 2023/2/7.
//

// IAP 的 APP 必須確保有連到 Wi-Fi，否則會有"An unknown error occurred"的發生

import UIKit
import StoreKit

enum Product {
    case consumable
    case nonConsumable
    case restore
}

class MainViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var toSubscriptionButton: UIButton!
    @IBOutlet weak var setupIAPurchaseItemsTableView: UITableView!
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var restoreButton: UIButton!
    
    // MARK: - Instance Properties
    var productsArray: [SKProduct] = [SKProduct]() //  存放 server 回應的產品項目
    var selectedProductIndex: Int! // 點擊到的購買項目
    
    // MARK: - Vie Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewCell()    // 設定 TableView
        setUI()                 // 設定 MainViewController UI
        productsStatus()           // 讀取產品資訊
        purchasedProducts()     // 讀取已購買的資訊
    }
    
    /// 設定 TableView
    private func setupTableViewCell() {
        // setupIAPurchaseItemsTableView
        setupIAPurchaseItemsTableView.delegate = self
        setupIAPurchaseItemsTableView.dataSource = self
        setupIAPurchaseItemsTableView.register(
            UINib(nibName: IAPurchaseItemsTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: IAPurchaseItemsTableViewCell.identifier)
        setupIAPurchaseItemsTableView.isScrollEnabled = true
        setupIAPurchaseItemsTableView.allowsSelection = false
        
        // detailsTableView
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.register(
            UINib(nibName: DetailsTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: DetailsTableViewCell.identifier)
        detailsTableView.isScrollEnabled = true
        detailsTableView.allowsSelection = false
    }
    
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        toSubscriptionButton.setTitle("自動訂閱", for: .normal)
        restoreButton.setTitle("回覆購買 restore", for: .normal)
    }
    
    /// 讀取產品資訊
    private func productsStatus() {
        // 加入旋轉動畫
        CommandBase.sharedInstance.showActivityIndicatorView(uiView: self.view)
        
        // 發送請求取得在 iTunes Connect 內購的產品資訊，並非所有的產品，只會請求有定義在 ConsumableProgram 的產品 ID
        ConsumableProgram.storeConsumable.requestProducts { [weak self] success, products in
            guard let self = self else { return }
            guard success else {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Failed to load list of products",
                                                            message: "Check logs for details",
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
                return
            }
            self.productsArray = products!
        }
        
        // 確認產品是否已購買過
        self.purchasedStatus()
        
        // 移除旋轉動畫
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            CommandBase.sharedInstance.removeActivityIndicatorView(uiView: self.view)
            // 更新表格
            self.setupIAPurchaseItemsTableView.reloadData()
            self.detailsTableView.reloadData()
        }
    }
    
    /// 確認產品是否已購買過
    private func purchasedStatus() {
        //檢查用戶購買的種類
        if (ConsumableProgram.storeConsumable.isProductPurchased(ConsumableProgram.rmAD)) ||
            (ConsumableProgram.storeConsumable.isProductPurchased(ConsumableProgram.storeDatas)) {
            print("已有購買過 IAP 產品")
        } else {
            print("未購買 IAPurchased 產品")
        }
    }
    
    /// 讀取已購買的資訊
    /// - Parameters:
    ///     - orderID: 訂單編號
    ///     - expirationDate: 有效期限
    private func purchasedProducts(){
        // Get the receipt if it's available.
        
        // appStoreReceiptURL: file:///private/var/mobile/Containers/Data/Application/407B8D95-FEB9-4220-819B-615014F19F1F/StoreKit/sandboxReceipt
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
           FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            
            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                print(receiptData)
                
                let receiptString = receiptData.base64EncodedString(options: [])
                
                // Read receiptData.
            }
            catch { print("Couldn't read receipt data with error: " + error.localizedDescription) }
        }
    }
    
    @IBAction func gotoSubscriptionVC(_ sender: UIButton) {
        let nextVC = SubscriptionViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    /// 回復購買
    @IBAction func toRestore(_ sender: UIButton) {
        // 代表有購買項目正在處理中
        if isProgress {
            return
        }
        
        if IAPManager.canMakePayments() {
            ConsumableProgram.storeConsumable.restorePurchases()
            isProgress = true
            // 開始執行回復購買的動作、加入旋轉動畫
            CommandBase.sharedInstance.showActivityIndicatorView(uiView: self.view)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // 移除旋轉動畫
            CommandBase.sharedInstance.removeActivityIndicatorView(uiView: self.view)
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case setupIAPurchaseItemsTableView:
            return productsArray.count
        case detailsTableView:
            return 1
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case setupIAPurchaseItemsTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: IAPurchaseItemsTableViewCell.identifier,
                                                           for: indexPath) as? IAPurchaseItemsTableViewCell else {
                fatalError("IAPurchaseItemsTableViewCell 載入失敗")
            }
            
            // 確認是否有產品能被訂閱
            guard !productsArray.isEmpty else {
                print("Cannot purchase subscription because products is empty!")
                return cell
            }
            let product = self.productsArray[indexPath.row] // 請求的產品
            
            // 將價格依本地國家進行轉換
            var regularPrice: String? {
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.locale = product.priceLocale
                return formatter.string(from: product.price)
            }
            // localizedTitle(商品名稱)、localizedDescription(商品描述)
            cell.setInit(title: "\(product.localizedTitle)（\(product.localizedDescription)）",
                         buttonTitle: "\(regularPrice!.description)",
                         index: indexPath.row)
            
            // protocol
            cell.delegateToBuy = self
            
            /*
             print("\(product.localizedTitle)\n",
             "\(product.localizedDescription)\n",
             "\(product.price)\n",
             indexPath.row)
             */
            
            return cell
            
        case detailsTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier,
                                                           for: indexPath) as? DetailsTableViewCell else {
                fatalError("DetailsTableViewCell 載入失敗")
            }
            cell.setUI(title: "bbb", startTime: "1997", endTime: "2001")
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
}

extension MainViewController: ToBuy {
    /// 購買所選的產品
    func toBuy(index: Int) {
        // 開始執行回復購買的動作、加入旋轉動畫
        CommandBase.sharedInstance.showActivityIndicatorView(uiView: self.view)
        
        SubscriptionProgram.storeSubscription.buyProduct(productsArray[index]) { [weak self] success, productId in
            guard let self = self else { return }
            guard success else {
                // 若使用者在 APP Store 購買畫面按下"Ｘ"的話，會執行以下程式
                DispatchQueue.main.async {
                    CommandBase.sharedInstance.removeActivityIndicatorView(uiView: self.view)
                    
                    // Failed to purchase product
                    let alertController = UIAlertController(title: "您已取消購買",
                                                            message: "",
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
                return
            }
            print("\(self.productsArray[index].localizedTitle) success")
            
            CommandBase.sharedInstance.removeActivityIndicatorView(uiView: self.view)
        }
    }
}
