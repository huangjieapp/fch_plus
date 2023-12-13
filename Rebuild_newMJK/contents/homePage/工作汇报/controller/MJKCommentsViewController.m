//
//  MJKCommentsViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/4.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKCommentsViewController.h"

#import "MJKCommentsListModel.h"

#import "MJKCommentsCell.h"

@interface MJKCommentsViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** 输入框*/
@property (nonatomic, strong) UIView *textView;
/** 输入框输入的内容*/
@property (nonatomic, strong) NSString  *textStr;
/** 列表数组*/
@property (nonatomic, strong) NSArray *dataArray;
/** inputView*/
@property (nonatomic, strong) UITextView *inputView;
/** choose view*/
@property (nonatomic, strong) UIView *chooseView;
@end

@implementation MJKCommentsViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	self.title = @"评论";
	[self initUI];
}

- (void)initUI {
	[self.view addSubview:self.chooseView];
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.textView];
	
	CGRect tableViewFrame = self.tableView.frame;
	UIView *sepView = [self.chooseView viewWithTag:100];
	CGRect sepFrame = sepView.frame;
	if ([self.typeStr isEqualToString:@"点赞"]) {
		UIButton *button = [self.chooseView viewWithTag:1001];
		sepFrame.origin.x = button.frame.origin.x;
		
	}
	if (![self.typeStr isEqualToString:@"评论"]) {
		tableViewFrame.size.height = tableViewFrame.size.height + self.textView.frame.size.height;
		self.textView.hidden = YES;
	} else {
		UIButton *button = [self.chooseView viewWithTag:1000];
		sepFrame.origin.x = button.frame.origin.x;
		tableViewFrame.size.height = tableViewFrame.size.height - self.textView.frame.size.height;
		self.textView.hidden = NO;
	}
	sepView.frame = sepFrame;
	self.tableView.frame = tableViewFrame;
//	[self httpCommentsAllCount];//评论、阅读、点赞数
	[self httpGetCommentsList:self.typeStr];//评论、阅读、点赞列表
	
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKCommentsListModel *model = self.dataArray[indexPath.row];
	MJKCommentsCell *cell = [MJKCommentsCell cellWithTableView:tableView];
	cell.model = model;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKCommentsListModel *model = self.dataArray[indexPath.row];
	CGSize size = [model.X_REMARK boundingRectWithSize:CGSizeMake(KScreenWidth - 90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.f]} context:nil].size;
	if (size.height + 50 > 70) {
		return size.height + 50;
	} else {
		return 70;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1;
}

#pragma mark - get comments list
- (void)httpGetCommentsList:(NSString *)typeStr {
	NSString *actionStr;
	if ([typeStr isEqualToString:@"评论"]) {
		actionStr = @"A46500WebService-getList";
	} else if ([typeStr isEqualToString:@"阅读"]) {
		actionStr = @"A46500WebService-getReadList";
	} else if ([typeStr isEqualToString:@"点赞"]) {
		actionStr = @"A46500WebService-getFabulousList";
	}
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:actionStr];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"C_OBJECTID"] = self.C_OBJECTID;
	[dict setObject:dic forKey:@"content"];
	DBSelf(weakSelf);
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.dataArray = [MJKCommentsListModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
			weakSelf.textStr = @"";
			weakSelf.inputView.text = @"";
			[weakSelf httpCommentsAllCount];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		weakSelf.view.userInteractionEnabled = YES;
	}];
	
}

#pragma mark add comments
- (void)httpAddComments{
	self.view.userInteractionEnabled = NO;
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A46500WebService-insert"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"C_OBJECTID"] = self.C_OBJECTID;
	dic[@"X_REMARK"] = self.textStr;
	dic[@"C_ID"] = [DBObjectTools getWorkReportCommentsA46500];
	[dict setObject:dic forKey:@"content"];
	DBSelf(weakSelf);
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf httpGetCommentsList:weakSelf.typeStr];
			[JRToast showWithText:@"评论成功"];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}
//评论、阅读、点赞数
- (void)httpCommentsAllCount{
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A46500WebService-getAllCount"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"C_OBJECTID"] = self.C_OBJECTID;
	[dict setObject:dic forKey:@"content"];
	DBSelf(weakSelf);
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			UIButton *button = [weakSelf.chooseView viewWithTag:1000];
			[button setTitleNormal:[NSString stringWithFormat:@"评论 %@",data[@"comments"]]];
			UIButton *button1 = [weakSelf.chooseView viewWithTag:1002];
			[button1 setTitleNormal:[NSString stringWithFormat:@"阅读 %@",data[@"read"]]];
			UIButton *button2 = [weakSelf.chooseView viewWithTag:1001];
			[button2 setTitleNormal:[NSString stringWithFormat:@"点赞 %@",data[@"fabulous"]]];
            [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isRefresh"];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma keyBoardShow
- (void)keyBoardShow:(NSNotification *)noti {
	DBSelf(weakSelf);
	NSDictionary*userInfo=noti.userInfo;
	CGFloat keyEndY = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].origin.y;
	
	[UIView animateWithDuration:.1 animations:^{
		CGRect frame = weakSelf.textView.frame;
		frame.origin.y =keyEndY - frame.size.height - 30;
		weakSelf.textView.frame = frame;
	}];
	
}

- (void)keyBoardHide:(NSNotification *)noti {
	DBSelf(weakSelf);
	[UIView animateWithDuration:.1 animations:^{
		CGRect frame = weakSelf.textView.frame;
		frame.origin.y = KScreenHeight - 60 - SafeAreaBottomHeight;
		weakSelf.textView.frame = frame;
	}];
}

#pragma textViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
	self.textStr = textView.text;
}

#pragma mark - 选择类型
- (void)chooseTypeButtonAction:(UIButton *)sender {
	UIView *chooseSepView = [self.chooseView viewWithTag:100];
	CGRect frame = chooseSepView.frame;
	frame.origin.x = sender.frame.origin.x;
	chooseSepView.frame = frame;

	
	
	self.typeStr = [sender.titleLabel.text substringToIndex:2];
	CGRect tableViewFrame = self.tableView.frame;
	if (![self.typeStr isEqualToString:@"评论"]) {
		tableViewFrame.size.height = tableViewFrame.size.height + self.textView.frame.size.height;
		self.textView.hidden = YES;
	} else {
		tableViewFrame.size.height = tableViewFrame.size.height - self.textView.frame.size.height;
		self.textView.hidden = NO;
	}
	self.tableView.frame = tableViewFrame;
	
	[self httpGetCommentsList:self.typeStr];
	
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.chooseView.frame), KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight - self.textView.frame.size.height - SafeAreaBottomHeight - self.chooseView.frame.size.height)];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.tableFooterView = [[UIView alloc]init];
	}
	return _tableView;
}

- (UIView *)textView {
	if (!_textView) {
		_textView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 60 - SafeAreaBottomHeight, KScreenWidth, 60)];
		_textView.backgroundColor = kBackgroundColor;
		
		UITextView *inputView = [[UITextView alloc]initWithFrame:CGRectMake(8, 5, KScreenWidth - 100 - 20, _textView.frame.size.height - 10)];
		[_textView addSubview:inputView];
		inputView.font = [UIFont systemFontOfSize:14.f];
		inputView.layer.cornerRadius = 5.f;
		inputView.delegate = self;
		self.inputView = inputView;
		
		
		UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(inputView.frame) + 10, 5, 100, inputView.frame.size.height)];
		button.backgroundColor = KNaviColor;
		[button setTitle:@"评论" forState:UIControlStateNormal];
		button.layer.cornerRadius = 5.f;
		[button addTarget:self action:@selector(addCommentAction:)];
		[_textView addSubview:button];
	}
	return _textView;
}

#pragma mark 新增评论按钮
- (void)addCommentAction:(UIButton *)sender {
	if (self.textStr.length <= 0) {
		[JRToast showWithText:@"请输入"];
		return;
	}
	[self.view endEditing:YES];
//	self.inputView.text = @"";
	[self httpAddComments];
}

- (UIView *)chooseView {
	if (!_chooseView) {
		_chooseView = [[UIView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 41)];
		_chooseView.backgroundColor = [UIColor whiteColor];
		UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, KScreenWidth, 1)];
		sepView.backgroundColor = kBackgroundColor;
		[_chooseView addSubview:sepView];
		
		for (int i = 0; i < 3; i++) {
			UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake( i * (KScreenWidth / 3), 0, KScreenWidth / 3, 40)];
			[button setTitleNormal:@[@"评论 0",@"点赞 0",@"阅读 0"][i]];
			button.titleLabel.font = [UIFont systemFontOfSize:14.f];
			button.tag = 1000 + i;
			[button setTitleColor:[UIColor blackColor]];
			[button addTarget:self action:@selector(chooseTypeButtonAction:)];
			if (i == 0) {
				UIView *chooseSepView = [[UIView alloc]initWithFrame:CGRectMake(button.frame.origin.x, 38, button.frame.size.width, 2)];
				chooseSepView.backgroundColor = KNaviColor;
				chooseSepView.tag = 100;
				[_chooseView addSubview:chooseSepView];
			}
			[_chooseView addSubview:button];
		}
	}
	return _chooseView;
}

@end
