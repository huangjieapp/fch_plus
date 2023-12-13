//
//  MJKMaterialListViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/9/16.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import "MJKMaterialListViewController.h"
#import "MJKMaterialDetailViewController.h"

#import "MJKMaterialListTypeTableViewCell.h"
#import "MJKMaterialListType0TableViewCell.h"

#import "MJKMaterialListModel.h"

#import "WXApi.h"

#import "ZZShareView.h"

#import "WWKApi.h"

@interface MJKMaterialListViewController ()<UITableViewDataSource, UITableViewDelegate,ZZShareDelegate,WWKApiDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, assign) NSInteger pageSize;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *dataArray;
/** ZZShareView*/
@property (nonatomic, strong) ZZShareView *shareView;
/** <#注释#>*/
@property (nonatomic, strong) MJKMaterialListModel *exModel;
@end

@implementation MJKMaterialListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self initUI];
}

- (void)initUI {
    /*! @brief 调用这个方法前需要先到管理端进行注册 走管理端的注册方式
         *
         * 在管理端通过注册(可能需要等待审批)，获得schema+corpid+agentid
         * @param registerApp 第三方App的Schema
         * @param corpId 第三方App所属企业的ID
         * @param agentId 第三方App在企业内部的ID
         */
    [WWKApi registerApp:@"wwauthf37d01c97bf0f76d000002" corpId:@"wwf37d01c97bf0f76d" agentId:@"1000002"];
    self.title = @"素材列表";
    [self.view addSubview:self.tableView];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setTitleNormal:@"+"];
    [button setTitleColor:[UIColor blackColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:30.f];
    [button addTarget:self action:@selector(addAction)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    [self configRefresh];
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.pageSize = 20;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageSize = 20;
        [weakSelf httpRequestList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageSize += 20;
        [weakSelf httpRequestList];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    MJKMaterialListModel *model = self.dataArray[indexPath.row];
    if ([model.type isEqualToString:@"0"]) {
        MJKMaterialListType0TableViewCell *cell = [MJKMaterialListType0TableViewCell cellWithTableView:tableView];
        cell.model = model;
        cell.shareButtonActionBlock = ^{
            weakSelf.shareView = [[ZZShareView alloc]initWithdelegate:self withArr:@[@"微信好友",@"朋友圈",@"小程序",@"企业微信"]];
            [weakSelf.view addSubview:weakSelf.shareView];
            weakSelf.exModel=model;
        };
        return cell;
    } else {
        MJKMaterialListTypeTableViewCell *cell = [MJKMaterialListTypeTableViewCell cellWithTableView:tableView];
        cell.model = model;
        cell.shareButtonActionBlock = ^{
            weakSelf.shareView = [[ZZShareView alloc]initWithdelegate:self withArr:@[@"微信好友",@"朋友圈",@"小程序",@"企业微信"]];
            [weakSelf.view addSubview:weakSelf.shareView];
            weakSelf.exModel=model;
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKMaterialListModel *model = self.dataArray[indexPath.row];
    if ([model.type isEqualToString:@"0"]) {
        return [MJKMaterialListType0TableViewCell heightForCellWithModel:model];
    } else {
        return [MJKMaterialListTypeTableViewCell heightForCellWithModel:model];
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKMaterialListModel *model = self.dataArray[indexPath.row];
    if ([model.type isEqualToString:@"4"]) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.fchcrm.com/api/mjk/forward?openid=%@&id=%@",model.openid,model.cid] ]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.fchcrm.com/api/forward?openid=%@&id=%@",model.openid,model.cid]]];
        }
    } else {
        MJKMaterialDetailViewController *vc = [[MJKMaterialDetailViewController alloc]initWithNibName:@"MJKMaterialDetailViewController" bundle:nil];
        vc.productid = model.cid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)addAction {
    DBSelf(weakSelf);
    [self httpGetAccountIdWithSuccessBlock:^(NSString *userToken, NSString *openId) {
        WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
        launchMiniProgramReq.userName = [NewUserSession instance].C_GID;  //拉起的小程序的username
        launchMiniProgramReq.path = @"pages/materialAdd/materialAdd?show=1";    ////拉起小程序页面的可带参路径，不填默认拉起小程序首页，对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
        launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
        [WXApi sendReq:launchMiniProgramReq completion:nil];
    }];
}

/// 分享视图代理
- (void)selectBtn:(ZZShareView *)shareView withButtonTitle:(NSString *)buttonTitle{
    
    
    if ([buttonTitle isEqualToString:@"微信好友"]) {
        [self httpGetAccountIdWithSuccessBlock:^(NSString *userToken, NSString *openid) {
            [self httpShareWithSid:self.exModel.cid andClassify:@"3" andUserToken:userToken andOpenid:openid andSuccessBlock:^(NSString *shareToken) {
            //            if ([self.exModel.type intValue]==4) {
            //             [self shareMinWXWith:self.exModel.cid withImgStr:[self.exModel.images firstObject]];
            //            }else{
                             [self shareSessionWXWith:self.exModel.cid withImgStr:self.exModel.fxpicurl withShareToken:shareToken];
            //            }
                    }];
        }];
        
    }
    if ([buttonTitle isEqualToString:@"朋友圈"]) {
        [self httpGetAccountIdWithSuccessBlock:^(NSString *userToken, NSString *openid) {
             [self httpShareWithSid:self.exModel.cid andClassify:@"4" andUserToken:userToken andOpenid:openid andSuccessBlock:^(NSString *shareToken){
        //        if ([self.exModel.type intValue]==4) {
        //             [self sendWeiXin:self.exModel.title withDesc:self.exModel.content withImg:[self.exModel.images firstObject]];
        //        }else{
                    [self sendTimelineWeiXin:self.exModel.title withDesc:self.exModel.content withImg:self.exModel.fxpicurl withShareToken:shareToken];
        //        }
             }];
        }];
    }
        
    
    if ([buttonTitle isEqualToString:@"小程序"]) {
        [self httpGetAccountIdWithSuccessBlock:^(NSString *userToken, NSString *openid) {
             [self httpShareWithSid:self.exModel.cid andClassify:@"0" andUserToken:userToken andOpenid:openid andSuccessBlock:^(NSString *shareToken){
        //        if ([self.exModel.type intValue]==4) {
        //             [self sendWeiXin:self.exModel.title withDesc:self.exModel.content withImg:[self.exModel.images firstObject]];
        //        }else{
        //            [self sendWeiXin:self.exModel.title withDesc:self.exModel.content withImg:self.exModel.poster];
        //        }

                 [self shareMinWXWith:self.exModel.cid withImgStr:self.exModel.fxpicurl withShareToken:shareToken andOpenid:openid];
             }];
        }];
    }
    
    if ([buttonTitle isEqualToString:@"企业微信"]) {
        [self httpGetAccountIdWithSuccessBlock:^(NSString *userToken, NSString *openid) {
             [self httpShareWithSid:self.exModel.cid andClassify:@"3" andUserToken:userToken andOpenid:openid andSuccessBlock:^(NSString *shareToken){
                 [self shareWWK:self.exModel andShareToken:shareToken];
             }];
        }];
    }
    
    
}

- (void)shareWWK:(MJKMaterialListModel *)model andShareToken:(NSString *)shareToken {
    
    WWKSendMessageReq *req = [[WWKSendMessageReq alloc] init];
    WWKMessageLinkAttachment *attachment = [[WWKMessageLinkAttachment alloc] init];
    attachment.title = model.title;
    attachment.summary = model.remark;
    if ([model.type intValue]==4) {
        attachment.url = [NSString stringWithFormat:@"https://www.fchcrm.com/api/sharewx/forward?shareToken=%@",shareToken];
    }else{
        attachment.url = [NSString stringWithFormat:@"https://www.fchcrm.com/api/sharewx/liveDetail?shareToken=%@",shareToken];
    }
    
    
    attachment.icon = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.fxpicurl]];
    req.attachment = attachment;
    [WWKApi sendReq:req];
}

#pragma mark --- 微信分享
- (void)sendTimelineWeiXin:(NSString *)title withDesc:(NSString *)desc withImg:(NSString *)imgUrl withShareToken:(NSString *)shareToken{
    
   
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    if ([self.exModel.type intValue]==4) {
          webpageObject.webpageUrl = [NSString stringWithFormat:@"https://www.fchcrm.com/api/sharewx/forward?shareToken=%@",shareToken];
    }else{
        webpageObject.webpageUrl = [NSString stringWithFormat:@"https://www.fchcrm.com/api/sharewx/liveDetail?shareToken=%@",shareToken];
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.exModel.title;
    message.description = self.exModel.title;
    [message setThumbImage:[UIImage scaledImageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]] withSize:CGSizeMake(KScreenWidth / 2, KScreenWidth / 2) scale:.9f orientation:UIImageOrientationUp]];
    message.mediaObject = webpageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req completion:nil];
}


- (void)shareSessionWXWith:(NSString *)sid withImgStr:(NSString *)imgStr withShareToken:(NSString *)shareToken{
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    if ([self.exModel.type intValue]==4) {
        webpageObject.webpageUrl = [NSString stringWithFormat:@"https://www.fchcrm.com/api/sharewx/forward?shareToken=%@",shareToken];
    }else{
        webpageObject.webpageUrl = [NSString stringWithFormat:@"https://www.fchcrm.com/api/sharewx/liveDetail?shareToken=%@",shareToken];
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.exModel.title;
    message.description = self.exModel.title;
    
    [message setThumbImage:[UIImage scaledImageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgStr]] withSize:CGSizeMake(KScreenWidth / 2, KScreenWidth / 2) scale:.9f orientation:UIImageOrientationUp]];
    message.mediaObject = webpageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req completion:nil];
      
    
}

- (void)shareMinWXWith:(NSString *)sid withImgStr:(NSString *)imgStr withShareToken:(NSString *)shareToken andOpenid:(NSString *)openid{
    WXMiniProgramObject *object = [WXMiniProgramObject object];
    object.webpageUrl = @"https://open.weixin.qq.com";
//    if ([self.exModel.type intValue]==4) {
//          object.webpageUrl = [NSString stringWithFormat:@"https://www.fchcrm.com/api/sharewx/forward?shareToken=%@",shareToken];
//    }else{
//        object.webpageUrl = [NSString stringWithFormat:@"https://www.fchcrm.com/api/sharewx/liveDetail?shareToken=%@",shareToken];
//    }
//    object.userName = @"gh_b03a61a40b60";
    object.userName = [NewUserSession instance].C_GID;
    if ([self.exModel.type intValue]==4) {
        object.path = [NSString stringWithFormat:@"/pages/webview/webview?shareToken=%@",shareToken];
    }else{
        object.path = [NSString stringWithFormat:@"/pages/liveDetail/liveDetail?shareToken=%@",shareToken];
    }
//    object.path = path;
    object.hdImageData = UIImagePNGRepresentation([UIImage scaledImageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgStr]] withSize:CGSizeMake(KScreenWidth / 2, KScreenWidth / 2) scale:.9f orientation:UIImageOrientationUp]);
    object.withShareTicket = NO;
    object.miniProgramType = WXMiniProgramTypeRelease;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.exModel.title;
    message.description = self.exModel.title;
    message.thumbData = nil;  //兼容旧版本节点的图片，小于32KB，新版本优先
                              //使用WXMiniProgramObject的hdImageData属性
    message.mediaObject = object;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;  //目前只支持会话
    [WXApi sendReq:req completion:nil];
      
}


- (void)httpShareWithSid:(NSString *)sid andClassify:(NSString *)classify andUserToken:(NSString *)userToken andOpenid:(NSString *)openid andSuccessBlock:(void(^)(NSString *shareToken))completeBlock{
    
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    [dict setObject:[DBObjectTools ret18bitString] forKey:@"shareToken"];
    [dict setObject:userToken forKey:@"userToken"];
    [dict setObject:openid forKey:@"openid"];
    [dict setObject:sid forKey:@"objectid"];
    [dict setObject:@"2" forKey:@"type"];
    [dict setObject:classify forKey:@"classify"];
    [dict setObject:@"001" forKey:@"storeid"];
    [[POPRequestManger defaultManger] requestWithMethod:POST url:@"https://www.fchcrm.com/api/feedShare/share" dict:dict target:self finished:^(id responsed) {
        
        if ([responsed[@"code"] intValue]==200) {
            MyLog(@"%@",responsed);
            if (completeBlock) {
                completeBlock(dict[@"shareToken"]);
            }
            
        }
    } failed:^(id error) {
        
    }];
    
    
}

- (void)httpGetAccountIdWithSuccessBlock:(void(^)(NSString *userToken, NSString *openId))completeBlock {
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    [dict setObject:[NewUserSession instance].user.u051Id forKey:@"userId"];
    [[POPRequestManger defaultManger] requestWithMethod:POST url:@"https://www.fchcrm.com/api/feedBroker/getAccountInfo" dict:dict target:self finished:^(id responsed) {
        
        if ([responsed[@"code"] intValue]==200) {
            MyLog(@"%@",responsed);
            if ([responsed[@"userToken"] length] > 0) {
                if (completeBlock) {
                    completeBlock(responsed[@"userToken"],responsed[@"openid"]);
                }
            } else {
                [self loginWX];
            }
            
            
        } else if (([responsed[@"code"] intValue]==400)) {
            [JRToast showWithText:@"账号尚未同步"];
        }
        
    } failed:^(id error) {
        
    }];
}

- (void)loginWX {
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
//    object.userName = @"gh_b03a61a40b60";
    launchMiniProgramReq.userName = [NewUserSession instance].C_GID;  //拉起的小程序的username
    launchMiniProgramReq.path = [NSString stringWithFormat:@"/pages/login/login?id=%@&pw=%@",[KUSERDEFAULT objectForKey:saveLoginName],[KUSERDEFAULT objectForKey:saveLoginCode]];    ////拉起小程序页面的可带参路径，不填默认拉起小程序首页，对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
    [WXApi sendReq:launchMiniProgramReq completion:nil];
}


- (UIImage *)handleImageWithURLStr:(NSString *)imageURLStr {

    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLStr]];
    NSData *newImageData = imageData;
    // 压缩图片data大小
    newImageData = UIImageJPEGRepresentation([UIImage imageWithData:newImageData scale:0.1], 0.1f);
    UIImage *image = [UIImage imageWithData:newImageData];

    // 压缩图片分辨率(因为data压缩到一定程度后，如果图片分辨率不缩小的话还是不行)
    CGSize newSize = CGSizeMake(100, 100);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)httpRequestList{
    DBSelf(weakSelf);
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    [dict setObject:@"001" forKey:@"storeid"];
    [dict setObject:@"1" forKey:@"currPage"];
    [dict setObject:@(self.pageSize) forKey:@"pageSize"];
//    [dict setObject:@"0" forKey:@"type"];
    [dict setObject:[NewUserSession instance].user.C_OPENID forKey:@"openid"];
 
    
    [[POPRequestManger defaultManger] requestWithNoHudMethod:POST url:@"https://www.fchcrm.com/api/feedMaterial/materialList" dict:dict target:self andIsHud:NO finished:^(id responsed) {
        
        if ([responsed[@"code"] intValue]==200) {
            MyLog(@"%@",responsed);
            weakSelf.dataArray = [MJKMaterialListModel mj_objectArrayWithKeyValuesArray:responsed[@"list"]];
            [weakSelf.tableView reloadData];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        
    } failed:^(id error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
    
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

@end
