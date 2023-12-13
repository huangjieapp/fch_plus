//
//  MJKMessagePushNotiViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/17.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKMessagePushNotiViewController.h"

#import <QuestionInputUI/QuestionInputUI.h>

#import "OrderDetailViewController.h"

#import "DBNavigationController.h"

#import "MJKShowSendView.h"

#import <MessageUI/MessageUI.h>

#import "WXApi.h"
#import "MJKBusinessCardSetViewController.h"

@interface MJKMessagePushNotiViewController ()<MFMessageComposeViewControllerDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UIButton *commitButton;
/** InputQuestionContentView *questionView*/
@property (nonatomic, strong) NSArray *objectArr;
@end

@implementation MJKMessagePushNotiViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"通知消息";
    [self.view addSubview:self.commitButton];
    

    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:@"btn-返回"];
    [backButton addTarget:self action:@selector(clickBackButtonAction)];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    DBSelf(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:@"WillEnterForeground" object:nil];
}

- (void)enterForeground {
    [self httpPushMessageAgain];
}

- (void)clickBackButtonAction {
    if (self.backActionBlock) {
        self.backActionBlock();
    }
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self initUI];
}

- (void)initUI {
    
    NSArray *arr = self.dataDic[@"params"];
    
    NSString *pushMessage = self.dataDic[@"pushMessage"];
    
    NSMutableArray *objectArr = [NSMutableArray array];
    
    for (int i = 0; i < arr.count; i++) {
        
        NSString *str = arr[i];
        CGSize size = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20.f) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
        
        NSRange range;
        range = [pushMessage rangeOfString:[NSString stringWithFormat:@"{%d}",i + 1]];
        if (range.location != NSNotFound) {
           pushMessage = [pushMessage stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"{%d}",i + 1] withString:@""];
        }
        
        [objectArr addObject:[[InputLocationInfoObject alloc] initWithInputSize:CGSizeMake(size.width + 10, 20.f) locationIndex:range.location]];
    }
    
    self.objectArr = [objectArr copy];
    InputQuestionContentView *questionView = [[InputQuestionContentView alloc]initWithStartPoint:CGPointMake(20.0f, SafeAreaTopHeight) contentWidth:self.view.bounds.size.width - 40.0f text:pushMessage font:[UIFont systemFontOfSize:14.0f] textColor:[UIColor darkGrayColor] lineGap:1.f wordGap:1.0f inputLocations:objectArr];
    NSMutableArray *objectDataArr = [NSMutableArray array];
    [arr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //当需要结束循环的时候,调用stop,赋予YES
        [objectDataArr addObject:obj];
        
    }];
    for (int i = 0; i < objectArr.count; i++) {
        InputLocationInfoObject *object = objectArr[i];
        object.inputContentField.textColor = [UIColor blackColor];
        object.inputContentField.text = objectDataArr[i];
    }
    
    [self.view addSubview:questionView];
    
}

- (void)commitButtonAction {
    DBSelf(weakSelf);
    
    NSString *pushMessageStr = self.dataDic[@"pushMessage"];
    for (int i = 0; i < self.objectArr.count; i++) {
        InputLocationInfoObject *object = self.objectArr[i];
        NSLog(@"%@",object.inputContentField.text);
        NSRange range;
        range = [pushMessageStr rangeOfString:[NSString stringWithFormat:@"{%d}",i + 1]];
        if (range.location != NSNotFound) {
            pushMessageStr = [pushMessageStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"{%d}",i + 1] withString:object.inputContentField.text];
        }
    }
    
    NSArray *arr = self.dataDic[@"openids"];
    NSString *phonrStr = self.dataDic[@"phone"];
    if (arr.count <= 0) {
        MJKShowSendView *showView = [[MJKShowSendView alloc]initWithFrame:self.view.frame andButtonTitleArray:@[@"短信发送",@"个人微信发送"] andTitle:@"" andMessage:@"您好！请选择以下两种形式进行通知消息发送。"];
        showView.buttonActionBlock = ^(NSString * _Nonnull str) {
            
            if ([str isEqualToString:@"短信发送"]) {
//                MFMessageCompdoseViewController *vc = [[MFMessageComposeViewController alloc] init];
//                // 设置短信内容
//                vc.body = pushMessageStr;
//
//                // 设置收件人列表
//                vc.recipients = @[phonrStr];  // 号码数组
//                // 设置代理
//                vc.messageComposeDelegate = self;
//                // 显示控制器
//                [self presentViewController:vc animated:YES completion:nil];
                [weakSelf phonePush];
            } else if ([str isEqualToString:@"个人微信发送"]) {
//                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//                req.text =pushMessageStr;
//                req.bText = YES;
//                req.scene = 0;
//                [WXApi sendReq:req];
                [weakSelf getOperationLog];
                if ([NewUserSession instance].I_MP_SQ == nil) {
                    MJKBusinessCardSetViewController *vc = [[MJKBusinessCardSetViewController alloc]init];
//                    vc.openBusinessCardBlock = ^{
//                    };
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    return ;
                } else {
                    WXMiniProgramObject *object = [WXMiniProgramObject object];
                    object.webpageUrl = @"http://www.qq.com";
                    object.userName = [NewUserSession instance].C_GID;
                    NSString *str = [NSString stringWithFormat:@"/pages/push/push?id=%@&objectid=%@&type=%@&accountid=%@&sharename=%@&shareopenid%@",self.C_A41500_C_ID,self.dataDic[@"C_OBJECTID"],self.C_TYPE_DD_ID,[NewUserSession instance].user.u051Id,[NewUserSession instance].user.nickName,[NewUserSession instance].user.C_OPENID];
                    object.path = str;
                    UIImage *image = [UIImage imageNamed:@"支付功能_03"];
                    object.hdImageData = UIImagePNGRepresentation(image);
                    object.withShareTicket = NO;
                    object.miniProgramType = WXMiniProgramTypeRelease;
                    WXMediaMessage *message = [WXMediaMessage message];
                    message.title = self.titleNameXCX;
                    //                message.description = @"小程序描述";
                    message.thumbData = nil;  //兼容旧版本节点的图片，小于32KB，新版本优先
                    //使用WXMiniProgramObject的hdImageData属性
                    message.mediaObject = object;
                    
                    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                    req.bText = NO;
                    req.message = message;
                    req.scene = WXSceneSession;  //目前只支持会话
                    [WXApi sendReq:req completion:nil];
                }
                
                
            }
            if (self.backActionBlock) {
                self.backActionBlock();
            }
        };
        [self.view addSubview:showView];
    } else {
        
    }
    
    
//    [self clickBackButtonAction];
}

- (void)httpPushMessageAgain {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"UserWebService-getPushMsg"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"C_A41500_C_ID"] = self.C_A41500_C_ID;
    dic[@"C_OBJECTID"] = self.C_ID;
    dic[@"C_TYPE_DD_ID"] = self.C_TYPE_DD_ID;
    
    [dict setObject:dic forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        
        if ([data[@"code"] integerValue]==200) {
            [NewUserSession instance].accountId = data[@"accountId"];
            [NewUserSession instance].user.C_OPENID = data[@"C_OPENID"];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (void)getOperationLog {
    //UserWebService-pushMsgByCustomer
    DBSelf(weakSelf);
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"UserWebService-pushMsgByCustomer"];
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    dic[@"params"] = self.dataDic[@"params"];
    //    dic[@"openids"] = self.dataDic[@"openids"];
    dic[@"C_OBJECTID"] = self.dataDic[@"C_OBJECTID"];
    dic[@"C_TYPE_DD_ID"] = self.C_TYPE_DD_ID;
    
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            
            [weakSelf pushSaveLogXCX];
        }else{
            
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
    
    
    
}

////随机18位随机数
-(NSString *)ret18bitString {
    char data[18];
    for (int x=0;x<18;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:18 encoding:NSUTF8StringEncoding];
}

- (void)pushSaveLogXCX {
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    dict[@"objectid"] = self.dataDic[@"C_OBJECTID"];
    dict[@"shareopenid"] = [NewUserSession instance].user.C_OPENID;
    dict[@"type"] = @"4";
    dict[@"storecode"] = [NewUserSession instance].user.C_LOCCODE;
    dict[@"shareToken"] = [self ret18bitString];
    
    
    [[POPRequestManger defaultManger] requestWithNoHudMethod:POST url:@"https://xcx.51mcr.com/api/material/share" dict:dict target:self andIsHud:NO finished:^(id responsed) {
        
    } failed:^(id error) {
       
    }];
    
    
}

- (void)phonePush {
    //UserWebService-pushMsgByCustomer
        
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"UserWebService-pushMsgByCustomer"];
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    dic[@"phone"] = self.dataDic[@"phone"];
    dic[@"smsType"] = self.dataDic[@"smsType"];
    dic[@"params"] = self.dataDic[@"params"];
//    dic[@"openids"] = self.dataDic[@"openids"];
    dic[@"C_OBJECTID"] = self.dataDic[@"C_OBJECTID"];
    dic[@"C_TYPE_DD_ID"] = self.C_TYPE_DD_ID;
    
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            [JRToast showWithText:@"短信已发送"];
        }else{
            
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
        
        
        
}

- (UIButton *)commitButton {
    if (!_commitButton) {
        _commitButton = [[UIButton alloc]initWithFrame:CGRectMake(5, KScreenHeight - 60 - SafeAreaBottomHeight, KScreenWidth - 10, 50)];
        [_commitButton setTitleNormal:@"发送"];
        [_commitButton setTitleColor:[UIColor blackColor]];
        [_commitButton setBackgroundColor:KNaviColor];
        [_commitButton addTarget:self action:@selector(commitButtonAction)];
        
    }
    return _commitButton;
}

@end
