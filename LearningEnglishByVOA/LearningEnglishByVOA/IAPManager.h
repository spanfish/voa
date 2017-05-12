//
//  IAPManager.h
//  GSPro
//
//  Created by Xiangwei Wang on 1/28/15.
//  Copyright (c) 2015 Xiangwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define InAppErrorDomain @"com.xiang.inapp.error"
typedef enum : NSUInteger {
    InAppErrorCodeNone = 0,
    InAppErrorCodeNotAllowed,
    InAppErrorCodePayFailed,
    InAppErrorCodePayCancelled,
    InAppErrorCodeRestoreFailed
} InAppErrorCode;

#define RestoreNotification           @"RestoreNotification"
#define PurchaseNotification          @"PurchaseNotification"
#define ProductsNotification          @"ProductsNotification"
#define kInappError                   @"Error"
#define kProducts                     @"Products"

#define kProductIdentifier            @"ProductIdentifier"
#define kProductQuantity              @"Productquantity"


@interface IAPManager : NSObject<SKPaymentTransactionObserver, SKProductsRequestDelegate>

+ (IAPManager *)sharedInstance;

/*商品是否正在被恢复*/
@property(nonatomic, assign, getter=isRestoring, readonly) BOOL restoring;
@property(nonatomic, strong) NSArray * products;
/**
* By default, it will request products listed in file product_ids.plist.
*/
-(void) requestProducts;

/**
 * Purchase product, PurchaseNotification will be posted when purchase is finished.
 */
-(BOOL) purchaseProduct:(SKProduct *) product;

/**
 * Restore purchased product, RestoreNotification will be posted when purchase is finished.
 */
-(void) restorePurchasedProducts;

/**
 * Is it requesting product.
 */
-(BOOL) requestingProduct;

/*Return true if the product is being purchased*/
-(BOOL) purchasingForProduct:(NSString *) productId;
/*Return true if the product has been purchased already*/
-(BOOL) purchasedProduct:(NSString *) productId;
/*Return false if IAP is not allowed, this can be set in setting*/
-(BOOL) paymentAllowed;
/*Load purchased from local receipt*/
-(void) loadPurchasedProducts;
@end

