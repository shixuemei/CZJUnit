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

NSString * const CZJUnitTestRunnerRunningStateChanged = @"CZJUnitTestRunnerRunningStateChanged";

@interface CZJTestRunner ()

@property (nonatomic, assign, getter=isRunning) BOOL running;

@property (nonatomic, copy) NSMutableDictionary *log;

@end

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
        [_testQueue addObserver:self
                     forKeyPath:@"operationCount"
                        options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                        context:nil];
        
        _log = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    [_testQueue removeObserver:self forKeyPath:@"operationCount" context:nil];
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
    inDisplayer:(id<CZJTestDisplayDelegate>)displayer {
    [_log removeAllObjects];
    
    _testQueue.suspended = YES;
    
    [self addTest:test withOptions:options inDisplayer:displayer];
    
    _testQueue.suspended = NO;
}

- (void)runTest:(id<CZJTest>)test withOptions:(CZJTestOptions)options {
    [self runTest:test withOptions:options inDisplayer:nil];
}

- (BOOL)isRunning {
    return _testQueue.operationCount > 0;
}

- (void)cancel {
    if (self.isRunning) {
        [_testQueue cancelAllOperations];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == _testQueue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *userInfo = @{@"operationCount" : [NSNumber numberWithUnsignedInteger:_testQueue.operationCount]};
            if ([keyPath isEqualToString:@"operationCount"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:CZJUnitTestRunnerRunningStateChanged
                                                                    object:self
                                                                  userInfo:userInfo];
            }
        });
    }
}

+ (NSString *)descriptionForException:(NSException *)exception {
    NSNumber *lineNumber = [exception userInfo][GHTestLineNumberKey];
    NSString *lineDescription = (lineNumber ? [lineNumber description] : @"Unknown");
    NSString *filename = [[[exception userInfo][GHTestFilenameKey] stringByStandardizingPath] stringByAbbreviatingWithTildeInPath];
    NSString *filenameDescription = (filename ? filename : @"Unknown");
    
    return [NSString stringWithFormat:@"Name: %@\nFile: %@\nLine: %@\nReason: %@\n\n",
            [exception name],
            filenameDescription,
            lineDescription,
            [exception reason]];
}

- (NSString *)testLog {
    NSMutableString *logs = [NSMutableString string];
    
    for (NSString *testIdentifier in _log) {
        NSString *log = _log[testIdentifier];
        [logs appendString:[NSString stringWithFormat:@"%@\n%@", testIdentifier, log]];
    }
    
    return logs;
}

#pragma mark - Private methods

- (void)addTest:(id<CZJTest>)test
    withOptions:(CZJTestOptions)options
    inDisplayer:(id<CZJTestDisplayDelegate>)displayer {
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
            BOOL passed = [CZJTesting runTestWithTarget:aTest.target
                                               selector:aTest.selector
                                              exception:&exception
                                               interval:nil
                                      reraiseExceptions:reraiseExceptions];
            if (!passed) {
                [aTest.log addObject:exception];
                aTest.status = CZJTestStatusErrored;
                _log[aTest.identifier] = [CZJTestRunner descriptionForException:exception];
            } else {
                aTest.status = CZJTestStatusSucceeded;
                _log[aTest.identifier] = @"Passed\n\n";
            }

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
            [self addTest:childTest withOptions:options inDisplayer:displayer];
        }
    }
}

@end
