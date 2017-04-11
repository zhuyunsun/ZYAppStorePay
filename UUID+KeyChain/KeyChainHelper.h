//
//  KeyChainHelper.h
//  keyChainDemo
//
//  Created by EL133 on 16/5/20.
//  Copyright © 2016年 EL133. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
@interface KeyChainHelper : NSObject
+ (void)saveUDID;
+ (NSString*)loadKeyChainUDID;
@end
