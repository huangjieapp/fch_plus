//
//  MJKQrCodeViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/3/3.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKQrCodeViewController.h"

#import "WXApi.h"

@interface MJKQrCodeViewController ()
/** <#注释#>*/
@property (nonatomic, strong) NSString *qrcode;
/** <#注释#>*/
@property (nonatomic, strong) UIImageView *qrImageView;

@property (nonatomic, strong) UIView *bgView;
@end

@implementation MJKQrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的二维码";
    [self configUI];
}

- (void)configUI {
    UISegmentedControl *sg = [[UISegmentedControl alloc]initWithItems:@[@"公众号",@"企业号",@"小程序"]];
    sg.frame = CGRectMake(20, 20 + SafeAreaTopHeight, KScreenWidth - 40, 44);
    sg.backgroundColor = KNaviColor;
    sg.selectedSegmentIndex = 0;
    [self.view addSubview:sg];
    [sg addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(sg.frame) + 20, KScreenWidth, KScreenHeight - SafeAreaTopHeight - 200)];
    bgView.backgroundColor = COLOR_RGB(0x5FCD73);
    self.bgView = bgView;
    [self.view addSubview:bgView];
    
    UIView *operationView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame) + 20, KScreenWidth, 80)];
    [self.view addSubview:operationView];
   
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake((KScreenWidth / 2 - 50) / 2, 0, 50, 50)];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"baocuntupian"] forState:UIControlStateNormal];
    [operationView addSubview:saveButton];
    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    UILabel *saveLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(saveButton.frame), KScreenWidth / 2, 30)];
    saveLabel.font = [UIFont systemFontOfSize:14];
    saveLabel.textColor = [UIColor blackColor];
    saveLabel.text = @"保存图片";
    saveLabel.textAlignment = NSTextAlignmentCenter;
    [operationView addSubview:saveLabel];
    
    
    UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake((KScreenWidth / 2) + (KScreenWidth / 2 - 50) / 2, 0, 50, 50)];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [operationView addSubview:sendButton];
    [sendButton addTarget:self action:@selector(shareImage) forControlEvents:UIControlEventTouchUpInside];
    UILabel *sendLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth / 2, CGRectGetMaxY(sendButton.frame), KScreenWidth / 2, 30)];
    sendLabel.font = [UIFont systemFontOfSize:14];
    sendLabel.textColor = [UIColor blackColor];
    sendLabel.text = @"发送客户";
    sendLabel.textAlignment = NSTextAlignmentCenter;
    [operationView addSubview:sendLabel];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(40, 60, bgView.frame.size.width - 80, KScreenHeight - SafeAreaTopHeight - 320)];
    contentView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:contentView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((KScreenWidth - 100) / 2, CGRectGetMinY(contentView.frame) - 50, 100, 100)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NewUserSession instance].user.avatar]];
    imageView.layer.cornerRadius = 50;
    imageView.layer.masksToBounds = YES;
    [bgView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(contentView.frame.origin.x, CGRectGetMaxY(imageView.frame), contentView.frame.size.width, 30)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NewUserSession instance].user.nickName;
    [bgView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(contentView.frame.origin.x, CGRectGetMaxY(label.frame), contentView.frame.size.width, 30)];
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:14.f];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = [NewUserSession instance].C_XCXPOSITION;
    [bgView addSubview:label1];
    
    UIImageView *qrImageView = [[UIImageView alloc]initWithFrame:CGRectMake((KScreenWidth - 200) / 2, CGRectGetMaxY(label1.frame) + 10, 200, 200)];
    self.qrImageView = qrImageView;
    [bgView addSubview:qrImageView];
    UILongPressGestureRecognizer *QrCodeTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(qrCodeLongPress:)];
    qrImageView.userInteractionEnabled = YES;
    [qrImageView addGestureRecognizer:QrCodeTap];
    
    
    UILabel *noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(contentView.frame.origin.x, CGRectGetMaxY(qrImageView.frame) + 20, contentView.frame.size.width, 30)];
    noteLabel.textColor = [UIColor blackColor];
    noteLabel.font = [UIFont systemFontOfSize:14.f];
    noteLabel.textAlignment = NSTextAlignmentCenter;
    noteLabel.text = @"请扫码或长按二维码识别";
    [bgView addSubview:noteLabel];
    
    [self getGZHQrCode];
}

- (void)changeValue:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self getGZHQrCode];
    } else if (sender.selectedSegmentIndex == 1) {
        [self getQYQrCode];
    } else {
        [self getXCXQrCode];
    }
}

- (void)getXCXQrCode {
    DBSelf(weakSelf);
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    //pages/materialList/materialList
    [dict setObject:@"pages/materialList/materialList" forKey:@"page"];
//    [dict setObject:@"pages/login/login" forKey:@"page"];
    [dict setObject:[NewUserSession instance].C_APPID forKey:@"appid"];
    [dict setObject:[NewUserSession instance].C_APPSECRET forKey:@"appsecret"];
    [dict setObject:[NSString stringWithFormat:@"userid=%@", [NewUserSession instance].user.u051Id] forKey:@"sceneStr"];
    [[POPRequestManger defaultManger] requestWithMethod:POST url:@"https://www.fchcrm.com/api/my/qrcodeAddCard" dict:dict target:self finished:^(id responsed) {
        
        if ([responsed[@"code"] intValue]==200) {
            MyLog(@"%@",responsed);
            weakSelf.qrcode = responsed[@"qrcode"];
            [weakSelf.qrImageView sd_setImageWithURL:[NSURL URLWithString:responsed[@"qrcode"]]];
        } else if (([responsed[@"code"] intValue]==400)) {
            [JRToast showWithText:@"账号尚未同步"];
        }
        
    } failed:^(id error) {
        
    }];
}

- (void)getGZHQrCode {
    DBSelf(weakSelf);
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    [dict setObject:[NewUserSession instance].user.u051Id forKey:@"userid"];
    [dict setObject:@"wxa0e745ea39450b65" forKey:@"appid"];
    [dict setObject:@"d801470b3ef5759b9f84a8c1447d2dfb" forKey:@"secret"];
    [[POPRequestManger defaultManger] requestWithMethod:POST url:@"https://www.fchcrm.com/api/weixin/qrcode" dict:dict target:self finished:^(id responsed) {
        
//        if ([responsed[@"code"] intValue]==200) {
            MyLog(@"%@",responsed);
        weakSelf.qrcode = responsed[@"qrcode"];
        [weakSelf.qrImageView sd_setImageWithURL:[NSURL URLWithString:responsed[@"qrcode"]]];
            
            
//        } else if (([responsed[@"code"] intValue]==400)) {
//            [JRToast showWithText:@"账号尚未同步"];
//        }
        
    } failed:^(id error) {
        
    }];
}

- (void)getQYQrCode {
    DBSelf(weakSelf);
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    [dict setObject:[NewUserSession instance].user.u051Id forKey:@"userid"];
    [dict setObject:@"wwf9b6e3c7b4520da1" forKey:@"appid"];
    [dict setObject:@"Hr9oE4vVHkQFcsfpCmV-OQGxdkK29ZsmzF5u8NW2LuA" forKey:@"secret"];
    [[POPRequestManger defaultManger] requestWithMethod:POST url:@"https://www.fchcrm.com/api/weixin/qyqrcode" dict:dict target:self finished:^(id responsed) {
        
//        if ([responsed[@"code"] intValue]==200) {
//            MyLog(@"%@",responsed);
            
            
        weakSelf.qrcode = responsed[@"qr_code"];
        [weakSelf.qrImageView sd_setImageWithURL:[NSURL URLWithString:responsed[@"qr_code"]]];
            
//        } else if (([responsed[@"code"] intValue]==400)) {
//            [JRToast showWithText:@"账号尚未同步"];
//        }
        
    } failed:^(id error) {
        
    }];
}

- (void)saveImage {
    [self TDScreenCapture_isSavePhoto:YES snapshotView:self.bgView andCompleteBlock:^{
        [JRToast showWithText:@"已保存到相册"];
    }];
}

/**
 * 截屏-
 * isWathermark 是否带有水印-默认带有
 * isSave       是否保存到相册-默认保存
 * view         截图的view
 */
- (UIImage *)TDScreenCapture_isSavePhoto:(BOOL)isSave snapshotView:(UIView *)view andCompleteBlock:(void(^)(void))successBlock
{
    // 判断是否为retina屏, 即retina屏绘图时有放大因子
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(view.bounds.size);
    }
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
      
    UIGraphicsEndImageContext();
    // 保存到相册
    if (isSave) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        if (successBlock) {
            successBlock();
        }
    }
    return image;
}

- (void)qrCodeLongPress:(UILongPressGestureRecognizer *)pressSender {
    if (pressSender.state != UIGestureRecognizerStateBegan) {
        return;//长按手势只会响应一次
    }
    
    UIImageView *imgV = (UIImageView *)pressSender.view;
    
    //创建上下文
    CIContext *context = [[CIContext alloc] init];
    //创建一个探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    //直接开始识别图片,获取图片特征
    CIImage *imageCI = [[CIImage alloc] initWithImage:imgV.image];
    NSArray *features = [detector featuresInImage:imageCI];
    CIQRCodeFeature *codef = (CIQRCodeFeature *)features.firstObject;
        
    //弹出选项列表
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(imgV.image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
    }];
    UIAlertAction *identifyAction = [UIAlertAction actionWithTitle:@"识别二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%@", codef.messageString);
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
    }];
    [alert addAction:saveAction];
    [alert addAction:identifyAction];
    [alert addAction:cancelAction];

//    [self presentViewController:alert animated:YES completion:nil];
}

- (void)shareImage {
    UIImage *image = [self TDScreenCapture_isSavePhoto:NO snapshotView:self.bgView andCompleteBlock:nil];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
       
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData =  imageData;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.mediaObject = imageObject;

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req completion:nil];
}

@end
