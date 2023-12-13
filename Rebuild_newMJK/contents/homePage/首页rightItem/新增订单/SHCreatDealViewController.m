//
//  SHCreatDealViewController.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/12.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHCreatDealViewController.h"
#import "CreatDealSection1TableViewCell.h"

@interface SHCreatDealViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)NSArray*localDatas;
@end

@implementation SHCreatDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=@"新增订单";
    [self.view addSubview:self.tableView];
    
    
    
}

#pragma mark  --UI
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.localDatas.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [self.localDatas[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.section==1&&indexPath.row==0) {
        CreatDealSection1TableViewCell*cell=[[CreatDealSection1TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        
        
        return cell;
    }
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text=self.localDatas[indexPath.section][indexPath.row];
    cell.detailTextLabel.text=@"12";
    
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    BGView.backgroundColor=DBColor(247, 247, 247);
    UILabel*textLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 2.5, KScreenWidth/2, 15)];
    textLabel.textColor=[UIColor grayColor];
    textLabel.font=[UIFont systemFontOfSize:12];
    [BGView addSubview:textLabel];
    
    if (section==0) {
        textLabel.text=@"车主信息";
    }else if (section==1){
        textLabel.text=@"订单详情";
    }else{
        return nil;
    }
    
    
    
    return BGView;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
        BGView.backgroundColor=[UIColor whiteColor];
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(20, 8, KScreenWidth-40, 48)];
        button.backgroundColor=KNaviColor;
        [button setTitle:@"绑定微信"];
        button.titleLabel.font=[UIFont systemFontOfSize:17];
        button.titleColor=[UIColor whiteColor];
        [button addTarget:self action:@selector(clickBlindWechat)];
        [BGView addSubview:button];
        
        return BGView;
        
    }else if (section==1){
        UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 90)];
        BGView.backgroundColor=[UIColor whiteColor];
        
        UIButton*leftButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 20, KScreenWidth/2-20-20, 50)];
        [leftButton setTitle:@"确定"];
        leftButton.backgroundColor=DBColor(233, 234, 239);
//        leftButton.titleLabel.textColor=[UIColor blackColor];
        [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(clickSure)];
        [BGView addSubview:leftButton];
        
        
        UIButton*RightButton=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/2+20, 20, KScreenWidth/2-20-20, 50)];
        [RightButton setTitle:@"结账"];
        RightButton.backgroundColor=DBColor(233, 234, 239);
        [RightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [RightButton addTarget:self action:@selector(clickAccount)];
        [BGView addSubview:RightButton];

        return BGView;
    }else{
        return nil;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 64;
    }else if (section==1){
        return 90;
    }else{
        return 0.001;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1&&indexPath.row==0) {
        return [CreatDealSection1TableViewCell calculatorHeightWithArray:@[@""]];
    }
    return 44;
}

#pragma mark  --touch
-(void)clickBlindWechat{
    
    
    
}

-(void)clickSure{
    
    
}

-(void)clickAccount{
    
    
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
-(NSArray *)localDatas{
    if (!_localDatas) {
        NSArray*array=@[@"客户姓名",@"联系电话",@"车辆号牌"];
        NSArray*array1=@[@"服务内容",@"预计金额",@"预计完成时间",@"服务顾问",@"选择技师",@"订单类型"];
        
        _localDatas=@[array,array1];
    }
    return _localDatas;
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}


@end
