//
//  VerifyStoreReceipt.h
//
//  Based on validatereceipt.h
//  Created by Ruotger Skupin on 23.10.10.
//  Copyright 2010-2011 Matthew Stevens, Ruotger Skupin, Apple, Alessandro Segala. All rights reserved.
//
//  Modified for iOS, converted to ARC, and added additional fields by Rick Maddy 2013-08-20
//  Copyright 2013 Rick Maddy. All rights reserved.
//

/*
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in
 the documentation and/or other materials provided with the distribution.
 
 Neither the name of the copyright holders nor the names of its contributors may be used to endorse or promote products derived
 from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
 BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>

extern NSString * const kReceiptBundleIdentifer;
extern NSString * const kReceiptBundleIdentiferData;
extern NSString * const kReceiptVersion;
extern NSString * const kReceiptOpaqueValue;
extern NSString * const kReceiptHash;
extern NSString * const kReceiptInApp;
extern NSString * const kReceiptOriginalVersion;
extern NSString * const kReceiptExpirationDate;

extern NSString * const kReceiptInAppQuantity;
extern NSString * const kReceiptInAppProductIdentifier;
extern NSString * const kReceiptInAppTransactionIdentifier;
extern NSString * const kReceiptInAppPurchaseDate;
extern NSString * const kReceiptInAppOriginalTransactionIdentifier;
extern NSString * const kReceiptInAppOriginalPurchaseDate;
extern NSString * const kReceiptInAppSubscriptionExpirationDate;
extern NSString * const kReceiptInAppCancellationDate;
extern NSString * const kReceiptInAppWebOrderLineItemID;

NSDictionary *dictionaryWithAppStoreReceipt(NSString *receiptPath);
NSArray *obtainInAppPurchases(NSString *receiptPath);
BOOL verifyReceiptAtPath(NSString *receiptPath);
