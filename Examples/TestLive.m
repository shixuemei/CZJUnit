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

@interface TestLive : CZJTestCase {
    KSYGPUStreamerKit *_kit;
    KSYMoviePlayerController *_player;
    NSURL *_hostURL;
    NSURL *_playURL;
}

@end

@implementation TestLive

- (void)setUp {
    PRINT_CLASS_MATHOD;
    
    _kit = [[KSYGPUStreamerKit alloc] initWithDefaultCfg];
    
    _kit.capPreset        = AVCaptureSessionPreset640x480;
    _kit.previewDimension = CGSizeMake(640, 360);
    _kit.streamDimension  = CGSizeMake(640, 360);
    _kit.videoFPS       = 15;
    _kit.cameraPosition = AVCaptureDevicePositionBack;
    _kit.gpuOutputPixelFormat = kCVPixelFormatType_32BGRA;
    _kit.videoProcessingCallback = ^(CMSampleBufferRef buf) { };
    
    _kit.gpuToStr.bCustomOutputSize = YES;
    
    _kit.streamerBase.videoCodec = KSYVideoCodec_AUTO;
    _kit.streamerBase.videoInitBitrate =  800;
    _kit.streamerBase.videoMaxBitrate  = 1000;
    _kit.streamerBase.videoMinBitrate  =    0;
    _kit.streamerBase.audiokBPS        =   48;
    _kit.streamerBase.enAutoApplyEstimateBW     = YES;
    _kit.streamerBase.shouldEnableKSYStatModule = YES;
    _kit.streamerBase.videoFPS = 15;
    _kit.streamerBase.logBlock = ^(NSString* str) { };
    
    NSString *devCode  = [ [[[UIDevice currentDevice] identifierForVendor] UUIDString] substringToIndex:3];
    NSString *streamSrv  = @"rtmp://test.uplive.ksyun.com/live";
    NSString *streamUrl      = [ NSString stringWithFormat:@"%@/%@", streamSrv, devCode];
    _hostURL = [NSURL URLWithString:streamUrl];
    
    _playURL = [NSURL URLWithString:[NSString stringWithFormat:@"rtmp://test.live.ks-cdn.com/live/%@", devCode]];
}

- (void)tearDown {
    PRINT_CLASS_MATHOD;
    [_kit.streamerBase stopStream];
    [_kit stopPreview];
    _kit = nil;
    
    [_player stop];
    _player = nil;
}

- (void)testPushStreamInLandscape {
    PRINT_CLASS_MATHOD;
    
    [[UIDevice currentDevice] performSelectorOnMainThread:@selector(setOrientation:)
                                               withObject:@(UIDeviceOrientationLandscapeLeft)
                                            waitUntilDone:YES];
    
    UIViewController *vc = CZJCurrentDisplayingViewController();
    
    _kit.videoOrientation = [UIApplication sharedApplication].statusBarOrientation;
    [_kit startPreview:vc.view];
    [_kit.streamerBase startStream:_hostURL];
    
    sleep(5);
    _player = [[KSYMoviePlayerController alloc] initWithContentURL:_playURL];
    
    _player.shouldEnableVideoPostProcessing = TRUE;
    
    _player.shouldAutoplay = YES;
    _player.shouldEnableKSYStatModule = YES;
    _player.shouldLoop = NO;
    _player.videoDecoderMode = MPMovieVideoDecoderMode_Hardware;
    [_player setTimeout:10 readTimeout:60];
    [_player prepareToPlay];
    sleep(5);
    
    GHAssertEquals(_player.naturalSize.width, _kit.streamDimension.width, nil);
    GHAssertEquals(_player.naturalSize.height, _kit.streamDimension.height, nil);
}

@end
