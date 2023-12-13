//
//  CGCSelectCustomVC.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/28.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCSelectCustomVC.h"
#import "CGCSellModel.h"
#import "CGCSelCustomCell.h"

@interface CGCSelectCustomVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CGCSelectCustomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self HTTPGetSellList];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count>0?self.dataArray.count:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
  
    return self.dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGCSellModel *model=self.dataArray[indexPath.row];
    CGCSelCustomCell * cell=[CGCSelCustomCell cellWithTableView:tableView];
    [cell reloadCellWithModel:model];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
}


#pragma mark -- request网络请求


- (void)HTTPGetSellList{
    
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list",HTTP_IP] parameters:@{@"C_LOCCODE" : [NewUserSession instance].user.C_LOCCODE} compliation:^(id data, NSError *error) {
        [self.view addSubview:self.tableView];
        if ([data[@"code"] integerValue]==200) {
            NSDictionary*dict=[data copy];
            for (NSDictionary * div in dict[@"data"]) {
                CGCSellModel * model=[CGCSellModel yy_modelWithDictionary:div];
                [self.dataArray addObject:model];
            }
            
            [self.tableView reloadData];
            
        }else{
            
            [JRToast showWithText:data[@"msg"]];
        }
        
        
    }];
    
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
  
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    view.backgroundColor=CGCTABBGColor;
    
    
    
    return view;
}




#pragma mark -- set
- (UITableView *)tableView{
    
    if (_tableView==nil) {
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 30, KScreenWidth, KScreenHeight-30) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedRowHeight=50;
      
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray{
    
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
    
}


@end
