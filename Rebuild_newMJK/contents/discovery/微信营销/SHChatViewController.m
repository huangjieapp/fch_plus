//
//  SHChatViewController.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/31.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

//微信营销


#import "SHChatViewController.h"
#import "SHChatInterfaceView.h"
#import "SHChatBarView.h"
#import "SHChooseView.h"

#import "SHWechatMainTrackModel.h"
#import "SHWechatTrackModel.h"

#import "SHWechatCellSendAndReceiveView.h"

#import "TFLoadingController.h"
#import "UIViewController+MJPopupViewController.h"

#import "CGCTemplateVC.h"
#import "CGCSelectCustomVC.h"

#import "CGCWXHelpVC.h"
#import "MJKMarketViewController.h"

@interface SHChatViewController ()<SHChatBarViewDelegate,YYTextViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate> {
	BOOL _isSend;
	int count;
	NSInteger pages;
	NSInteger pagen;
}
@property(nonatomic,strong)SHChatBarView*chatView;
@property(nonatomic,strong)SHChooseView*chooseView;
@property(nonatomic,strong)UITableView*tableView;
//等待的转圈
@property (nonatomic, strong) TFLoadingController *loadController;

@property (nonatomic, strong) SHWechatMainTrackModel *wechatMainTrackModel;

@property (nonatomic, copy) NSString *sendStr;

@end

@implementation SHChatViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self.view addSubview:self.tableView];
    [self setUpRefresh];
    [self setTopView];
    [self setBottomChatView];
    self.view.backgroundColor=[UIColor whiteColor];
	[self presentPopupViewController:self.loadController animationType:MJPopupViewAnimationFade];
	[self getTrackData];
   
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboard:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowChooseView) name:KNotifactionShowChooseView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HiddenChooseView) name:KNotifactionHiddenChooseView object:nil];

    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotifactionShowChooseView object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotifactionHiddenChooseView object:nil];

}


#pragma mark  --tableView
-(void)setUpRefresh{
	pages = 1;
	pagen = 10;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
    }];
   
    
     self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		 pagen += pagen;
		 [self getTrackData];
		 [self.tableView .mj_footer endRefreshing];
		
    }];
    
    
}

#pragma mark --
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.wechatMainTrackModel.content.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [UITableViewCell new];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	[cell.contentView addSubview:[SHWechatCellSendAndReceiveView bubbleView:self.wechatMainTrackModel.content[indexPath.row] withPosition:20]];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
		SHWechatTrackModel *wechatTrackModel = self.wechatMainTrackModel.content[indexPath.row];
		CGSize size = [wechatTrackModel.X_REMARK sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
		CGSize timeSize = [wechatTrackModel.D_CREATE_TIME sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
		return  size.height + timeSize.height + 20;
	
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 10;
}

#pragma mark --获取粉丝轨迹
- (void)getTrackData {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A52100WebService-getLogByA511ID"];
	[dict setObject:@{@"currPage" : [NSString stringWithFormat:@"%ld",(long)pages], @"pageSize" : [NSString stringWithFormat:@"%ld",(long)pagen], @"C_A51100_C_ID" : [NSString stringWithFormat:@"%@",self.wechatListSubModel.C_ID]} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			self.wechatMainTrackModel = [SHWechatMainTrackModel yy_modelWithJSON:data];
			//A52100_C_TYPE_0004 消息发送
			[weakSelf.tableView reloadData];
			[weakSelf dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}


- (void)HTTPSendTextMessageRequest{

    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_CGC_weChatTextPushByA511];
   
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:self.wechatListSubModel.C_ID forKey:@"C_A51100_C_ID"];
    [dic setObject:self.sendStr forKey:@"CONTENT"];
    [dict setObject:dic forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            [weakSelf getTrackData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];


}


- (void)HTTPSetStartRequestWithType:(NSString *)type withButton:(UIButton *)btn{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_CGC_updateBeanById];
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:self.wechatListSubModel.C_ID forKey:@"C_ID"];
    self.wechatListSubModel.X_REMARK.length>0?[dic setObject:self.wechatListSubModel.X_REMARK forKey:@"X_REMARK"]:[dic setObject:@"" forKey:@"X_REMARK"];
    [dic setObject:type forKey:@"C_STAR"];
    [dict setObject:dic forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
//        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
          
            if ([type intValue]==0) {
                [btn setImage:@"星标客户"];
            }
            if ([type intValue]==1) {
                [btn setImage:@"未星标客户"];
            }
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
    
}


#pragma mark  --UI
-(void)setTopView{
    SHChatInterfaceView*topView=[SHChatInterfaceView chatInterfaceView];
	topView.rootVC = self;
	topView.wechatListSubModel = self.wechatListSubModel;
	topView.custImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.wechatListSubModel.C_HEADIMGURL]]];
	topView.custNameLabel.text = self.wechatListSubModel.C_NAME;
	topView.fromCityLabel.text = self.wechatListSubModel.C_CITYNAME;
	topView.firstLoginLabel.text = self.wechatListSubModel.D_CONVERT_TIME;
	topView.lastLoginLabel.text = self.wechatListSubModel.D_LASTUPDATE_TIME;
	topView.scanningChannelsLabel.text = [NSString stringWithFormat:@"扫码渠道:%@",self.wechatListSubModel.C_CHANNEL_DD_NAME];
	if ([self.wechatListSubModel.C_STAR isEqualToString:@"1"]) {
		[topView.startState setBackgroundImage:[UIImage imageNamed:@"星标.png"] forState:UIControlStateNormal];
	} else {
		[topView.startState setBackgroundImage:[UIImage imageNamed:@"未星标.png"] forState:UIControlStateNormal];
	}
	topView.memoLabel.text = self.wechatListSubModel.X_REMARK;

    topView.frame=CGRectMake(0, 64, KScreenWidth, 175);
    [self.view addSubview:topView];
    
}

-(void)setBottomChatView{
    SHChatBarView*chatView=[[SHChatBarView alloc]init];
    self.chatView=chatView;
    chatView.frame=CGRectMake(0, KScreenHeight-44, KScreenWidth, 44);
    self.chatView.textView.delegate = self;
    self.chatView.delegate = self;
    self.chatView.voiceB = ^{
        
    };
    self.chatView.textB = ^{
        
    };
    
    [self.view addSubview:chatView];
    
}


#pragma mark  -click
- (void)handleKeyboard:(NSNotification *)aNotification {
    
    CGRect keyboardFrame = [aNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
   CGFloat keyBoardheight = -([UIScreen mainScreen].bounds.size.height - keyboardFrame.origin.y);
    
   
    self.chatView.showType=SHChatBarTypeshowKeyBoard;
    CGRect chatViewFrame=self.chatView.frame;
    chatViewFrame.origin.y= KScreenHeight-44+keyBoardheight;
    self.chatView.frame=chatViewFrame;
    
    
    
}


-(void)hiddenKeyBoard:(NSNotification*)aNotification{
    //隐藏
    DBSelf(weakSelf);
    self.chatView.showType=SHChatBarTypeNoneView;
    
    [UIView animateWithDuration:0.15 animations:^{
         CGRect chatViewFrame=self.chatView.frame;
        chatViewFrame.origin.y= KScreenHeight-44;
        weakSelf.chatView.frame=chatViewFrame;
        weakSelf.chooseView.frame=CGRectMake(0, KScreenHeight, KScreenWidth, 100);
    }];
   
  
}


-(void)ShowChooseView{
    self.chatView.showType=SHChatBarTypeshowOtherView;
    DBSelf(weakSelf);
 
    CGRect chatViewFrame=self.chatView.frame;
    chatViewFrame.origin.y= KScreenHeight-44-100;
    weakSelf.chatView.frame=chatViewFrame;

    CGRect viewRect=self.chooseView.frame;
    viewRect.origin.y=KScreenHeight-100;
    weakSelf.chooseView.frame=viewRect;
    
}

-(void)HiddenChooseView{
    self.chatView.showType=SHChatBarTypeNoneView;
    CGRect chatViewFrame=self.chatView.frame;
    chatViewFrame.origin.y= KScreenHeight-44;
    self.chatView.frame=chatViewFrame;

    CGRect viewRect=self.chooseView.frame;
    viewRect.origin.y=KScreenHeight;
    self.chooseView.frame=viewRect;

    
}


- (void)tapDisKeyboard{
    [[UIApplication sharedApplication].keyWindow endEditing:YES ];
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    
    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]){
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        return NO;
    }
    
    return YES;
}

#pragma mark  -- delegate
-(void)chatBarOfVoice:(UILongPressGestureRecognizer*)gesture{
    
    
}

-(void)chatBarOfSend:(NSString*)str{
  
    self.sendStr=str;
    self.sendStr.length>0?[self HTTPSendTextMessageRequest]:0;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark  -- set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+175, KScreenWidth, KScreenHeight-64-175-44) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
         UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDisKeyboard)];
        [_tableView addGestureRecognizer:tap];
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
    }
    return _tableView;
}

#pragma mark  -- 底部星标客户、素材模板、重新指派、请求协助
-(SHChooseView *)chooseView{
    DBSelf(weakSelf);
    if (!_chooseView) {
        _chooseView=[[SHChooseView alloc]initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 100) withDataArray:@[@"星标客户",@"素材模板",@"重新指派",@"请求协助"] withPicArr:@[@"未星标客户",@"未星标客户",@"未星标客户",@"未星标客户"] withSel:^(NSString *str,UIButton *btn) {
            
            
            if ([str isEqualToString:@"星标客户"]) {
                if ([self.wechatListSubModel.C_STAR isEqualToString:@"0"]) {
                    [weakSelf HTTPSetStartRequestWithType:@"1" withButton:btn];
                    
                }
                if ([self.wechatListSubModel.C_STAR isEqualToString:@"1"]) {
                    [weakSelf HTTPSetStartRequestWithType:@"0" withButton:btn];
                   
                }
                
            }
            
            
            if ([str isEqualToString:@"素材模板"]) {
                
                CGCTemplateVC *vc=[[CGCTemplateVC alloc] init];
                vc.templateType=CGCTemplatePublic;
                vc.C_A51100_C_ID=self.wechatListSubModel.C_ID;
                [weakSelf.navigationController pushViewController:vc animated:YES ];
            }
            
            if ([str isEqualToString:@"重新指派"]) {
                MJKMarketViewController *vc=[[MJKMarketViewController alloc] init];
                vc.C_ID=self.wechatListSubModel.C_ID;
                vc.rootViewController=self;
                vc.backSelectParameterBlock = ^(NSString *codeStr, NSString *nameStr) {
                    NSLog(@"%@-=-=-=%@",codeStr,nameStr);
                };
                [self.navigationController pushViewController:vc animated:YES];
                

            }
            if ([str isEqualToString:@"请求协助"]) {
                CGCWXHelpVC * svc=[[CGCWXHelpVC alloc] init];
                svc.c_id=self.wechatListSubModel.C_ID;
                [weakSelf.navigationController pushViewController:svc animated:YES ];
            }

           
        }];
        
        [self.view addSubview:_chooseView];
    }
    return _chooseView;
}

- (TFLoadingController *)loadController {
	if (!_loadController) {
		_loadController = [[TFLoadingController alloc]initWithNibName:@"TFLoadingController" bundle:nil];
	}
	return _loadController;
}

- (void)viewWillDisappear:(BOOL)animated {
	if (self.isLook) {
		self.isLook(YES);
	}
}

@end
