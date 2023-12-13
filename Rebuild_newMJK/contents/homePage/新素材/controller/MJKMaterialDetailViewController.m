//
//  MJKMaterialDetailViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/9/16.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import "MJKMaterialDetailViewController.h"

#import "MJKMaterialListModel.h"

#import "MJKMaterialPhotoTableViewCell.h"
#import "MJKMaterialNinePhotoTableViewCell.h"

#import "ZZShareView.h"
#import "WXApi.h"

@interface MJKMaterialDetailViewController ()<UITableViewDataSource, UITableViewDelegate, ZZShareDelegate>
/** <#注释#>*/
@property (nonatomic, strong) ZZShareView *shareView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *detailView;
/** MJKMaterialListModel*/
@property (nonatomic, strong) MJKMaterialListModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeightLayout;

/** <#注释#>*/
@property (nonatomic, strong) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation MJKMaterialDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    DBSelf(weakSelf);
    self.title = @"素材详情";
//    self.scrollView = [[UIScrollView alloc]init];
//    [self.detailView addSubview:self.scrollView];
//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.mas_equalTo(weakSelf.detailView);
//        make.left.mas_equalTo(weakSelf.detailView).mas_offset(10);
//        make.right.mas_equalTo(weakSelf.detailView).mas_offset(-10);
//    }];
//    self.contentLabel = [[UILabel alloc]init];
//    self.contentLabel.font = [UIFont systemFontOfSize:14.f];
//    self.contentLabel.textColor = [UIColor darkGrayColor];
//    self.contentLabel.numberOfLines = 0;
//    [self.scrollView addSubview:self.contentLabel];
//    self.contentLabel.frame = CGRectMake(0, 0, KScreenWidth - 20, 20);
    
    [self httpRequestList];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.model.type isEqualToString:@"0"]) {
        return 1;
    }
    return self.model.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    if ([self.model.type isEqualToString:@"0"]) {
        MJKMaterialNinePhotoTableViewCell *cell = [MJKMaterialNinePhotoTableViewCell cellWithTableView:tableView];
        cell.model = self.model;
        cell.shareButton.hidden = cell.timeLabel.hidden = YES;
        return cell;
    } else {
        MJKMaterialPhotoTableViewCell *cell = [MJKMaterialPhotoTableViewCell cellWithTableView:tableView];
        [cell.materialImageView sd_setImageWithURL:[NSURL URLWithString:self.model.images[indexPath.row]]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return self.cellHeight;
    if ([self.model.type isEqualToString:@"0"]) {
        return [MJKMaterialNinePhotoTableViewCell heightForCellWithModel:self.model];
    } else {
        if (self.model.cellHeight != 0) {
            return self.model.cellHeight;
        }
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.images[indexPath.row]]]];
        CGFloat imageWidth = KScreenWidth - 20;
        CGFloat scale = imageWidth / image.size.width;
        CGFloat imageHeight = image.size.height * scale;
        self.model.cellHeight = imageHeight;
        return imageHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *str = self.model.title;
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    CGFloat height = [str boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
    if (height > 20) {
        return height + 10;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *str = self.model.title;
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    CGFloat height = [str boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
    if (height > 20) {
        height += 10;
    } else {
        height = 20;
    }
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, height)];
    bgView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, bgView.frame.size.height)];
    label.numberOfLines = 0;
    label.text = str;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:14.f];
    [bgView addSubview:label];
    return bgView;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (IBAction)shareButtonAction:(UIButton *)sender {
    self.shareView = [[ZZShareView alloc]initWithdelegate:self withArr:@[@"微信好友",@"朋友圈",@"小程序"]];
    [self.view addSubview:self.shareView];
}

// 分享视图代理
- (void)selectBtn:(ZZShareView *)shareView withButtonTitle:(NSString *)buttonTitle{
    
    
    if ([buttonTitle isEqualToString:@"微信好友"]) {
        [self httpGetAccountIdWithSuccessBlock:^(NSString *userToken, NSString *openid) {
            [self httpShareWithSid:self.model.cid andClassify:@"3" andUserToken:userToken andOpenid:openid andSuccessBlock:^(NSString *shareToken) {
            //            if ([self.exModel.type intValue]==4) {
            //             [self shareMinWXWith:self.exModel.cid withImgStr:[self.exModel.images firstObject]];
            //            }else{
                             [self shareSessionWXWith:self.model.cid withImgStr:self.model.fxpicurl withShareToken:shareToken];
            //            }
                    }];
        }];
        
    }
    if ([buttonTitle isEqualToString:@"朋友圈"]) {
        [self httpGetAccountIdWithSuccessBlock:^(NSString *userToken, NSString *openid) {
             [self httpShareWithSid:self.model.cid andClassify:@"4" andUserToken:userToken andOpenid:openid andSuccessBlock:^(NSString *shareToken){
        //        if ([self.exModel.type intValue]==4) {
        //             [self sendWeiXin:self.exModel.title withDesc:self.exModel.content withImg:[self.exModel.images firstObject]];
        //        }else{
                    [self sendTimelineWeiXin:self.model.title withDesc:self.model.content withImg:self.model.fxpicurl withShareToken:shareToken];
        //        }
             }];
        }];
    }
        
    
    if ([buttonTitle isEqualToString:@"小程序"]) {
        [self httpGetAccountIdWithSuccessBlock:^(NSString *userToken, NSString *openid) {
             [self httpShareWithSid:self.model.cid andClassify:@"0" andUserToken:userToken andOpenid:openid andSuccessBlock:^(NSString *shareToken){
        //        if ([self.exModel.type intValue]==4) {
        //             [self sendWeiXin:self.exModel.title withDesc:self.exModel.content withImg:[self.exModel.images firstObject]];
        //        }else{
        //            [self sendWeiXin:self.exModel.title withDesc:self.exModel.content withImg:self.exModel.poster];
        //        }

                 [self shareMinWXWith:self.model.cid withImgStr:self.model.fxpicurl withShareToken:shareToken andOpenid:openid];
             }];
        }];
    }
    
    
}

#pragma mark --- 微信分享
- (void)sendTimelineWeiXin:(NSString *)title withDesc:(NSString *)desc withImg:(NSString *)imgUrl withShareToken:(NSString *)shareToken{
    
   
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    if ([self.model.type intValue]==4) {
          webpageObject.webpageUrl = [NSString stringWithFormat:@"https://www.fchcrm.com/api/sharewx/forward?shareToken=%@",shareToken];
    }else{
        webpageObject.webpageUrl = [NSString stringWithFormat:@"https://www.fchcrm.com/api/sharewx/liveDetail?shareToken=%@",shareToken];
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.model.title;
    message.description = self.model.title;
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
    if ([self.model.type intValue]==4) {
        webpageObject.webpageUrl = [NSString stringWithFormat:@"https://www.fchcrm.com/api/sharewx/forward?shareToken=%@",shareToken];
    }else{
        webpageObject.webpageUrl = [NSString stringWithFormat:@"https://www.fchcrm.com/api/sharewx/liveDetail?shareToken=%@",shareToken];
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.model.title;
    message.description = self.model.title;
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
    object.userName = [NewUserSession instance].C_GID;
    if ([self.model.type intValue]==4) {
        object.path = [NSString stringWithFormat:@"/pages/webview/webview?shareToken=%@",shareToken];
    }else{
        object.path = [NSString stringWithFormat:@"/pages/liveDetail/liveDetail?shareToken=%@",shareToken];
    }
//    object.path = path;
    object.hdImageData = UIImagePNGRepresentation([UIImage scaledImageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgStr]] withSize:CGSizeMake(KScreenWidth / 2, KScreenWidth / 2) scale:.9f orientation:UIImageOrientationUp]);
    object.withShareTicket = NO;
    object.miniProgramType = WXMiniProgramTypeRelease;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.model.title;
    message.description = self.model.title;
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
    launchMiniProgramReq.userName = [NewUserSession instance].C_GID;  //拉起的小程序的username
    launchMiniProgramReq.path = @"/pages/login/login";    ////拉起小程序页面的可带参路径，不填默认拉起小程序首页，对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
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
    [dict setObject:self.productid forKey:@"productid"];
    [dict setObject:@"oZ19L5G-VWnCiW9FpwHDlyXpTQcU" forKey:@"openid"];
 
    
    [[POPRequestManger defaultManger] requestWithNoHudMethod:POST url:@"https://www.fchcrm.com/api/feedMaterial/product" dict:dict target:self andIsHud:NO finished:^(id responsed) {
        
        if ([responsed[@"code"] intValue]==200) {
            MyLog(@"%@",responsed);
            weakSelf.model = [MJKMaterialListModel mj_objectWithKeyValues:responsed[@"product"]];
            [weakSelf.tableView reloadData];
            [weakSelf.headImageView sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.salespicture]];
            weakSelf.nameLabel.text = weakSelf.model.salesname;
//            NSString *str = model.title;
//            str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
//            weakSelf.contentLabel.text = str;
//            CGFloat height = [str boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
//            if (height > 20) {
//                CGRect contentLabelFrame = weakSelf.contentLabel.frame;
//                contentLabelFrame.size.height = height + 10;
//                weakSelf.contentLabel.frame = contentLabelFrame;
//            }
            weakSelf.timeLabel.text = weakSelf.model.createTime;
//            __block CGFloat scrollContentHeight = 0;
//            for (int i = 0; i < model.images.count; i++) {
//                UIImageView *imageView = [[UIImageView alloc]init];
//                [weakSelf.scrollView addSubview:imageView];
//                __block  UIImageView *_blockImageView = imageView;
//                [imageView sd_setImageWithURL:[NSURL URLWithString:model.images[i]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//                    CGFloat imageWidth = KScreenWidth - 20;
//                    CGFloat scale = imageWidth / image.size.width;
//                    CGFloat imageHeight = image.size.height * scale;
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        _blockImageView.frame = CGRectMake(0, CGRectGetMaxY(weakSelf.contentLabel.frame) + scrollContentHeight, imageWidth, imageHeight);
//                        scrollContentHeight += imageHeight + 10;
//                        weakSelf.scrollView.contentSize = CGSizeMake(KScreenWidth - 20, scrollContentHeight + height);
//                    });
//                }];
//            }
            
        }
    } failed:^(id error) {
    }];
    
    
}

@end
