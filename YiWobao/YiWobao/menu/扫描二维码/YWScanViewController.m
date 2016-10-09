//
//  YWScanViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/9/23.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "YWShopPayViewController.h"
#import "XYLScanView.h"

#define GH_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define GH_HEIGHT   [[UIScreen mainScreen] bounds].size.height
@interface YWScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    UIImageView * imageView;
}
@property ( strong , nonatomic ) AVCaptureDevice * device;

@property ( strong , nonatomic ) AVCaptureDeviceInput * input;

@property ( strong , nonatomic ) AVCaptureMetadataOutput * output;

@property ( strong , nonatomic ) AVCaptureSession * session;

@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer * preview;

@property ( nonatomic ) CGRect rectOfInterest NS_AVAILABLE_IOS (7_0);

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, retain) UIImageView * line;

@property (strong, nonatomic) UIView *boxView;
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) CALayer *scanLayer;


@end

@implementation YWScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    self.title = @"扫描二维码";
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    
}
#pragma mark -
#pragma mark - 上下动画
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake((GH_WIDTH-(GH_WIDTH-GH_WIDTH*0.5f))/2, GH_HEIGHT*0.2f+2*num, imageView.frame.size.width, 2);
        if (2*num > GH_WIDTH-GH_WIDTH*0.5f-5) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake((GH_WIDTH-(GH_WIDTH-GH_WIDTH*0.5f))/2, GH_HEIGHT*0.2f+2*num, imageView.frame.size.width, 2);
        if (num == 2) {
            upOrdown = NO;
        }
    }
    
}

#pragma mark -
#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:( AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] > 0 )
    {   // 停止扫描
        [ _session stopRunning ];
        _line.hidden = YES;
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
       
        [self readingFinshedWithMessage:stringValue];
    }
}
- (void)readingFinshedWithMessage:(NSString *)msg{
    if (msg) {
        [self playSystemSound];
        
       YWShopPayViewController *shopVC = [[YWShopPayViewController alloc]init];
        NSRange rage = [msg rangeOfString:@"="];
        shopVC.shopID = [msg substringFromIndex:rage.location+1];
        [self.navigationController pushViewController:shopVC animated:YES];
    }

}

/**
 *  展示声音提示
 */
- (void)playSystemSound{
    NSString *path = [NSString stringWithFormat:@"%@/scan.wav", [[NSBundle mainBundle] resourcePath]];
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(filePath), &soundID);
    AudioServicesPlaySystemSound(soundID);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    XYLScanView *overView = [[XYLScanView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:overView];
    
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(0, 80, GH_WIDTH, 50)];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内";
    [self.view addSubview:labIntroudction];
    //扫描框
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake((GH_WIDTH-(GH_WIDTH-GH_WIDTH*0.5f))/2,GH_HEIGHT*0.2f,GH_WIDTH- GH_WIDTH*0.5f,GH_WIDTH-GH_WIDTH*0.5f)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    upOrdown = NO;
    num =0;
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((GH_WIDTH-(GH_WIDTH-GH_WIDTH*0.5f))/2,GH_HEIGHT*0.2f,GH_WIDTH- GH_WIDTH*0.5f,1)];
    
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];

    
    _device = [ AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    _input = [ AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    _output = [[AVCaptureMetadataOutput alloc]init];
    [ _output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    _session = [[ AVCaptureSession alloc]init];
    [ _session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([ _session canAddInput:self.input])
    {
        [ _session addInput:self.input];
    }
    if ([ _session canAddOutput:self.output])
    {
        [ _session addOutput:self.output];
    }
    
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    [ _output setRectOfInterest : CGRectMake (( 124 )/ GH_HEIGHT ,(( GH_WIDTH - 220 )/ 2 )/ GH_WIDTH , 220 / GH_HEIGHT , 220 / GH_WIDTH )];
    
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.layer.bounds;
    //    _preview.tor
    [self.view.layer insertSublayer:_preview atIndex:0];
    // 停止扫描
    [ _session startRunning];
    _line.hidden = NO;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
