//
//  SHHomePageFirstTableViewCell.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/3.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHHomePageFirstTableViewCell.h"
#import "FirstCellSubTableViewCell.h"


#import "PYSearchViewController.h"

#import "SHIntoShopCarViewController.h"
#import "SHDealDetailHomeViewController.h"
#import "SHOrderViewController.h"
#import "SHNeedContactCustomViewController.h"
#import "SHShopingMallViewController.h"


#define CELL0   @"FirstCellSubTableViewCell"
@interface SHHomePageFirstTableViewCell()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView*tableView;


@property(nonatomic,strong)NSArray*localDatass;
@end

@implementation SHHomePageFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.tableView];
        [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];

        
    }
    
    return self;
}




#pragma mark  --UI
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.localDatass.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FirstCellSubTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=NO;
    cell.titleLabel.text=self.localDatass[indexPath.row][@"title"];
    cell.subLabel.text=self.localDatass[indexPath.row][@"datail"];
    
    cell.leftImageView.image=[UIImage imageNamed:@"销售战板-订单"];
   
    if (indexPath.row==3) {
        cell.rightImageView.hidden=NO;
    }else{
//         cell.rightImageView.hidden=YES;
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     UIViewController*mainVC=[DBTools getSuperViewWithsubView:self];
    switch (indexPath.row) {
        case 0:{
            SHIntoShopCarViewController*vc=[[SHIntoShopCarViewController alloc]init];
           
            [mainVC.navigationController pushViewController:vc animated:YES];
            
        break;}
        case 1:{
            SHDealDetailHomeViewController*vc=[[SHDealDetailHomeViewController alloc]init];
            [mainVC.navigationController pushViewController:vc animated:YES];
            
            
            break;}

        case 2:{
            SHOrderViewController*vc=[[SHOrderViewController alloc]init];
            [mainVC.navigationController pushViewController:vc animated:YES];
            
            break;}

        case 3:{
            SHNeedContactCustomViewController*vc=[SHNeedContactCustomViewController needContactCustomWithType:needContactCustomTypeTimeOver];
            [mainVC.navigationController pushViewController:vc animated:YES];
            
            break;}

        case 4:{
            SHNeedContactCustomViewController*vc=[SHNeedContactCustomViewController needContactCustomWithType:needContactCustomTypeContact];
            [mainVC.navigationController pushViewController:vc animated:YES];

            
            break;}

        case 5:{
            SHShopingMallViewController*vc=[[SHShopingMallViewController alloc]init];
            [mainVC.navigationController pushViewController:vc animated:YES];
            
            break;}

       
    
        default:
            break;
    }
    
    
    
}



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 80)];
    bgView.backgroundColor=[UIColor whiteColor];
    
    UIView*ricleView=[[UIView alloc]initWithFrame:CGRectMake(18, 10, KScreenWidth-36, 30)];
    ricleView.layer.cornerRadius=12;
    ricleView.layer.borderWidth=1;
    ricleView.layer.borderColor=[UIColor grayColor].CGColor;
    [bgView addSubview:ricleView];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSearch)];
    [ricleView addGestureRecognizer:tap];
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(18, 6, KScreenWidth-36-18-38, 18)];
    titleLabel.text=@"请输入车牌号或顾客手机号";
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textColor=[UIColor grayColor];
    [ricleView addSubview:titleLabel];
    
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(ricleView.width-30, 6, 18, 18)];
    [button setBackgroundImage:[UIImage imageNamed:@"录音"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickRecord)];
    [ricleView addSubview:button];
    [bgView addSubview:ricleView];
    
    
    //下面的图片和销售战报
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, ricleView.bottom+8, 28, 28)];
    imageView.image=[UIImage imageNamed:@"placeholder"];
   
    [bgView addSubview:imageView];
    
    UILabel*boardLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 0, KScreenWidth-80, 18)];
    boardLabel.centerY=imageView.centerY;
    boardLabel.text=@"中美仕家 的销售战板";
    boardLabel.textColor=[UIColor grayColor];
    boardLabel.font=[UIFont systemFontOfSize:14];
    [bgView addSubview:boardLabel];
    
    
    
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}



#pragma mark  --touch
-(void)clickSearch{
    MyLog(@"xx");
    UIViewController*vc=[DBTools getSuperViewWithsubView:self];
    
    PYSearchViewController*searchVC=[PYSearchViewController searchViewControllerWithHotSearches:@[@"tim",@"sam",@"jam",@"tom"] searchBarPlaceholder:@"请输入搜索关键字" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
    }];
    [vc.navigationController pushViewController:searchVC animated:YES];
    
    
    
}
-(void)clickRecord{
    MyLog(@"录音");
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark  --set

-(NSArray *)localDatass{
    if (!_localDatass) {
        NSDictionary*dict0=@{@"title":@"今日进场台数",@"datail":@"00"};
        NSDictionary*dict1=@{@"title":@"今日交易笔数",@"datail":@"11"};
        NSDictionary*dict2=@{@"title":@"今日预约订单数",@"datail":@"22"};
        NSDictionary*dict3=@{@"title":@"今日到期提醒客户",@"datail":@"33"};
        NSDictionary*dict4=@{@"title":@"今日待回访客户 ",@"datail":@"44"};
        NSDictionary*dict5=@{@"title":@"今日新增商城订单  ",@"datail":@"55"};
        
        _localDatass=@[dict0,dict1,dict2,dict3,dict4,dict5];
    }
    return _localDatass;
    
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, [SHHomePageFirstTableViewCell getCellHeight]) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    
    return _tableView;
}


+(CGFloat)getCellHeight{
    
    return 320;
}

@end
