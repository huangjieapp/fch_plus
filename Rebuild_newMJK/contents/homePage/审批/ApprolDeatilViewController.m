//
//  ApprolDeatilViewController.m
//  mcr_s
//
//  Created by bipyun on 16/6/7.
//  Copyright © 2016年 match. All rights reserved.
//

#import "ApprolDeatilViewController.h"
#import "ApprolDeatilTableViewCell.h"
//#import "CreateNEWOrderViewController.h"
#import "CustomerDetailViewController.h"
#import "PotentailCustomerListDetailModel.h"
#import "OrderDetailViewController.h"
#import "MJKAuditRecordsViewController.h"
#import "MJKAuditPerformanceViewController.h"
#import "MJKTaskClockDetailViewController.h"
#import "MJKCarSourceNewDetailViewController.h"

#import "MJKMortgageViewController.h"
#import "MJKQualityAssuranceViewController.h"
#import "MJKRegistrationViewController.h"
#import "MJKInsuranceViewController.h"
#import "MJKHighQualityViewController.h"
#import "MJKOldCustomerSalesViewController.h"

#import "MJKApprovalDetailModel.h"

@interface ApprolDeatilViewController ()<MBProgressHUDDelegate,UIAlertViewDelegate>
{
   PDESegmentControl *_pde;
   int index;
   int currPage;
    MJRefreshNormalHeader *header;
    MJRefreshBackNormalFooter *footer;
    MBProgressHUD *mbprogress;
    NSMutableArray *dateArray;
   NSString *idStr;
   NSString *C_A40300_C_ID;
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *rejectedView;
@property (weak, nonatomic) IBOutlet UITextField *rejectedField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@end

@implementation ApprolDeatilViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	self.topLayout.constant = NavStatusHeight;
    self.title=@"审批记录";
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    C_A40300_C_ID=[user objectForKey:@"C_A40300_C_ID"];
    [user synchronize];
  dateArray=[[NSMutableArray alloc]init];
//   mbprogress= [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//   [self.navigationController.view addSubview:mbprogress];
//   mbprogress.delegate = self;
//   mbprogress.color=[UIColor whiteColor];
    self.mainTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    if(self.typeStr!=nil){
        
        self.itemArr = [NSArray arrayWithObjects:@"未审批", @"已审批",@"驳回",nil];
        _pde = [[PDESegmentControl alloc]initWithFrame:CGRectMake(90, 85, [UIScreen mainScreen].bounds.size.width-180, 30) items:self.itemArr];
        //   self.view.backgroundColor=[UIColor lightTextColor];
//       [self.view addSubview:_pde];
        
        [self.button1 setTitleColor:KNaviColor forState:UIControlStateNormal];
        [self.button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _pde.changeSegBtnIndex = ^(int selectedIndex)
//        {
            index = 0;//每次要重置index
            currPage = 1;
//            index=selectedIndex;
            [dateArray removeAllObjects];
            
//            [self refersh];
//        };
    }else{
        self.view1.hidden=YES;
        self.mainTab.frame=CGRectMake(0, 64, self.mainTab.frame.size.width, self.view.frame.size.height-64);
    }
   
    
    self.mainTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        currPage = 1;
        [self refersh];
    }];
    // 马上进入刷新状态
    [self.mainTab.mj_header beginRefreshing];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    
    self.mainTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.mainTab.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self refersh];
    self.bgView.hidden = self.rejectedView.hidden = YES;
}
-(void)refersh
{
    DBSelf(weakSelf);
//    [mbprogress show:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self gethttpValues];
        [weakSelf getApprovalList];
    });
}
-(void)loadMoreData
{
    
    currPage=currPage+1;
    
    [self refersh];
    
    
    
}

- (void)getApprovalList{
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"pageNum"] = @(currPage);
    contentDic[@"pageSize"] = @(10);
    if ([self.typeStr isEqualToString:@"apply"]) {
        contentDic[@"C_APPLY_ID"] = [NewUserSession instance].user.u051Id;
    }else {
        contentDic[@"C_APPROVAL_ID"] = [NewUserSession instance].user.u051Id;
    }
    if (index == 0) {
        contentDic[@"C_STATUS_DD_ID"] = @"A42500_C_STATUS_0000";
    } else if (index == 1) {
        contentDic[@"C_STATUS_DD_ID"] = @"A42500_C_STATUS_0002";
    } else {
        contentDic[@"C_STATUS_DD_ID"] = @"A42500_C_STATUS_0001";
    }
    contentDic[@"C_TYPE_DD_ID"] = self.typeID;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:HTTP_SYSTEMD425RECORDLIST parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            if(currPage==1){
                [dateArray removeAllObjects];
            }
//            NSArray *arr = [MJKApprovalDetailModel mj_keyValuesArrayWithObjectArray:data[@"data"][@"list"]];
            NSMutableArray *itemsArray=[[NSMutableArray alloc]init];
            
            itemsArray=[[data objectForKey:@"data"] objectForKey:@"list"];
            
            for (NSDictionary *model in itemsArray) {
                
                [dateArray addObject:[MJKApprovalDetailModel yy_modelWithDictionary:model]];
                
            }
            [self.mainTab reloadData];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
        [weakSelf.mainTab.mj_header endRefreshing];
        [weakSelf.mainTab.mj_footer endRefreshing];
    }];
}

-(void)gethttpValues
{
    NSMutableDictionary *mainDic = [DBObjectTools getAddressDicWithAction:@"ApplicationWebService-getRecordALLList"];
    
//    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//    [dic setObject:@"ApplicationWebService-getRecordALLList" forKey:@"action"];
//    [dic setObject:[MyUtil getuser_id] forKey:@"user_id"];
//    [dic setObject:@"" forKey:@"gsonValue"];
//    [dic setObject:[MyUtil getuser_token] forKey:@"appkey"];
//    [dic setObject:@"S" forKey:@"appType"];
//    NSInteger arc=[MyUtil getRandomNumber];
//    [dic setObject:[NSString stringWithFormat:@"%li",arc]  forKey:@"nonceStr"];//随机数
//    [dic setObject:[MyUtil getMD5String] forKey:@"signature"];//MD5
//    [dic setObject:[MyUtil getCurrentTimeStamp] forKey:@"timestamp"];//时间戳
    NSMutableDictionary *dic1=[NSMutableDictionary new];
    [dic1 setObject:[NSString stringWithFormat:@"%d",currPage] forKey:@"currPage"];
    [dic1 setObject:@"10" forKey:@"pageSize"];
    [dic1 setObject:self.typeID forKey:@"TYPE"];
    //approval  apply
    if ([self.typeStr isEqualToString:@"apply"]) {//申请
        [dic1 setObject:[NewUserSession instance].user.u051Id forKey:@"C_APPLY_ID"];
        [dic1 setObject:@"" forKey:@"C_APPROVAL_ID"];
    }else if ([self.typeStr isEqualToString:@"approval"]) {//审批
        [dic1 setObject:[NewUserSession instance].user.u051Id forKey:@"C_APPROVAL_ID"];
        [dic1 setObject:@"" forKey:@"C_APPLY_ID"];
    }else{
      
        [dic1 setObject:[NewUserSession instance].user.u051Id forKey:@"C_APPROVAL_ID"];
        
    }
    
    [dic1 setObject:[NSString stringWithFormat:@"%d",index] forKey:@"STATUS"];//未完成或完成的状态
    [mainDic setObject:dic1 forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue] == 200) {
            if(currPage==1){
                [dateArray removeAllObjects];
            }
            NSMutableArray *itemsArray=[[NSMutableArray alloc]init];
            
            itemsArray=[data objectForKey:@"content"];
            
            for (NSDictionary *contentDic in itemsArray) {
                
                [dateArray addObject:contentDic];
                
            }
            [self.mainTab reloadData];
        } else {
            [JRToast showWithText:data[@"message"]];
        }
        [self.mainTab.mj_header endRefreshing];
        [self.mainTab.mj_footer endRefreshing];
    }];
    
//    NSString *str=[dic JSONString];
//
//    NSString *respone=[HttpPost getPost:str];
//
//    if (![respone isEqualToString:@""])
//    {
//        if(currPage==1){
//            [dateArray removeAllObjects];
//        }
//        NSDictionary *  dataDic1 = [respone objectFromJSONString];
//
//        NSString *errcode = [dataDic1 objectForKey:@"code"];
//
//        if ([errcode isEqualToString:@"200"]) {
//
//            NSMutableArray *itemsArray=[[NSMutableArray alloc]init];
//
//            itemsArray=[dataDic1 objectForKey:@"content"];
//
//            for (NSDictionary *contentDic in itemsArray) {
//
//                [dateArray addObject:contentDic];
//
//            }
//
//
//        }
//
//        else
//        {
//            [KVNProgress showErrorWithStatus:[dataDic1 objectForKey:@"message"]];
//
//        }
//
//    }else{
//
//        [KVNProgress showErrorWithStatus:[MyUtil getMessage]];
//
//    }
//    //    [KVNProgress dismiss];
//    [mbprogress hide:YES];
//    [self.mainTab reloadData];
//    [self.mainTab.footer endRefreshing];
//    [self.mainTab.header endRefreshing];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dateArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJKApprovalDetailModel *detailModel = dateArray[indexPath.row];
    ApprolDeatilTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"ApprolDeatilTableViewCell" owner:self options:nil] lastObject];
    }
   cell.contentView.backgroundColor=[UIColor clearColor];
   /*
    C_A41900_C_ID  产品id
    C_A41900_C_NAME  产品名称
    C_A41900_C_PICTURE  产品图片
    */
//    NSMutableDictionary *dic=[dateArray objectAtIndex:indexPath.row];
    cell.statuesLabel.text=detailModel.C_STATUS_DD_NAME; //[dic objectForKey:@"C_STATUS_DD_NAME"];
    cell.shenqinName.text=detailModel.C_APPLY_NAME;//[dic objectForKey:@"C_APPLY_NAME"];
    if ([self.typeID isEqualToString:@"8"]) {
        cell.typeLabel.text=@"点击查看绩效详情";
        cell.carLabel.hidden = YES;
        cell.remark.hidden = cell.shenqinName.hidden = YES;
        
    } else if ([self.typeID isEqualToString:@"7"]) {
        cell.typeLabel.text=detailModel.X_REMARK;//[dic objectForKey:@"X_REMARK"];
        cell.typeLabel.numberOfLines = 0;
        
        CGRect rect= cell.typeLabel.frame;
        rect.size.height=40;
        cell.typeLabel.frame=rect;
        cell.carLabel.hidden = YES;
        cell.remark.hidden = cell.shenqinName.hidden = YES;
    } else {
        cell.typeLabel.text=detailModel.C_A41500_C_NAME;//[dic objectForKey:@"C_A41500_C_NAME"];
        cell.carLabel.hidden = NO;
    }
    if ([self.typeID isEqualToString:@"A42500_C_TYPE_0019"]) {
        
        cell.typeLabel.text=detailModel.X_REMARK;
    }
    //X_AGREE驳回理由
    cell.rejectedLabel.text = detailModel.X_AGREE;//[dic objectForKey:@"X_AGREE"];
    if ([self.typeID isEqualToString:@"4"]) {
        cell.carLabel.text = @"转出位置:";
        cell.label2.text=@"潜客转出";
    }  else {
        cell.label2.text=detailModel.C_TYPE_DD_NAME;//[dic objectForKey:@"C_TYPE_DD_NAME"];
    }
    cell.bianhaoLabel.text=detailModel.C_A70600_C_NAME;//[dic objectForKey:@"C_A40600_C_NAME"];//A41900_C_NAME

    NSString *str=detailModel.C_A70600_C_PICTURE;//[dic objectForKey:@"C_A41900_C_PICTURE"];

    if (str.length==0) {
        cell.imgView.hidden=YES;
        cell.ImgViewLabel.hidden=NO;
        if (cell.typeLabel.text.length>1) {
            cell.ImgViewLabel.text=[cell.typeLabel.text substringToIndex:1];

        }
        NSLog(@"%@",cell.ImgViewLabel.text);
    }else
    {
        cell.imgView.hidden=NO;
        cell.ImgViewLabel.hidden=YES;

    }
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"image.png"]];
    cell.timeLabel.text=detailModel.D_CREATE_TIME;//[dic objectForKey:@"D_CREATE_TIME"];
    cell.remark.text=detailModel.X_REMARK;//[dic objectForKey:@"X_REMARK"];
   //绿色：通过  驳回：红色 申请中：黄色
   if ([detailModel.C_STATUS_DD_ID isEqualToString:@"A42500_C_STATUS_0001"]) {//驳回
      cell.imgStatues.image=[UIImage imageNamed:@"btn_reds"];
   }else if([detailModel.C_STATUS_DD_ID isEqualToString:@"A42500_C_STATUS_0002"]) {//通过
      cell.imgStatues.image=[UIImage imageNamed:@"btn_greens"];
   }else if([detailModel.C_STATUS_DD_ID isEqualToString:@"A42500_C_STATUS_0000"]) {//申请中
      cell.imgStatues.image=[UIImage imageNamed:@"btn_yellows"];
   }
   cell.agreeBtn.tag=1000+indexPath.row;
   cell.disagreeBtn.tag=2000+indexPath.row;
   [cell.agreeBtn addTarget:self action:@selector(agreeButton:) forControlEvents:UIControlEventTouchUpInside];
   [cell.disagreeBtn addTarget:self action:@selector(disagreeButton:) forControlEvents:UIControlEventTouchUpInside];
   
   [cell.imgView setClipsToBounds:YES];
   cell.imgView.layer.cornerRadius=10.0;
   cell.imgView.contentMode = UIViewContentModeScaleAspectFill;
//   NSString *statues=[dic objectForKey:@"C_STATUS_DD_ID"];
//   if ([statues isEqualToString:@"A42500_C_STATUS_0002"]||[statues isEqualToString:@"A42500_C_STATUS_0001"]) {
//      cell.agreeBtn.hidden=YES;
//      cell.disagreeBtn.hidden=YES;
//      cell.view_line.hidden=YES;
//   
//   }
   
    if ([self.typeStr isEqualToString:@"apply"]) {
        cell.agreeBtn.hidden=YES;
        cell.disagreeBtn.hidden=YES;
        cell.view_line.hidden=YES;
        cell.btnbohui.hidden=YES;
        cell.btntongyi.hidden=YES;
        CGRect rect= cell.bavkeview.frame;
        rect.size.height=170;
        cell.bavkeview.frame=rect;
        CGRect rect1= cell.contentview.frame;
        rect1.size.height=170;
        cell.contentview.frame=rect1;
    }else if ([self.typeStr isEqualToString:@"approval"]){
        if (index==1 || index == 2) {
            cell.agreeBtn.hidden=YES;
            cell.disagreeBtn.hidden=YES;
            cell.view_line.hidden=YES;
            cell.btnbohui.hidden=YES;
            cell.btntongyi.hidden=YES;
            CGRect rect= cell.bavkeview.frame;
            rect.size.height=170;
            cell.bavkeview.frame=rect;
            CGRect rect1= cell.contentview.frame;
            rect1.size.height=170;
            cell.contentview.frame=rect1;
        }
        
    }
    
    cell.historyButton.tag = 1919+indexPath.row;
    [cell.historyButton addTarget:self action:@selector(historyButtonAction:) forControlEvents:UIControlEventTouchUpInside];

 
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJKApprovalDetailModel *model = dateArray[indexPath.row];
    if ([self.typeID isEqualToString:@"A42500_C_TYPE_0008"]) {//目标导入
//        NSMutableDictionary *dic=[dateArray objectAtIndex:indexPath.row];
        MJKAuditPerformanceViewController *vc = [[MJKAuditPerformanceViewController alloc]init];
        vc.C_ID = model.C_ID;//[dic objectForKey:@"C_ID"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.typeID isEqualToString:@"A42500_C_TYPE_0007"]) { //任务打卡
//        NSMutableDictionary *dic=[dateArray objectAtIndex:indexPath.row];
        MJKTaskClockDetailViewController *vc = [[MJKTaskClockDetailViewController alloc]init];
        vc.C_ID = model.C_OBJECT_ID;//[dic objectForKey:@"C_OBJECT_ID"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.typeID isEqualToString:@"A42500_C_TYPE_0002"]||[self.typeID isEqualToString:@"A42500_C_TYPE_0003"] || [self.typeID isEqualToString:@"A42500_C_TYPE_0006"] || [self.typeID isEqualToString:@"A42500_C_TYPE_0016"]) {//订单相关
        
//        NSMutableDictionary *dic=[dateArray objectAtIndex:indexPath.row];
        OrderDetailViewController * order=[[OrderDetailViewController alloc] init];
        [[NSUserDefaults standardUserDefaults]setObject:@"order" forKey:@"VCName"];
//        if ([model.C_STATUS_DD_ID isEqualToString:@"A42000_C_STATUS_0005"]) {//报价
//            order.URL=[dic objectForKey:@"C_OFFERPIC"];
//
//        }else{
//            order.URL=[dic objectForKey:@"C_ORDERPIC"];
//        }

        order.isEdit=model.C_STATUS_DD_ID;//[dic objectForKey:@"C_STATUS_DD_ID"];
        order.statusType = model.C_STATUS_DD_NAME;//[dic objectForKey:@"C_STATUS_DD_NAME"];
        order.orderId=model.C_OBJECT_ID;//[dic objectForKey:@"C_OBJECT_ID"];
        
//        DBSelf(weakSelf);
//        order.reloadBlock=^(){
//
//            self.currPage=20;
//            //        [weakSelf HTTPGetOrderList];
//            [weakSelf.tableView.mj_header beginRefreshing];
//        };
        
        
        [self.navigationController pushViewController:order animated:YES];
    } else if ([self.typeID isEqualToString:@"A42500_C_TYPE_0009"]) {
        MJKMortgageViewController *vc= [[MJKMortgageViewController alloc]init];
        vc.C_ID = model.C_OBJECT_ID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.typeID isEqualToString:@"A42500_C_TYPE_0010"]) {
        MJKInsuranceViewController *vc = [[MJKInsuranceViewController alloc]init];
        vc.C_ID = model.C_OBJECT_ID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.typeID isEqualToString:@"A42500_C_TYPE_0011"]) {
        MJKQualityAssuranceViewController *vc= [[MJKQualityAssuranceViewController alloc]init];
        vc.C_ID = model.C_OBJECT_ID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.typeID isEqualToString:@"A42500_C_TYPE_0012"] || [self.typeID isEqualToString:@"A42500_C_TYPE_0014"]) { //精品 装潢|售后
        MJKHighQualityViewController *vc= [[MJKHighQualityViewController alloc]init];
        vc.C_ID = model.C_OBJECT_ID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.typeID isEqualToString:@"A42500_C_TYPE_0013"]) {
        MJKRegistrationViewController *vc= [[MJKRegistrationViewController alloc]init];
        vc.C_ID = model.C_OBJECT_ID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.typeID isEqualToString:@"A42500_C_TYPE_0015"]) {//售后
        MJKOldCustomerSalesViewController *vc= [[MJKOldCustomerSalesViewController alloc]init];
        vc.C_ID = model.C_OBJECT_ID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.typeID isEqualToString:@"A42500_C_TYPE_0019"]) {
        MJKCarSourceNewDetailViewController *vc= [[MJKCarSourceNewDetailViewController alloc]init];
        vc.C_ID = model.C_OBJECT_ID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.typeID isEqualToString:@"A42500_C_TYPE_0020"]) {
        MJKRegistrationViewController *vc= [[MJKRegistrationViewController alloc]init];
        vc.C_ID = model.C_OBJECT_ID;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //  typeID = A42500_C_TYPE_0004 //转入公海
    
//    else{//潜客相关
////        NSMutableDictionary *dic=[dateArray objectAtIndex:indexPath.row];
//
//        CustomerDetailViewController*vc=[[CustomerDetailViewController alloc]init];
//        //客户详情里输入框下面弹框内容，如果是协助就只有新增预约
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VCName"];
//        PotentailCustomerListDetailModel *model1 = [[PotentailCustomerListDetailModel alloc]init];
//        model1.C_ID = model.C_OBJECT_ID;//[dic objectForKey:@"C_OBJECT_ID"];
//        model1.C_A41500_C_ID = model.C_OBJECT_ID;//[dic objectForKey:@"C_OBJECT_ID"];
//        vc.mainModel=model1;
//        [self.navigationController pushViewController:vc animated:YES];
//
//
//
//    }
   
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//   NSMutableDictionary *dic=[dateArray objectAtIndex:indexPath.row];
//   NSString *statues=[dic objectForKey:@"C_STATUS_DD_ID"];
//   if ([statues isEqualToString:@"A42500_C_STATUS_0002"]||[statues isEqualToString:@"A42500_C_STATUS_0001"]) {
//      return 120;
//   }
    if ([self.typeStr isEqualToString:@"apply"]) {
       
      return 190;
        
   }else if ([self.typeStr isEqualToString:@"approval"]){
       if (index==1) {
          
            return 190.0;
          
       }else{
      
          return 220.0;
       }
      
   }else{
   
      return 220.0;
   }
   
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 1.0;
    
}
- (IBAction)bgViewTap:(UITapGestureRecognizer *)sender {
    self.rejectedView.hidden = YES;
    [self.rejectedField resignFirstResponder];
    self.bgView.hidden = YES;
}
#pragma mark同意
-(void)agreeButton:(UIButton *)btn
{
    DBSelf(weakSelf);
   NSInteger indexs=btn.tag-1000;
//   NSDictionary *dic=[dateArray objectAtIndex:indexs];
    MJKApprovalDetailModel *model = [dateArray objectAtIndex:indexs];
    idStr=model.C_ID;// [dic objectForKey:@"C_ID"];
//   [mbprogress show:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self doActionRefer];
        [weakSelf agree];
    });
//   dispatch_async(dispatch_get_main_queue(), ^{
    
//   });

}
#pragma mark驳回
-(void)disagreeButton:(UIButton *)btn
{
    self.bgView.hidden = NO;
    self.rejectedView.hidden = NO;
   NSInteger indexs=btn.tag-2000;
//   NSDictionary *dic=[dateArray objectAtIndex:indexs];
    MJKApprovalDetailModel *model = [dateArray objectAtIndex:indexs];
    idStr=model.C_ID;//[dic objectForKey:@"C_ID"];
}
#pragma mark同意
-(void)doActionRefer
{
    NSMutableDictionary *mainDic = [DBObjectTools getAddressDicWithAction:@"ApplicationWebService-byApplication"];
//   NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//   [dic setObject:@"ApplicationWebService-byApplication" forKey:@"action"];
//   [dic setObject:[MyUtil getuser_id] forKey:@"user_id"];
//   [dic setObject:@"" forKey:@"gsonValue"];
//   [dic setObject:[MyUtil getuser_token] forKey:@"appkey"];
//   [dic setObject:@"S" forKey:@"appType"];
//   NSInteger arc=[MyUtil getRandomNumber];
//   [dic setObject:[NSString stringWithFormat:@"%li",arc]  forKey:@"nonceStr"];//随机数
//   [dic setObject:[MyUtil getMD5String] forKey:@"signature"];//MD5
//   [dic setObject:[MyUtil getCurrentTimeStamp] forKey:@"timestamp"];//时间戳
   NSMutableDictionary *dic1=[NSMutableDictionary new];
   [dic1 setObject:idStr forKey:@"C_ID"];
   [mainDic setObject:dic1 forKey:@"content"];
   
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue] == 200) {
            [dateArray removeAllObjects];
            currPage=1;
            //         [self refersh];
            [self gethttpValues];
            
            if([self.typeID isEqualToString:@"3"]){
                //            UIAlertView *myView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否更新报价" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                //            myView.tag=12;
                //            [UIView appearance].tintColor=UIColorForAlert;
                //            [myView show];
            }else {
                
                [JRToast showWithText:[data objectForKey:@"message"]];
            }
        } else {
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
   
//   NSString *str=[dic JSONString];
//   NSString *respone=[HttpPost getPost:str];
//   if (![respone isEqualToString:@""])
//   {
//
//      NSDictionary *  dataDic1 = [respone objectFromJSONString];
//
//      NSString *errcode = [dataDic1 objectForKey:@"code"];
//
//      if ([errcode isEqualToString:@"200"]) {
////
//         [dateArray removeAllObjects];
//         currPage=1;
////         [self refersh];
//         [self gethttpValues];
//
//         if([self.typeID isEqualToString:@"3"]){
////            UIAlertView *myView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否更新报价" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
////            myView.tag=12;
////            [UIView appearance].tintColor=UIColorForAlert;
////            [myView show];
//         }else {
//
//            [KVNProgress showSuccessWithStatus:[dataDic1 objectForKey:@"message"]];
//         }
//
//      }
//
//      else
//      {
//         [KVNProgress showErrorWithStatus:[dataDic1 objectForKey:@"message"]];
//
//      }
//
//   }else{
//
//      [KVNProgress showErrorWithStatus:[MyUtil getMessage]];
//
//   }
//
//   [mbprogress hide:YES];
   
}
#pragma mark 审核记录
- (void)historyButtonAction:(UIButton *)btn {
    NSInteger indexs=btn.tag-1919;
//    NSDictionary *dic=[dateArray objectAtIndex:indexs];
    MJKApprovalDetailModel *model = [dateArray objectAtIndex:indexs];
    MJKAuditRecordsViewController *vc = [[MJKAuditRecordsViewController alloc]init];
    vc.C_ID = model.C_ID;//[dic objectForKey:@"C_ID"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   if (buttonIndex==1) {
      dispatch_async(dispatch_get_main_queue(), ^{
         [self doActionReferUpdateQuote];
      });
   }

}

#pragma mark 同意之后更新报价
-(void)doActionReferUpdateQuote
{
    NSMutableDictionary *mainDic = [DBObjectTools getAddressDicWithAction:@"ApplicationWebService-agreeUpdateProPrice"];
//   NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//   [dic setObject:@"ApplicationWebService-agreeUpdateProPrice" forKey:@"action"];
//   [dic setObject:[MyUtil getuser_id] forKey:@"user_id"];
//   [dic setObject:@"" forKey:@"gsonValue"];
//   [dic setObject:[MyUtil getuser_token] forKey:@"appkey"];
//   [dic setObject:@"S" forKey:@"appType"];
//   NSInteger arc=[MyUtil getRandomNumber];
//   [dic setObject:[NSString stringWithFormat:@"%li",arc]  forKey:@"nonceStr"];//随机数
//   [dic setObject:[MyUtil getMD5String] forKey:@"signature"];//MD5
//   [dic setObject:[MyUtil getCurrentTimeStamp] forKey:@"timestamp"];//时间戳
   NSMutableDictionary *dic1=[NSMutableDictionary new];
   [dic1 setObject:idStr forKey:@"C_ID"];
   [dic1 setObject:C_A40300_C_ID forKey:@"C_A40300_C_ID"];

   [mainDic setObject:dic1 forKey:@"content"];
   
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue] == 200) {
            [JRToast showWithText:[data objectForKey:@"message"]];
            [dateArray removeAllObjects];
            currPage=1;
            //         [self refersh];
            [self gethttpValues];
        } else {
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
   
//   NSString *str=[dic JSONString];
//   NSString *respone=[HttpPost getPost:str];
//   if (![respone isEqualToString:@""])
//   {
//
//      NSDictionary *  dataDic1 = [respone objectFromJSONString];
//
//      NSString *errcode = [dataDic1 objectForKey:@"code"];
//
//      if ([errcode isEqualToString:@"200"]) {
//         [KVNProgress showSuccessWithStatus:[dataDic1 objectForKey:@"message"]];
//         [dateArray removeAllObjects];
//         currPage=1;
//         //         [self refersh];
//         [self gethttpValues];
//      }
//
//      else
//      {
//         [KVNProgress showErrorWithStatus:[dataDic1 objectForKey:@"message"]];
//
//      }
//
//   }else{
//
//      [KVNProgress showErrorWithStatus:[MyUtil getMessage]];
//
//   }
//
//   [mbprogress hide:YES];
   
}
#pragma mark驳回取消/确定
- (IBAction)rejectedCancelAction:(UIButton *)sender {
    self.rejectedView.hidden = YES;
    [self.rejectedField resignFirstResponder];
    self.bgView.hidden = YES;
}
- (IBAction)trueRejectedAction:(UIButton *)sender {
    DBSelf(weakSelf);
    if (self.rejectedField.text.length <= 0) {
        [KVNProgress showErrorWithStatus:@"请输入驳回理由"];
        return;
    }
    self.rejectedView.hidden = YES;
    [self.rejectedField resignFirstResponder];
    self.bgView.hidden = YES;
//    [mbprogress show:YES];

    dispatch_async(dispatch_get_main_queue(), ^{
//        [self doActiondisagree];
        [weakSelf rejected];
    });
}

- (void)rejected {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = idStr;
    contentDic[@"X_AGREE"] = self.rejectedField.text;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:HTTP_SYSTEMD425APPROVEDFAILED parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            [JRToast showWithText:[data objectForKey:@"msg"]];
            self.rejectedField.text = @"";
                [weakSelf refersh];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)agree {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = idStr;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:HTTP_SYSTEMD425APPROVED parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            [JRToast showWithText:[data objectForKey:@"msg"]];
            self.rejectedField.text = @"";
            [weakSelf refersh];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

#pragma mark驳回
-(void)doActiondisagree
{
    NSMutableDictionary *mainDic = [DBObjectTools getAddressDicWithAction:@"ApplicationWebService-turnDownApplication"];
    
//   NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//   [dic setObject:@"ApplicationWebService-turnDownApplication" forKey:@"action"];
//   [dic setObject:[MyUtil getuser_id] forKey:@"user_id"];
//   [dic setObject:@"" forKey:@"gsonValue"];
//   [dic setObject:[MyUtil getuser_token] forKey:@"appkey"];
//   [dic setObject:@"S" forKey:@"appType"];
//   NSInteger arc=[MyUtil getRandomNumber];
//   [dic setObject:[NSString stringWithFormat:@"%li",arc]  forKey:@"nonceStr"];//随机数
//   [dic setObject:[MyUtil getMD5String] forKey:@"signature"];//MD5
//   [dic setObject:[MyUtil getCurrentTimeStamp] forKey:@"timestamp"];//时间戳
   NSMutableDictionary *dic1=[NSMutableDictionary new];
   [dic1 setObject:idStr forKey:@"C_ID"];
    [dic1 setObject:self.rejectedField.text forKey:@"X_AGREE"];
   [mainDic setObject:dic1 forKey:@"content"];
   NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:@"1"];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue] == 200) {
            [JRToast showWithText:[data objectForKey:@"message"]];
            [dateArray removeAllObjects];
            currPage=1;
            self.rejectedField.text = @"";
            //         [self refersh];
            [self gethttpValues];

        } else {
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
   
//   NSString *str=[dic JSONString];
//   NSString *respone=[HttpPost getPost:str];
//   if (![respone isEqualToString:@""])
//   {
//
//      NSDictionary *  dataDic1 = [respone objectFromJSONString];
//
//      NSString *errcode = [dataDic1 objectForKey:@"code"];
//
//      if ([errcode isEqualToString:@"200"]) {
//         [KVNProgress showSuccessWithStatus:[dataDic1 objectForKey:@"message"]];
//         [dateArray removeAllObjects];
//         currPage=1;
//          self.rejectedField.text = @"";
////         [self refersh];
//         [self gethttpValues];
//      }
//
//      else
//      {
//         [mbprogress hide:YES];
//
//         [KVNProgress showErrorWithStatus:[dataDic1 objectForKey:@"message"]];
//
//      }
//
//   }else{
//      [mbprogress hide:YES];
//
//      [KVNProgress showErrorWithStatus:[MyUtil getMessage]];
//
//   }
   
   
}
- (IBAction)unAgreeButton:(id)sender {
    
    [self.button3 setTitleColor:KNaviColor forState:UIControlStateNormal];
    [self.button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    index = 2;//每次要重置index
    currPage = 1;
    [dateArray removeAllObjects];
    [self refersh];
}


- (IBAction)shenqingButton:(id)sender {
    
    [self.button1 setTitleColor:KNaviColor forState:UIControlStateNormal];
    [self.button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    index = 0;//每次要重置index
    currPage = 1;
    [dateArray removeAllObjects];
    [self refersh];
}

- (IBAction)shenpiButotn:(id)sender {
    [self.button2 setTitleColor:KNaviColor forState:UIControlStateNormal];
    [self.button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    index = 1;
    currPage = 1;
    [dateArray removeAllObjects];
    [self refersh];
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

@end
