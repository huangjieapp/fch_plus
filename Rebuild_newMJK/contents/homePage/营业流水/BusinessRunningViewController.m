//
//  BusinessRunningViewController.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/24.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "BusinessRunningViewController.h"
#import "BusinessRunningHeaderCellView.h"
#import "BusinessRunningTableViewCell.h"

#import "BusinessRunningModel.h"
#import "BusinessSubRunningModel.h"



#import "BusinessDayViewController.h"
#import "addDealViewController.h"


#define HEADER    @"BusinessRunningHeaderCellView"
#define CELL0    @"BusinessRunningTableViewCell"

@interface BusinessRunningViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;   //
@property(nonatomic,assign)NSInteger currPage;
@property(nonatomic,assign)NSInteger pageSize;
@property(nonatomic,assign)NSInteger currentMonth;  //本月传0，上月传1，上上月传2以此类推



@property(nonatomic,strong)NSMutableArray*mainDatasArray;   //
@property(nonatomic,strong)BusinessRunningModel*mainDatasModel;

@end

@implementation BusinessRunningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentMonth=0;
   self.title=@"营业流水";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self.tableView registerNib:[UINib nibWithNibName:HEADER bundle:nil] forHeaderFooterViewReuseIdentifier:HEADER];
    
    [self setupRefresh];
    [self addNaviButton];
    
    [self addTopButtonView];
	if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
	}else{
		self.automaticallyAdjustsScrollViewInsets=NO;
	}
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.tableView.mj_header beginRefreshing];
}


#pragma mark  --UI
-(void)addTopButtonView{
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 50)];
    mainView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:mainView];
    
    UIButton*leftButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, (KScreenWidth-40)/2, 40)];
    [leftButton setTitleColor:[UIColor blackColor]];
    [leftButton  setBackgroundColor:KNaviColor];
    [leftButton setTitleNormal:@"上一月"] ;
    leftButton.titleLabel.font=[UIFont systemFontOfSize:15];
    leftButton.layer.cornerRadius=10;
    leftButton.layer.masksToBounds=YES;
    [leftButton addTarget:self action:@selector(clickFontMonth)];
    [mainView addSubview:leftButton];
    
    
    UIButton*rightButton=[[UIButton alloc]initWithFrame:CGRectMake(10+KScreenWidth/2, 5, (KScreenWidth-40)/2, 40)];
    [rightButton setTitleColor:[UIColor blackColor]];
    [rightButton  setBackgroundColor:KNaviColor];
    [rightButton setTitleNormal:@"下一月"] ;
    rightButton.layer.cornerRadius=10;
    rightButton.layer.masksToBounds=YES;
    rightButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [rightButton addTarget:self action:@selector(clickNextMonth)];
    [mainView addSubview:rightButton];

    
    
    
}


-(void)addNaviButton{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(0, 0, 60, 40);
	[button setTitleNormal:@"收款/退款"];
	button.titleLabel.font = [UIFont systemFontOfSize:14.f];
	[button addTarget:self action:@selector(clickRightBarButton)];
	[button setTitleColor:[UIColor blackColor]];
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem=item;
    
}


-(void)setupRefresh{
    self.pageSize=100;
    self.currPage=1;
    
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currPage=1;
        [self httpPostGetshowInfo];
        
    }];
    
//    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        self.currPage++;
//        [self httpPostGetshowInfo];
//        
//    }];
    
    
   
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainDatasArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BusinessRunningTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
//    cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageWithColor:DBColor(241, 245, 248) size:CGSizeMake(1, 1)]];
    cell.contentView.backgroundColor=tableView.backgroundColor;
    
    BusinessSubRunningModel*model=self.mainDatasArray[indexPath.row];

    cell.titleLab.text=model.D_CREATE_TIME;
    cell.numberLab.text=model.COUNT;
    cell.moneyLab.text=model.AMOUNT;
    
    if ([model.C_STATUS isEqualToString:@"0"]) {
        cell.numberLab.textColor=[UIColor blackColor];
        cell.moneyLab.textColor=[UIColor blackColor];
        
    }else{
        cell.numberLab.textColor=[UIColor redColor];
        cell.moneyLab.textColor=[UIColor redColor];
        
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     BusinessSubRunningModel*model=self.mainDatasArray[indexPath.row];
    
    BusinessDayViewController*vc=[[BusinessDayViewController alloc]init];
    vc.C_A46300_C_ID=model.C_ID;
    vc.D_CREATE_TIME=model.D_CREATE_TIME;
    [self.navigationController pushViewController:vc animated:YES];
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BusinessRunningHeaderCellView*BGView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:HEADER];
    BGView.backgroundColor=[UIColor whiteColor];
    BGView.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)]];
      NSString*dateStr=[NSString stringWithFormat:@"%@营业流水",self.mainDatasModel.MONTHNAME];
    
    BGView.titleLab.text=dateStr;
    BGView.moneyLab.text=[NSString stringWithFormat:@"%@元",self.mainDatasModel.ALL_AMOUNT];
    BGView.numberLab.text=[NSString stringWithFormat:@"%@笔",self.mainDatasModel.ALL_COUNT];
    return BGView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 150;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark  --click
-(void)clickRightBarButton{
    addDealViewController*vc=[[addDealViewController alloc]init];
	vc.vcName = @"收款/退款";
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)clickFontMonth{
    self.currentMonth++;
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)clickNextMonth{
    if (self.currentMonth>0) {
        self.currentMonth--;
        [self.tableView.mj_header beginRefreshing];
    }else{
        [JRToast showWithText:@"已是最近的月份了。。"];
    }
    
}


#pragma mark  --datas
-(void)httpPostGetshowInfo{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_BussinessRunning];
//    @"D_CREATE_TIME":[DBTools getTimeFomatFromCurrentTimeStamp]
    NSDictionary*contentDict=@{@"currPage":@(self.currPage),@"pageSize":@(self.pageSize),@"DATETYPE":@(self.currentMonth)};
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if (self.currPage==1) {
                [self.mainDatasArray removeAllObjects];
            }
            
            
            self.mainDatasModel=[BusinessRunningModel yy_modelWithDictionary:data];
            NSArray*allDatasArray=data[@"content"];
            for (NSDictionary*dict in allDatasArray) {
                BusinessSubRunningModel*subModel=[BusinessSubRunningModel yy_modelWithDictionary:dict];
                [self.mainDatasArray addObject:subModel];
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



#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + 50, KScreenWidth, KScreenHeight-NavStatusHeight  - WD_TabBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
    }
    return _tableView;
}

-(NSMutableArray *)mainDatasArray{
    if (!_mainDatasArray) {
        _mainDatasArray=[NSMutableArray array];
    }
    return _mainDatasArray;
}


@end
