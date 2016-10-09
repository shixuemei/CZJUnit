//
//  CZJTestSuite.m
//  CZJUnit
//
//  Created by isExist on 2016/10/5.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import "CZJTestSuite.h"
#import "CZJTesting.h"

@implementation CZJTestSuite

- (instancetype)initWithName:(NSString *)name testCases:(NSArray *)testCases delegate:(id<CZJTestDelegate>)delegate {
    if (self = [super initWithName:name delegate:delegate]) {
        for (id testCase in testCases) {
            [self addTestCase:testCase];
        }
    }
    
    return self;
}

+ (instancetype)suiteFromEnv {
    return [CZJTestSuite allTests];
}

+ (instancetype)allTests {
    NSArray *testCases = [[CZJTesting sharedInstance] loadAllTestCases];
    CZJTestSuite *allTests = [[CZJTestSuite alloc] initWithName:@"Tests" testCases:nil delegate:nil];
    for (id testCase in testCases) {
        [allTests addTestCase:testCase];
    }
    
    return allTests;
}

@end
