//
//  CZJTestViewController.h
//  CZJTest
//
//  Created by isExist on 2016/9/27.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZJTest.h"

// Used to display test and show the result.
@interface CZJTestViewController : UIViewController

- (void)setTest:(id<CZJTest>)test;

@end
