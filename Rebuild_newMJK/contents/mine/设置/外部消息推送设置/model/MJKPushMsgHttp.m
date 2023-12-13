//
//  MJKPushMsgHttp.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/11.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKPushMsgHttp.h"

#import "MJKShowSendView.h"

#import "MJKMessagePushNotiViewController.h"

@implementation MJKPushMsgHttp
+ (void)pushInfoWithC_A41500_C_ID:(NSString *)C_A41500_C_ID andC_ID:(NSString *)C_ID andC_TYPE_DD_ID:(NSString *)C_TYPE_DD_ID andVC:(UIViewController *)vc andYesBlock:(void(^)(NSDictionary *data))yesBlock andNoBlock:(void(^)(void))noBlock {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"UserWebService-getPushMsg"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"C_A41500_C_ID"] = C_A41500_C_ID;
    dic[@"C_OBJECTID"] = C_ID;
    dic[@"C_TYPE_DD_ID"] = C_TYPE_DD_ID;
    
    [dict setObject:dic forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        
        if ([data[@"code"] integerValue]==200) {
            //            weakSelf.dataDic = data[@"content"];
            MJKShowSendView *showView = [[MJKShowSendView alloc]initWithFrame:vc.view.frame andButtonTitleArray:@[@"否",@"是"] andTitle:@"" andMessage:@"是否给客户发送通知消息?"];
            showView.buttonActionBlock = ^(NSString * _Nonnull str) {
                if ([str isEqualToString:@"否"]) {
                    if (noBlock) {
                        noBlock();
                    }
                } else {
                    if (yesBlock) {
                        yesBlock(data);
                    }
                }
            };
            [vc.view addSubview:showView];
            
            
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}
@end
