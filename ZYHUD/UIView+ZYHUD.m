//
//  UIView+ZYHUD.m
//  SJSDK2.0.5
//
//  Created by 朱运 on 2017/4/18.
//  Copyright © 2017年 朱运. All rights reserved.
//

#import "UIView+ZYHUD.h"
#import "ZYMBProgressHUD.h"
#import <objc/runtime.h>
static const void *ZYHttpRequestHUDKey = &ZYHttpRequestHUDKey;
@implementation UIView (ZYHUD)
- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    ZYMBProgressHUD * HUD = [[ZYMBProgressHUD alloc] initWithView:view];
    HUD.mode = ZYMBProgressHUDModeIndeterminate;
    //    HUD.dimBackground = YES;
    [view addSubview:HUD];
    [HUD show:YES];
    HUD.removeFromSuperViewOnHide = YES;
    [self setHUD:HUD];
}
- (void)showHintAndHide:(UIView *)view hint:(NSString *)hint {

    ZYMBProgressHUD * HUD = [[ZYMBProgressHUD alloc] initWithView:view];
    HUD.mode = ZYMBProgressHUDModeText;
    HUD.labelText = hint;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:1.3];
}

- (void)setHUD:(ZYMBProgressHUD *)HUD{
    objc_setAssociatedObject(self, ZYHttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (ZYMBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, ZYHttpRequestHUDKey);
}

- (void)hideHud{
    [[self HUD] hide:YES];
}

@end
