//
//  SJAppStorePay.h
//  PayAppstoreText
//
//  Created by sj_ios on 16/11/29.
//  Copyright © 2016年 LW_ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ITMS_PROD_VERIFY_RECEIPT_URL        @"https://buy.itunes.apple.com/verifyReceipt"//验证正式的
#define ITMS_SANDBOX_VERIFY_RECEIPT_URL     @"https://sandbox.itunes.apple.com/verifyReceipt"//验证沙盒
@protocol SJAppStoreDelegate;
@interface SJAppStorePay : NSObject
@property(nonatomic,weak)id<SJAppStoreDelegate>payDelegate;

/**
 根据内购产品id申请内购产品信息

 @param arrProduct 内购产品id数组
 */
-(void)getProductWithProductID:(NSArray *)arrProduct;

/**
 购买产品

 @param product 内购的产品
 */
-(void)getAppStorePay:(id)product;
/**
 单例创造对象
 */
+(SJAppStorePay *)sharedInstance;

/**
 添加协议

 @param SJAppStoreDelegate 协议
 */
-(void)addPayDelegate:(id)SJAppStoreDelegate;
@end
@protocol SJAppStoreDelegate <NSObject>
@optional

/**
 返回获取到的内购产品信息

 @param productsArr 内购产品数组,SKProduct类
 */
-(void)onGetSuccess:(NSArray *)productsArr;

/**
 获取内购产品信息失败

 @param failCode 失败的原因
 */
-(void)onGetFail:(NSString *)failCode;


/**
 内购成功

 @param receiptData 没有验证的购买凭证
 */
-(void)onAppStorePaySuccess:(NSString *)receiptData;

/**
 内购失败
 */
-(void)onAppStorePayFail;
@end
