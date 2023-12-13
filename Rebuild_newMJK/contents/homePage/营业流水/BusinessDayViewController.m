//
//  BusinessDayViewController.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/25.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "BusinessDayViewController.h"
#import "BusinessDayHeaderCellView.h"
#import "BusinessDayTableViewCell.h"
#import "CloseDealView.h"   //关账



#import "BusinessDayModel.h"
#import "BusinessDaySubModel.h"





#define HEADER    @"BusinessDayHeaderCellView"
#define CELL0    @"BusinessDayTableViewCell"

@interface BusinessDayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;   //
@property(nonatomic,assign)NSInteger currPage;
@property(nonatomic,assign)NSInteger pageSize;

@property(nonatomic,strong)NSMutableArray*mainDatasArray;   //
@property(nonatomic,strong)BusinessDayModel*mainDatasModel;
@end

@implementation BusinessDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=@"营业流水";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self.tableView registerNib:[UINib nibWithNibName:HEADER bundle:nil] forHeaderFooterViewReuseIdentifier:HEADER];
    
    [self setupRefresh];

    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark  --UI
-(void)setupRefresh{
    self.pageSize=100;
    self.currPage=1;
    
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currPage=1;
        [self httpPostGetshowInfo];
        
    }];
    
//    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        self.currPage++;
//        [self httpPostGetshowInfo];
//        
//    }];
    
    

    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainDatasArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BusinessDaySubModel*model=self.mainDatasArray[indexPath.row];
    BusinessDayTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.contentView.backgroundColor=tableView.backgroundColor;
    
    cell.topLab.text=model.X_REMARK;
    cell.bottomLab.text=[NSString stringWithFormat:@"%@    %@    %@",model.D_CREATE_TIME,model.C_OWNER_ROLENAME,model.C_A41500_C_NAME];
    cell.rightLab.text=model.AMOUNT;
    
    
    return cell;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BusinessDayHeaderCellView*BGView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:HEADER];
    BGView.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)]];

    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:ss"];
    NSDate*currentDate=[formatter dateFromString:self.mainDatasModel.D_LASTUPDATE_TIME];
    
    NSDateFormatter*newFormatter= [[NSDateFormatter alloc]init];
    newFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [newFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString*newDateStr=[newFormatter stringFromDate:currentDate];

    
    
    BGView.timeLab.text=newDateStr;
    BGView.priceLab.text=[NSString stringWithFormat:@"%@元",self.mainDatasModel.ALL_AMOUNT_UPDATE];
    BGView.numberLab.text=[NSString stringWithFormat:@"%@笔",self.mainDatasModel.ALL_COUNT_UPDATE];
    
    
    
    //手动关账
    BGView.closeBillBlock = ^{
        CloseDealView*dealView=[[NSBundle mainBundle]loadNibNamed:@"CloseDealView" owner:nil options:nil].firstObject;
        dealView.frame=self.view.bounds;
        dealView.fourthTextF.text=[NSString stringWithFormat:@"关账人:%@",_mainDatasModel.MENDER];
        [[UIApplication sharedApplication].keyWindow addSubview:dealView];
        dealView.clickSureBlock = ^(NSString *firstStr, NSString *secondStr, NSString *thirdStr,NSString*fourthStr) {
            MyLog(@"%@,%@,%@",firstStr,secondStr,thirdStr);
            if (!firstStr||!secondStr||!thirdStr) {
                [JRToast showWithText:@"营业总额，营业笔数，关账说明为必填项"];
                return ;
            }
            
            //吊接口
            [self httpPostForCloseDeal:firstStr and:secondStr and:thirdStr ];
            
            
        };
        
        
    };
    
    
    
    return BGView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 120;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


#pragma mark  --click



#pragma mark  --datas
-(void)httpPostGetshowInfo{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_BUsinessDayDetail];
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate*currentDate=[formatter dateFromString:self.D_CREATE_TIME];
    
    NSDateFormatter*newFormatter= [[NSDateFormatter alloc]init];
    newFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [newFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*newDateStr=[newFormatter stringFromDate:currentDate];
    
    NSDictionary*contentDict=@{@"currPage":@(self.currPage),@"pageSize":@(self.pageSize),@"D_CREATE_TIME":newDateStr?newDateStr:@"",@"C_A46300_C_ID":self.C_A46300_C_ID?_C_A46300_C_ID:@""};
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if (self.currPage==1) {
                [self.mainDatasArray removeAllObjects];
            }
            
            
            self.mainDatasModel=[BusinessDayModel yy_modelWithDictionary:data];
            NSArray*dataArray=data[@"content"];
            for (NSDictionary*dict in dataArray) {
                BusinessDaySubModel*subModel=[BusinessDaySubModel yy_modelWithDictionary:dict];
                [self.mainDatasArray addObject:subModel];
            }
            
            
            
             [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
       
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        
    }];
    
    
}



-(void)httpPostForCloseDeal:(NSString*)firstStr and:(NSString*)secondStr and:(NSString*)thirdStr{
     NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_closeDeal];
    NSDictionary*contentDict=@{@"C_A46300_C_ID":self.mainDatasModel.C_A46300_C_ID,@"B_MONEY":firstStr,@"I_COUNT":secondStr,@"X_REMARK":thirdStr,@"USER_ID":self.mainDatasModel.MENDER};
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [JRToast showWithText:data[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];
    
    
    
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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor whiteColor];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
    }
    return _tableView;
}

-(NSMutableArray *)mainDatasArray{
    if (!_mainDatasArray) {
        _mainDatasArray=[NSMutableArray array];
    }
    return _mainDatasArray;
}




@end
