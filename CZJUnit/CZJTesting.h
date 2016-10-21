//
//  CZJTesting.h
//  CZJTest
//
//  Created by isExist on 2016/9/28.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "CZJTest.h"

BOOL isTestFixtureOfClass(Class aClass, Class testCaseClass);

@interface CZJTesting : NSObject

+ (instancetype)sharedInstance;

/*!
 Load all test classes that we can "see".
 @result Array of initialized (and autoreleased) test case classes in an autoreleased array.
 */
- (NSArray *)loadAllTestCases;

/*!
 Load tests from target.
 @param target Target
 @result Array of id<CZJTest>
 */
- (NSArray<id<CZJTest>> *)loadTestsFromTarget:(id)target;

/*!
 Run test.
 @param target Target
 @param selector Selector
 @param exception Exception, if set, is retained and should be released by the caller.
 @param interval Time to run the test
 @param reraiseExceptions If YES, will re-raise exceptions
 */
+ (BOOL)runTestWithTarget:(id)target selector:(SEL)selector exception:(NSException **)exception
                 interval:(NSTimeInterval *)interval reraiseExceptions:(BOOL)reraiseExceptions;

- (BOOL)isTestCaseClass:(Class)aClass;

+ (NSString *)descriptionForException:(NSException *)exception;

@end
