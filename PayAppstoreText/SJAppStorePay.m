//
//  SJAppStorePay.m
//  PayAppstoreText
//
//  Created by sj_ios on 16/11/29.
//  Copyright © 2016年 LW_ios. All rights reserved.
//

#import "SJAppStorePay.h"
#import <StoreKit/StoreKit.h>
#define non_Products @"没有购买的产品"
#define fail_Products @"请求内购产品失败"
@interface SJAppStorePay()<SKPaymentTransactionObserver,SKProductsRequestDelegate>

@end
@implementation SJAppStorePay
-(void)getProductWithProductID:(NSArray *)arrProduct{
    if (arrProduct.count > 0) {
        NSSet * nsset = [NSSet setWithArray:arrProduct];
        SKProductsRequest * request = [[SKProductsRequest alloc]initWithProductIdentifiers:nsset];
        request.delegate = self;
        [request start];
    }else{
        [self.payDelegate onGetFail:non_Products];
    }
}
-(void)getAppStorePay:(id)product{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
#pragma mark -- SKProductsRequestDelegate delegate
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray * product = response.products;
    if (product.count == 0) {
        [self.payDelegate onGetFail:non_Products];
    }else{
        [self.payDelegate onGetSuccess:product];
    }
}
-(void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [self.payDelegate onGetFail:fail_Products];
}
-(void)requestDidFinish:(SKRequest *)request{
    //请求完成
    NSLog(@"请求完成");
}
#pragma mark -- SKPaymentTransactionObserver delegate
//监听购买结果
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    for(SKPaymentTransaction * tran in transactions){
            NSLog(@"购买状态%ld",(long)tran.transactionState);
        if (tran.transactionState == SKPaymentTransactionStatePurchased) {
                         NSLog(@"购买成功");
            NSURL * receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
            // 从沙盒中获取到购买凭据
            NSData * receiptData = [NSData dataWithContentsOfURL:receiptURL];
            NSString * encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];

            [self.payDelegate onAppStorePaySuccess:encodeStr];
            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
        }else if (tran.transactionState == SKPaymentTransactionStateRestored){
                         NSLog(@"重新购买");
            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
        }else if (tran.transactionState == SKPaymentTransactionStateFailed){
                         NSLog(@"购买失败");
            [self.payDelegate onAppStorePayFail];
            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
        }
        else if (tran.transactionState == SKPaymentTransactionStatePurchasing){
                         NSLog(@"正在购买");
        }else{
                         NSLog(@"排队中");
        }
        
    }
}
//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    //    NSLog(@"交易完成");
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
-(void)addPayDelegate:(id)SJAppStoreDelegate{
    self.payDelegate = SJAppStoreDelegate;
}
+(SJAppStorePay *)sharedInstance{
    static SJAppStorePay * payInfo = nil;
    @synchronized (self) {
        if (payInfo == nil) {
            payInfo = [SJAppStorePay new];
        }
    }
    return payInfo;
}
@end
