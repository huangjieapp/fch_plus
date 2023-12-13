//
//  CGCSelCustomerVC.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/6/1.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "CGCSelCustomerVC.h"

#import "SelCustomerCell.h"
#import "CGCSelCustomerModel.h"

#import "CGCIntegrateHView.h"
#import "CGCIntegarlListModel.h"
#import "SingleIntegarModel.h"

#import "CGCAlertDateView.h"



@interface CGCSelCustomerVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *IDArray;

@property (nonatomic, strong) NSMutableArray *JFArray;

@property (nonatomic, strong) CGCIntegrateHView *headView;

@property (nonatomic, strong) CGCIntegarlListModel *integarModel;

@property (assign) NSInteger currPage;

@property (nonatomic,strong) CGCAlertDateView * alertDateView;

@property (nonatomic, strong) UILabel *integarLab;



@end

@implementation CGCSelCustomerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"积分结算";
   
    self.currPage=1;
    [self httpRequestList];
    [self.view addSubview:self.tableView];
    [self createBottom];
    
    self.tableView.mj_header=[MJRefreshHeader headerWithRefreshingBlock:^{
        
        self.currPage=1;
        [self httpRequestList];
    }];
    
//    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//
//        self.currPage++;
//        [self httpRequestList];
//
//    }];
    
    // Do any additional setup after loading the view.
}

- (void)createBottom{
    
    UIView * bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, HIGHT-44, WIDE, 44)];
    bottomView.backgroundColor=[UIColor whiteColor];
    

    
    
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDE/2, 44)];
    lab.textColor=[UIColor blackColor];
    lab.text=@"合计积分：0";
    [bottomView addSubview:lab];
    self.integarLab=lab;
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(WIDE-100, 0, 100, 44);
    btn.backgroundColor=KNaviColor;
    [btn setTitleNormal:@"提交"];
    [btn addTarget:self action:@selector(httpRequestSubmit)];
    [btn setTitleColor:[UIColor blackColor]];
    [bottomView addSubview:btn];
    [self.view addSubview:bottomView];
    
}
- (void)httpRequestSubmit{
 
    
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_operationClueToIntegarl];
    
    NSMutableDictionary *dic=[NSMutableDictionary new];

    NSMutableArray * cidArr=[NSMutableArray array];
   
    for (int i=0; i<self.JFArray.count; i++) {
        [cidArr addObject:[NSString stringWithFormat:@"%@#%@",self.IDArray[i],self.JFArray[i]]];
    }
    [dic setObject:[cidArr componentsJoinedByString:@","] forKey:@"C_ID"];
    
    [dic setObject:self.C_A41200_C_ID forKey:@"C_A42000_C_ID"];
    
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
         
            [self.navigationController popViewControllerAnimated:NO];
            self.selBlock();
            
        }else{
            
          
            [JRToast showWithText:data[@"message"]];
        }
        
    
        
    }];
}




- (void)httpRequestList{
    
    if (self.C_A41200_C_ID.length==0) {
        [JRToast showWithText:@"订单不存在！"];
        return;
    }
    
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_getClueToIntegarlByA420];
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:@"10" forKey:@"pageSize"];
    [dic setObject:@(self.currPage) forKey:@"currPage"];
    [dic setObject:self.C_A41200_C_ID forKey:@"C_A42000_C_ID"];
    
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            NSDictionary*dict=[data copy];
            if (self.currPage==1) {
                [self.dataArray removeAllObjects];
            }
            self.integarModel =[CGCIntegarlListModel yy_modelWithDictionary:dict];
            for (SingleIntegarModel * model in self.integarModel.content) {
                double jf=[model.C_INTEGRAL doubleValue]*[self.B_GUIDEPRICE doubleValue]/100.0;
                [self.dataArray addObject:model];
                [self.IDArray addObject:model.C_ID];
                [self.JFArray addObject:[NSString stringWithFormat:@"%.f",jf]];
                
            }
            
            NSLog(@"-=----%@",self.JFArray);
            
            
        }else{
            
//            self.currPage>1?self.currPage--:0;
            
            [JRToast showWithText:data[@"message"]];
        }
        
        
        //        self.currPage>1?self.currPage--:0;
        
        
        [self.tableView reloadData];
        [self reloadHeadView];
        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
        
    }];
    
    
    
    
    
}

- (void)reloadHeadView{
//    [self.headView.headImg sd_setImageWithURL:[NSURL URLWithString:self.headImg]];
    
    [self.headView.headImg sd_setImageWithURL:[NSURL URLWithString:self.headImg] placeholderImage:[UIImage imageNamed:@"icon_default_head"]];
    self.headView.nameLab.text=self.integarModel.C_A41500_C_NAME;
    self.headView.des1.text=self.integarModel.D_CREATE_TIME;
    self.headView.des2.text=self.integarModel.D_SEND_TIME;
    self.headView.des3.text=self.integarModel.B_MONTHLYSUPPLY;
    double total=0;
    for (NSString *value in self.JFArray) {
        total+=[value doubleValue];
    }
    self.integarLab.text=[NSString stringWithFormat:@"合计积分：%.f",total];
    
}


- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake( 0, 0, WIDE, HIGHT-SafeAreaBottomHeight-44) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        //        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView=self.headView;
        
        
    }
    
    return _tableView;
}
- (void)setupTableView
{
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 49+44+SafeAreaBottomHeight, 0);
    //    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    SelCustomerCell * cell=[SelCustomerCell cellWithTableView:tableView];
    SingleIntegarModel * model=self.dataArray[indexPath.section];
    cell.delBtn.tag=cell.selBtn.tag=indexPath.section;
    [cell.selBtn addTarget:self action:@selector(reviseIntegar:)];
    [cell.delBtn addTarget:self action:@selector(delIntegar:)];
    [cell reloadCellWithModel:model];
    cell.jfLab.text=self.JFArray[indexPath.section];
    
   
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.dataArray.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.integarModel.content.count;
        return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * view=[[UIView alloc] init];
    view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    return view;
}




- (void)reviseIntegar:(UIButton *)btn{
    DBSelf(weakSelf);
  __block  SingleIntegarModel * model=self.integarModel.content[btn.tag];
 
    NSIndexPath *index=[NSIndexPath indexPathForRow:btn.tag inSection:0];
     SelCustomerCell * cell=[self.tableView cellForRowAtIndexPath:index];
    
    
    self.alertDateView=[[CGCAlertDateView alloc] initWithFrame:self.view.bounds  withSelClick:^{
        
    } withSureClick:^(NSString *title, NSString *dateStr) {
//        NSLog(@"%@",title);
        if (title.length>0&&title.intValue>0) {
            cell.jfLab.text=title;
            if (btn.tag<weakSelf.JFArray.count) {
               [weakSelf.JFArray replaceObjectAtIndex:btn.tag withObject:title];
                
                double total=0;
                for (NSString *str in self.JFArray) {
                    total+=[str doubleValue];
                }
                self.integarLab.text=[NSString stringWithFormat:@"合计积分：%.f",total];
            }
           
        }
      
    } withHight:135.0 withText:self.JFArray[btn.tag] withDatas:nil];
    
   
    [self.view addSubview:self.alertDateView];
    
    
}
- (void)delIntegar:(UIButton *)btn{
    if (self.dataArray.count>btn.tag) {
        [self.dataArray removeObjectAtIndex:btn.tag];
        [self.JFArray removeObjectAtIndex:btn.tag];
        [self.IDArray removeObjectAtIndex:btn.tag];
        [self.tableView reloadData];
        double total=0;
        for (NSString *str in self.JFArray) {
            total+=[str doubleValue];
        }
        self.integarLab.text=[NSString stringWithFormat:@"合计积分：%.f",total];
    }
    
}


- (CGCIntegrateHView *)headView{
    
    if(_headView==nil){
        _headView=[CGCIntegrateHView getView];
    }
    return _headView;
}

- (NSMutableArray *)dataArray{
    
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)IDArray{
    
    if (_IDArray==nil) {
        _IDArray=[NSMutableArray array];
    }
    
    return _IDArray;
}

-(NSMutableArray *)JFArray{
    
    if (_JFArray==nil) {
        _JFArray=[NSMutableArray array];
    }
    
    return _JFArray;
    
}




@end
