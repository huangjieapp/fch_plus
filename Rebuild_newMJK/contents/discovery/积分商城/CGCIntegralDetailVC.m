//
//  CGCIntegralDetailVC.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/9.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "CGCIntegralDetailVC.h"
#import "MessageCell.h"
#import "IntegralDetailModel.h"

#import "ZZShareView.h"
#import "HeadImageView.h"
#import "WXApi.h"

@interface CGCIntegralDetailVC ()<UITableViewDelegate,UITableViewDataSource,HeadImageViewDelegate,ZZShareDelegate>
@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) HeadImageView *heagImageView;

@property (nonatomic, strong) IntegralDetailModel *detailModel;

@property (nonatomic, strong) ZZShareView *sharView;

@end

@implementation CGCIntegralDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self httpRequestGetDetail];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"商品详情";
    [self.view addSubview:self.tableView];
    
   
   
    // Do any additional setup after loading the view.
}



- (void)httpRequestGetDetail{
    
    [KVNProgress show];
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    [dict setObject:self.sid forKey:@"id"];
    
    [[POPRequestManger defaultManger] requestWithMethod:POST url:HTTP_integralGetInfo dict:dict target:self finished:^(id responsed) {
        [KVNProgress dismiss];
        if ([responsed[@"code"] intValue]==200) {
            self.detailModel=[IntegralDetailModel yy_modelWithJSON:responsed[@"commodity"]];
        }else{
            [KVNProgress showErrorWithStatus:responsed[@"message"]];
        }
        
        self.heagImageView.dataArray=self.detailModel.pictureList;
        [self.heagImageView makecurentView];
        [self.tableView reloadData];
        
    } failed:^(id error) {
       
        [KVNProgress showErrorWithStatus:@"网络连接失败"];
    }];
    
}


- (void)shareBtnClick:(UIButton *)btn{
    
    self.sharView = [[ZZShareView alloc]initWithdelegate:self withArr:@[@"微信好友"]];
    [self.view addSubview:self.sharView];
    
}

/// 分享视图代理
- (void)selectBtn:(ZZShareView *)shareView withButtonTitle:(NSString *)buttonTitle{
    
    
    if ([buttonTitle isEqualToString:@"微信好友"]) {
    
      
            [self shareMinWXWith:self.detailModel.sid  withImgStr:[self.detailModel.pictureList firstObject]];
     
    }
    if ([buttonTitle isEqualToString:@"朋友圈"]) {
        
       
//            [self sendWeiXin:self.exModel.title withDesc:self.exModel.content withImg:self.exModel.poster];
       
    }
    if ([buttonTitle isEqualToString:@"QQ好友"]) {
        
//        [self sendWeiXin:@"hahah" withDesc:@"hahahh" withImg:self.exModel.poster];
    }
    
}

#pragma mark --- 微信分享
- (void)sendWeiXin:(NSString *)title withDesc:(NSString *)desc withImg:(NSString *)imgUrl{
    
    
    UIImage *image=[self handleImageWithURLStr:imgUrl];
    
    
    
    
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = title;//分享标题
    urlMessage.description = desc;//分享描述
    [urlMessage setThumbImage:image];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
    
    
    
    //创建多媒体对象
    WXWebpageObject *webObj = [WXWebpageObject object];
//    if ([self.exModel.type intValue]==3) {
//        webObj.webpageUrl = [NSString stringWithFormat:@"%@%@?a=%@",HTTP_sharePYQ,self.exModel.sid,self.exModel.accountid];
//    }else{
//        webObj.webpageUrl = [NSString stringWithFormat:@"%@?accountId=%@&productId=%@",HTTP_shareSPZP,self.exModel.accountid,self.exModel.sid];
//    }
    
    
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    
    
    
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.scene = WXSceneTimeline;
    req.bText = NO;
    req.message = urlMessage;
    [WXApi sendReq:req completion:nil];
    
    
}


- (void)shareMinWXWith:(NSString *)sid withImgStr:(NSString *)imgStr{
    
    UIImage *image=[self handleImageWithURLStr:imgStr];
    
    WXMiniProgramObject *miniProgramObj = [WXMiniProgramObject object];
    miniProgramObj.webpageUrl = @"http://www.qq.com"; // 兼容低版本的网页链接
    miniProgramObj.miniProgramType=WXMiniProgramTypeRelease;
    
    miniProgramObj.userName = @"gh_b03a61a40b60";     // 小程序原始id
    miniProgramObj.path = [NSString stringWithFormat:@"/pages/goods/goods?id=%@",sid];            //小程序页面路径
    miniProgramObj.hdImageData= UIImagePNGRepresentation(image);
    WXMediaMessage *msg = [WXMediaMessage message];
    msg.title = @"脉居客";                    // 小程序消息title
    msg.description = @"脉居客";// 小程序消息desc
    msg.thumbData = UIImagePNGRepresentation(image);// 小程序消息封面图片，小于128k
    msg.mediaObject=miniProgramObj;
    SendMessageToWXReq  *req = [[SendMessageToWXReq alloc] init];
    
    req.message = msg;
    req.scene = WXSceneSession;  // 目前支持会话
    [WXApi sendReq:req completion:nil];
    
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



- (HeadImageView *)heagImageView{
    
    
    if (_heagImageView==nil) {
        
        _heagImageView=[[HeadImageView alloc]initWithFrame:CGRectMake(0, 0, WIDE, WIDE*2/3)];
        _heagImageView.ploadImage=[UIImage imageNamed:@"600_600"];
        _heagImageView.deleagte=self;
        _heagImageView.isShowWater=NO;
        
        _heagImageView.isUserTouch=YES;//不可滚动
        _heagImageView.showPageControl=YES;
        
        
    }
    
    return _heagImageView;
}
- (UITableView *)tableView{
    NSLog(@"%d-==%d",SafeAreaTopHeight,SafeAreaBottomHeight);
    if(_tableView==nil){
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDE, HIGHT-SafeAreaBottomHeight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableHeaderView=self.heagImageView;
//        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.backgroundColor=CGCTABBGColor;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDE, 80)];
        view.backgroundColor=CGCTABBGColor;
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(10, 18, WIDE-20, 44);
        btn.backgroundColor=CGCNAVCOLOR;
        btn.layer.cornerRadius=4;
        btn.layer.masksToBounds=YES;
        [btn addTarget:self action:@selector(shareBtnClick:)];
        [btn setTitleNormal:@"分享"];
        [btn setTitleColor:[UIColor blackColor]];
        [view addSubview:btn];
    
        _tableView.tableFooterView=view;
    
    }
    
    return _tableView;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MessageCell * cell=[MessageCell cellWithTableView:tableView];
    cell.contentLab.text=@[@"兑换积分",@"商品名称",@"商品规格",@"市场参考价",@"详情"][indexPath.row];
    if (self.detailModel) {
        
        cell.timeLab.text=@[
                            self.detailModel.awardfactor1.length > 0 ? self.detailModel.awardfactor1 : @"",
                            
                            self.detailModel.name.length > 0 ? self.detailModel.name : @"",
                            
                            self.detailModel.specification.length > 0 ? self.detailModel.specification : @"",
                            
                            self.detailModel.price.length > 0 ? self.detailModel.price : @"",
                            
                            self.detailModel.customfields.length > 0 ? self.detailModel.customfields : @""][indexPath.row];
    }
   
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
}

- (void)headView:(HeadImageView*)headcolleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
@end
