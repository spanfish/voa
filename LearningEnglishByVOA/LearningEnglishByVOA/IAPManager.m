//
//  IAPManager.h
//  GSPro
//
//  Created by Xiangwei Wang on 1/28/15.
//  Copyright (c) 2015 Xiangwei Wang. All rights reserved.
//

#import "IAPManager.h"
#import "VerifyStoreReceipt.h"
#import <SAMKeychain/SAMKeychain.h>
#import <SAMKeychain/SAMKeychainQuery.h>

#define SERVICE_NAME @"VOA"
//update to app version every time before new version is submited
const NSString * global_bundleVersion = @"1.0.1";
const NSString * global_bundleIdentifier = @"com.xiang.LearningEnglishByVOA";

@interface IAPManager () <SKProductsRequestDelegate>
@end

@implementation IAPManager {
    SKProductsRequest * _productsRequest;
    NSSet * _productIdentifiers;
    BOOL _requestingProduct;
    SKReceiptRefreshRequest *_refreshRequest;
    NSMutableDictionary *_productIdsInPurchasing;
    NSArray *_purchasedProducts;
}

//Call this in application:didFinishLaunchingWithOptions
+ (IAPManager *)sharedInstance {
    static dispatch_once_t once;
    static IAPManager * sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[IAPManager alloc] init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:sharedInstance];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if(self) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"product_ids"
                                             withExtension:@"plist"];
        _productIdentifiers = [NSSet setWithArray:[NSArray arrayWithContentsOfURL:url]];
        _productIdsInPurchasing = [NSMutableDictionary dictionary];
    }
    
    return self;
}

-(BOOL) requestingProduct {
    return _requestingProduct;
}

/*
 *从appstore取得现在inapp的商品。
 */
- (void)requestProducts {
    if(_requestingProduct) {

        return;
    }
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    _requestingProduct = YES;
}

#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
   
    _productsRequest = nil;
    _requestingProduct = NO;
    NSArray * skProducts = response.products;
    self.products = [NSArray arrayWithArray: skProducts];

#ifdef DEBUG
    //请用下面的方法在UI显示商品
    NSNumberFormatter *numberFmt = [[NSNumberFormatter alloc] init];
    [numberFmt setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFmt setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    for (SKProduct * product in skProducts) {
        [numberFmt setLocale:product.priceLocale];
        NSLog(@"Found product: %@ %@, %@f",
              product.productIdentifier,
              product.localizedTitle,
              [numberFmt stringFromNumber:product.price]);
    }
#endif
    if([[NSThread currentThread] isMainThread]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ProductsNotification object:nil userInfo:@{kProducts: skProducts}];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:ProductsNotification object:nil userInfo:@{kProducts: skProducts}];
        });
    }
}

/*
 *Appstore请求的callback，可能有两个情况，一是取得商品列表的callback，二是恢复已购买的callback。
 */
- (void)requestDidFinish:(SKRequest *)request {
    NSLog(@"requestDidFinish");
    if([request isKindOfClass:[SKReceiptRefreshRequest class]]) {
        _restoring = NO;
        _refreshRequest = nil;
        [self processReceipt];

        //发送恢复已完成的通知
        if([[NSThread currentThread] isMainThread]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RestoreNotification
                                                                object:nil
                                                              userInfo:nil];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:RestoreNotification
                                                                    object:nil
                                                                  userInfo:nil];
            });
        }
        
    } else if([request isKindOfClass:[SKProductsRequest class]]) {
        _requestingProduct = NO;
    }
}

/*
 *Appstore请求失败的callback，可能有两个情况，一是取得商品列表的callback，二是恢复已购买的callback。
 */
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    if([request isKindOfClass:[SKProductsRequest class]]) {
        _productsRequest = nil;
        _requestingProduct = NO;
        
        if([[NSThread currentThread] isMainThread]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ProductsNotification
                                                                object:nil
                                                              userInfo:nil];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:ProductsNotification
                                                                    object:nil
                                                                  userInfo:nil];
            });
        }
    } else if([request isKindOfClass:[SKReceiptRefreshRequest class]]) {
        _restoring = NO;
        //发送恢复已完成的通知
        _refreshRequest = nil;
        NSError *error = [NSError errorWithDomain:InAppErrorDomain
                                             code:InAppErrorCodeRestoreFailed
                                         userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"RestoreFailed", nil)}];
        
        
        if([[NSThread currentThread] isMainThread]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RestoreNotification
                                                                object:nil
                                                              userInfo: @{kInappError: error}];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:RestoreNotification
                                                                    object:nil
                                                                  userInfo: @{kInappError: error}];
            });
        }
    }
}

/*InApp功能已打开？*/
-(BOOL) paymentAllowed {
    return [SKPaymentQueue canMakePayments];
}

#pragma mark - Purchase
/*购买某个商品*/
-(BOOL) purchaseProduct:(SKProduct *) product {
    if(![self paymentAllowed]) {
        //UI提示用户打开该功能
        NSError *error = [NSError errorWithDomain:InAppErrorDomain
                                             code:InAppErrorCodeNotAllowed
                                         userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"InAppNotAllowed", nil)}];
        
        
        if([[NSThread currentThread] isMainThread]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:PurchaseNotification
                                                                object:nil
                                                              userInfo: @{kInappError: error}];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:PurchaseNotification
                                                                    object:nil
                                                                  userInfo: @{kInappError: error}];
            });
        }
        return NO;
    }
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];

    [_productIdsInPurchasing setObject:[NSNumber numberWithBool:YES] forKey:product.productIdentifier];
    return YES;
}

#pragma mark Transaction statuses and corresponding actions
/*购买商品事物被更新*/
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        NSLog(@"productIdentifier:%@, state:%ld, error:%ld %@",
                     transaction.payment.productIdentifier,
                     (long)transaction.transactionState,
                     (long)transaction.error.code,
                     transaction.error.localizedDescription);
        switch (transaction.transactionState) {
                // Call the appropriate custom method for the transaction state.
            case SKPaymentTransactionStatePurchasing:
                break;
            case SKPaymentTransactionStateDeferred:
                break;
            case SKPaymentTransactionStateFailed:
                [self finishPaymentTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchased:
                [self finishPaymentTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self finishPaymentTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

/*
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions {
    DLog(@"removedTransactions");
    for (SKPaymentTransaction *transaction in transactions) {
        if(transaction.transactionState == SKPaymentTransactionStatePurchased || transaction.transactionState == SKPaymentTransactionStateRestored) {
        } else {
        }
    }
}
*/


-(void) finishPaymentTransaction:(SKPaymentTransaction *) transaction {
    NSLog(@"productIdentifier:%@, state:%ld, error:%ld %@",
                 transaction.payment.productIdentifier,
                 (long)transaction.transactionState,
                 (long)transaction.error.code,
                 transaction.error.localizedDescription);
    if(transaction.transactionState == SKPaymentTransactionStatePurchased) {
        [self purchaseProductFinished:transaction.payment.productIdentifier];
        //购买成功
        [self loadPurchasedProducts];
    } else if(transaction.transactionState == SKPaymentTransactionStateFailed) {
        [self purchaseProductFinished:transaction.payment.productIdentifier];
        //购买失败
        NSError *error = nil;

        if(transaction.error.code == SKErrorPaymentCancelled) {
            error = [NSError errorWithDomain:InAppErrorDomain
                                        code:InAppErrorCodePayCancelled
                                    userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"PurchaseCancelled", nil)}];
        } else {
            error = [NSError errorWithDomain:InAppErrorDomain
                                        code:InAppErrorCodePayFailed
                                    userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"PurchaseFailed", nil)}];
        }
        
        if([[NSThread currentThread] isMainThread]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:PurchaseNotification
                                                                object:nil
                                                              userInfo: @{kInappError: error,
                                                                          kProductIdentifier: transaction.payment.productIdentifier,
                                                                          kProductQuantity: [NSNumber numberWithInteger: transaction.payment.quantity]}];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:PurchaseNotification
                                                                    object:nil
                                                                  userInfo: @{kInappError: error,
                                                                              kProductIdentifier: transaction.payment.productIdentifier,
                                                                              kProductQuantity: [NSNumber numberWithInteger: transaction.payment.quantity]}];
            });
        }
        
        
    } else if(transaction.transactionState == SKPaymentTransactionStateRestored) {
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

/*商品的购买手续正在进行中吗？*/
-(BOOL) purchasingForProduct:(NSString *) productId {
    return [[_productIdsInPurchasing objectForKey:productId] boolValue];
}

-(void) purchaseProductFinished:(NSString *) productId {
    [_productIdsInPurchasing removeObjectForKey:productId];
}

/*商品是否已经购买过, 此方法只检查Local receipt，如果要最新纪录，请先和appstore同步后再调用processReceipt*/
-(BOOL) purchasedProduct:(NSString *) productId {
    BOOL purchased = NO;
    for (NSDictionary *purchase in _purchasedProducts) {
        if(![productId isEqualToString:[purchase objectForKey:kReceiptInAppProductIdentifier]]) {
            continue;
        }
        //已购买
        NSLog(@"商品:%@", purchase);
        NSLog(@"kReceiptInAppPurchaseDate:%@", [purchase objectForKey:kReceiptInAppPurchaseDate]);
        //购买取消?
        NSString *purchaseDate = [purchase objectForKey:kReceiptInAppCancellationDate];
        if(purchaseDate == nil || [@"" isEqualToString:purchaseDate]) {
            //purchase not cancelled
        }

        break;
    }
    return purchased;
}

-(void) processReceipt {
    NSArray *products = obtainInAppPurchases([[[NSBundle mainBundle] appStoreReceiptURL] path]);

    _purchasedProducts = products;
}
#pragma mark Restore
/*恢复已购买过的商品*/
-(void) restorePurchasedProducts {
    if(self.isRestoring) {
        NSLog(@"恢复进行中");
        return;
    }

    if(!_refreshRequest) {
        _refreshRequest = [[SKReceiptRefreshRequest alloc] init];
        _refreshRequest.delegate = self;
    }
    [_refreshRequest start];
    _restoring = YES;
}

-(void) loadPurchasedProducts {
    [self processReceipt];
}
@end
