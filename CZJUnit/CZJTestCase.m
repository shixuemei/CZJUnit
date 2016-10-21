//
//  CZJTestCase.m
//  CZJTest
//
//  Created by isExist on 2016/9/28.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import "CZJTestCase.h"
#import "CZJTesting.h"

UIViewController * CZJCurrentDisplayingViewController(void) {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return [(UINavigationController *)rootVC topViewController];
    } else {
        return rootVC;
    }
}

@implementation CZJTestCase

- (void)setUp {}

- (void)tearDown {}

- (void)handleException:(NSException *)exception {
    NSLog(@"%@", [CZJTesting descriptionForException:exception]);
}

- (void)failWithException:(NSException *)exception {
    [exception raise];
}

@end
