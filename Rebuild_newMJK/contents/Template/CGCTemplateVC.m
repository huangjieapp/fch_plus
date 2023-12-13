//
//  CGCTemplateVC.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCTemplateVC.h"
#import "CGCTemplateCell.h"
#import "CGCTalkModel.h"
#import "CGCOtherTalkModel.h"
#import "CGCTalkDetailModel.h"

#import "CGCTalkTable.h"
#import "CGCRecordTextSelView.h"

#import "CGCCustomModel.h"
#import "CGCEidtMessView.h"

#import "WXApi.h"
#import "ISRDataHelper.h"
#import "IATConfig.h"
#import <MessageUI/MessageUI.h>
#import<MessageUI/MFMailComposeViewController.h>
#import "CustomerFollowAddEditViewController.h"

#import "CustomerDetailInfoModel.h"
#import "MJKAddMessageViewController.h"

typedef enum {
	kShareTool_WeiXinFriends = 0, // 微信好友
	kShareTool_WeiXinCircleFriends, // 微信朋友圈
} ShareToolType;

@interface CGCTemplateVC ()<UITableViewDelegate,UITableViewDataSource,CGCTalkTableDelegate,UIGestureRecognizerDelegate,MFMessageComposeViewControllerDelegate,CustomerFollowAddEditViewControllerDelegate>{
	
	
	enum WXScene _scene;
	NSString *contentStr;
}

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *secArray;

@property (nonatomic, strong) CGCTalkTable *firstTab;

@property (nonatomic, strong) CGCTalkTable *secondTab;

@property (nonatomic, strong) NSMutableArray *picTextTab;

@property (nonatomic, strong) NSMutableArray *picTab;

@property (nonatomic, strong) NSMutableArray *vocieTab;
/** keyBoardView*/
@property (nonatomic, strong) UIView *keyBoardView;

@property (nonatomic, strong) NSMutableArray *voideTab;

@property (nonatomic, strong) NSMutableArray *templateTab;

@property (nonatomic, strong) NSMutableArray *fileTab;

@property (nonatomic, strong) UILabel * headLab;



@property (assign) CGFloat firstH;

@property (assign) CGFloat secondH;

@property (assign) NSInteger currPage;

@property (nonatomic, copy) NSString *firstStr;

@property (nonatomic, copy) NSString *secondStr;

@property (nonatomic, strong) CGCRecordTextSelView *recordTextView;//底部语音和文字切换

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) CGCEidtMessView *eidtMessView;

@property (nonatomic, copy) NSIndexPath *firstIndex;

@property (nonatomic, copy) NSIndexPath *secondIndex;

@property (nonatomic, copy) NSString *titleStyle;//公共模板选择的类型

@property (nonatomic, copy) NSString *customStr;//选中的客户姓名

@property (nonatomic, copy) NSString *publicID;//选中的公众号ID

@property (nonatomic, copy) NSString *messStr;//短信内容

@property (nonatomic, copy) NSString *isAdd;//新增模版



@end

@implementation CGCTemplateVC

- (void)viewDidLoad {
	[super viewDidLoad];
	[self addDismissButton];
	self.firstH=self.secondH=50;
	self.currPage=1;
	self.titleStyle=@"文本";
	[self.view addSubview:self.tableView];
	//    [self createBottom];//底部发送视图
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareSuccess) name:WXSHARESUCCESS object:nil];
	// Do any additional setup after loading the view.
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:[UIImage imageNamed:@"新增预约-head"] forState:UIControlStateNormal];
	button.frame = CGRectMake(0, 0, 30, 30);
	[button addTarget:self action:@selector(addMessage:)];
	UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
	
	self.navigationItem.rightBarButtonItem = item;
}

- (void)addMessage:(UIButton *)sender {
	MJKAddMessageViewController *vc = [[MJKAddMessageViewController alloc]init];
	vc.backAdd = ^{
		self.isAdd = @"true";
		self.firstH=50;
		[self.tableView reloadData];
		//        [self HTTPGetTemplateListWithType:0];
	};
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc{
	[[NSNotificationCenter defaultCenter ] removeObserver:self];
	
}
#pragma mark --- createNav

- (void)createBottom{
	self.recordTextView=[[CGCRecordTextSelView alloc]initWithFrame:CGRectMake(0, KScreenHeight-50-SafeAreaBottomHeight, KScreenWidth, 50) withChange:^{
		
	} withRecord:^{
		
	} withText:^{
		
	} withSend:^(NSString *text) {
		if(self.customPhoneArr.count==0){
			[JRToast showWithText:@"选择用户"];
			return ;
		}
		self.messStr=text;
		
		
		[self sendMessageWithContent:text withCustomID:nil];
		
		
	} withShow:^(CGFloat hight, CGFloat time) {
		[UIView animateWithDuration:time animations:^{
			
			self.recordTextView.y=KScreenHeight-20-hight;
		}];
	} withDiss:^(CGFloat hight, CGFloat time) {
		[UIView animateWithDuration:time animations:^{
			self.recordTextView.y=KScreenHeight-50-SafeAreaBottomHeight;
		}];
	} withRecordStart:^{
		
	} withRecordEnd:^(NSString *str) {
		
		if (str.length>0) {
			[self.recordTextView setTextWith:str];
		}else{
			
			[JRToast showWithText:@"我没能听清你说什么！！！"];
		}
		
		
	}];
	self.recordTextView.y=KScreenHeight-50-SafeAreaBottomHeight;
	
	[[UIApplication sharedApplication].keyWindow addSubview:self.recordTextView];
}

- (void)viewWillDisappear:(BOOL)animated{
	
	self.recordTextView.hidden=YES;
	self.bottomView.hidden=YES;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	
	
}

- (void)viewWillAppear:(BOOL)animated{
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
	if (self.templateType==CGCTemplateMessage||([self.titleStyle isEqualToString:@"文本"]&&self.templateType!=CGCTemplatePublic)) {
		
		self.recordTextView.hidden=NO;
	}else{
		self.recordTextView.hidden=YES;
		self.bottomView.hidden=NO;
	}
}


-(void)addDismissButton{
	
	if (@available(iOS 11.0,*)) {
		self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
	}else{
		if (@available(iOS 11.0, *)) {
			self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
		}else {
			self.automaticallyAdjustsScrollViewInsets = NO;
		}
	}
	if (self.templateType==CGCTemplateMessage) {
		self.title=@"发送短信";
	}
	if (self.templateType==CGCTemplateWeiXin) {
		self.title=@"发送微信";
	}
	if (self.templateType==CGCTemplatePublic) {
		self.title=@"发送公众号";
	}
	self.view.backgroundColor=DBColor(255, 255, 255);
	
	UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
	[button setBackgroundImage:[UIImage imageNamed:@"icon_dismiss"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(clickDismiss)];
	UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:button];
	self.navigationItem.leftBarButtonItem=item;
	
	
	
}

-(void)clickDismiss{
	if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
		[self.navigationController popViewControllerAnimated:YES];
	}
	
	
	if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
		[self dismissViewControllerAnimated:YES completion:nil];
	}
	
}


#pragma mark  --delegate
-(void)DelegateCompletePopToDo{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self dismissViewControllerAnimated:YES completion:nil];
	});
	
}

#pragma mark --- tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	return 2;
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	CGCTemplateCell * cell= [CGCTemplateCell cellWithTableView:tableView];
	
	
	[self reloadCell:cell withIndex:indexPath];
	
	return cell;
	
}


- (void)reloadCell:(CGCTemplateCell *)cell withIndex:(NSIndexPath *)indexPath{
	if (indexPath.row==0) {
		
		if (self.firstH==50) {
			[cell.iconImg setImage:[UIImage imageNamed:@"三角"]];
		}else{
			[cell.iconImg setImage:[UIImage imageNamed:@"三角-下拉"]];
		}
		[cell.contentView addSubview:self.firstTab];
		cell.clipsToBounds=YES;
		
	}
	if (indexPath.row==1) {
		if (self.secondH==50) {
			[cell.iconImg setImage:[UIImage imageNamed:@"三角"]];
		}else{
			[cell.iconImg setImage:[UIImage imageNamed:@"三角-下拉"]];
		}
		[cell.contentView addSubview:self.secondTab];
		cell.clipsToBounds=YES;
		
	}
	
	cell.titLab.text=@[@"个人模板",@"公共模板"][indexPath.row];
	
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (indexPath.row==0) {
		return self.firstH;
	}
	if (indexPath.row==1) {
		return self.secondH;
	}
	return 50;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.row==0) {
		
		if (self.firstH == 50) {
			[self HTTPGetTemplateListWithType:0];
			//            self.isAdd = nil;
		} else {
			//            //isAdd如果为true则请求
			//            if ([self.isAdd isEqualToString:@"true"]) {
			//                [self HTTPGetTemplateListWithType:0];
			//                self.isAdd = nil;
			//            } else {
			//                CGRect frame = self.firstTab.frame;
			//                frame.size.height = self.firstH;
			//                self.firstTab.frame = frame;
			[self.firstTab.tableView reloadData];
			//            }
			//
		}
		
		self.firstH=(self.firstH==50)?KScreenHeight - 214:50;
		//		self.tableView.scrollEnabled = YES;
		
		self.secondH=50;
	}
	if (indexPath.row==1) {
		if (self.secondH == 50) {
			[self HTTPGetTemplateListWithType:1];
		} else {
			[self.secondTab.tableView reloadData];
		}
		
		
		self.secondH=(self.secondH==50)?KScreenHeight - 214:50;
		//		self.tableView.scrollEnabled = NO;
		self.firstH=50;
	}
	[self.tableView reloadData];
}


#pragma mark --- HTTPRequest
- (void)HTTPGetTemplateListWithType:(NSInteger)type{//常用公共模板
	
	
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_CGC_getMessageList];
	NSMutableDictionary *dic=[NSMutableDictionary new];
	[dic setObject:@(self.currPage) forKey:@"currPage"];
	[dic setObject:@"100" forKey:@"pageSize"];
	[dic setObject:@(type) forKey:@"TYPE"];
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		[self.view addSubview:self.tableView];
		if ([data[@"code"] integerValue]==200) {
			if (self.currPage==1&&type==0) {
				
				[self.dataArray removeAllObjects];
				
			}
			if (self.currPage==1&&type==1) {
				
				[self.secArray removeAllObjects];
			}
			if (type==0) {
				self.firstStr=@"first";
				for (NSDictionary * dic in data[@"content"]) {
					
					CGCTalkModel * model=[CGCTalkModel yy_modelWithDictionary:dic];
					[self.dataArray addObject:model];
					
				}
				//                self.firstH=(self.firstH==50)?(self.dataArray.count*100+60):50;
				//                CGRect frame = self.firstTab.frame;
				//                frame.size.height = self.firstH;
				//                self.firstTab.frame = frame;
			}
			if (type==1) {
				self.secondStr=@"second";
				for (NSDictionary * dic in data[@"content"]) {
					
					CGCTalkModel * model=[CGCTalkModel yy_modelWithDictionary:dic];
					[self.secArray addObject:model];
					
				}
			}
			
			
		}else{
			self.currPage>1?self.currPage--:0;
			[JRToast showWithText:data[@"message"]];
		}
		if (type==0) {
			[self.firstTab reloadTableWithArray:self.dataArray withStyle:CGCTalkTableText];
			//			self.tableView.scrollEnabled = YES;
			//            self.firstH=50+self.dataArray.count*60;
			//            CGRect frame = self.firstTab.frame;
			//            frame.size.height = self.firstH;
			//            self.firstTab.frame = frame;
			//            [self.tableView reloadData];
		}
		if (type==1) {
			[self.secondTab reloadTableWithArray:self.secArray withStyle:CGCTalkTableText];
			
		}
		
		
	}];
	
	
	
}

- (void)HTTPGetOtherTemplateList:(NSString *)type{//图片文字模板
	
	
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_CGC_getMessageListByWx];
	
	NSMutableDictionary *dic=[NSMutableDictionary new];
	[dic setObject:@(self.currPage) forKey:@"currPage"];
	[dic setObject:@"10" forKey:@"pageSize"];
	[dic setObject:type forKey:@"TYPE"];
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	
	
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		[self.view addSubview:self.tableView];
		if ([data[@"code"] integerValue]==200) {
			if (self.currPage==1) {
				[self.dataArray removeAllObjects];
			}
			for (NSDictionary * dic in data[@"content"]) {
				CGCOtherTalkModel * model=[CGCOtherTalkModel yy_modelWithDictionary:dic];
				if ([type isEqualToString:@"8"]) {
					[self.picTextTab addObject:model];
				}
				if ([type isEqualToString:@"2"]) {
					[self.picTab addObject:model];
				}
				if ([type isEqualToString:@"3"]) {
					[self.vocieTab addObject:model];
				}
				if ([type isEqualToString:@"4"]) {
					[self.voideTab addObject:model];
				}
				if ([type isEqualToString:@"7"]) {
					[self.templateTab addObject:model];
				}
				if ([type isEqualToString:@"6"]) {
					[self.fileTab addObject:model];
				}
			}
		}else{
			self.currPage>1?self.currPage--:0;
			[JRToast showWithText:data[@"message"]];
		}
		
		[type isEqualToString:@"8"]?[self.secondTab reloadTableWithArray:self.picTextTab withStyle:CGCTalkTablePic_Text]:0;
		[type isEqualToString:@"2"]?[self.secondTab reloadTableWithArray:self.picTab withStyle:CGCTalkTablePic]:0;
		[type isEqualToString:@"3"]?[self.secondTab reloadTableWithArray:self.vocieTab withStyle:CGCTalkTableVoice]:0;
		[type isEqualToString:@"4"]?[self.secondTab reloadTableWithArray:self.voideTab withStyle:CGCTalkTableVideo]:0;
		[type isEqualToString:@"7"]?[self.secondTab reloadTableWithArray:self.templateTab withStyle:CGCTalkTableTemplate]:0;
		[type isEqualToString:@"6"]?[self.secondTab reloadTableWithArray:self.fileTab withStyle:CGCTalkTableFile]:0;
	}];
	
	
	
}



#pragma mark -- 添加我的常用模板
-(void)HTTPAddMineMessageRequest:(NSString *)C_ID
{
	if (C_ID.length==0) {
		[JRToast showWithText:@"添加失败"];
		return;
	}
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_CGC_saveBeanId];
	
	NSMutableDictionary *dic=[NSMutableDictionary new];
	[dic setObject:C_ID forKey:@"C_ID"];
	[dic setObject:@"" forKey:@"X_PICCONTENT"];
	[dic setObject:@"" forKey:@"X_NAME"];
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	
	
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		
		if ([data[@"code"] integerValue]==200) {
			
			[JRToast showWithText:data[@"message"]];
			//            [self HTTPGetTemplateListWithType:0];//0个人1公共
			
		}else{
			
			[JRToast showWithText:data[@"message"]];
			
		}
	}];
	
	
}


#pragma mark -- 多人发送短信的接口

-(void)HTTPMorePeopleMessageRequestWithType:(NSString *)type withContent:(NSString *)content withC_ID:(NSString *)C_ID
{
	if (self.customIDArr.count==0) {
		[JRToast showWithText:@"跟进失败"];
		return;
	}
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_CGC_insertAllTemplateMessageToFollow];
	
	NSMutableDictionary *dic=[NSMutableDictionary new];
	//    if ([type isEqualToString:@"1"]) {
	//        if (self.customPhoneArr.count==0) {
	//            [JRToast showWithText:@"没有号码"];
	//            return;
	//        }
	//         [dic setObject:[self.customPhoneArr componentsJoinedByString:@","] forKey:@"C_A41500_C_ID"];
	//    }
	//    if ([type isEqualToString:@"2"]) {
	if (self.customIDArr.count==0) {
		[JRToast showWithText:@"没有客户ID"];
		return;
	}
	[dic setObject:[self.customIDArr componentsJoinedByString:@","] forKey:@"C_A41500_C_ID"];
	//    }
	
	[dic setObject:type forKey:@"TYPE"];
	content.length>0?[dic setObject:content forKey:@"X_PICCONTENT"]:0;
	
	[dict setObject:dic forKey:@"content"];
	
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	
	
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		
		if ([data[@"code"] integerValue]==200) {
			
			
			[JRToast showWithText:@"跟进成功"];
		}else{
			
			[JRToast showWithText:data[@"message"]];
			
		}
		
	}];
	
	
	
}

#pragma mark -- 删除模板
-(void)HTTPDeleteMineMessageRequest:(NSString *)C_ID
{
	if (C_ID.length==0) {
		[JRToast showWithText:@"删除失败"];
		return;
	}
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_CGC_templateMessageDeleteByID];
	
	NSMutableDictionary *dic=[NSMutableDictionary new];
	[dic setObject:C_ID forKey:@"C_ID"];
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	
	
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		
		if ([data[@"code"] integerValue]==200) {
			
			[self HTTPGetTemplateListWithType:0];
			
		}else{
			
			[JRToast showWithText:data[@"message"]];
			
		}
		
	}];
	
	
	
}

#pragma mark -- 微信公众号推送素材消息（通过潜客）
- (void)HTTPSharePublic:(NSString *)c_id{
	
	
	NSMutableDictionary*dict=self.C_A51100_C_ID.length>0?[DBObjectTools getAddressDicWithAction:HTTP_CGC_weChatPushByA511]:[DBObjectTools getAddressDicWithAction:HTTP_CGC_weChatPush];
	
	
	
	NSMutableDictionary *dic=[NSMutableDictionary new];
	[dic setObject:c_id forKey:@"C_ID"];
	if (self.C_A51100_C_ID.length>0) {
		[dic setObject:self.C_A51100_C_ID forKey:@"C_A51100_C_ID"];
	}else{
		(self.customIDArr.count>0)?[dic setObject:[self.customIDArr componentsJoinedByString:@","] forKey:@"C_A41500_C_ID"]:[dic setObject:@" " forKey:@"C_A41500_C_ID"];
	}
	
	
	
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	
	
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		
		if ([data[@"code"] integerValue]==200) {
			
			[JRToast showWithText:@"发送成功"];
		}else{
			
			[JRToast showWithText:data[@"message"]];
			
		}
		
	}];
	
}

#pragma mark -- 更新模板
-(void)HTTPUpdaeMineMessageRequest:(CGCTalkModel *)model withTitle:(NSString *)title withDesc:(NSString *)desc
{
	
	if (model.C_ID.length==0) {
		[JRToast showWithText:@"编辑失败"];
		return;
	}
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_CGC_templateMessageUpdate];
	
	NSMutableDictionary *dic=[NSMutableDictionary new];
	[dic setObject:model.C_ID forKey:@"C_ID"];
	(title.length>0)?[dic setObject:title forKey:@"C_NAME"]:[dic setObject:@" " forKey:@"C_NAME"];
	(desc.length>0)?[dic setObject:desc forKey:@"X_PICCONTENT"]:[dic setObject:@" " forKey:@"X_PICCONTENT"];
	(model.C_PHONETO.length>0)?[dic setObject:model.C_PHONETO forKey:@"C_PHONETO"]:[dic setObject:@" " forKey:@"C_PHONETO"];
	
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	
	
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		
		if ([data[@"code"] integerValue]==200) {
			
			[self HTTPGetTemplateListWithType:0];
		}else{
			
			[JRToast showWithText:data[@"message"]];
			
		}
		
	}];
	
	
}


#pragma mark --- 微信分享
- (void)sendWeiXin:(NSString *)title withDesc:(NSString *)desc withImg:(NSString *)imgUrl{
	
	if (imgUrl.length==0) {
		SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
		req.text =desc;
		req.bText = YES;
		req.scene = 0;
		[WXApi sendReq:req completion:nil];
		return;
	}
	UIImage *image=[self handleImageWithURLStr:imgUrl];
	
	WXMediaMessage *message = [WXMediaMessage message];
	[message setThumbImage:image];
	WXImageObject *webObj = [WXImageObject object];
	webObj.imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
	message.mediaObject = webObj;
	message.title=title;
	message.description=desc;
	
	SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
	req.scene = _scene;
	req.bText = NO;
	req.message = message;
	[WXApi sendReq:req completion:nil];
	
	
}

- (void)shareSuccess{
    if ([self.isFollow isEqualToString:@"noFollow"]) {
        if (self.textBackBlock) {
            self.textBackBlock(self.messStr);
        }
        [self.navigationController popViewControllerAnimated:NO];
        return;
    } else {
        NSArray * arr=[self.customStr componentsSeparatedByString:@","];
        //    self.firstIndex,self.secondIndex
        
        
        UIAlertController *alert= [DBObjectTools getAlertVCwithTitle:@"提示" withMessage:@"是否跟进客户？" clickCanel:^{
            self.bottomView.hidden=NO;
            self.recordTextView.hidden=NO;
        } sureClick:^{
            
            //        if (arr.count==1||self.customIDArr.count==1) {
            CustomerFollowAddEditViewController *cvc=[[CustomerFollowAddEditViewController alloc] init];
            cvc.Type=CustomerFollowUpAdd;
            cvc.delegate=self;
            cvc.followText =  self.messStr;
            cvc.infoModel=self.cusDetailModel;
            NSInteger section=self.secondIndex.section;
            NSInteger row=self.secondIndex.row;
            if (self.secArray.count>section){
                CGCTalkDetailModel *model=([[self.secArray[section] array] count]>row)?[self.secArray[section] array][row]:nil;  if (self.secondIndex!=nil) {
                    cvc.followText=  model.X_PICCONTENT;
                }
            }
            
            if (self.firstIndex!=nil) {
                if (self.dataArray.count>self.firstIndex.row) {
                    CGCTalkModel * model=self.dataArray[self.firstIndex.row];
                    cvc.followText=  model.X_PICCONTENT;
                }
                
            }
            
            
            
            [self.navigationController pushViewController:cvc animated:YES];
            //        }
            //
            //        if (arr.count>1||self.customIDArr.count>1) {
            //
            //            if (_templateType==CGCTemplateWeiXin) {
            //                NSLog(@"%@===%@----%@",self.titleStyle,self.firstIndex,self.secondIndex);
            //
            //                if (self.secondIndex!=nil) {
            //                    NSInteger section=self.secondIndex.section;
            //                    NSInteger row=self.secondIndex.row;
            //                    if ([self.titleStyle isEqualToString:@"文本"]) {
            //                        if (self.secArray.count>section){
            //                            CGCTalkDetailModel *model=([[self.secArray[section] array] count]>row)?[self.secArray[section] array][row]:nil;
            //                            [self HTTPMorePeopleMessageRequestWithType:@"2" withContent:model.X_PICCONTENT withC_ID:model.C_ID];
            //
            //                        }else{
            //                            [JRToast showWithText:@"跟进失败"];
            //                        }
            //
            //                    }
            //                    if ([self.titleStyle isEqualToString:@"图文"]) {
            //
            //                        if (self.picTextTab.count>row) {
            //                            CGCOtherTalkModel *model=self.picTextTab[row];
            //                            [self HTTPMorePeopleMessageRequestWithType:@"2" withContent:model.X_PICCONTENT withC_ID:model.C_ID];
            //                        }else{
            //                             [JRToast showWithText:@"跟进失败"];
            //                        }
            //
            //
            //                    }
            //                    if ([self.titleStyle isEqualToString:@"图片"]) {
            //
            //                        if (self.picTab.count>row) {
            //                            CGCOtherTalkModel *model=self.picTab[row];
            //                            [self HTTPMorePeopleMessageRequestWithType:@"2" withContent:model.X_PICCONTENT withC_ID:model.C_ID];
            //                        }else{
            //                            [JRToast showWithText:@"跟进失败"];
            //
            //                        }
            //
            //                    }
            //                    if ([self.titleStyle isEqualToString:@"文件"]) {
            //
            //                        if (self.fileTab.count>row) {
            //                            CGCOtherTalkModel *model=self.fileTab[row];
            //                           [self HTTPMorePeopleMessageRequestWithType:@"2" withContent:model.X_PICCONTENT withC_ID:model.C_ID];
            //                        }else{
            //                            [JRToast showWithText:@"跟进失败"];
            //
            //                        }
            //
            //                    }
            //                }
            //
            //                if (self.firstIndex!=nil) {
            //                    if (self.dataArray.count>self.firstIndex.row) {
            //                        CGCTalkModel * model=self.dataArray[self.firstIndex.row];
            //                        [self HTTPMorePeopleMessageRequestWithType:@"2" withContent:model.X_PICCONTENT withC_ID:model.C_ID];
            //                    }else{
            //                        [JRToast showWithText:@"跟进失败"];
            //
            //                    }
            //
            //                }
            //
            //
            //
            //            }
            //
            //
            //        }
            
        } canelActionTitle:@"取消" sureActionTitle:@"确定"];
        
        [self presentViewController:alert animated:YES completion:^{
            self.bottomView.hidden=YES;
            self.recordTextView.hidden=YES;
        }];
        NSLog(@"分享成功-=-=-=-");
    }
	
	
}

-(void)onResp:(BaseResp*)resp{
	
	if ([resp isKindOfClass:[PayResp class]]){
		PayResp*response=(PayResp*)resp;
		switch(response.errCode){
				
			case WXSuccess:
				NSLog(@"支付成功");
				break;
			default:
				NSLog(@"支付失败，retcode=%d",resp.errCode);
				break;
		}
	}
	
}

- (UIImage *)handleImageWithURLStr:(NSString *)imageURLStr {
	
	NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLStr]];
	NSData *newImageData = imageData;
	// 压缩图片data大小
	newImageData = UIImageJPEGRepresentation([UIImage imageWithData:newImageData scale:0.1], 0.1f);
	UIImage *image = [UIImage imageWithData:newImageData];
	
	// 压缩图片分辨率(因为data压缩到一定程度后，如果图片分辨率不缩小的话还是不行)
	CGSize newSize = CGSizeMake(200, 200);
	UIGraphicsBeginImageContext(newSize);
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}


#pragma mark --- 发送短信
- (void)sendMessageWithContent:(NSString *)content withCustomID:(NSArray *)cusArr{
	if (_templateType==CGCTemplatePublic||_templateType==CGCTemplateWeiXin) {
		if (self.customIDArr.count<=0) {
			[JRToast showWithText:@"请选择客户"];
			return;
		}
		if (_templateType==CGCTemplateWeiXin&&content.length>0) {
			SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
			req.text =content;
			req.bText = YES;
			req.scene = 0;
			[WXApi sendReq:req completion:nil];
			return;
		}
		
		
		[self bottomSendClick];
		
		return;
	}
	
	if (self.customIDArr.count==0) {
		[JRToast showWithText:@"请选择客户"];
		return;
	}
	if (self.customPhoneArr.count <= 0) {
		
		[JRToast showWithText:@"此客户没有电话号码，无法发送"];
		return;
	}
	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	
	if (messageClass!=nil&&[messageClass canSendText]) {
		
	}
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate =self;
	picker.recipients = self.customPhoneArr;
	picker.body = content;
	[self presentViewController:picker animated:YES completion:^{
		
	}];
	
	
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
	
	//关键的一句   不能为YES
	[controller dismissViewControllerAnimated:NO completion:^{
		
	}];
	switch (result) {
			
		case MessageComposeResultCancelled:
			
			[JRToast showWithText:@"发送取消"];
			break;
		case MessageComposeResultFailed:// send failed
			[JRToast showWithText:@"发送失败"];
			
			break;
		case MessageComposeResultSent:
			
			[JRToast showWithText:@"发送成功"];
			[self messSuccess];
			
			break;
		default:
			break;
	}
}

- (void)messSuccess{
	if ([self.isFollow isEqualToString:@"noFollow"]) {
        if (self.textBackBlock) {
            self.textBackBlock(self.messStr);
        }
		[self.navigationController popViewControllerAnimated:NO];
		return;
    } else {
        UIAlertController *alert= [DBObjectTools getAlertVCwithTitle:@"提示" withMessage:@"是否跟进客户？" clickCanel:^{
            
            self.bottomView.hidden=NO;
            self.recordTextView.hidden=NO;
            
        } sureClick:^{
            if (self.customPhoneArr.count==1) {
                CustomerFollowAddEditViewController *cvc=[[CustomerFollowAddEditViewController alloc] init];
                cvc.Type=CustomerFollowUpAdd;
                cvc.infoModel=self.cusDetailModel;
                
                cvc.followText=self.messStr;
                
                [self.navigationController pushViewController:cvc animated:YES];
            }
            if (self.customPhoneArr.count>1) {
                
                [self HTTPMorePeopleMessageRequestWithType:@"1" withContent:self.messStr withC_ID:nil];
                
            }
            
            
        } canelActionTitle:@"取消" sureActionTitle:@"确定"];
        [self presentViewController:alert animated:YES completion:^{
            self.bottomView.hidden=YES;
            self.recordTextView.hidden=YES;
        }];

    }
	
	
}

#pragma mark --- action

- (void)tapDisKeyboard{
	[[UIApplication sharedApplication].keyWindow endEditing:YES ];
}

//选择潜客
//- (void)addCustomClick{
//	DBSelf(weakSelf);
//	CGCCustomListVC * cvc=[[CGCCustomListVC alloc] init];
//	cvc.VCName=@"模板";
//	cvc.customSureBlock = ^(NSMutableArray *selArr) {
//		[weakSelf.customPhoneArr removeAllObjects];
//		[weakSelf.customIDArr removeAllObjects];
//		NSMutableArray * arr=[NSMutableArray array];
//
//		for (CGCCustomModel *model in selArr) {
//			if (selArr.count==1) {
//				self.cusDetailModel.C_ID=model.C_ID;
//				self.cusDetailModel.C_HEADIMGURL=model.C_PICURL;
//				self.cusDetailModel.C_NAME=model.C_NAME;
//				self.cusDetailModel.C_LEVEL_DD_NAME=model.C_LEVEL_DD_NAME;
//				self.cusDetailModel.C_LEVEL_DD_ID=model.C_LEVEL_DD_ID;
//
//			}
//			model.C_NAME.length>0?[arr addObject:model.C_NAME]:0;
//			model.C_PHONE.length>0?[self.customPhoneArr addObject:model.C_PHONE]:0;
//			model.C_ID.length>0?[self.customIDArr addObject:model.C_ID]:0;
//
//		}
//		NSString * str=[arr componentsJoinedByString:@","];
//		self.customStr=str;
//		self.headLab.text=[NSString stringWithFormat:@"收件人：%@",str];
//
//	};
//
//	[self.navigationController pushViewController:cvc animated:YES];
//}

#pragma mark -- 发送
- (void)bottomSendClick{
	
	MyLog(@"%s----line:----%d",__func__,__LINE__);
	NSLog(@"%@-=-", [self.customStr componentsSeparatedByString:@","]);
	
	if (self.customIDArr.count==0) {
		[JRToast showWithText:@"请选择收件人！"];
		return;
	}
	
	
	
	/*******************************公众号*******************************/
	
	if (_templateType==CGCTemplatePublic) {
		
		if (self.publicID.length==0) {
			[JRToast showWithText:@"发送失败"];
			return;
		}
		
		[self HTTPSharePublic:self.publicID];
		
	}
	
	/*******************************微信发送*******************************/
	
	if (_templateType==CGCTemplateWeiXin) {
		NSLog(@"%@===%@----%@",self.titleStyle,self.firstIndex,self.secondIndex);
		
		if (self.secondIndex!=nil) {
			NSInteger section=self.secondIndex.section;
			NSInteger row=self.secondIndex.row;
			if ([self.titleStyle isEqualToString:@"文本"]) {
				if (self.secArray.count>section){
					CGCTalkDetailModel *model=([[self.secArray[section] array] count]>row)?[self.secArray[section] array][row]:nil;
					[self sendWeiXin:model.C_NAME withDesc:model.X_PICCONTENT withImg:@""];
					
				}else{
					[JRToast showWithText:@"分享失败"];
				}
				
			}
			if ([self.titleStyle isEqualToString:@"图文"]) {
				
				if (self.picTextTab.count>row) {
					CGCOtherTalkModel *model=self.picTextTab[row];
					[self sendWeiXin:@"" withDesc:model.X_PICCONTENT withImg:model.X_MEDIAURL];
				}else{
					[JRToast showWithText:@"分享失败"];
				}
				
				
			}
			if ([self.titleStyle isEqualToString:@"图片"]) {
				
				if (self.picTab.count>row) {
					CGCOtherTalkModel *model=self.picTab[row];
					[self sendWeiXin:@"" withDesc:model.X_PICCONTENT withImg:model.X_MEDIAURL];
				}else{
					[JRToast showWithText:@"分享失败"];
				}
				
			}
			if ([self.titleStyle isEqualToString:@"文件"]) {
				
				if (self.fileTab.count>row) {
					CGCOtherTalkModel *model=self.fileTab[row];
					[self sendWeiXin:@"" withDesc:model.X_PICCONTENT withImg:model.X_MEDIAURL];
				}else{
					[JRToast showWithText:@"分享失败"];
				}
				
			}
		}
		
		if (self.firstIndex!=nil) {
			if (self.dataArray.count>self.firstIndex.row) {
				CGCTalkModel * model=self.dataArray[self.firstIndex.row];
				[self sendWeiXin:model.C_NAME withDesc:model.X_PICCONTENT withImg:@""];
			}else{
				[JRToast showWithText:@"分享失败"];
			}
			
		}
		
		
		
	}
	
	
}


#pragma mark --- set
- (UITableView *)tableView{
	
	if (!_tableView) {
		_tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight-NavStatusHeight-WD_TabBarHeight - SafeAreaBottomHeight) style:UITableViewStylePlain];
		_tableView.delegate=self;
		_tableView.dataSource=self;
		_tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
		_tableView.tableHeaderView=self.headView;
		_tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
		UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDisKeyboard)];
		tap.delegate=self;
		[_tableView addGestureRecognizer:tap];
		_tableView.scrollEnabled = NO;
	}
	
	return _tableView;
}

- (CustomerDetailInfoModel *)cusDetailModel{
	
	if (_cusDetailModel==nil) {
		_cusDetailModel=[[CustomerDetailInfoModel alloc] init];
	}
	return _cusDetailModel;
	
}

- (NSMutableArray *)customIDArr{
	
	if (!_customIDArr) {
		_customIDArr=[NSMutableArray array];
	}
	
	return _customIDArr;
}
- (NSMutableArray *)customPhoneArr{
	
	if (!_customPhoneArr) {
		_customPhoneArr=[NSMutableArray array];
	}
	
	return _customPhoneArr;
}


-(NSMutableArray *)dataArray{
	
	if (!_dataArray) {
		_dataArray=[NSMutableArray array];
	}
	return _dataArray;
}

- (CGCTalkTable *)firstTab{
	if (!_firstTab) {
		_firstTab=[[CGCTalkTable alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, KScreenHeight - 264) withTitleArr:@[]  withStyle:CGCTalkTableText withEidt:EidtUp];
		_firstTab.delegate=self;
		//		_firstTab.tableView.scrollEnabled = NO;
		//		_firstTab.tableView.bounces = NO;
	}
	return _firstTab;
}

-(CGCTalkTable *)secondTab{
	if (!_secondTab) {
		//        NSArray * arr=@[];
		//        if (self.templateType==CGCTemplatePublic) {
		//            arr=  @[@"文本",@"图文",@"图片",@"音频",@"视频",@"模板"];
		//        }
		//        if (self.templateType==CGCTemplateWeiXin) {
		//            arr=  @[@"文本",@"图文",@"图片",@"文件"];
		//        }
		//        if (self.templateType==CGCTemplateMessage) {
		//            arr =@[];
		//        }
		
		_secondTab=[[CGCTalkTable alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, KScreenHeight-264) withTitleArr:@[] withStyle:CGCTalkTableText withEidt:EidtDown];
		_secondTab.delegate=self;
		
	}
	return _secondTab;
	
}




- (UIView *)headView{
	
	if (!_headView) {
		_headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
		UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,KScreenWidth-70, 50)];
		self.titStr=self.titStr.length>0?self.titStr:@"";
		if (self.titStr.length > 0) {
			lab.text= [NSString stringWithFormat:@"收件人：%@",self.titStr];
		} else {
			NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"收件人: 请选择收件人"];
			[str addAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} range:NSMakeRange(5, str.length - 5)];
			lab.attributedText = str;
		}
		
		lab.font=[UIFont systemFontOfSize:16];
		[_headView addSubview:lab];
		self.headLab=lab;
		UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
		[btn setImage:@"短信收件人展开+"];
		[btn addTarget:self action:@selector(addCustomClick)];
		btn.frame=CGRectMake(KScreenWidth-50, 0, 50, 50);
		_headView.backgroundColor=DBColor(245, 245, 245);
		[_headView addSubview:btn];
	}
	
	return _headView;
}


-(NSMutableArray *)secArray{
	
	if (!_secArray) {
		_secArray=[NSMutableArray array];
	}
	
	return _secArray;
}

-(NSMutableArray *)picTextTab{
	
	if (!_picTextTab) {
		_picTextTab=[NSMutableArray array];
	}
	
	return _picTextTab;
}
-(NSMutableArray *)picTab{
	
	if (!_picTab) {
		_picTab=[NSMutableArray array];
	}
	
	return _picTab;
}
-(NSMutableArray *)vocieTab{
	
	if (!_vocieTab) {
		_vocieTab=[NSMutableArray array];
	}
	
	return _vocieTab;
}
//-(NSMutableArray *)voideTab{
//
//    if (!_voideTab) {
//        _voideTab=[NSMutableArray array];
//    }
//
//    return _voideTab;
//}
-(NSMutableArray *)templateTab{
	
	if (!_templateTab) {
		_templateTab=[NSMutableArray array];
	}
	
	return _templateTab;
}
-(NSMutableArray *)fileTab{
	
	if (!_fileTab) {
		_fileTab=[NSMutableArray array];
	}
	
	return _fileTab;
}

- (UIView *)bottomView{
	
	if (!_bottomView) {
		_bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-60 - SafeAreaBottomHeight, KScreenWidth, 60)];
		_bottomView.backgroundColor=DBColor(245, 245, 245);
		UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
		btn.frame=CGRectMake(10, 8, KScreenWidth-20, 44);
		btn.backgroundColor=CGCNAVCOLOR;
		[btn setTitleNormal:@"发送"];
		[btn setTitleColor:DBColor(0, 0, 0)];
		[btn addTarget:self action:@selector(bottomSendClick)];
		[_bottomView addSubview:btn];
	}
	
	return _bottomView;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
	
	// 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
	
	if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]){
		[[UIApplication sharedApplication].keyWindow endEditing:YES];
		return NO;
	}
	
	return YES;
}

#pragma mark --- 模板选择delegate
- (void)talkTable:(CGCTalkTable *)talk didSelectWithIndex:(NSIndexPath *)indexPath withSelectText:(NSString *)text withSelC_ID:(NSString *)C_ID{
	self.messStr = text;
	self.publicID=C_ID;
	
	if (self.templateType==CGCTemplatePublic||self.templateType==CGCTemplateWeiXin) {
		//        [self.view addSubview:self.bottomView];//单个发送按钮
		self.recordTextView.hidden = YES;
	}else{
		self.bottomView.hidden=YES;
	}
	NSLog(@"%@-=-=-=-==-",text);
	
	if (talk==self.firstTab) {
		self.firstTab.indexPath=indexPath;
		self.secondTab.indexPath=nil;
		[self.firstTab.tableView reloadData];
		[self.secondTab.tableView reloadData];
		[self.recordTextView setTextWith:text];
		
		self.firstIndex=indexPath;
		self.secondIndex=nil;
		[self sendMessageWithContent:text withCustomID:nil];
	}
	if (talk==self.secondTab) {
		
		
		self.secondTab.indexPath=indexPath;
		self.firstTab.indexPath=nil;
		[self.firstTab.tableView reloadData];
		[self.secondTab.tableView reloadData];
		[self.tableView reloadData];
		[self.recordTextView setTextWith:text];
		
		self.firstIndex=nil;
		self.secondIndex=indexPath;
		//        [self bottomSendClick];
		[self sendMessageWithContent:text withCustomID:nil];
		
	}
	
}

- (void)talkTable:(CGCTalkTable *)talk didClickWithTitle:(NSString *)title{
	
	self.titleStyle=title;
	
	self.secondTab.indexPath=nil;
	self.firstTab.indexPath=nil;
	[self.firstTab.tableView reloadData];
	[self.secondTab.tableView reloadData];
	
	if (![title isEqualToString:@"文本"]||self.templateType==CGCTemplatePublic) {
		[self.recordTextView setHidden:YES];
		self.bottomView.hidden=NO;
	}else{
		[self.recordTextView setHidden:NO];
		self.bottomView.hidden=YES;
	}
	
	
	if ([title isEqualToString:@"文本"]) {
		[self.secondTab reloadTableWithArray:self.secArray withStyle:CGCTalkTableText];
		
		
	}
	
	if ([title isEqualToString:@"图文"]&&self.picTextTab.count==0) {
		
		
		[self HTTPGetOtherTemplateList:@"8"];
	}else if ([title isEqualToString:@"图文"]&&self.picTextTab.count>0){
		[self.secondTab reloadTableWithArray:self.picTextTab withStyle:CGCTalkTablePic_Text];
	}
	
	if ([title isEqualToString:@"图片"]&&self.picTab.count==0) {
		[self HTTPGetOtherTemplateList:@"2"];
	}else if ([title isEqualToString:@"图片"]&&self.picTab.count>0){
		[self.secondTab reloadTableWithArray:self.picTab withStyle:CGCTalkTablePic];
	}
	
	
	
	if ([title isEqualToString:@"音频"]&&self.vocieTab.count==0) {
		[self HTTPGetOtherTemplateList:@"3"];
	}else if ([title isEqualToString:@"音频"]&&self.vocieTab.count>0){
		[self.secondTab reloadTableWithArray:self.vocieTab withStyle:CGCTalkTableVoice];
	}
	
	
	if ([title isEqualToString:@"视频"]&&self.voideTab.count==0) {
		[self HTTPGetOtherTemplateList:@"4"];
	}else if ([title isEqualToString:@"视频"]&&self.voideTab.count>0){
		[self.secondTab reloadTableWithArray:self.voideTab withStyle:CGCTalkTableVideo];
	}
	
	
	if ([title isEqualToString:@"模板"]&&self.templateTab.count==0) {
		[self HTTPGetOtherTemplateList:@"7"];
	}else if ([title isEqualToString:@"模板"]&&self.templateTab.count>0){
		[self.secondTab reloadTableWithArray:self.templateTab withStyle:CGCTalkTableTemplate];
	}
	
	if ([title isEqualToString:@"文件"]&&self.fileTab.count==0) {
		[self HTTPGetOtherTemplateList:@"6"];
	}else if ([title isEqualToString:@"文件"]&&self.fileTab.count>0){
		[self.secondTab reloadTableWithArray:self.fileTab withStyle:CGCTalkTableFile];
	}
	
	
}




- (void)talkTable:(CGCTalkTable *)talk didClickEidtIndex:(NSIndexPath *)indexPath withEidt:(EidtStyle)eidtStyle withTitle:(NSString *)title andText:(NSString *)textStr {
	DBSelf(weakSelf);
	if (eidtStyle==EidtUp) {
		
		if ([title isEqualToString:@"编辑"]) {
			
			CGCTalkModel *model=weakSelf.dataArray[indexPath.row];
			if (textStr.length > 0) {
				[self HTTPUpdaeMineMessageRequest:model withTitle:model.C_NAME withDesc:textStr];
			}
			//            self.eidtMessView=[[CGCEidtMessView alloc] initWithFrame:self.view.bounds withTitle:model.C_NAME withDesStr:model.X_PICCONTENT withCanel:^{
			//
			//            } withSure:^(NSString *title, NSString *desc) {
			
			
			//            }];
			//
			//            [self.view addSubview:self.eidtMessView];
		}
		
		if ([title isEqualToString:@"删除"]) {
			
			UIAlertController* alert= [DBObjectTools getAlertVCwithTitle:@"提示" withMessage:@"是否删除此条模板消息" clickCanel:^{
				
			} sureClick:^{
				CGCTalkModel *model=weakSelf.dataArray[indexPath.row];
				
				[weakSelf HTTPDeleteMineMessageRequest:model.C_ID];
				
			} canelActionTitle:@"取消" sureActionTitle:@"确定"];
			[self presentViewController:alert animated:YES completion:^{
				
			}];
		}
		
	}
	
	if (eidtStyle==EidtDown) {
		DBSelf(weakSelf);
		UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"是否添加到个人模板中" message:nil preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			CGCTalkModel *model=weakSelf.secArray[indexPath.section];
			
			CGCTalkDetailModel * desModel= model.array.count>0?[weakSelf.secArray[indexPath.section] array][indexPath.row]:0;
			[weakSelf HTTPAddMineMessageRequest:desModel.C_ID];
		}];
		
		UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
			
		}];
		
		[alertV addAction:noAction];
		[alertV addAction:yesAction];
		
		[self presentViewController:alertV animated:YES completion:nil];
		
		
	}
	
	
	
}



#pragma mark 当键盘出现
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
		self.keyBoardView.transform = CGAffineTransformMakeTranslation(0, keyboardFrame.origin.y - self.view.frame.size.height-30);
		
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

@end
