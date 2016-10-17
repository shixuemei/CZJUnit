//
//  CZJTestRunner.m
//  CZJUnit
//
//  Created by 陈昭杰 on 2016/10/15.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import "CZJTestRunner.h"
#import "CZJTestGroup.h"
#import "CZJTesting.h"

@implementation CZJTestRunner {
    NSOperationQueue *_testQueue;
}

static CZJTestRunner *_sharedRunner = nil;

+ (instancetype)sharedRunner {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedRunner = [[super allocWithZone:NULL] init];
    });
    
    return _sharedRunner;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _testQueue = [[NSOperationQueue alloc] init];
        _testQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedRunner];
}

- (instancetype)copy {
    return [CZJTestRunner sharedRunner];
}

- (instancetype)mutableCopy {
    return [CZJTestRunner sharedRunner];
}

- (void)runTest:(id<CZJTest>)test
    withOptions:(CZJTestOptions)options
    inDisplayer:(id<CZJTestDisplayDelegate>)displayer{
    if ([test isKindOfClass:[CZJTest class]]) {
        CZJTest *aTest = (CZJTest *)test;
        
        [_testQueue addOperationWithBlock:^{
            if (displayer) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [displayer willDisplayTest:aTest];
                });
            }
            
            aTest.status = CZJTestStatusRunning;
            
            BOOL reraiseExceptions = ((options & CZJTestOptionReraiseExceptions) == CZJTestOptionReraiseExceptions);
            NSException *exception = nil;
            [CZJTesting runTestWithTarget:aTest.target
                                 selector:aTest.selector
                                exception:&exception
                                 interval:nil
                        reraiseExceptions:reraiseExceptions];
            
            if (displayer) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [displayer didDisplayTest:aTest];
                });
            }
            
            sleep(1);
        }];
    } else {
        CZJTestGroup *testGroup = (CZJTestGroup *)test;
        for (id<CZJTest> childTest in testGroup.children) {
            [self runTest:childTest withOptions:options inDisplayer:displayer];
        }
    }
}

- (void)runTest:(id<CZJTest>)test withOptions:(CZJTestOptions)options {
    [self runTest:test withOptions:options inDisplayer:nil];
}

#pragma mark - Private methods

@end
