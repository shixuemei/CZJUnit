//
//  CZJTestViewController.m
//  CZJTest
//
//  Created by isExist on 2016/9/27.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import "CZJTestViewController.h"
#import "CZJTestNode.h"
#import "CZJTestRunner.h"

@interface CZJTestViewController () {
    CZJTestNode *_testNode;
    
    UIBarButtonItem *_caseCtrlButton;
    UIBarButtonItem *_caseLogButton;
}

@end

@implementation CZJTestViewController

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    _caseCtrlButton = [[UIBarButtonItem alloc] initWithTitle:@"Run" style:UIBarButtonItemStylePlain target:self
                                                      action:@selector(toggleCtrlButton)];
    _caseLogButton = [[UIBarButtonItem alloc] initWithTitle:@"Log" style:UIBarButtonItemStylePlain target:self
                                                     action:@selector(toggleLogButton)];
    self.navigationItem.rightBarButtonItems = @[_caseCtrlButton, _caseLogButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.hidesBarsOnSwipe = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTest:(id<CZJTest>)test {
    _testNode = [[CZJTestNode alloc] initWithTest:test children:nil source:nil];
    self.title = _testNode.identifier;
}

#pragma mark - Private methods

- (void)toggleCtrlButton {
    [[CZJTestRunner sharedRunner] runTest:_testNode.test
                              withOptions:CZJTestOptionNone];
}

- (void)toggleLogButton {
    
}

@end
