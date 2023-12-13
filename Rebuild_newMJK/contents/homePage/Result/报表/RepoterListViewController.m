//
//  RepoterListViewController.m
//  mcr_s
//
//  Created by bipyun on 16/12/8.
//  Copyright © 2016年 match. All rights reserved.
//

#import "RepoterListViewController.h"
//#import "HttpPost.h"
#import "MBProgressHUD.h"
#import "KVNProgress.h"
//#import "MyUtil.h"
//#import "JSONKit.h"
#import "reporterlistTableViewCell.h"
#import "DetailWebviewViewController.h"
@interface RepoterListViewController ()<MBProgressHUDDelegate>
{
 
    MBProgressHUD *mbprogress;
    NSMutableArray *dateArray;
    NSMutableArray *detailArray;
    NSMutableArray *PicArray;

}
@end

@implementation RepoterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
	 NSDictionary*dict0=@{@"title":@"流量报表",@"image":@"线索报表",@"description":@"查看流量的相关数据"};
	 NSDictionary*dict1=@{@"title":@"到店报表",@"image":@"预约报表",@"description":@"查看到店的相关数据"};
	 NSDictionary*dict2=@{@"title":@"客户报表",@"image":@"客户报表",@"description":@"查看客户的相关数据"};
	 NSDictionary*dict3=@{@"title":@"交易报表",@"image":@"订单报表",@"description":@"查看交易的相关数据"};
	 NSDictionary*dict4=@{@"title":@"市场报表",@"image":@"跟进报表",@"description":@"查看市场的相关数据"};
	 NSDictionary*dict5=@{@"title":@"绩效报表",@"image":@"每日展厅快报",@"description":@"查看绩效的相关数据"};
	 */
    self.title=@"集团报表";
    dateArray=[[NSMutableArray alloc]initWithObjects:@"流量报表",@"到店报表",@"客户报表",@"交易报表",@"市场报表",@"绩效榜单", nil];
    detailArray=[[NSMutableArray alloc]initWithObjects:@"查看潜客的相关数据",@"查看潜客跟进的相关数据",@"查看每月所有分配线索的数据",@"查看订单的相关数据",@"查看预约的相关数据",@"查看来电流量的相关数据",@"查看本店当日当月流量来源分析", nil];
    PicArray=[[NSMutableArray alloc]initWithObjects:@"线索报表.png",@"预约报表.png",@"客户报表.png",@"订单报表.png",@"跟进报表.png",@"每日展厅快报.png", nil];

    
    self.automaticallyAdjustsScrollViewInsets=NO;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

        
        return 1;
        

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dateArray.count;
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
        view.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(16, 0, 100, 20)];
        label.textColor=[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
        
        
        label.text=[NSString stringWithFormat:@"统计报表"];
        label.font=[UIFont systemFontOfSize:13.0];
        [view addSubview:label];
        
        UIView *bgViewLine=[[UIView alloc]initWithFrame:CGRectMake(0, 19, KScreenWidth, 0.5)];
        bgViewLine.backgroundColor=[UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
        
        [view addSubview:bgViewLine];
        
        UIView *bgViewLine1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.5)];
        bgViewLine1.backgroundColor=[UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
        
        [view addSubview:bgViewLine1];
        
        return view;
 
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        reporterlistTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"reporterlistTableViewCell" owner:self options:nil] lastObject];
        }
    cell.NameLabel.text=dateArray[indexPath.row];
    cell.DeatilLabel.text=detailArray[indexPath.row];
    NSString *str12=PicArray[indexPath.row];
    cell.HeadImaageView.image=[UIImage imageNamed:str12];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row==0) {
        DetailWebviewViewController *myView=[[DetailWebviewViewController alloc] initWithNibName:@"DetailWebviewViewController" bundle:nil];
        myView.PassType=@"1";
        myView.title=@"流量报表";
        myView.type=self.type;
        [self.navigationController pushViewController:myView animated:YES];
    }else if (indexPath.row==1){
        DetailWebviewViewController *myView=[[DetailWebviewViewController alloc] initWithNibName:@"DetailWebviewViewController" bundle:nil];
        myView.PassType=@"4";
        myView.title=@"到店报表";
        [self.navigationController pushViewController:myView animated:YES];
    }else if (indexPath.row==2){
        DetailWebviewViewController *myView=[[DetailWebviewViewController alloc] initWithNibName:@"DetailWebviewViewController" bundle:nil];
        myView.PassType=@"0";
        myView.title=@"客户报表";
        [self.navigationController pushViewController:myView animated:YES];
		
    }else if (indexPath.row==3){
        DetailWebviewViewController *myView=[[DetailWebviewViewController alloc] initWithNibName:@"DetailWebviewViewController" bundle:nil];

        myView.PassType=@"2";
        myView.title=@"交易报表";
        [self.navigationController pushViewController:myView animated:YES];
		
    }else if (indexPath.row==4){
		
        DetailWebviewViewController *myView=[[DetailWebviewViewController alloc] initWithNibName:@"DetailWebviewViewController" bundle:nil];
        myView.PassType=@"3";
        myView.title=@"市场报表";
        [self.navigationController pushViewController:myView animated:YES];
    }else if (indexPath.row==5){
		
        DetailWebviewViewController *myView=[[DetailWebviewViewController alloc] initWithNibName:@"DetailWebviewViewController" bundle:nil];
        myView.PassType=@"5";
        myView.title=@"绩效榜单";
        [self.navigationController pushViewController:myView animated:YES];
    }
//



    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 60.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 20.0;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.1;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
