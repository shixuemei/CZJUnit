//
//  CZJTestRunner.h
//  CZJUnit
//
//  Created by 陈昭杰 on 2016/10/15.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZJTest.h"

FOUNDATION_EXPORT NSString * const CZJUnitTestRunnerRunningStateChanged;

@protocol CZJTestDisplayDelegate <NSObject>

- (void)willDisplayTest:(id<CZJTest>)test;

- (void)didDisplayTest:(id<CZJTest>)test;

@end

@interface CZJTestRunner : NSObject

@property (nonatomic, assign, readonly, getter=isRunning) BOOL running;

+ (instancetype)sharedRunner;

- (void)runTest:(id<CZJTest>)test
    withOptions:(CZJTestOptions)options
    inDisplayer:(id<CZJTestDisplayDelegate>)displayer;

- (void)runTest:(id<CZJTest>)test
    withOptions:(CZJTestOptions)options;

- (void)cancel;

+ (NSString *)descriptionForException:(NSException *)exception;

- (NSString *)testLog;

@end
