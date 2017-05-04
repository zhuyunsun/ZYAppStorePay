//
//  UIView+ZYHUD.h
//  SJSDK2.0.5
//
//  Created by 朱运 on 2017/4/18.
//  Copyright © 2017年 朱运. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZYHUD)

/**
 展示并隐藏HUD

 @param view 展示view
 @param hint 提示话语
 */
- (void)showHintAndHide:(UIView *)view hint:(NSString *)hint;

/**
 展示一个提示层

 @param view 展示的view
 @param hint 提示话语
 */
- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

/**
 隐藏
 */
- (void)hideHud;
@end
