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
    UITextView *_logView;
    UIView *_maskView;
    
    BOOL _shouldShowLogView;
}

@end

@implementation CZJTestViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runningStateChanged) name:CZJUnitTestRunnerRunningStateChanged object:[CZJTestRunner sharedRunner]];
        
        _shouldShowLogView = YES;
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
    
    _maskView = [[UIView alloc] initWithFrame:self.view.frame];
    _maskView.backgroundColor = [UIColor darkGrayColor];
    _maskView.hidden = YES;
    UITapGestureRecognizer *tapMaskViewGes = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(toggleLogButton)];
    [_maskView addGestureRecognizer:tapMaskViewGes];
    [self.view addSubview:_maskView];
    
    _logView = [[UITextView alloc] init];
    _logView.frame = CGRectMake(0,
                                self.view.frame.size.height,
                                self.view.frame.size.width,
                                self.view.frame.size.height / 2);
    [self.view addSubview:_logView];
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
    if (_shouldShowLogView) {
        [self.view bringSubviewToFront:_maskView];
        [self.view bringSubviewToFront:_logView];
        
        _logView.text = @"";
        NSArray *log = [(CZJTest *)_testNode.test log];
        for (NSException *exception in log) {
            NSString *logString = [CZJTestRunner descriptionForException:exception];
            _logView.text = [_logView.text stringByAppendingString:logString];
        }
        
        [UIView animateWithDuration:0.3f animations:^{
            _maskView.hidden = NO;
            _maskView.alpha = .3f;
            
            _logView.frame = CGRectMake(0,
                                        self.view.center.y,
                                        self.view.frame.size.width,
                                        self.view.frame.size.height / 2);
            
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            _logView.frame = CGRectMake(0,
                                        self.view.frame.size.height,
                                        self.view.frame.size.width,
                                        self.view.frame.size.height / 2);
            
            [UIView animateWithDuration:0.3f animations:^{
                _maskView.alpha = 0.f;
                _maskView.hidden = YES;
            }];
        }];
    }
    
    _shouldShowLogView = !_shouldShowLogView;
}

- (void)runningStateChanged {
    _caseCtrlButton.title = [CZJTestRunner sharedRunner].isRunning ? @"Cancel" : @"Run";
}

@end
