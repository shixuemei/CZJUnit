//
//  TestCase1.m
//  CZJUnit
//
//  Created by 陈昭杰 on 2016/10/16.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import "CZJTestCase.h"
#import "Test-Macros.h"

#import <GPUImage/GPUImage.h>
#import <libksygpulive/libksygpuimage.h>
#import "KSYGPUStreamerKit.h"

#import <UIKit/UIKit.h>

@interface TestPlayer : CZJTestCase {
    KSYMoviePlayerController *_player;
}

@end

@implementation TestPlayer

- (void)setUp {
    PRINT_CLASS_MATHOD;
    UIViewController *vc = CZJCurrentDisplayingViewController();
    
    NSURL *url = [NSURL URLWithString:@"http://maichang.kssws.ks-cdn.com/upload20150716161913.mp4"];
    _player = [[KSYMoviePlayerController alloc] initWithContentURL:url];
    
    [_player.view setFrame: vc.view.bounds];
    [vc.view addSubview: _player.view];
    vc.view.autoresizesSubviews = TRUE;
    
    _player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _player.controlStyle = MPMovieControlStyleNone;
    _player.shouldEnableVideoPostProcessing = TRUE;
    
    _player.shouldAutoplay = YES;
    _player.shouldEnableKSYStatModule = YES;
    _player.shouldLoop = NO;
    _player.scalingMode = MPMovieScalingModeAspectFit;
    _player.videoDecoderMode = MPMovieVideoDecoderMode_Hardware;
    [_player setTimeout:10 readTimeout:60];
    
    [_player prepareToPlay];
}

- (void)tearDown {
    PRINT_CLASS_MATHOD;
    [_player stop];
    _player = nil;
}

- (void)testRotate {
    PRINT_CLASS_MATHOD;
    sleep(3);
    _player.rotateDegress = 90;
    GHAssertEquals(_player.rotateDegress, 90, nil);
    sleep(1);
    _player.rotateDegress = 180;
    GHAssertEquals(_player.rotateDegress, 180, nil);
    sleep(1);
    _player.rotateDegress = 270;
    GHAssertEquals(_player.rotateDegress, 270, nil);
    sleep(1);
    _player.rotateDegress = 0;
    GHAssertEquals(_player.rotateDegress, 0, nil);
}

@end
