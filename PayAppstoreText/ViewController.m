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
#import "UIView+ZYHUD.h"
@interface ViewController ()<SJAppStoreDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)id product1;
@property(nonatomic,strong)NSMutableArray * dataSource;
@end

@implementation ViewController
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cells = @"ssss";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cells];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cells];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"获取内购产品";
    }else{
       SKProduct * product = self.dataSource[indexPath.row - 1];
//    NSLog(@"产品描述 = %@",product.localizedTitle);
       cell.textLabel.text = product.localizedTitle;
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count + 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self getAction];
    }else{
     SKProduct * product = self.dataSource[indexPath.row - 1];
     [[SJAppStorePay sharedInstance] getAppStorePay:product];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}
-(UITableView *)MyTableView{
    if (_MyTableView == nil) {
        _MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 69, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 69)];
        _MyTableView.dataSource = self;
        _MyTableView.delegate = self;
        [self.view addSubview:_MyTableView];
    }
    return _MyTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"内购测试";
    self.view.backgroundColor = [UIColor whiteColor];
    [self getAction];
}
-(void)getAction{
    [self.view showHudInView:self.view hint:@"获取中..."];
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
    self.dataSource = [NSMutableArray arrayWithArray:productsArr];
    [self.MyTableView reloadData];
    [self.view hideHud];
}
-(void)onGetFail:(NSString *)failCode{
    NSLog(@"%@",failCode);
    [self.view hideHud];
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
