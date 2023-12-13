//
//  SHIntoShopViewController.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/12.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHIntoShopViewController.h"

@interface SHIntoShopViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)NSArray*localDatas;
@property(nonatomic,strong)NSMutableArray*rightDatas;
@end

@implementation SHIntoShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=@"进场识别";
    [self.view addSubview:self.tableView];
    
}
#pragma mark --UI
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.localDatas.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.localDatas[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle=NO;
    cell.textLabel.text=self.localDatas[indexPath.section][indexPath.row];
    cell.detailTextLabel.text=self.rightDatas[indexPath.section][indexPath.row];
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 210)];
        BGView.backgroundColor=DBColor(247, 247, 247);
        
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 190)];
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        imageView.backgroundColor=[UIColor redColor];
        [BGView addSubview:imageView];
        
        UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 190+2.5, KScreenWidth/2, 15)];
        titleLabel.textColor=[UIColor grayColor];
        titleLabel.font=[UIFont systemFontOfSize:14];
        titleLabel.text=@"车辆信息";
        [BGView addSubview:titleLabel];
        
        
        return BGView;

    }else{
        
        UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
        BGView.backgroundColor=DBColor(247, 247, 247);
        
        UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 2.5, KScreenWidth/2, 15)];
        titleLabel.textColor=[UIColor grayColor];
        titleLabel.font=[UIFont systemFontOfSize:14];
        titleLabel.text=@"历史信息";
        [BGView addSubview:titleLabel];
        return BGView;
        
    }
    
    return nil;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1) {
        UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 110)];
        BGView.backgroundColor=[UIColor whiteColor];
        
        UIButton*leftButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 40, KScreenWidth/2-40, 50)];
        leftButton.backgroundColor=[UIColor grayColor];
        [leftButton setTitle:@"建档" forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(clickCreatDeal)];

        [leftButton setTitleColor:[UIColor blackColor]];
        
        UIButton*rightButton=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/2+20, 40, KScreenWidth/2-40, 50)];
        rightButton.backgroundColor=KNaviColor;
        [rightButton setTitle:@"开单" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor whiteColor]];

        [rightButton addTarget:self action:@selector(clickOpenDeal)];
        [BGView addSubview:leftButton];
        [BGView addSubview:rightButton];
        return BGView;
    }
    
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 210;
    }else if (section==1){
        return 20;
    }
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        return 110;
    }else{
        return 0.001;
    }
    
}


#pragma mark  --
-(void)clickCreatDeal{
    
    
}

-(void)clickOpenDeal{
    MyLog(@"开单");
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
        NSArray*array=@[@"车辆号牌",@"到店时间",@"到店次数"];
        NSArray*array1=@[@"上次到店时间",@"上次接待销售"];
        
        _localDatas=@[array,array1];
    }
    return _localDatas;
}

-(NSMutableArray *)rightDatas{
    if (!_rightDatas) {
        _rightDatas=[NSMutableArray array];
        NSArray*array=@[@"沪KR9888",@"2017-04-30 15:36",@"6次"];
        NSArray*array1=@[@"2017-02-16 13:48",@"王大宝"];
        [_rightDatas addObject:array];
        [_rightDatas addObject:array1];
    }
    return _rightDatas;
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
