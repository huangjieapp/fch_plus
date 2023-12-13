//
//  RegardingMJKViewController.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/11.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "RegardingMJKViewController.h"

#import "MJKIntroduceViewController.h"

#import "MJKUpdateHistoryViewController.h"

@interface RegardingMJKViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView*tableView;

@end

@implementation RegardingMJKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"关于房车汇5.0";
    [self.view addSubview:self.tableView];
    
    
}

#pragma mark --UI
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	if (indexPath.row == 0) {
		cell.textLabel.text=@"房车汇5.0介绍";
	} else {
		cell.textLabel.text=@"更新历史";
	}
	
	
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.row == 0) {
		MJKIntroduceViewController*vc=[[MJKIntroduceViewController alloc]initWithNibName:@"MJKIntroduceViewController" bundle:nil];
		[self.navigationController pushViewController:vc animated:YES];
	} else {
		MJKUpdateHistoryViewController *vc = [[MJKUpdateHistoryViewController alloc]init];
		[self.navigationController pushViewController:vc animated:YES];
	}
    
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 170)];
    BGView.backgroundColor=[UIColor clearColor];
    
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, 65, 65)];
    imageView.image=[UIImage imageNamed:@"proiPhoneApp_60pt"];
    imageView.centerX=BGView.centerX;
    [BGView addSubview:imageView];
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, imageView.bottom+10, KScreenWidth-40, 20)];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    NSDictionary*infoDictionary=[[NSBundle mainBundle]infoDictionary];
    NSString*app_Version=[infoDictionary objectForKey:@"CFBundleShortVersionString"];
    titleLabel.text=[NSString stringWithFormat:@"房车汇5.0 v%@",app_Version];
    [BGView addSubview:titleLabel];
    
    
    
    return BGView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 170;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
    }
    return _tableView;
}


@end
