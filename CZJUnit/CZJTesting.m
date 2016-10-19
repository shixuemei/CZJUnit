//
//  CZJTesting.m
//  CZJTest
//
//  Created by isExist on 2016/9/28.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import "CZJTesting.h"
#import <objc/runtime.h>
#import "CZJTestCase.h"

BOOL isTestFixtureOfClass(Class aClass, Class testCaseClass) {
    if (testCaseClass == NULL)
        return NO;
    BOOL isCase = NO;
    Class superclass;
    for (superclass = aClass;
         !isCase && superclass;
         superclass = class_getSuperclass(superclass)) {
        isCase = superclass == testCaseClass ? YES : NO;
    }
    return isCase;
}

@interface CZJTesting () {
    NSMutableArray<NSString *> *_testCaseClassNames;
}

@end

@implementation CZJTesting

static CZJTesting *_sharedInstance = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [CZJTesting sharedInstance];
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[super allocWithZone:NULL] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _testCaseClassNames = [NSMutableArray arrayWithObjects:@"CZJTestCase", nil];
    }
    return self;
}

- (instancetype)copy {
    return _sharedInstance;
}

- (instancetype)mutableCopy {
    return _sharedInstance;
}

- (NSArray *)loadAllTestCases {
    NSMutableArray *testCases = [NSMutableArray array];
    
    int count = objc_getClassList(NULL, 0);
    NSMutableData *classData = [NSMutableData dataWithLength:sizeof(Class) * count];
    Class *classes = (Class *)[classData mutableBytes];
    NSAssert(classes, @"Couldn't allocate class list");
    objc_getClassList(classes, count);
    
    for (int i = 0; i < count; i++) {
        Class curClass = classes[i];
        id testCase = nil;
        
        if ([self isTestCaseClass:curClass]) {
            testCase = [[curClass alloc] init];
        } else {
            continue;
        }
        
        [testCases addObject:testCase];
    }

    return testCases;
}

- (NSArray<id<CZJTest>> *)loadTestsFromTarget:(id)target {
    NSMutableArray *invocations = nil;
    // Need to walk all the way up the parent classes collecting methods (in case
    //   a test is a subclass of another test).
    for (Class currentClass = [target class];
         currentClass && (currentClass != [NSObject class]);
         currentClass = class_getSuperclass(currentClass)) {
        unsigned int methodCount;
        Method *methods = class_copyMethodList(currentClass, &methodCount);
        if (methods) {
            // This handles disposing of methods for us even if an exception should fly.
            [NSData dataWithBytes:methods
                           length:sizeof(Method) * methodCount];
            if (!invocations) {
                invocations = [NSMutableArray arrayWithCapacity:methodCount];
            }
            for (size_t i = 0; i < methodCount; ++i) {
                Method currMethod = methods[i];
                SEL sel = method_getName(currMethod);
                const char *name = sel_getName(sel);
                char *returnType = NULL;
                // If it starts with test, takes 2 args (target and sel) and returns
                //   void run it.
                if (strstr(name, "test") == name) {
                    returnType = method_copyReturnType(currMethod);
                    if (returnType) {
                        // @gabriel from jjm - this does not appear to work, i am seeing
                        //                     memory leaks on exceptions
                        // This handles disposing of returnType for us even if an
                        // exception should fly. Length +1 for the terminator, not that
                        // the length really matters here, as we never reference inside
                        // the data block.
                        //[NSData dataWithBytes:returnType
                        //                     length:strlen(returnType) + 1];
                    }
                }
                // TODO: If a test class is a subclass of another, and they reuse the
                // same selector name (ie-subclass overrides it), this current loop
                // and test here will cause it to get invoked twice.  To fix this
                // the selector would have to be checked against all the ones already
                // added, so it only gets done once.
                if (returnType  // True if name starts with "test"
                    && strcmp(returnType, @encode(void)) == 0
                    && method_getNumberOfArguments(currMethod) == 2) {
                    NSMethodSignature *sig = [[target class] instanceMethodSignatureForSelector:sel];
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
                    [invocation setSelector:sel];
                    [invocations addObject:invocation];
                }
                if (returnType != NULL) {
                    free(returnType);
                }
            }
        }
        if (methods != NULL) {
            free(methods);
        }
    }
    
    NSMutableArray *tests = [[NSMutableArray alloc] initWithCapacity:[invocations count]];
    for (NSInvocation *invocation in invocations) {
        CZJTest *test = [CZJTest testWithTarget:target selector:invocation.selector];
        [tests addObject:test];
    }
    return tests;
}

+ (BOOL)runTestWithTarget:(id)target
                 selector:(SEL)selector
                exception:(NSException *__autoreleasing *)exception
                 interval:(NSTimeInterval *)interval
        reraiseExceptions:(BOOL)reraiseExceptions {

    
    NSException *testException = nil;
    
#pragma clang diagnostic push
    dispatch_sync(dispatch_get_main_queue(), ^{
        if ([target respondsToSelector:@selector(setUp)]) {
            [target performSelector:@selector(setUp)];
        }
    });
    
    if ([target respondsToSelector:@selector(setCurrentSelector:)]) {
        [target setCurrentSelector:selector];
    }
    
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    @try {
        [target performSelector:selector];
    } @catch (NSException *exception) {
        if (!testException) {
            testException = exception;
        }
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        if ([target respondsToSelector:@selector(tearDown)]) {
            [target performSelector:@selector(tearDown)];
        }
    });
#pragma clang diagnostic pop
    
    if (exception) {
        *exception = testException;
    }
    BOOL passed = (!testException);
    
    return passed;
}

- (BOOL)isTestCaseClass:(Class)aClass {
    for (NSString *className in _testCaseClassNames) {
        return isTestFixtureOfClass(aClass, NSClassFromString(className));
    }
    
    return NO;
}

@end
