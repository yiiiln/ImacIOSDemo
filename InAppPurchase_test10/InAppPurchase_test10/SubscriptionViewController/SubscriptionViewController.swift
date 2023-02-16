//
//  IAPurchaseViewController.swift
//  InAppPurchase_test10
//
//  Created by 侯懿玲 on 2023/2/3.
//

import UIKit
import StoreKit

class SubscriptionViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var oneYearButton: UIButton!
    @IBOutlet weak var checkAppStoreButton: UIButton!
    
    // MARK: - Instance Properties
    var products: [SKProduct] = []
    
    // MARK: - Vie Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        productsStatus()    // 讀取產品資訊
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .purple
        self.navigationController?.title = "訂閱"
        oneYearButton.setTitle("訂閱一年", for: .normal)
        oneYearButton.setTitleColor(.purple, for: .normal)
        checkAppStoreButton.setTitle("查看 APP Store 訂閱狀態", for: .normal)
        checkAppStoreButton.setTitleColor(.black, for: .normal)
    }
    
    private func productsStatus() {
        // 確認是否有產品能被訂閱
        SubscriptionProgram.storeSubscription.requestProducts { [weak self] success, products in
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
            self.products = products!
        }
        
        //檢查用戶購買的種類
        if (SubscriptionProgram.storeSubscription.isProductPurchased(SubscriptionProgram.yearlySub) || SubscriptionProgram.storeSubscription.isProductPurchased(SubscriptionProgram.oneYearSub)) {
            print("已訂閱 -> 訂閱一年")
        } else {
            print("未訂閱")
        }
    }
    
    @IBAction func clickButton(_ sender: UIButton) {
        // 確認是否有產品能被訂閱
        guard !products.isEmpty else {
            print("Cannot purchase subscription because products is empty!")
            return
        }
        
        switch sender {
        case oneYearButton:
            print("oneYearButton")
            purchaseItemIndex(index: 0)
            
        default:
            break
        }
    }
    
    @IBAction func presentAppStore(_ sender: UIButton) {
        if let window = UIApplication.shared.connectedScenes.first {
            Task {
                do {
                    try await AppStore.showManageSubscriptions(in: window as! UIWindowScene)
                    print("deviceVerificationID: ", AppStore.deviceVerificationID)
                    try? await print("deviceVerificationID: ", AppTransaction.shared.jwsRepresentation)
                } catch {
                    print("presentAppStore ERROR: ",error)
                }
            }
        }
    }
    /// 購買所選的產品
    private func purchaseItemIndex(index: Int) {
        CommandBase.sharedInstance.showActivityIndicatorView(uiView: self.view)
        
        SubscriptionProgram.storeSubscription.buyProduct(products[index]) { [weak self] success, productId in
            
            guard let self = self else { return }
            guard success else {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Failed to purchase product",
                                                            message: "Check logs for details",
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                    CommandBase.sharedInstance.removeActivityIndicatorView(uiView: self.view)
                }
                return
            }
            print("訂閱一年 success")
            CommandBase.sharedInstance.removeActivityIndicatorView(uiView: self.view)
        }
    }
}

// MARK: - 參考資料
/*
 IAP (In-App Purchase) 內購功能:
 https://franksios.medium.com/ios-app%E5%85%A7%E8%B3%BC%E5%8A%9F%E8%83%BD-in-app-purchase-6286a71105e2
 */
