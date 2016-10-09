//
//  CZJTestGroup.m
//  CZJUnit
//
//  Created by isExist on 2016/9/29.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import "CZJTestGroup.h"
#import "CZJTesting.h"

@implementation CZJTestGroup {
    NSString *_name;
    __weak id<CZJTestGroup> _parent;
    NSMutableArray<id<CZJTest>> *_children;
    __weak id<CZJTestDelegate> _delegate;
    CZJTestStats _stats;
    CZJTestStatus _status;
}

@synthesize parent = _parent, children = _children, name = _name, delegate = _delegate, stats = _stats, status = _status;

- (id)initWithName:(NSString *)name delegate:(id<CZJTestDelegate>)delegate {
    if (self = [self init]) {
        _name = name;
        _delegate = delegate;
        _children = [NSMutableArray array];
    }
    
    return self;
}

- (id)initWithTestCase:(id)testCase delegate:(id<CZJTestDelegate>)delegate {
    if (self = [self initWithName:NSStringFromClass([testCase class]) delegate:delegate]) {
        _testCase = testCase;
        [self addTestsFromTestCase:testCase];
    }
    
    return self;
}

- (NSString *)identifier {
    return _name;
}

- (void)addTest:(id<CZJTest>)test {
    [test setDelegate:self];
    _stats.testCount += test.stats.testCount;
    [_children addObject:test];
}

- (void)addTests:(NSArray<id<CZJTest>> *)tests {
    for (id test in tests) {
        [self addTest:test];
    }
}

- (void)addTestCase:(id)testCase {
    CZJTestGroup *testCaseGroup = [[CZJTestGroup alloc] initWithTestCase:testCase delegate:self];
    [self addTestGroup:testCaseGroup];
}

- (void)addTestGroup:(CZJTestGroup *)testGroup {
    [self addTest:testGroup];
    testGroup.parent = self;
}

#pragma mark - Private methods

- (void)addTestsFromTestCase:(id)testCase {
    NSArray *tests = [[CZJTesting sharedInstance] loadTestsFromTarget:testCase];
    [self addTests:tests];
}

@end
