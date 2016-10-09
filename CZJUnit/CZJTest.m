//
//  CZJTest.m
//  CZJUnit
//
//  Created by isExist on 2016/9/28.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import "CZJTest.h"
#import "CZJTesting.h"

CZJTestStats CZJTestStatsMake(NSInteger succeedCount, NSInteger failureCount, NSInteger cancelCount, NSInteger testCount) {
    CZJTestStats stats;
    stats.succeedCount = succeedCount;
    stats.failureCount = failureCount;
    stats.cancelCount = cancelCount;
    stats.testCount = testCount;
    return stats;
}

static NSString *kNSCodingKey_identifier = @"identifier";

@implementation CZJTest {
    NSString *_name;
    NSString *_identifier;
}

@synthesize identifier = _identifier, name = _name, status = _status, delegate = _delegate;

- (instancetype)initWithIdentifier:(NSString *)identifier name:(NSString *)name {
    if (self = [self init]) {
        _name = name;
        _identifier = identifier;
    }
    
    return self;
}

- (instancetype)initWithTarget:(id)target selector:(SEL)selector {
    NSString *name = NSStringFromSelector(selector);
    NSString *identifier = [NSString stringWithFormat:@"%@/%@", NSStringFromClass([target class]), name];
    if (self = [self initWithIdentifier:identifier name:name]) {
        _target = target;
        _selector = selector;
    }
    
    return self;
}

+ (instancetype)testWithTarget:(id)target selector:(SEL)selector {
    return [[self alloc] initWithTarget:target selector:selector];
}

#pragma mark - Protocol CZJTest

- (void)run:(CZJTestOptions)options {
    if (_status == CZJTestStatusCancelled) {
        return;
    }
    
    if ((options & CZJTestOptionForceSetUpTearDownClass) == CZJTestOptionForceSetUpTearDownClass) {
        [self setUp];
        if (_status == CZJTestStatusErrored) {
            return;
        }
    }
    
    _status = CZJTestStatusRunning;
    
//    [_delegate testDidStart:self source:self];
    
    BOOL reraiseExceptions = ((options & CZJTestOptionReraiseExceptions) == CZJTestOptionReraiseExceptions);
    NSException *exception = nil;
    [CZJTesting runTestWithTarget:_target selector:_selector exception:&exception interval:nil reraiseExceptions:reraiseExceptions];
    
    if (_status == CZJTestStatusCancelling) {
        _status = CZJTestStatusCancelled;
    } else if (_status == CZJTestStatusRunning) {
        _status = CZJTestStatusSucceeded;
    }
    
    if ((options & CZJTestOptionForceSetUpTearDownClass) == CZJTestOptionForceSetUpTearDownClass) {
        [self tearDown];
    }
    
//    [_delegate testDidEnd:self source:self];
}

- (CZJTestStats)stats {
    switch (_status) {
        case CZJTestStatusSucceeded:
            return CZJTestStatsMake(1, 0, 0, 1);
        case CZJTestStatusErrored:
            return CZJTestStatsMake(0, 1, 0, 1);
        case CZJTestStatusCancelled:
            return CZJTestStatsMake(0, 0, 1, 1);
        default:
            return CZJTestStatsMake(0, 0, 0, 1);
    }
}

#pragma mark - Private methods

- (void)setUp {
    
}

- (void)tearDown {
    
}

#pragma mark - Protocol NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_identifier forKey:kNSCodingKey_identifier];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    CZJTest *test = [self initWithIdentifier:[aDecoder decodeObjectForKey:kNSCodingKey_identifier] name:nil];
    
    return test;
}

#pragma mark - Protocol NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    if (!_target) {
        [NSException raise:NSObjectNotAvailableException format:@"NSCopying unsupported for tests without target/selector pair"];
    }
    
    return [CZJTest allocWithZone:zone];
}

@end
