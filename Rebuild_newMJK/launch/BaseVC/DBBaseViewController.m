//
//  DBBaseViewController.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/3/17.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBBaseViewController.h"

#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

//UMSocialShareMenuViewDelegate,
@interface DBBaseViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    CTCallCenter *center_;
}

@property (nonatomic,strong) UIButton * pickerBtn;

@property (nonatomic, strong) UIView *keyBoardView;
@property (nonatomic, strong) HXPhotoManager *photoManager;

@end

@implementation DBBaseViewController

static  DBBaseViewController*DBVC=nil;

+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DBVC=[[DBBaseViewController alloc]init];
    });
    return DBVC;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.keyBoardView removeFromSuperview];
    self.keyBoardView=nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    
#pragma mark - 监测打完电话了
    
//    CTCallCenter *center = [[CTCallCenter alloc] init];
//    center_ = center;
//    DBSelf(weakSelf);
//    center.callEventHandler = ^(CTCall *call) {
//        NSSet *curCalls = center_.currentCalls;
//        NSLog(@"current calls:%@", curCalls);
//        NSLog(@"call:%@", [call description]);
//        if ([call.callState isEqualToString:CTCallStateDialing]) {
//            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"enterBackground"] isEqualToString:@"yes"]) {
//                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"enterBackground"];
//            } else {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [weakSelf closePhone];
//                    [[NSNotificationCenter defaultCenter]postNotificationName:@"CTCallStateDisconnected" object:nil];
//                });
//
//            }
//        }
//    };
    
}



- (void)closePhone {
    
}

- (void)createView{

  }

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    if (self.keyBoardView==nil) {
        UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 30)];
        view.backgroundColor=DBColor(236, 236, 236);
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(0, 0, KScreenWidth, 30);
        [btn setTitleNormal:@"完成"];
        btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        btn.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 20);
        [btn setTitleColor:[UIColor blackColor]];
        [btn addTarget:self action:@selector(dismissKeyboardView)];
        [view addSubview:btn];

        
        self.keyBoardView=view;
    }
    
    DBSelf(weakSelf);
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    CGFloat height = keyboardRect.size.height;
    NSLog(@"%f-=-=-",height);
    //获取键盘弹出或收回时frame
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //获取键盘弹出所需时长
    float duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //添加弹出动画
    [UIView animateWithDuration:duration animations:^{
         weakSelf.keyBoardView.transform = CGAffineTransformMakeTranslation(0, keyboardFrame.origin.y - weakSelf.view.frame.size.height-30);
       
    }];
    
   
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.keyBoardView removeFromSuperview];
    self.keyBoardView=nil;
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    CGFloat height = keyboardRect.size.height;
    NSLog(@"%f-=-=-",height);
}

- (void)dismissKeyboardView{

    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)createLabStr:(NSString *)str withbool:(BOOL)hide{
    UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth-100)/2, 200, 100, 40)];
    lab.text=str;
    lab.textAlignment=NSTextAlignmentCenter;
    lab.textColor=DBColor(0, 0, 0);
    self.aplaceholdLab=lab;
    self.aplaceholdLab.hidden=hide;
    [self.view addSubview:self.aplaceholdLab];


}




#pragma mark  -- 使用相册
//点击相册的使用方法
-(void)TouchAddImage{
    DBSelf(weakSelf);
    UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController*imagePicker=[[UIImagePickerController alloc]init];
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing=NO;
        imagePicker.delegate=weakSelf;
        [weakSelf presentViewController:imagePicker animated:YES completion:nil];
        
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
#if TARGET_IPHONE_SIMULATOR
        MyLog(@"模拟");
        
        
#elif TARGET_OS_IPHONE
        UIImagePickerController*imagePicker=[[UIImagePickerController alloc]init];
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing=NO;
        imagePicker.delegate=weakSelf;
        [weakSelf presentViewController:imagePicker animated:YES completion:nil];

#endif
        
        
        
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
}




//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    //    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//    if (!newPhoto) {
//        newPhoto=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    }
    
    //    //吊接口  照片
    //    UITableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //    UIImageView*imageView=[cell viewWithTag:111];
    //    imageView.image=newPhoto;
    
    
    
    
    //    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}









#pragma mark  --  分享功能
//-(void)showShareMenuWithAnchor_id:(NSString*)idd{
//    MyLog(@"分享");
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        //点击了某个分享按钮之后 成功就吊用 获取分享信息的接口
//        //获取了分享的信息 在
//        [self shareWebPageToPlatformType:platformType andAnchor_id:idd];
//       
//        
//
//    }];
//    
//    
//}
//
//
////网页分享
//- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType andAnchor_id:(NSString*)idd
//{
//    //这里是吊用获取分享内容的接口
//    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_ShareInfo];
//    NSDictionary*params=@{@"anchor_id":idd};
//    HttpManager*manager=[[HttpManager alloc]init];
//    [manager postDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
//        MyLog(@"%@",data);
//        if ([data[@"errorCode"] integerValue]==0) {
//            //    NSString*imageStr=@"https://a-ssl.duitang.com/uploads/item/201606/28/20160628132132_JEnik.jpeg";
//            //    NSString*titleStr=@"压缩";
//            //    NSString*desStr=@"哈撒ki，面对疾风吧";
//            //    NSString*webStr=@"www.baidu.com";
//            
//            NSString*imageStr=data[@"data"][@"head_img"];
//            NSString*titleStr=data[@"data"][@"nickname"];
//            NSString*desStr;
//            if (data[@"data"][@"room_name"]==nil) {
//                desStr=DBGetStringWithKeyFromTable(@"L无房间名", nil);
//            }else{
//                desStr=data[@"data"][@"room_name"];
//            }
//            NSString*webStr=data[@"data"][@"share_url"];
//            
//            
//            //分享网页的数据
//            [self SharefunctionPlatform:platformType andImage:imageStr andtitle:titleStr anddes:desStr andweb:webStr];
//
//        }else{
//            [JRToast showWithText:data[@"errorMessage"]];
//        }
//        
//        
//        
//        
//    }];
//}
//
//
//     
//-(void)SharefunctionPlatform:(UMSocialPlatformType)platformType andImage:(NSString*)imageStr andtitle:(NSString*)titleStr anddes:(NSString*)desStr andweb:(NSString*)webStr{
//    //分享
//    [self setUpShare];
//
//    
//    
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    
//    //创建网页内容对象
//    //imageStr
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleStr descr:desStr thumImage:imageStr];
//    //设置网页地址
//    shareObject.webpageUrl = webStr;
//    
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject;
//    
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        
//        if (error) {
//            [JRToast showWithText:[NSString stringWithFormat:@"%@",error]];
//        }else{
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
////                UMSocialShareResponse *resp = data;
//                
//                [self getSharePoint];
//                
//                
//            }else{
//                
//                [JRToast showWithText:[NSString stringWithFormat:@"%@",data]];
//            }
//        }
//        
//    }];
//    
//  
//    
//}
//
//-(void)setUpShare{
//    //设置分享面板的显示和隐藏的代理回调
//    [UMSocialUIManager setShareMenuViewDelegate:self];
//
//    //设置用户自定义的平台
//    NSMutableArray*mtArray=[NSMutableArray array];
//    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
//        [mtArray addObject:@(UMSocialPlatformType_WechatSession)];
//        [mtArray addObject:@(UMSocialPlatformType_WechatTimeLine)];
//        [mtArray addObject:@(UMSocialPlatformType_WechatFavorite)];
//    }
//    
//    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]){
//        [mtArray addObject:@(UMSocialPlatformType_QQ)];
//        [mtArray addObject:@(UMSocialPlatformType_Qzone)];
//    }
//    
//    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Sina]){
//        [mtArray addObject:@(UMSocialPlatformType_Sina)];
//        
//    }
//    
//    [UMSocialUIManager setPreDefinePlatforms:mtArray];
//    
////    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
////                                               @(UMSocialPlatformType_WechatTimeLine),
////                                               @(UMSocialPlatformType_WechatFavorite),
////                                               @(UMSocialPlatformType_QQ),
////                                               @(UMSocialPlatformType_Qzone),
////                                               @(UMSocialPlatformType_Sina),
////                                               
////                                               ]];
//    //    [UMSocialUIManager removeAllCustomPlatformWithoutFilted];
//    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
//    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
//    
//    
//    
//}
//
////友盟退出登录
//-(void)UMCancelLogin:(NSString*)typeStr{
//    UMSocialPlatformType platType=0;
//    if ([typeStr isEqualToString:@"UMSocialPlatformType_WechatSession"]) {
//        platType=UMSocialPlatformType_WechatSession;
//    }else if ([typeStr isEqualToString:@"UMSocialPlatformType_Sina"]){
//        platType=UMSocialPlatformType_Sina;
//    }else if ([typeStr isEqualToString:@"UMSocialPlatformType_QQ"]){
//        platType=UMSocialPlatformType_QQ;
//    }else{
//         platType=UMSocialPlatformType_WechatSession;
//    }
//    
//    
//    [[UMSocialManager defaultManager] cancelAuthWithPlatform:platType completion:^(id result, NSError *error) {
//      
//        
//        
//    }];
//
//    
//}
//
//
////分享结束 回调得到马币  这里要有个接口
//-(void)getSharePoint{
//    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_SignTo];
//    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[NewUserSession instance].token,@"user_id":[NewUserSession instance].user.u051Id,@"type":@"2"};
//    HttpManager*manager=[[HttpManager alloc]init];
//    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
//        MyLog(@"%@",data);
//        if ([data[@"errorCode"] integerValue]==0) {
//            [JRToast showWithText:data[@"msg"]];
//            [NewUserSession instance].user_info.CurrencyNumber=data[@"data"];
//
//            
//        }else{
//            [JRToast showWithText:data[@"errorMessage"]];
//        }
//        
//        
//    }];
//    
//    
//    
//    
//    
//}
//
//#pragma mark - UMSocialShareMenuViewDelegate
//- (void)UMSocialShareMenuViewDidAppear
//{
//    NSLog(@"UMSocialShareMenuViewDidAppear");
//}
//- (void)UMSocialShareMenuViewDidDisappear
//{
//    NSLog(@"UMSocialShareMenuViewDidDisappear");
//}
//
//
//
//
////得到友盟分享的所有数据
//-(void)getUMShareDatasWithPlatformType:(NSString*)typeStr success:(void(^)(UMSocialUserInfoResponse* resp))success failure:(void(^)(NSError*error))fail{
//    UMSocialPlatformType platType=0;
//    if ([typeStr isEqualToString:@"UMSocialPlatformType_WechatSession"]) {
//        platType=UMSocialPlatformType_WechatSession;
//    }else if ([typeStr isEqualToString:@"UMSocialPlatformType_Sina"]){
//        platType=UMSocialPlatformType_Sina;
//    }else if ([typeStr isEqualToString:@"UMSocialPlatformType_QQ"]){
//        platType=UMSocialPlatformType_QQ;
//    }else{
//        fail(nil);
//    }
//
//    
//    //得到 所有授权的东西
////    if (![[UMSocialManager defaultManager] isInstall:platType]) {
////        fail(nil);
////    }else{
//    
//    
//    [[UMSocialManager defaultManager]getUserInfoWithPlatform:platType currentViewController:self completion:^(id result, NSError *error) {
//        if (error) {
//            [JRToast showWithText:[NSString stringWithFormat:@"%@",error]];
//            fail(nil);
//            
//        }else{
//            if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
//                
//                UMSocialUserInfoResponse *resp = result;
//                
////                NSString*uid=resp.uid;
////                NSString*platform=typeStr;
////                
////                NSString*name=resp.name;
////                NSString*iconurl=resp.iconurl;
////                NSString*gender=resp.gender;
//
//                
//                success(resp);
//            
//            }else{
//                fail(nil);
//            }
//        }
//
//        
//        
//    }];
//    
//    
//    
//
////    }
//  
//}




#pragma mark  --  支付宝支付
//-(void)ToaliPay:(NSString*)orderStringg{
//    //吊用接口  传 多少钱  得到 orderString    RSA(SHA1)密钥 老版的 没有用罪行的
//    NSString *orderString =orderStringg;
//    //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
//    NSString *appScheme = @"MDShowAliSDK";
//    
//    // NOTE: 调用支付结果开始支付
//    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//        NSLog(@"reslut = %@",resultDic);
//        
//    }];
//    
//    
//}
//
//
//
//#pragma mark  -- 微信支付
//-(void)TowechatPay:(NSDictionary*)dict{
//    //    NSString *res = [WXApiRequestHandler jumpToBizPay];
//    //    if( ![@"" isEqual:res] ){
//    //        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    //
//    //        [alter show];
//    //        [alter release];
//    //    }
//    
//    //接口 得到所有需要的东西
//    
//    
//    //    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
//    //
//    //    //调起微信支付
//    //    PayReq* req             = [[[PayReq alloc] init]autorelease];
//    //    req.partnerId           = [dict objectForKey:@"partnerid"];
//    //    req.prepayId            = [dict objectForKey:@"prepayid"];
//    //    req.nonceStr            = [dict objectForKey:@"noncestr"];
//    //    req.timeStamp           = stamp.intValue;
//    //    req.package             = [dict objectForKey:@"package"];
//    //    req.sign                = [dict objectForKey:@"sign"];
//    //    [WXApi sendReq:req];
//    
//    
//    PayReq* req  = [[PayReq alloc] init];
//    req.partnerId           = dict[@"partnerid"];
//    req.prepayId            = dict[@"prepayid"];
//    req.nonceStr            = dict[@"nonce_str"];
//    req.timeStamp           = [dict[@"timestamp"] intValue];
//    req.package             = dict[@"package"];
//    req.sign                = dict[@"sign"];
//    
//    [WXApi sendReq:req];
//    
//};



#pragma mark - WXApiDelegate
//- (void)onResp:(BaseResp *)resp {
//    if([resp isKindOfClass:[PayResp class]]){
//        //支付返回结果，实际支付结果需要去微信服务器端查询
//        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
//        
//        switch (resp.errCode) {
//            case WXSuccess:
//                strMsg = @"支付结果：成功！";
//                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                break;
//                
//            default:
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//                break;
//        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        
//    }
//    
//}




- (void)selectTelephone:(NSInteger)index{
    
    UIAlertController * alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    __weak __typeof__(self) weakSelf=self;
    UIAlertAction*sanfdal=[UIAlertAction actionWithTitle:@"用手机拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf telephoneCall:index];
        
        
    }];
    UIAlertAction*manual=[UIAlertAction actionWithTitle:@"用座机拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf landLineCall:index];
        
    }];
    UIAlertAction*callBacks=[UIAlertAction actionWithTitle:@"回呼到手机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf callBack:index];
        
    }];
    UIAlertAction*whbcallBacks=[UIAlertAction actionWithTitle:@"外呼宝拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf whbcallBack:index];
        
    }];
    
    [alertVC addAction:sanfdal];
//    [alertVC addAction:manual];
//    [alertVC addAction:callBacks];
    
    if ([NewUserSession instance].configData.setThPush == YES) {
        [alertVC addAction:whbcallBacks];
    }
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
}



#pragma  mark --- 拨打电话
//电话
- (void)telephoneCall:(NSInteger)index{
    
  
}
//座机
- (void)landLineCall:(NSInteger)index{
    
    
   
}
//回呼
- (void)callBack:(NSInteger)index{
    
    
    
}




- (void)datePickerAndMethod
{
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=self.view.bounds;
    [btn addTarget:self action:@selector(dissmissPicker) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor=CGCBGCOLOR;
    self.pickerBtn=btn;
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-200 - SafeAreaBottomHeight, KScreenWidth, 200 + SafeAreaBottomHeight)];
    view.backgroundColor=[UIColor whiteColor];
    
    UIButton * doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame=CGRectMake(KScreenWidth-60, 0, 60, 40);
    [doneBtn addTarget:self action:@selector(donePicker) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setTitleNormal:@"完成"];
    self.doneButton = doneBtn;
    [doneBtn setTitleColor:[UIColor blackColor]];
    [view addSubview:doneBtn];
    
    UIButton * canelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    canelBtn.frame=CGRectMake(0, 0, 60, 40);
    [canelBtn addTarget:self action:@selector(dissmissPicker) forControlEvents:UIControlEventTouchUpInside];
    [canelBtn setTitleNormal:@"取消"];
    [canelBtn setTitleColor:[UIColor blackColor]];
    [view addSubview:canelBtn];
    
    UIDatePicker *Picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, 160)];
    self.datePicker = Picker;
    Picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    if (@available(iOS 13.4, *)) {
        Picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    } else {
        // Fallback on earlier versions
    }
    Picker.datePickerMode = UIDatePickerModeDateAndTime;
    Picker.tag=100;
    
    NSDate *Date = [NSDate date];
    NSDateFormatter *birthformatter = [[NSDateFormatter alloc] init];
    birthformatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    birthformatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    
    
    [Picker setDate:Date animated:YES];
    [Picker addTarget:self action:@selector(showDate:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:Picker];
    [self.pickerBtn addSubview:view];
    [self.view addSubview:self.pickerBtn];
    
    
    
}

- (void)showDate:(UIDatePicker *)datePicker
{
    
}

- (void)dissmissPicker{
    
    [self.pickerBtn removeFromSuperview];
}

- (void)donePicker {
    [self.pickerBtn removeFromSuperview];
}




#pragma mark  --定位
//定位
-(void)LocateCurrentLocatedWithSuccess:(void(^)(MAPointAnnotation *annotation))successBlock{
    
    [self configLocationManager];
    
    [self initCompleteBlockWithSuccess:^(MAPointAnnotation *annotation) {
        successBlock(annotation);
        
    }];
    
    [self LocationReGeocodeAction];
    
}


- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
//    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
	
    //设置定位超时时间
    [self.locationManager setLocationTimeout:6];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:3];
    
    //设置开启虚拟定位风险监测，可以根据需要开启
    [self.locationManager setDetectRiskOfFakeLocation:NO];
}


- (void)LocationReGeocodeAction
{
    
    
    //进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}



- (void)initCompleteBlockWithSuccess:(void(^)(MAPointAnnotation *annotation))successBlock;
{
    DBSelf(weakSelf);
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        
        //根据定位信息，添加annotation
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        [annotation setCoordinate:location.coordinate];
        
        //有无逆地理信息，annotationView的标题显示的字段不一样
        if (regeocode)
        {
            [annotation setTitle:[NSString stringWithFormat:@"%@", regeocode.formattedAddress]];
            [annotation setSubtitle:[NSString stringWithFormat:@"%@-%@-%.2fm", regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]];
        }
        else
        {
            [annotation setTitle:[NSString stringWithFormat:@"lat:%f;lon:%f;", location.coordinate.latitude, location.coordinate.longitude]];
            [annotation setSubtitle:[NSString stringWithFormat:@"accuracy:%.2fm", location.horizontalAccuracy]];
        }
        
        successBlock(annotation);
        
        
        
        
    };
}


- (void)openPhotoLibraryWith:(HXPhotoManager * _Nullable)photoManager success:(void (^)(VideoAndImageModel * model))successUpdateBlock {
    if (photoManager != nil) {
        self.photoManager.configuration.singleJumpEdit = NO;
        self.photoManager.configuration.singleSelected = photoManager.configuration.singleSelected;
        self.photoManager.configuration.cameraPhotoJumpEdit = NO;
    }
    @weakify(self);
    [self hx_presentSelectPhotoControllerWithManager:self.photoManager didDone:^(NSArray<HXPhotoModel *> * _Nullable allList, NSArray<HXPhotoModel *> * _Nullable photoList, NSArray<HXPhotoModel *> * _Nullable videoList, BOOL isOriginal, UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
        @strongify(self);
        if(photoList.count < 1) return;
        HXPhotoModel *photo = [photoList firstObject];
        
        if (self.photoManager.configuration.singleJumpEdit == NO) {
            CGSize size = CGSizeMake(photo.imageSize.width * 0.5, photo.imageSize.height * 0.5);
            
            [photo requestPreviewImageWithSize:size startRequestICloud:^(PHImageRequestID iCloudRequestId, HXPhotoModel * _Nullable model) {
                // 如果图片是在iCloud上的话会先走这个方法再去下载
            } progressHandler:^(double progress, HXPhotoModel * _Nullable model) {
                // iCloud的下载进度
            } success:^(UIImage * _Nullable image, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                // image
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                
                NSString *urlStr = [NSString stringWithFormat:@"%@/system/file/uploadByQiNiu",HTTP_IP];
                HttpManager *manager = [[HttpManager alloc]init];
                [manager postDataQiNiuUpDataFileWithUrl:HTTP_UploadByQiNiu parameters:nil file:imageData andFileName:@"headimage.png" andMimeType:@".png" compliation:^(id data, NSError *error) {
                    if ([data[@"code"] integerValue] == 200) {
                        VideoAndImageModel *model = [VideoAndImageModel mj_objectWithKeyValues:data];
                        if (successUpdateBlock) {
                            successUpdateBlock(model);
                        }
                    } else {
                        [JRToast showWithText:data[@"msg"]];
                    }
                }];
                
                
            } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
                // 获取失败
            }];
        } else {
            NSData *imageData = photo.photoEdit.editPreviewData;
            if(imageData.length < 1) return;
            
            NSString *urlStr = [NSString stringWithFormat:@"%@/system/file/uploadByQiNiu",HTTP_IP];
            HttpManager *manager = [[HttpManager alloc]init];
            [manager postDataQiNiuUpDataFileWithUrl:HTTP_UploadByQiNiu parameters:nil file:imageData andFileName:@"headimage.png" andMimeType:@".png" compliation:^(id data, NSError *error) {
                if ([data[@"code"] integerValue] == 200) {
                    VideoAndImageModel *model = [VideoAndImageModel mj_objectWithKeyValues:data];
                    if (successUpdateBlock) {
                        successUpdateBlock(model);
                    }
                } else {
                    [JRToast showWithText:data[@"msg"]];
                }
            }];
        }
    } cancel:^(UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (HXPhotoManager *)photoManager {
    if (!_photoManager) {
        _photoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _photoManager.configuration.type = HXConfigurationTypeWXMoment;
        _photoManager.configuration.localFileName = @"hx_WxMomentPhotoModels";
        _photoManager.configuration.showOriginalBytes = YES;
        _photoManager.configuration.showOriginalBytesLoading = YES;
        // 添加一个可以更改可查看照片的数据
        
        _photoManager.selectPhotoFinishDismissAnimated = YES;
        _photoManager.cameraFinishDismissAnimated = YES;
        _photoManager.type = HXPhotoManagerSelectedTypePhoto;
        _photoManager.configuration.singleJumpEdit = YES;
        _photoManager.configuration.openCamera = YES;
        _photoManager.configuration.singleSelected = YES;
        _photoManager.configuration.lookGifPhoto = NO;
        _photoManager.configuration.lookLivePhoto = NO;
        _photoManager.configuration.photoEditConfigur.aspectRatio = HXPhotoEditAspectRatioType_1x1;
        _photoManager.configuration.photoEditConfigur.onlyCliping = YES;
    }
    return _photoManager;
}

@end
