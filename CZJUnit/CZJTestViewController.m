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

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runningStateChanged) name:CZJUnitTestRunnerRunningStateChanged object:[CZJTestRunner sharedRunner]];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CZJUnitTestRunnerRunningStateChanged object:[CZJTestRunner sharedRunner]];
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *ctrlTittle = [CZJTestRunner sharedRunner].isRunning ? @"Cancel" : @"Run";
    _caseCtrlButton = [[UIBarButtonItem alloc] initWithTitle:ctrlTittle style:UIBarButtonItemStylePlain target:self
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
    if ([CZJTestRunner sharedRunner].isRunning) {
        [[CZJTestRunner sharedRunner] cancel];
    } else {
        [[CZJTestRunner sharedRunner] runTest:_testNode.test
                                  withOptions:CZJTestOptionNone];
    }
}

- (void)toggleLogButton {
    
}

- (void)runningStateChanged {
    _caseCtrlButton.title = [CZJTestRunner sharedRunner].isRunning ? @"Cancel" : @"Run";
}

@end
