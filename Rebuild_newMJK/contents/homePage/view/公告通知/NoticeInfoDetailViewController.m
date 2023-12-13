//
//  NoticeInfoDetailViewController.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/22.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "NoticeInfoDetailViewController.h"
#import "NoticeDetailTableViewCell.h"
#import "NoticeInfoModel.h"
#import "AddNewNoticeViewController.h"
#import "MJKReaderListViewController.h"

#import "DBWebViewController.h"

#define CELL0   @"NoticeDetailTableViewCell"

@interface NoticeInfoDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,assign)NSInteger pagen;
@property(nonatomic,assign)NSInteger pages;

@end

@implementation NoticeInfoDetailViewController
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (self.type==noticeTypeManager) {
		[self setupRefresh];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
    self.title=@"公司公告";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
	
	
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
	[button setImage:[UIImage imageNamed:@"head+"] forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont systemFontOfSize:14.f];
	[button addTarget:self action:@selector(addNotice)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
	
    
}

- (void)addNotice {
	if (![[NewUserSession instance].appcode containsObject:@"APP008_0016"]) {
		[JRToast showWithText:@"账号无权限"];
		return;
	}
	
	AddNewNoticeViewController*vc=[[AddNewNoticeViewController alloc]init];
	[self.navigationController pushViewController:vc animated:YES];
}



#pragma mark  --UI
-(void)setupRefresh{
    self.pagen=10;
    self.pages=1;
    
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pages=1;
        [self httpPostGetInfo];
    }];
    
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pages++;
         [self httpPostGetInfo];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allDatas.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	DBSelf(weakSelf);
    NoticeDetailTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    NoticeInfoModel*model=self.allDatas[indexPath.row];
    [cell getValue:model];
	cell.readerListBlock = ^{
		MJKReaderListViewController *vc = [[MJKReaderListViewController alloc]init];
		vc.C_OBJECTID = model.C_ID;
		[weakSelf.navigationController pushViewController:vc animated:YES];
	};
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
    NoticeInfoModel*model=self.allDatas[indexPath.row];
    DBWebViewController*vc=[[DBWebViewController alloc]init];
	NSString *httpUrl = [[[NSUserDefaults standardUserDefaults]objectForKey:@"formal"] isEqualToString:@"YES"] ? HTTP_CompanyNotice : HTTP_TestCompanyNotice;
    NSString*address=[NSString stringWithFormat:@"%@%@",httpUrl,model.C_JUMP_URL];
//	NSString*address=[NSString stringWithFormat:@"%@%@",HTTP_CompanyNotice,model.C_JUMP_URL];
    vc.urlStr=address;
    vc.title=model.C_TITLE;
	vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


#pragma mark  --datas
-(void)httpPostGetInfo{

    NSMutableDictionary*mainDic=[DBObjectTools getAddressDicWithAction:HTTP_NOticeInfo];
    NSDictionary*dict=@{@"TYPE":@"1",@"pageSize":@(_pagen),@"currPage":@(_pages)};
    [mainDic setObject:dict forKey:@"content"];
    NSString*params=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:params parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if (self.pages==1) {
                self.allDatas=[NSMutableArray array];
            }
            
            NSArray*array=data[@"content"];
            for (NSDictionary*dict in array) {
                NoticeInfoModel*model=[NoticeInfoModel yy_modelWithDictionary:dict];
                [self.allDatas addObject:model];
                
            }
            
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];

    
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

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight - SafeAreaBottomHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
    }
    return _tableView;
}

@end
