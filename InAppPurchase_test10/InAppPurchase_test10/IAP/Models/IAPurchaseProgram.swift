//
//  TekPassCardSubscriptionProgram.swift
//  TekPass Card
//
//  Created by 侯懿玲 on 2023/2/4.
//

import Foundation

// 訂閱項目
public struct SubscriptionProgram {
    // 確保將兩個訂閱的產品 ID 替換為您在 App Store Connect 上創建的產品 ID
    public static let yearlySub = "ios.InAppPurchaseTest10.oneYear"
    public static let oneYearSub = "oneYear"
    
    public static let storeSubscription = IAPManager(productIDs: SubscriptionProgram.productIDs)
    private static let productIDs: Set<ProductID> = [SubscriptionProgram.yearlySub,
                                                     SubscriptionProgram.oneYearSub]
}

// 消耗性項目
public struct ConsumableProgram {
    // 確保將兩個訂閱的產品 ID 替換為您在 App Store Connect 上創建的產品 ID
    public static let rmAD = "ios.InAppPurchaseTest10.rmAD"
    public static let storeDatas = "ios.InAppPurchaseTest10.storeDatas"
    
    public static let storeConsumable = IAPManager(productIDs: ConsumableProgram.productIDs)
    private static let productIDs: Set<ProductID> = [ConsumableProgram.rmAD,
                                                     ConsumableProgram.storeDatas]
}


public func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
