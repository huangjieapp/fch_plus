//
//  CGCOperationalLog.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/31.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCOperationalLog.h"
#import "CGCLogModel.h"
#import "CGCLogCell.h"
#import "HistoryDetailView.h"

@interface CGCOperationalLog ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) CGCLogModel * logModel;
@end

@implementation CGCOperationalLog

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=DBColor(255, 255, 255);
    self.title=@"预约操作记录";
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    [self.view addSubview:self.tableView];
    [self HTTPGetLogList];
    // Do any additional setup after loading the view.
}


//- (void)createPoint{
//    UIImageView* img=[[UIImageView alloc] initWithFrame:CGRectMake(106, 70, 8, 8)];
////    img.backgroundColor=[UIColor redColor];
//    img.image=[UIImage imageNamed:@"topimg"];
//    [self.view addSubview:img];
//}

#pragma mark -- tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{

    return  self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGCLogCell * cell=[CGCLogCell cellWithTableView:tableView];
    CGCLogModel * model=self.dataArray[indexPath.row];
    cell.statusRightLayout.constant = 20;
    [cell reloadCellWithModel:model];
	DBSelf(weakSelf);
	cell.detailButtonClickBlock = ^{
        NSString *str = model.X_REMARK;
        if (model.X_DETAILS.length > 0) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"\n%@",model.X_DETAILS]];
        }
		HistoryDetailView *detailView = [[HistoryDetailView alloc]initWithFrame:weakSelf.view.frame andTimeAndRemark:@[model.D_CREATE_TIME, str]];
		[[UIApplication sharedApplication].keyWindow addSubview:detailView];
	};
//    cell.topImage.hidden = YES;
    cell.iconImg.hidden=YES;
    if (indexPath.row == 0) {
        cell.topImage.hidden = NO;
    }
    if (self.dataArray.count-1==indexPath.row) {
        cell.iconImg.hidden=NO;
    }else{
        cell.iconImg.hidden=YES;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 80;
}

#pragma mark -- request网络请求

- (void)HTTPGetLogList{

    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    
    [dic setObject:self.C_ID forKey:@"C_OBJECTID"];
    
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a459/list", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
   
        if ([data[@"code"] integerValue]==200) {
            for (NSDictionary * div in data[@"data"][@"list"]) {
                CGCLogModel* model=[CGCLogModel yy_modelWithDictionary:div];
                [self.dataArray addObject:model];
            }
            
            if (self.dataArray.count>0) {
//                 [self createPoint];
            }else{
            
                UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth-100)/2, 200, 100, 40)];
                lab.text=@"暂无记录";
                lab.textAlignment=NSTextAlignmentCenter;
                lab.textColor=DBColor(0, 0, 0);
                [self.view addSubview:lab];
                
            
            }
            
        }else{
        
            [JRToast showWithText:data[@"msg"]];
        }
        
        
        [self.tableView reloadData];
        
    }];
    

}


#pragma mark -- set
- (UITableView *)tableView{
    
    if (_tableView==nil) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight-NavStatusHeight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedRowHeight=50;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        
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
