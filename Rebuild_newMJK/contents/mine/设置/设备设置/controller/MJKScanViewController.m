//
//  MJKScanViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/31.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WSLScanView.h"

@interface MJKScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
/** WSLScanView*/
@property (nonatomic, strong) WSLScanView *scanView;
@property (strong,nonatomic)AVCaptureDevice * device;

@property (strong,nonatomic)AVCaptureDeviceInput * input;

@property (strong,nonatomic)AVCaptureMetadataOutput * output;

@property (strong,nonatomic)AVCaptureSession * session;

@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@end

@implementation MJKScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"扫一扫";
	[self initScanClass];
}

- (void)initScanClass {
	//输出流视图
	UIView *preview  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0)];
	[self.view addSubview:preview];
	
//	__weak typeof(self) weakSelf = self;
	
	//构建扫描样式视图
	_scanView = [[WSLScanView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0)];
	_scanView.scanRetangleRect = CGRectMake(60, 120, (self.view.frame.size.width - 2 * 60),  (self.view.frame.size.width - 2 * 60));
	_scanView.colorAngle = [UIColor greenColor];
	_scanView.photoframeAngleW = 20;
	_scanView.photoframeAngleH = 20;
	_scanView.photoframeLineW = 2;
	_scanView.isNeedShowRetangle = YES;
	_scanView.colorRetangleLine = [UIColor whiteColor];
	_scanView.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
	_scanView.animationImage = [UIImage imageNamed:@"scanLine"];
	_scanView.myQRCodeBlock = ^{
//		[WSLNativeScanTool createQRCodeImageWithString:@"https://www.jianshu.com/u/e15d1f644bea" andSize:CGSizeMake(250, 250) andBackColor:[UIColor whiteColor] andFrontColor:[UIColor orangeColor] andCenterImage:[UIImage imageNamed:@"piao"]];
//		createQRCodeController.qrString = @"https://www.jianshu.com/u/e15d1f644bea";
	};
	_scanView.flashSwitchBlock = ^(BOOL open) {
//		[weakSelf.scanTool openFlashSwitch:open];
	};
	[self.view addSubview:_scanView];
	// Device
	_device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	// Input
	_input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
	// Output
	 _output = [[AVCaptureMetadataOutput alloc]init];
	[_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
	
	CGSize size = self.view.bounds.size;
	CGRect cropRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0);;
	_output.rectOfInterest =  CGRectMake(cropRect.origin.y/KScreenHeight,
										cropRect.origin.x/size.width,
										cropRect.size.height/size.height,
										cropRect.size.width/size.width);
	
	// Session
	_session = [[AVCaptureSession alloc]init];
	[_session setSessionPreset:AVCaptureSessionPresetHigh];
	if ([_session canAddInput:self.input])
		{
			[_session addInput:self.input];
		}
	if ([_session canAddOutput:self.output])
		{
			[_session addOutput:self.output];
		}
	// 条码类型 AVMetadataObjectTypeQRCode
	_output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
	// Preview
	_preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
	_preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
	_preview.frame =self.view.layer.bounds;
	[self.view.layer insertSublayer:_preview atIndex:0];
	// Start
	[_session startRunning];
	
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection

{
	NSString *stringValue;
	if ([metadataObjects count] >0)
		{
			//停止扫描
			[_session stopRunning];
			AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
			stringValue = metadataObject.stringValue;
			if (self.scanContentBackBlock) {
				self.scanContentBackBlock(stringValue);
			}
			[self.navigationController popViewControllerAnimated:YES];
		}
}


@end
