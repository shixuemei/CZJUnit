//
//  CZJTestViewModel.m
//  CZJUnit
//
//  Created by isExist on 2016/9/29.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import "CZJTestViewModel.h"
#import "CZJTestSuite.h"

#define DEFAULT_CACHED_FILE_NAME(identifier) [NSString stringWithFormat:@"CZJUnit-%@.tests", identifier]

@interface CZJTestViewModel () {
    NSString *_identifier;
    CZJTestSuite *_suite;
    CZJTestNode *_root;
    NSMutableDictionary *_map;
    NSMutableDictionary *_defaults;
}

@end

@implementation CZJTestViewModel

- (instancetype)initWithIdentifier:(NSString *)identifier suite:(CZJTestSuite *)suite {
    if (self = [self init]) {
        _identifier = identifier;
        _suite = suite;
        _map = [NSMutableDictionary dictionary];
        _root = [[CZJTestNode alloc] initWithTest:suite children:suite.children source:self];
    }
    
    return self;
}

- (void)testNodeDidChange:(CZJTestNode *)node {
    
}

- (NSString *)name {
    return _root.name;
}

- (NSInteger)numberOfGroups {
    return _root.children.count;
}

- (NSInteger)numberOfTestsInGroup:(NSInteger)group {
    NSArray *children = _root.children;
    if (children.count == 0) {
        return 0;
    }
    
    CZJTestNode *groupNode = children[group];
    return groupNode.children.count;
}

- (void)loadDefaults {
    if (!_defaults) {
        NSString *path = [self defaultsPath];
        if (path) {
            _defaults = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        }
    }
    
    if (!_defaults) {
        _defaults = [NSMutableDictionary dictionary];
    }
    
    [self updateTestNodeWithDefaults:_root];
}

- (void)registerNode:(CZJTestNode *)node {
    _map[node.identifier] = node;
    node.delegate = self;
}

#pragma mark - Private methods

- (NSString *)defaultsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if (paths.count == 0) {
        return nil;
    }
    
    NSString *identifier = _identifier ? _identifier : @"Tests";
    return [paths[0] stringByAppendingPathComponent:DEFAULT_CACHED_FILE_NAME(identifier)];
}

- (void)updateTestNodeWithDefaults:(CZJTestNode *)node {
    id<CZJTest> test = node.test;
    id<CZJTest> testDefault = _defaults[test.identifier];
    
    if (testDefault) {
        test.status = testDefault.status;
    }
    
    for (CZJTestNode *childNode in node.children) {
        [self updateTestNodeWithDefaults:childNode];
    }
}


@end
