//
//  TestCase1.m
//  CZJUnit
//
//  Created by 陈昭杰 on 2016/10/16.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import "CZJTestCase.h"
#import "Test-Macros.h"

@interface TestCase1 : CZJTestCase

@end

@implementation TestCase1

- (void)setUp {
    PRINT_CLASS_MATHOD;
}

- (void)tearDown {
    PRINT_CLASS_MATHOD;
}

- (void)testRedBlue {
    PRINT_CLASS_MATHOD;
    UIViewController *vc = CZJCurrentDisplayingViewController();
    for (int i = 0; i < 5; i++) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            vc.view.backgroundColor = [UIColor redColor];
        });
        sleep(1);
        dispatch_sync(dispatch_get_main_queue(), ^{
            vc.view.backgroundColor = [UIColor blueColor];
        });
        sleep(1);
    }
}

- (void)testWhiteBlack {
    PRINT_CLASS_MATHOD;
    UIViewController *vc = CZJCurrentDisplayingViewController();
    for (int i = 0; i < 1; i++) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            vc.view.backgroundColor = [UIColor whiteColor];
        });
        sleep(1);
        dispatch_sync(dispatch_get_main_queue(), ^{
            vc.view.backgroundColor = [UIColor blackColor];
        });
        sleep(1);
    }
}

@end
