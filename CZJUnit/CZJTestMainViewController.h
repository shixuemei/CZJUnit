//
//  CZJTestMainViewController.h
//  CZJTest
//
//  Created by isExist on 2016/9/23.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CZJTestTableViewDataSource;

@interface CZJTestMainViewController : UIViewController

@property (nonatomic, readonly, strong) CZJTestTableViewDataSource *dataSource;

@end
