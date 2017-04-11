//
//  ViewController.m
//  PayAppstoreText
//
//  Created by sj_ios on 16/11/25.
//  Copyright © 2016年 LW_ios. All rights reserved.
//

#import "ViewController.h"
#import <StoreKit/StoreKit.h>
#import "SJAppStorePay.h"

@interface ViewController ()<SJAppStoreDelegate>
@property(nonatomic,strong)id product1;
@end

@implementation ViewController
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.product1 != nil) {
         [[SJAppStorePay sharedInstance] getAppStorePay:self.product1];
    }else{
        NSLog(@"还没请求到购买的内购产品！?");
    }
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"内购测试";
    self.view.backgroundColor = [UIColor whiteColor];
    NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"xwzmen" ofType:@"plist"];
    NSArray * arrya1 = [NSArray arrayWithContentsOfFile:plistPath];
    NSLog(@"array1 = %@",arrya1);
    [[SJAppStorePay sharedInstance] getProductWithProductID:arrya1];
    [[SJAppStorePay sharedInstance] addPayDelegate:self];
}
-(void)onGetSuccess:(NSArray *)productsArr{
    for (int i = 0; i < productsArr.count; i++) {
        SKProduct * product = productsArr[i];
        NSLog(@"产品描述 = %@",product.localizedTitle);
    }
     self.product1 = productsArr[1];
    [[SJAppStorePay sharedInstance] getAppStorePay:productsArr[1]];
}
-(void)onGetFail:(NSString *)failCode{
    NSLog(@"%@",failCode);
}
-(void)onAppStorePayFail{
    NSLog(@"内购失败");
}
-(void)onAppStorePaySuccess:(NSString *)receiptData{
    NSLog(@"内购成功");
    /*
     验证购买凭证一般都是在服务端进行验证
     */
    // 发送网络POST请求，对购买凭据进行验证
    NSURL *url = [NSURL URLWithString:ITMS_SANDBOX_VERIFY_RECEIPT_URL];
    // 国内访问苹果服务器比较慢，timeoutInterval需要长一点
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    request.HTTPMethod = @"POST";
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptData];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = payloadData;
    // 提交验证请求，并获得官方的验证JSON结果
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    // 官方验证结果为空
    if (result == nil) {
        NSLog(@"验证失败");
    }
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
    if (dict != nil) {
         NSLog(@"验证成功");
    }

}
@end
