//
//  SHWechatMarketingViewController.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/27.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHWechatMarketingViewController.h"
#import "CFDropDownMenuView.h"
#import "FunnelShowView.h"
#import "SHWechatMarketTableViewCell.h"


#import "PYSearchViewController.h"
#import "SHChatViewController.h"

#import "SHWechatMainListModel.h"
#import "SHWechatListModel.h"
#import "SHWechatListSubModel.h"

#import "UIViewController+MJPopupViewController.h"
#import "TFLoadingController.h"


#define CELL0    @"SHWechatMarketTableViewCell"

@interface SHWechatMarketingViewController ()<UITableViewDelegate,UITableViewDataSource,CFDropDownMenuViewDelegate,UISearchBarDelegate> {
	NSString *_countNumber;
	NSInteger _count;
	NSString *_type;
	NSString *_state;
	NSString *_time;
	NSString *_saleUser;
	NSString *pageSize;
	BOOL isSelect;
	BOOL _islook;//是否已查看
}
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)CFDropDownMenuView*menuView;   //菜单选择栏
@property(nonatomic,strong)FunnelShowView*funnelView;   //右边移过来的view

@property(nonatomic,assign)NSInteger pagen;
@property(nonatomic,assign)NSInteger pages;  //1 开始
@property(nonatomic,strong)NSMutableArray*MAAllDatas;

@property (nonatomic, strong) NSMutableArray <SHWechatListModel *>*listArray;
@property (nonatomic, strong) SHWechatMainListModel *wechatMainListModel;
//筛选条件
@property (nonatomic, strong) NSMutableArray *filterArray;
//销售顾问列表
@property (nonatomic, strong) NSMutableArray *salesNameArray;
@property (nonatomic, strong) NSMutableArray *salesCodeArray;
@property (nonatomic, strong) TFLoadingController *loadController;
@property (nonatomic, strong) NSString *searchName;
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation SHWechatMarketingViewController

- (instancetype)init {
	if (self = [super init]) {
		self.salesNameArray = [NSMutableArray array];
		self.salesCodeArray = [NSMutableArray array];
		[self presentPopupViewController:self.loadController animationType:MJPopupViewAnimationFade];
		[self getSalesList];
	}
	return self;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.pages = 1;
	self.pagen = _count;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.listArray removeAllObjects];
	[self getListData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.pages=1;
	_time = @"";
	_state = @"";
	_saleUser = @"";
	_type = @"";
	_count = 10;
//	NSString *namela = [MyUtil getuser_id];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"微信营销";
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self setRefreshReload];
//    [self addChooseView];
    [self setUpNaviView];
	
	
	
    
}

#pragma mark  --UI
-(void)setUpNaviView{
    UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-20-40, 30)];
    BGView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.8];
    BGView.layer.cornerRadius=15;
    BGView.layer.masksToBounds=YES;
    self.navigationItem.titleView=BGView;
    
//    UIButton*placeholderButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 5, KScreenWidth-20-40-20-60, 20)];
//    [placeholderButton setTitleNormal:@"请输入客户昵称" forState:UIControlStateNormal];
//    placeholderButton.titleLabel.font=[UIFont systemFontOfSize:14];
//    [placeholderButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [placeholderButton addTarget:self action:@selector(clickSearch)];
//    [BGView addSubview:placeholderButton];
	UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:BGView.frame];
	self.searchBar = searchBar;
	searchBar.placeholder = @"请输入客户昵称";
	searchBar.delegate = self;
	[BGView addSubview:searchBar];
	
//    UIButton*imageButton=[[UIButton alloc]initWithFrame:CGRectMake(BGView.width-15-15, 7.5, 15, 15)];
//    [imageButton setBackgroundImage:[UIImage imageNamed:@"放大镜"] forState:UIControlStateNormal];
//    [imageButton addTarget:self action:@selector(clickVedio)];
//    [BGView addSubview:imageButton];
	
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	self.searchName = searchBar.text;
	[self.tableView.mj_header beginRefreshing];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	self.searchName = searchBar.text;
	[self.tableView.mj_header beginRefreshing];
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self.searchBar resignFirstResponder];
}



-(void)addChooseView{
    CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 40)];
    self.menuView=menuView;
	menuView.delegate = self;
	NSMutableArray *arr = [NSMutableArray array];
	[arr addObject:@"全部"];
	[arr addObject:@"我的"];
	[arr addObjectsFromArray:self.salesNameArray];
    
    NSArray *titleArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
    NSArray *idArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
    menuView.dataSourceArr=[@[@[@"全部",@"待处理",@"已处理",@"今日关注",@"48H活跃"],
                             @[@"全部",@"已新增",@"未留档",@"已关联"],
                             titleArr,
                             arr] mutableCopy];
    menuView.defaulTitleArray=@[@"类型",@"状态",@"时间",@"员工"];

    
    menuView.startY=CGRectGetMaxY(menuView.frame);
    
    DBSelf(weakSelf);
    menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
        MyLog(@"%@ %@ %@",selectedSection,selectedRow,title);
		isSelect = YES;
		if ([selectedSection isEqualToString:@"0"]) {
			if ([title isEqualToString:@"待处理"]) {
				_type = @"0";
			} else if ([title isEqualToString:@"已处理"]) {
				_type = @"1";
			} else if ([title isEqualToString:@"今日关注"]) {
				_type = @"2";
			} else if ([title isEqualToString:@"48H活跃"]) {
				_type = @"3";
			} else {
				_type= @"";
			}
		}
		
		if ([selectedSection isEqualToString:@"1"]) {
			if (title != nil && title.length > 0) {
				_state = selectedRow;
			} else {
				_state = @"";
			}
			
		}
		
		if ([selectedSection isEqualToString:@"2"]) {
            _time = idArr[selectedRow.integerValue];
		}
		
		if ([selectedSection isEqualToString:@"3"]) {
			NSMutableArray *codeArr =[NSMutableArray array];
			[codeArr addObject:@""];//全部
			[codeArr addObject:[NewUserSession instance].user.u051Id];//我的
			[codeArr addObjectsFromArray:weakSelf.salesCodeArray];
			_saleUser = codeArr[selectedRow.integerValue];
		}
		//筛选后请求
		weakSelf.pages = 1;
		_count = 10;
		weakSelf.pagen = _count;
		[weakSelf.listArray removeAllObjects];
		[weakSelf presentPopupViewController:self.loadController animationType:MJPopupViewAnimationFade];
		[weakSelf getListData];
		if (_count > _countNumber.integerValue) {
			[weakSelf.tableView.mj_footer endRefreshing];
		} else {
			[weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
		}
    };
    
    
    [self.view addSubview:menuView];
    
    
//    //这个是漏斗
//    CFRightButton*funnelButton=[[CFRightButton alloc]initWithFrame:CGRectMake( KScreenWidth-40,64, 40, 40)];
//    [self.view addSubview:funnelButton];
//    //这个是选择的大view
//    FunnelShowView*funnelView=[FunnelShowView funnelShowView];
//    [[UIApplication sharedApplication].keyWindow addSubview:funnelView];
//    
//    funnelButton.clickFunnelBlock = ^(BOOL isSelected) {
//        [menuView hide];
//        //显示 左边的view
//        [funnelView show];
//        
//        
//        
//    };
//    
}

#pragma mark --CFDropDownMenuViewDelegate
- (void)startRequest {
	if (isSelect == YES) {
		self.pages = 1;
		_count = 10;
		self.pagen = _count;
		[self.listArray removeAllObjects];
		[self getListData];
		if (_count > _countNumber.integerValue) {
			[self.tableView.mj_footer endRefreshing];
		} else {
			[self.tableView.mj_footer endRefreshingWithNoMoreData];
		}
		
	} else {
		return;
	}
	isSelect = NO;
	
}

#pragma mark --列表接口请求
- (void)getListData {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A51100WebService-getList"];
	[dict setObject:@{@"currPage" : [NSString stringWithFormat:@"%ld",(long)self.pages] , @"pageSize" : [NSString stringWithFormat:@"%ld",(long)self.pagen], @"TYPE" : _type, @"USER_ID" : _saleUser, @"STATUS_TYPE" : _state, @"CREATE_TIME_TYPE" : _time, @"SEARCH_NAME" : self.searchName.length > 0 ? self.searchName : @""} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			_countNumber = data[@"countNumber"];
			pageSize = data[@"pageSize"];
			weakSelf.wechatMainListModel = [SHWechatMainListModel yy_modelWithDictionary:data];
			[weakSelf.tableView reloadData];
			[weakSelf dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		[self.tableView.mj_header endRefreshing];
	}];
}

#pragma mark --员工列表
- (void)getSalesList {
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list",HTTP_IP] parameters:@{@"C_LOCCODE" : [NewUserSession instance].user.C_LOCCODE} compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			NSArray *arr = data[@"data"];
			for (int i = 0; i < arr.count; i++) {
                NSDictionary *dic = arr[i];
				[weakSelf.salesNameArray addObject:dic[@"nickName"]];
				[weakSelf.salesCodeArray addObject:dic[@"u051Id"]] ;
			}
			[self addChooseView];
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}

#pragma mark  --tableView
-(void)setRefreshReload{
    self.pagen=10;
	self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		self.pagen = 10;
		[self getListData];
	}];
	self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoredata)];
}

- (void)loadMoredata {
//	self.pages++;
	self.pagen += self.pagen;
	_count += _count ;
	[self getListData];
	[self.tableView.mj_footer endRefreshing];
	if (_count > _countNumber.integerValue) {
		[self.tableView.mj_footer endRefreshingWithNoMoreData];
	}
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	NSArray *arr = self.wechatMainListModel.content;
    return arr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	SHWechatListModel *wechatListModel = self.wechatMainListModel.content[section];
	NSArray *arr = wechatListModel.content;
	return arr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SHWechatMarketTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
	SHWechatListModel *wechatListModel = self.wechatMainListModel.content[indexPath.section];
	SHWechatListSubModel *wechatListSubModel = wechatListModel.content[indexPath.row];
	cell.lastActiveTimeLabel.text = [NSString stringWithFormat:@"最后活跃:%@",wechatListSubModel.D_LASTUPDATE_TIME];
	[cell updateCellWithData:wechatListSubModel];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SHChatViewController*vc=[[SHChatViewController alloc]init];
	SHWechatListModel *wechatListModel = self.wechatMainListModel.content[indexPath.section];
	SHWechatListSubModel *wechatListSubModel = wechatListModel.content[indexPath.row];
	vc.wechatListSubModel = wechatListSubModel;
	
	[vc setIsLook:^(BOOL value){
		_islook = value;
	}];

    [self.navigationController pushViewController:vc animated:YES];
    

}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 25)];
    mainView.backgroundColor=DBColor(235,235,241);
    
    UILabel*leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 2.5, KScreenWidth/2, 20)];
    leftLabel.font=[UIFont systemFontOfSize:14];
    leftLabel.textColor=[UIColor grayColor];
	SHWechatListModel *wechatListModel = self.wechatMainListModel.content[section];
    leftLabel.text=wechatListModel.total;
    [mainView addSubview:leftLabel];
    
    //总计多少个
    if (section==0) {
        UILabel*rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth-60,0 , 60, 15)];
        rightLabel.backgroundColor=[UIColor whiteColor];
        rightLabel.font=[UIFont systemFontOfSize:10];
        rightLabel.textColor=[UIColor grayColor];
        rightLabel.textAlignment=NSTextAlignmentCenter;
        [mainView addSubview:rightLabel];
        rightLabel.text=[NSString stringWithFormat:@"总计%@",_countNumber];
    }
    return mainView;
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction*relevanceAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"关联" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
      
        MyLog(@"relevance");
        
        
    }];
      relevanceAction.backgroundColor=[UIColor blueColor];
    UITableViewRowAction*addtionAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"新增" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
       
        MyLog(@"addtion");
        
    }];
     addtionAction.backgroundColor=[UIColor grayColor];
    UITableViewRowAction*designateAgainAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"重新指派" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        MyLog(@"designateAgain");
    }];
    designateAgainAction.backgroundColor=[UIColor orangeColor];
    return @[relevanceAction,addtionAction,designateAgainAction];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark  -- touch
#pragma mark --naviView
-(void)clickSearch{
//    PYSearchViewController*searchVC=[PYSearchViewController searchViewControllerWithHotSearches:@[@"tim",@"sam",@"jam",@"tom"] searchBarPlaceholder:@"请输入搜索关键字" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
//
//    }];
//    [self.navigationController pushViewController:searchVC animated:YES];
}



-(void)clickVedio{
    MyLog(@"语音");
	
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

#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+40, KScreenWidth, KScreenHeight-64-40) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
//		_tableView.backgroundColor = DBColor(199, 197, 203);
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
		
	}
    return _tableView;
}

- (NSMutableArray<SHWechatListModel *> *)listArray {
	if (!_listArray) {
		_listArray = [NSMutableArray array];
	}
	return _listArray;
}

- (NSMutableArray *)filterArray {
	if (!_filterArray) {
		_filterArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
	}
	return _filterArray;
}

- (TFLoadingController *)loadController {
	if (!_loadController) {
		_loadController = [[TFLoadingController alloc]initWithNibName:@"TFLoadingController" bundle:nil];
	}
	return _loadController;
}

@end
