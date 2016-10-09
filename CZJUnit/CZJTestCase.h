//
//  CZJTestCase.h
//  CZJTest
//
//  Created by isExist on 2016/9/28.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;

/*!
 * Get current displaying view controller.
 */
extern UIViewController * CZJCurrentDisplayingViewController(void);

@interface CZJTestCase : NSObject

@property (nonatomic, assign) SEL currentSelector;

- (void)setUp;      // Called before the invocation of the first test method in the class.

- (void)tearDown;   // Called after the last test method in the class has completed.

@end