//
//  SHOrderViewController.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/17.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHOrderViewController.h"
#import "JSDropDownMenu.h"
#import "broadsideView.h"
#import "IntoShopHeaderView.h"   //head
#import "OrderViewTableViewCell.h"


#import "PYSearchViewController.h"


#define CELL0    @"OrderViewTableViewCell"
#define CELLHeader   @"IntoShopHeaderView"

@interface SHOrderViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate,UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_data0;
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    
    NSInteger _currentData0Index;
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    
    NSInteger _currentData0SelectedIndex;
    JSDropDownMenu *menu;
    broadsideView*mainCoverView;  //侧边栏的view
    
    
    
}


@property(nonatomic,strong)UITableView*tableView;

@end

@implementation SHOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self falseDatas];
    [self setUpNaviView];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self.tableView registerNib:[UINib nibWithNibName:CELLHeader bundle:nil] forHeaderFooterViewReuseIdentifier:CELLHeader];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self addDropDownMenu];

}

#pragma mark  --UI
-(void)setUpNaviView{
    UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-20-40, 30)];
    BGView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.8];
    BGView.layer.cornerRadius=15;
    BGView.layer.masksToBounds=YES;
    self.navigationItem.titleView=BGView;
    
    UIButton*placeholderButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 5, KScreenWidth-20-40-20-60, 20)];
    [placeholderButton setTitle:@"请输入车牌号或顾客手机号" forState:UIControlStateNormal];
    placeholderButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [placeholderButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [placeholderButton addTarget:self action:@selector(clickSearch)];
    [BGView addSubview:placeholderButton];
    
    UIButton*imageButton=[[UIButton alloc]initWithFrame:CGRectMake(BGView.width-15-15, 7.5, 15, 15)];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"放大镜"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(clickVedio)];
    [BGView addSubview:imageButton];
    
    
   UIBarButtonItem*item= [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"订单"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
    self.navigationItem.rightBarButtonItem=item;
    
}


#pragma mark  --tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    IntoShopHeaderView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:CELLHeader];
    if (section==0) {
        view.rightView.hidden=NO;
    }else{
        view.rightView.hidden=YES;
    }
    
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}


#pragma mark --click

-(void)clickRightItem{
    MyLog(@"11");
    
}

-(void)clickSearch{
    PYSearchViewController*searchVC=[PYSearchViewController searchViewControllerWithHotSearches:@[@"tim",@"sam",@"jam",@"tom"] searchBarPlaceholder:@"请输入搜索关键字" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
    }];
    [self.navigationController pushViewController:searchVC animated:YES];
    
    
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



#pragma mark  -- set
-(void)falseDatas{
    NSArray*array0=@[@"A4L",@"A6L",@"Q3",@"Q5",@"Q7"];
    NSArray*array1=@[@"3 series",@"5 series",@"730Li",@"X5",@"m3"];
    NSArray*array2=@[@"S500",@"E200L",@"Marbath S600",@"AMG C63"];
    
    
    _data0=[NSMutableArray arrayWithObjects:@{@"title":@"类型",@"data":@[@"类型"]},@{@"title":@"Audi",@"data":array0},@{@"title":@"BMW",@"data":array1},@{@"title":@"Benz",@"data":array2}, nil];
    _data1=[NSMutableArray arrayWithObjects:@"销售",@"王大宝",@"马大强",@"马冬冬",@"车城", nil];
    _data2=[NSMutableArray arrayWithObjects:@"状态",@"A级",@"B级",@"c级",@"d级", nil];
    
    _data3=[NSMutableArray arrayWithObjects:@"时间",@"今天",@"最近7天",@"本周",@"本月",@"自定义", nil];
    
    _currentData0Index=0;
    _currentData1Index=0;
    _currentData2Index=0;
    _currentData3Index=0;
    
    _currentData0SelectedIndex=0;
    
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+45, KScreenWidth, KScreenHeight-109) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}


#pragma mark  --function
-(void)clickOtherButton:(UIButton*)sender{
    //这里需要给他赋值
    mainCoverView.hidden=NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hiddenDropDownMenu" object:nil];
    
    
}


-(void)addDropDownMenu{
    menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:45];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    
    menu.dataSource = self;
    menu.delegate = self;
    
    [self.view addSubview:menu];
    
    UIButton*otherButton=[[UIButton alloc]initWithFrame:CGRectMake(menu.width-45, 0, 45, 45)];
    [otherButton setImage:[UIImage imageNamed:@"漏斗"] forState:UIControlStateNormal];
    [otherButton addTarget:self action:@selector(clickOtherButton:)];
    [menu addSubview:otherButton];
    
    mainCoverView=[[broadsideView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    
    
}

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 4;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    if (column==0) {
        return YES;
    }
    return NO;
}
-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    if (column==0) {
        return 0.3;
    }
    
    return 1;
}
-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        
        return _currentData0Index;
        
    }
    if (column==1) {
        
        return _currentData1Index;
    }
    if (column==2) {
        return _currentData2Index;
    }
    if (column==3) {
        return _currentData3Index;
    }
    
    return 0;
}


- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        if (leftOrRight==0) {
            
            return _data0.count;
        } else{
            
            NSDictionary *menuDic = [_data0 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] count];
        }
    } else if (column==1){
        
        return _data1.count;
        
    }else if (column==2){
        return _data2.count;
    }else if (column==3){
        return _data3.count;
    }
    
    return 0;
}


- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0: return [[_data0[_currentData0Index] objectForKey:@"data"] objectAtIndex:_currentData0SelectedIndex];
            break;
        case 1: return _data1[_currentData1Index];
            break;
        case 2: return _data2[_currentData2Index];
            break;
        case 3: return _data3[_currentData3Index];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        if (indexPath.leftOrRight==0) {
            NSDictionary *menuDic = [_data0 objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
        } else{
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_data0 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
        }
    } else if (indexPath.column==1) {
        
        return _data1[indexPath.row];
        
    }
    else if (indexPath.column==2) {
        
        return _data2[indexPath.row];
        
    }else if (indexPath.column==3) {
        
        return _data3[indexPath.row];
        
    }
    return @"";
    
}


- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        if(indexPath.leftOrRight==0){
            
            _currentData0Index = indexPath.row;
            
            
        }else if (indexPath.leftOrRight==1){
            _currentData0SelectedIndex=indexPath.row;
        }
        
    } else if(indexPath.column == 1){
        
        _currentData1Index = indexPath.row;
        
    }else if (indexPath.column==2){
        _currentData2Index=indexPath.row;
    }else if (indexPath.column==3){
        _currentData3Index=indexPath.row;
    }
}


@end
