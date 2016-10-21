//
//  CZJTest.h
//  CZJUnit
//
//  Created by isExist on 2016/9/28.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CZJTestStatus) {
    CZJTestStatusNone = 0,
    CZJTestStatusRunning,        // Test is running
    CZJTestStatusCancelling,     // Test is being cancelled
    CZJTestStatusCancelled,      // Test was cancelled
    CZJTestStatusSucceeded,      // Test finished and succeeded
    CZJTestStatusErrored,        // Test finished and errored
};

typedef NS_OPTIONS(NSInteger, CZJTestOptions) {
    CZJTestOptionReraiseExceptions =        1 << 0,     // Allows exceptions to be raised (so you can trigger the debugger)
    CZJTestOptionForceSetUpTearDownClass =  1 << 1,     // Runs setUpClass/tearDownClass for this (each) test,
                                                        //   used when re-running a single test in a group
    CZJTestOptionNone =                     0x0
};

/*!
 Test stats.
 */
typedef struct {
    NSInteger succeedCount;         // Number of succeeded tests
    NSInteger failureCount;         // Number of failed tests
    NSInteger cancelCount;          // Number of aborted tests
    NSInteger testCount;            // Total number of tests
} CZJTestStats;

#pragma mark -

@protocol CZJTestDelegate;

@protocol CZJTest <NSObject, NSCoding, NSCopying>

@property (nonatomic, readonly) NSString *identifier;

@property (nonatomic, readonly) NSString *name;

@property (nonatomic, weak) id<CZJTestDelegate> delegate;

@property (nonatomic, assign) CZJTestStatus status;

@property (nonatomic, readonly) CZJTestStats stats;

@end

#pragma mark -

@protocol CZJTestDelegate <NSObject>

/*!
 Test started.
 @param test Test
 @param source If tests are nested, than source corresponds to the originator of the delegate call
 */
- (void)testDidStart:(id<CZJTest>)test source:(id<CZJTest>)source;

/*!
 Test updated.
 @param test Test
 @param source If tests are nested, than source corresponds to the originator of the delegate call
 */
- (void)testDidUpdate:(id<CZJTest>)test source:(id<CZJTest>)source;

/*!
 Test ended.
 @param test Test
 @param source If tests are nested, than source corresponds to the originator of the delegate call
 */
- (void)testDidEnd:(id<CZJTest>)test source:(id<CZJTest>)source;

@end

#pragma mark -

@interface CZJTest : NSObject <CZJTest>

@property (nonatomic, strong, readonly) id target;

@property (nonatomic, assign, readonly) SEL selector;

@property (nonatomic, copy) NSMutableArray *log;

/*!
 Create test with identifier, name.
 @param identifier Unique identifier
 @param name Name
 */
- (instancetype)initWithIdentifier:(NSString *)identifier name:(NSString *)name;

/*!
 Create test with target/selector pair.
 @param target Target (usually a test case)
 @param selector Selector (usually a test method)
 */
- (instancetype)initWithTarget:(id)target selector:(SEL)selector;

/*!
 Create autoreleased test with target/selector.
 @param target Target (usually a test case)
 @param selector Selector (usually a test method)
 */
+ (instancetype)testWithTarget:(id)target selector:(SEL)selector;

@end
