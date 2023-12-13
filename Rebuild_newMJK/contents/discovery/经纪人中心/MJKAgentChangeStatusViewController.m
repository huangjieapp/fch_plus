//
//  MJKaAgentChangeStatusViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/3/4.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import "MJKAgentChangeStatusViewController.h"
#import "MJKAgentChangeStatusTableViewCell.h"

#import "WXApi.h"

@interface MJKAgentChangeStatusViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *submitButton;
/** <#注释#>*/
@property (nonatomic, strong) NSIndexPath *preIndexPath;
@end

@implementation MJKAgentChangeStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"变更类型";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableView];
    if ([self.C_TYPE_DD_ID isEqualToString:@"A47700_C_TYPE_0004"]) {
        self.preIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.submitButton setTitleNormal:@"确认并发送邀请"];
    } else if ([self.C_TYPE_DD_ID isEqualToString:@"A47700_C_TYPE_0002"]) {
        self.preIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.submitButton setTitleNormal:@"确认并发送邀请"];
    } else {
        self.preIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.submitButton setTitleNormal:@"确认"];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKAgentChangeStatusTableViewCell *cell = [MJKAgentChangeStatusTableViewCell cellWithTableView:tableView];
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"兼职业务员";
        cell.desLabel.text = @"(开通小程序功能,并可独立接待客户)";
    } else if (indexPath.row == 1) {
        cell.titleLabel.text = @"推广达人";
        cell.desLabel.text = @"(开通小程序功能,只负责推广,接待由销售完成)";
    } else {
        cell.titleLabel.text = @"普通粉丝";
        cell.desLabel.text = @"(不开通/关闭小程序功能)";
//        cell.chooseView.layer.borderColor = [UIColor redColor].CGColor;
    }
    if (indexPath.row == self.preIndexPath.row) {
        cell.chooseView.layer.borderColor = [UIColor redColor].CGColor;
    } else {
        cell.chooseView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKAgentChangeStatusTableViewCell *preCell = [tableView cellForRowAtIndexPath:self.preIndexPath];
    preCell.chooseView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    MJKAgentChangeStatusTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.chooseView.layer.borderColor = [UIColor redColor].CGColor;
    if (indexPath.row == 0) {
        self.C_TYPE_DD_ID = @"A47700_C_TYPE_0004";
    } else if (indexPath.row == 1) {
        self.C_TYPE_DD_ID = @"A47700_C_TYPE_0002";
    } else {
        self.C_TYPE_DD_ID = @"A47700_C_TYPE_0000";
    }
    
    if (indexPath.row == 2) {
        [self.submitButton setTitleNormal:@"确认"];
    } else {
        [self.submitButton setTitleNormal:@"确认并发送邀请"];
    }
    
    self.preIndexPath = indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)submitButtonAction {
    if (self.C_TYPE_DD_ID.length <= 0) {
        [JRToast showWithText:@"请选择类型"];
        return;
    }
    [self setTypeStatus];
}

-(void)setTypeStatus{
    DBSelf(weakSelf);
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A47700WebService-updateStar"];
    NSDictionary*contentDict=@{@"C_ID":self.C_ID,@"C_TYPE_DD_ID":self.C_TYPE_DD_ID};
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] intValue] == 200) {
            if (![weakSelf.C_STATUS_DD_ID isEqualToString:@"A47700_C_STATUS_0000"]) {
                if ([contentDict[@"C_TYPE_DD_ID"] isEqualToString:@"A47700_C_TYPE_0004"]) {
                    WXMiniProgramObject *miniProgramObj = [WXMiniProgramObject object];
                        miniProgramObj.webpageUrl = @"http://www.qq.com"; // 兼容低版本的网页链接
                        miniProgramObj.miniProgramType=WXMiniProgramTypeRelease;

                        miniProgramObj.userName = [NewUserSession instance].C_GID;     // 小程序原始id
                    miniProgramObj.path = [NSString stringWithFormat:@"/pages/cardAdd/cardAdd?usertoken=%@&storeid=%@&a477id=%@&type=%@&phone=%@&industry=%@",[NewUserSession instance].accountId,[NewUserSession instance].user.C_LOCCODE,self.C_ID,@"1",self.phone,self.C_INDUSTRY_DD_ID];
                    //小程序页面路径
                    UIImage *image = [UIImage imageNamed:@"icon_wx_lj"];
                        miniProgramObj.hdImageData= UIImageJPEGRepresentation(image, 0.1);
                        WXMediaMessage *msg = [WXMediaMessage message];
                        msg.title = [NSString stringWithFormat:@"%@房车汇邀请您",[NewUserSession instance].user.nickName];                    // 小程序消息title
                    //    msg.description = @"脉居客";// 小程序消息desc
                        msg.thumbData = UIImageJPEGRepresentation(image, 0.1);// 小程序消息封面图片，小于128k
                        msg.mediaObject=miniProgramObj;
                        SendMessageToWXReq  *req = [[SendMessageToWXReq alloc] init];
                        
                        req.message = msg;
                        req.scene = WXSceneSession;  // 目前支持会话
                        [WXApi sendReq:req completion:nil];
//                    
                } else if ([contentDict[@"C_TYPE_DD_ID"] isEqualToString:@"A47700_C_TYPE_0002"]) {
//
                    WXMiniProgramObject *miniProgramObj = [WXMiniProgramObject object];
                                           miniProgramObj.webpageUrl = @"http://www.qq.com"; // 兼容低版本的网页链接
                                           miniProgramObj.miniProgramType=WXMiniProgramTypeRelease;

                                           miniProgramObj.userName = [NewUserSession instance].C_GID;     // 小程序原始id
                    miniProgramObj.path = [NSString stringWithFormat:@"/pages/cardAdd/cardAdd?usertoken=%@&storeid=%@&a477id=%@&type=%@&phone=%@&industry=%@",[NewUserSession instance].accountId,[NewUserSession instance].user.C_LOCCODE,self.C_ID,@"0",self.phone,self.C_INDUSTRY_DD_ID];
                    //小程序页面路径
                    
                    UIImage *image = [UIImage imageNamed:@"icon_wx_lj"];
                                           miniProgramObj.hdImageData= UIImageJPEGRepresentation(image, 0.1);
                                           WXMediaMessage *msg = [WXMediaMessage message];
                                           msg.title = [NSString stringWithFormat:@"%@房车汇邀请您",[NewUserSession instance].user.nickName];                    // 小程序消息title
                                       //    msg.description = @"脉居客";// 小程序消息desc
                                           msg.thumbData = UIImageJPEGRepresentation(image, 0.1);// 小程序消息封面图片，小于128k
                                           msg.mediaObject=miniProgramObj;
                                           SendMessageToWXReq  *req = [[SendMessageToWXReq alloc] init];
                                           
                                           req.message = msg;
                                           req.scene = WXSceneSession;  // 目前支持会话
                                           [WXApi sendReq:req completion:nil];
                }
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        } else {
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
    
    
    
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 55) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 55 - SafeAreaBottomHeight, KScreenWidth, 55)];
        self.submitButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, KScreenWidth - 10, 45)];
        [self.submitButton setBackgroundColor:KNaviColor];
        [self.submitButton setTitleColor:[UIColor blackColor]];
        self.submitButton.layer.cornerRadius = 5.f;
        [self.submitButton addTarget:self action:@selector(submitButtonAction)];
        [_bottomView addSubview:self.submitButton];
        
    }
    return _bottomView;
}

@end
