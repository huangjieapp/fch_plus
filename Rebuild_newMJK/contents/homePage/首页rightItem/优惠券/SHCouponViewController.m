//
//  SHCouponViewController.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/10.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHCouponViewController.h"
#import "CouponTableViewCell.h"
#import "CouponModel.h"



#define CELL0   @"CouponTableViewCell"

@interface SHCouponViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSMutableArray*mainModelDatas;

@end

@implementation SHCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    
    [self creatRightItem];
    [self addBottomButton];
    [self falseDatas];
    
}
#pragma mark  -- UI
-(void)creatRightItem{
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 25)];
    [button setTitle:@"使用说明"];
    [button addTarget:self action:@selector(UseDetail)];
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem=item;
    
    
}

-(void)addBottomButton{
    UIButton*bottomButton=[[UIButton alloc]initWithFrame:CGRectMake(0, KScreenHeight-44, KScreenWidth, 44)];
    bottomButton.backgroundColor=KNaviColor;
    [bottomButton setTitle:@"确定"];
    [bottomButton addTarget:self action:@selector(clickSureCommit)];
    [self.view addSubview:bottomButton];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainModelDatas.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    CouponModel*model=self.mainModelDatas[indexPath.row];
    
    if (model.isSelected) {
        cell.isSelectedButton.selected=YES;
    }else{
        cell.isSelectedButton.selected=NO;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (CouponModel*model in self.mainModelDatas) {
        model.isSelected=NO;
    }
    
    CouponModel*model=self.mainModelDatas[indexPath.row];
    model.isSelected=YES;
    [self.tableView reloadData];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}


#pragma mark  --touch
-(void)UseDetail{
    MyLog(@"使用说明");
    
}

-(void)clickSureCommit{
    
     MyLog(@"确定");
    //跳转至公众号关注中的客户列表
    
    
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
-(void)falseDatas{
    for (int i=0; i<10; i++) {
         CouponModel*model=[[CouponModel alloc]init];
        [self.mainModelDatas addObject:model];
    }
   
    
}



-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64-44) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


-(NSMutableArray *)mainModelDatas{
    if (!_mainModelDatas) {
        _mainModelDatas=[NSMutableArray array];
    }
    return _mainModelDatas;
}


@end
