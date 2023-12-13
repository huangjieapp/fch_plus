//
//  ServiceOrderListViewController.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/31.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "ServiceOrderListViewController.h"
#import "CGCNavSearchTextView.h"
#import "CFDropDownMenuView.h"
#import "ServiceTaskTableViewCell.h"
#import "CGCCustomDateView.h"
#import "CGCMoreCollection.h"
#import "CustomerSignView.h"


#import "MJKClueListViewModel.h"
#import "ServiceOrderModel.h"

#import "MJKVoiceCViewController.h"
#import "ServiceOrderDetailOrEditViewController.h"
#import "CommonCallViewController.h"
#import "addDealViewController.h"
#import "CGCTemplateVC.h"

#import "CustomerFollowAddEditViewController.h"
#import "CustomerDetailInfoModel.h"

#import "VoiceView.h"


#define CELL0   @"ServiceTaskTableViewCell"
@interface ServiceOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)CGCNavSearchTextView*CurrentTitleView;  //不做属性 警告。。
@property(nonatomic,strong)CFDropDownMenuView*menuView;   //菜单选择栏
@property(nonatomic,strong)UILabel*allNumberLabel;   //总计label


@property(nonatomic,strong)NSMutableArray*mainDatasArray;   //所有的数据

@property(nonatomic,strong)NSMutableDictionary*saveSelTableDict;   //筛选的参数
@property(nonatomic,strong)NSMutableDictionary*saveSelTimeDict;   //筛选的时间
@property(nonatomic,strong)NSString*searchStr;   //搜索的文字
@property(nonatomic,assign)NSInteger currPage;
@property(nonatomic,assign)NSInteger pageSize;

@property(nonatomic,strong)ServiceOrderSubModel*detailModel;

@property(nonatomic,strong)NSMutableArray*TableChooseDatas;    //筛选的数据
@property(nonatomic,strong)NSMutableArray*TableSelectedChooseDatas;   //筛选选中的数据
@property(nonatomic,strong)CustomerDetailInfoModel*detailInfoModel;
@end

@implementation ServiceOrderListViewController

   // 服务工单
- (void)viewDidLoad {
    [super viewDidLoad];
 
     [self createNav];
    [self getChooseDatas];
    [self.view addSubview:self.tableView];
    [self setupRefresh];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.tableView.mj_header beginRefreshing];
    
    
}

#pragma mark  --UI
- (void)createNav{
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    self.view.backgroundColor=CGCTABBGColor;
    DBSelf(weakSelf);
    self.CurrentTitleView=[[CGCNavSearchTextView alloc] initWithFrame:self.view.bounds withPlaceHolder:@"请输入手机/客户姓名" withRecord:^{//点击录音
//        MJKVoiceCViewController *voiceVC = [[MJKVoiceCViewController alloc]initWithNibName:@"MJKVoiceCViewController" bundle:nil];
//        [voiceVC setBackStrBlock:^(NSString *str){
//            if (str.length>0) {
//                _CurrentTitleView.textField.text = str;
//                self.searchStr=str;
//                [self.tableView.mj_header beginRefreshing];
//            }
//        }];
//        [weakSelf presentViewController:voiceVC animated:YES completion:nil];
		VoiceView *vv = [[VoiceView alloc]initWithFrame:self.view.frame];
		[self.view addSubview:vv];
		[vv start];
		vv.recordBlock = ^(NSString *str) {
			_CurrentTitleView.textField.text = str;
			self.searchStr=str;
			[self.tableView.mj_header beginRefreshing];

		};
        
    } withText:^{//开始编辑
        MyLog(@"编辑");
        
        
    }withEndText:^(NSString *str) {//结束编辑
        NSLog(@"%@____",str);
        if (str.length>0) {
            self.searchStr=str;
            [self.tableView.mj_header beginRefreshing];
        }else{
            self.searchStr=@"";
            [self.tableView.mj_header beginRefreshing];
        }
        
    }];
    self.navigationItem.titleView=self.CurrentTitleView;
    
    
    
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_customer_add" highImage:@"" target:self andAction:@selector(addNewServiceTask)];
    
    
}

-(void)addChooseView{
    DBSelf(weakSelf);
    CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth-40, 40)];
    menuView.dataSourceArr=self.TableChooseDatas;
    self.menuView=menuView;
    menuView.defaulTitleArray=@[@"类型",@"状态",@"服务人员",@"工单日期"];
    menuView.startY=CGRectGetMaxY(menuView.frame);
    menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
        MyLog(@"%@  %@   %@",selectedSection,selectedRow,title);
        NSMutableArray*subArray=self.TableSelectedChooseDatas[[selectedSection integerValue]];
        NSString*selectValue=subArray[[selectedRow integerValue]];
        
        NSString*selectKey;
        if ([selectedSection isEqualToString:@"0"]) {
            //类型
            selectKey=@"TYPE";
            
        }else if ([selectedSection isEqualToString:@"1"]){
            //状态
            selectKey=@"STATUS_TYPE";
        }else if ([selectedSection isEqualToString:@"2"]){
            //服务人员
            selectKey=@"USER_ID";
        }else if ([selectedSection isEqualToString:@"3"]){
            //任务日期
            selectKey=@"CREATE_TIME_TYPE";
            [self.saveSelTimeDict removeObjectForKey:@"CREATE_START_TIME"];
            [self.saveSelTimeDict removeObjectForKey:@"CREATE_END_TIME"];
            
        }
        
        
        if (selectKey) {
            [self.saveSelTableDict setObject:selectValue forKey:selectKey];
            if ([selectValue isEqualToString:@"999"])  {
                
            }else{
                
                [self.tableView.mj_header beginRefreshing];
            }
        }
        
        
        //如果点击的是   自定义
        if ([selectValue isEqualToString:@"999"]) {
            CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
                
            } withEnd:^{
                
                
            } withSure:^(NSString *start, NSString *end) {
                MyLog(@"11--%@   22--%@",start,end);
                
                [self.saveSelTimeDict setObject:start forKey:@"CREATE_START_TIME"];
                [self.saveSelTimeDict setObject:end forKey:@"CREATE_END_TIME"];
                [self.saveSelTableDict removeObjectForKey:@"CREATE_TIME_TYPE"];
                
                [self.tableView.mj_header beginRefreshing];
                
            }];
            
            
            dateView.clickCancelBlock = ^{
                //选中第一个
                [self.menuView.dropDownMenuTableView.delegate tableView:self.menuView.dropDownMenuTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
                
                [self.saveSelTimeDict removeObjectForKey:@"CREATE_START_TIME"];
                [self.saveSelTimeDict removeObjectForKey:@"CREATE_END_TIME"];
                [self.saveSelTableDict setObject:@"" forKey:@"CREATE_TIME_TYPE"];
                
                [self.tableView.mj_header beginRefreshing];
            };
            
            
            
            [[UIApplication sharedApplication].keyWindow addSubview:dateView];
            
            
            
            
            
        }
        
        
        
    };
    [self.view addSubview:menuView];
    
    
    
    
    
    
    
    
    
    
    //这个是漏斗按钮
    CFRightButton*funnelButton=[[CFRightButton alloc]initWithFrame:CGRectMake( KScreenWidth-40,NavStatusHeight, 40, 40)];
    [self.view addSubview:funnelButton];
    funnelButton.clickFunnelBlock = ^(BOOL isSelected) {
        //tablieView
        [menuView hide];
        
    };
    
    
    //要写在 chooseView  加载完之后
    [self addTotailView];
    
    
    
    
    
    
}


-(void)addTotailView{
    UIImageView*BGImageV=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-60, NavStatusHeight+40-1, 60, 20)];
    BGImageV.image=[UIImage imageNamed:@"all_bg"];
    BGImageV.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:BGImageV];
    
    UILabel*allNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, BGImageV.width, BGImageV.height)];
    allNumberLabel.font=[UIFont systemFontOfSize:11];
    allNumberLabel.textColor=KColorGrayTitle;
    allNumberLabel.text=@"总计:0";
    allNumberLabel.textAlignment=NSTextAlignmentCenter;
    self.allNumberLabel=allNumberLabel;
    [BGImageV addSubview:allNumberLabel];
    
    
}


-(void)setupRefresh{
    DBSelf(weakSelf);
    self.pageSize=20;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currPage=1;
        [weakSelf HttpPostgetListDatas];
        
    }];
    
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currPage++;
        [weakSelf HttpPostgetListDatas];
        
    }];
    
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.mainDatasArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ServiceOrderModel*model=self.mainDatasArray[section];
    return model.content.count;
    
    return 4;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceTaskTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    ServiceOrderModel*model=self.mainDatasArray[indexPath.section];
    ServiceOrderSubModel*detailModel=model.content[indexPath.row];
    cell.pubOrderDatasModel=detailModel;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceOrderModel*model=self.mainDatasArray[indexPath.section];
    ServiceOrderSubModel*detailModel=model.content[indexPath.row];
    if ([detailModel.C_STATUS_DD_NAME isEqualToString:@"完成"]) {
        //完成
        ServiceOrderDetailOrEditViewController*vc=[[ServiceOrderDetailOrEditViewController alloc]init];
        vc.Type=OrderTypeComplete;
        vc.pubModel=detailModel;
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        //未完成
        ServiceOrderDetailOrEditViewController*vc=[[ServiceOrderDetailOrEditViewController alloc]init];
        vc.Type=OrderTypeUnComplete;
        vc.pubModel=detailModel;
        [self.navigationController pushViewController:vc animated:YES];

        
    }
    
   }



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ServiceOrderModel*model=self.mainDatasArray[section];
    
    
    UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 25)];
    BGView.backgroundColor=KColorGrayBGView;
    

    NSString*Strr=model.total;

    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth/2, 15)];
    titleLabel.textColor=KColorGrayTitle;
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.text=Strr;
    [BGView addSubview:titleLabel];
    
    return BGView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceOrderModel*model=self.mainDatasArray[indexPath.section];
    ServiceOrderSubModel*detailModel=model.content[indexPath.row];
    self.detailModel = detailModel;
    DBSelf(weakSelf);
    UITableViewRowAction*phoneAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"拨打电话" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        MyLog(@"1");
        [weakSelf httpPostGetCustomerDetailInfo:detailModel.C_A41500_C_ID];
        NSInteger index=indexPath.section*100+indexPath.row;
        [weakSelf selectTelephone:index];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    phoneAction.backgroundColor=DBColor(255,195,0);
    
    
    
    
    UITableViewRowAction*satisfactionAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"满意度" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        MyLog(@"2");
        [JRToast showWithText:@"暂未开放"];
        
    }];
    satisfactionAction.backgroundColor=DBColor(153,153,153);
    
    
    UITableViewRowAction*moreAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"更多操作" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        MyLog(@"3");
        [self MoreChooseWithIndexPath:indexPath];
        
        
    }];
    moreAction.backgroundColor=DBColor(50,151,234);
    
    
    
    
    //扫码
    UITableViewRowAction*SQCodeAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"扫码" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        MyLog(@"3");
        [JRToast showWithText:@"敬请期待"];
        
        
    }];
    SQCodeAction.backgroundColor=DBColor(50,151,234);
    
    //完成
    UITableViewRowAction*CompleteAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"完成" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        MyLog(@"2");
        [self completeForSignNameWithIndexPath:indexPath];
        
        
    }];
    CompleteAction.backgroundColor=DBColor(153,153,153);


    
    
    
    
    if ([detailModel.C_STATUS_DD_NAME isEqualToString:@"完成"]) {
        //拨打电话  满意度  更多
        return @[moreAction,satisfactionAction,phoneAction];
    }else{
        //拨打电话 完成  扫码
        
        return @[SQCodeAction,CompleteAction,phoneAction];

    }
    }


#pragma mark  --click
-(void)addNewServiceTask{
   
    
}


//签名 完成项目
-(void)completeForSignNameWithIndexPath:(NSIndexPath*)indexPath{
    ServiceOrderModel*model=self.mainDatasArray[indexPath.section];
    ServiceOrderSubModel*detailModel=model.content[indexPath.row];

    
    CustomerSignView*signView=[CustomerSignView signViewShowSuccess:^(UIImage *image) {
        MyLog(@"%@",image);
        NSData*data=UIImagePNGRepresentation(image);
        //上传图片
        [self HttpPostOneImageToJiekouWith:data success:^(NSString *imageStr) {
            //上传图片2
            [self httpPostUpdateOrderDetailWithSignImageStr:imageStr andServiceOrderSubModel:detailModel andComplete:^(id data) {
                //完成订单
                [self httpPostCompleteSignOrderWithServiceOrderSubModel:detailModel Success:^(id data) {

                    [self.tableView.mj_header beginRefreshing];
                    
                }];
                
                
                
            }];
            
            
            
            
            
            
            
        }];
        
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:signView];

    
    
}


-(void)showWechat:(ServiceOrderSubModel*)detailModel{
    CGCTemplateVC*vc=[[CGCTemplateVC alloc]init];
    vc.templateType=CGCTemplateWeiXin;
    vc.titStr=detailModel.C_A41500_C_NAME;
    vc.customIDArr=[@[detailModel.C_A41500_C_ID] mutableCopy];
    vc.cusDetailModel.C_ID=detailModel.C_A41500_C_ID;
    vc.cusDetailModel.C_HEADIMGURL=detailModel.C_HEADIMGURL;
    vc.cusDetailModel.C_NAME=detailModel.C_A41500_C_NAME;
//    vc.cusDetailModel.C_LEVEL_DD_NAME=self.detailInfoModel.C_LEVEL_DD_NAME;
//    vc.cusDetailModel.C_LEVEL_DD_ID=self.detailInfoModel.C_LEVEL_DD_ID;
    [self.navigationController pushViewController:vc animated:YES];

    
    
}


-(void)showShortMail:(ServiceOrderSubModel*)detailModel{
    CGCTemplateVC*vc=[[CGCTemplateVC alloc]init];
    vc.templateType=CGCTemplateMessage;
    vc.titStr=detailModel.C_A41500_C_NAME;
    vc.customPhoneArr=[@[detailModel.C_CONTACTPHONE] mutableCopy];
    vc.cusDetailModel.C_ID=detailModel.C_A41500_C_ID;
    vc.cusDetailModel.C_HEADIMGURL=detailModel.C_HEADIMGURL;
    vc.cusDetailModel.C_NAME=detailModel.C_A41500_C_NAME;
//    vc.cusDetailModel.C_LEVEL_DD_NAME=self.detailInfoModel.C_LEVEL_DD_NAME;
//    vc.cusDetailModel.C_LEVEL_DD_ID=self.detailInfoModel.C_LEVEL_DD_ID;
    [self.navigationController pushViewController:vc animated:YES];

    
}


-(void)MoreChooseWithIndexPath:(NSIndexPath*)indexPath{
    DBSelf(weakSelf);
    ServiceOrderModel*model=self.mainDatasArray[indexPath.section];
    ServiceOrderSubModel*detailModel=model.content[indexPath.row];
    NSArray*titleArray=@[@"支付",@"推送"];
    NSArray*imageArray;
    imageArray=@[@"more_支付",@"more_推送"];

    
    
    CGCMoreCollection*moreOperation=[[CGCMoreCollection alloc]initWithFrame:self.view.bounds withPicArr:imageArray withTitleArr:titleArray withTitle:@"更多操作" withSelectIndex:^(NSInteger index, NSString *title) {
        MyLog(@"index==%lu,title==%@",index,title);
        
        if ([title isEqualToString:@"支付"]) {
            
            addDealViewController*vc=[[addDealViewController alloc]init];
            vc.C_ORDER_ID=detailModel.C_ID;
			vc.vcName = @"收款/退款";
            [self.navigationController pushViewController:vc animated:YES];

            
        }
        
        if ([title isEqualToString:@"推送"]) {
            UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"推送" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction*wechat=[UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self showWechat:detailModel];
                
            }];
            UIAlertAction*shortmail=[UIAlertAction actionWithTitle:@"短信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self showShortMail:detailModel];
                
            }];
            UIAlertAction*publicNumber=[UIAlertAction actionWithTitle:@"公众号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [JRToast showWithText:@"敬请期待"];
                
            }];
            [alertVC addAction:cancel];
            [alertVC addAction:publicNumber];
            [alertVC addAction:shortmail];
            [alertVC addAction:wechat];
            [self presentViewController:alertVC animated:YES completion:nil];
            
            
            
        }
        
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:moreOperation];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  --datas
-(void)HttpPostgetListDatas{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_ServiceOrderList];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionaryWithDictionary:@{@"pageSize":@(_pageSize),@"currPage":@(_currPage)}];
    [self.saveSelTableDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [contentDict setObject:obj forKey:key];
        
    }];
    [self.saveSelTimeDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [contentDict setObject:obj forKey:key];
        
    }];
    
    
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            NSString*countNumber=[NSString stringWithFormat:@"%@",data[@"countNumber"]];
            self.allNumberLabel.text=[NSString stringWithFormat:@"总计:%@",countNumber] ;
            
            NSArray*dataArray=data[@"content"];
            
            if (self.currPage==1) {
                [self.mainDatasArray removeAllObjects];
            }
            
            
            for (NSDictionary*dict in dataArray) {
                ServiceOrderModel*model=[ServiceOrderModel yy_modelWithDictionary:dict];
                [self.mainDatasArray addObject:model];
            }
            
            [self.tableView reloadData];
            
            
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];

    
    
}

-(void)httpPostGetCustomerDetailInfo:(NSString *)C_A41500_ID{
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a415/info", HTTP_IP] parameters:@{@"C_ID":C_A41500_ID} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            self.detailInfoModel=[CustomerDetailInfoModel yy_modelWithDictionary:data[@"data"]];
          
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
    
    
}



-(void)getChooseDatas{
    [self getSalesListDatasCompliation:^(MJKClueListViewModel *saleDatasModel) {
        //类型
        NSMutableArray*TypeArr=[NSMutableArray arrayWithObjects:@"全部",@"上门测量",@"上门安装",@"上门维护",@"其他", nil];
        NSMutableArray*TypeSelectedArr=[NSMutableArray arrayWithObjects:@"",@"0",@"1",@"2",@"3", nil];
        
        //状态
        NSMutableArray*statusArr=[NSMutableArray arrayWithObjects:@"全部",@"完成",@"未完成", nil];
        NSMutableArray*statusSelectedArr=[NSMutableArray arrayWithObjects:@"",@"0",@"1", nil];
        
        //服务人员
        NSMutableArray*saleArr=[NSMutableArray arrayWithObjects:@"全部",@"我的", nil];
        NSMutableArray*saleSelectedArr=[NSMutableArray arrayWithObjects:@"",[NewUserSession instance].user.u051Id, nil];
        for (MJKClueListSubModel *clueListSubModel in saleDatasModel.data) {
            [saleArr addObject:clueListSubModel.nickName];
            [saleSelectedArr addObject:clueListSubModel.u051Id];
        }
        
        
        //工单日期
        NSMutableArray*timeArr=[NSMutableArray arrayWithObjects:@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义", nil];
        NSMutableArray*timeSelectedArr=[NSMutableArray arrayWithObjects:@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999", nil];
        
        
        //总的 筛选tableView 的数据
        NSMutableArray*totailTableDatas=[NSMutableArray arrayWithObjects:TypeArr,statusArr,saleArr,timeArr, nil];
        self.TableChooseDatas=totailTableDatas;
        NSMutableArray*totailTAbleSelected=[NSMutableArray arrayWithObjects:TypeSelectedArr,statusSelectedArr,saleSelectedArr,timeSelectedArr, nil];
        self.TableSelectedChooseDatas=totailTAbleSelected;
        
        
        [self addChooseView];
        
    }];
    
    
    
    
}


//得到销售列表
-(void)getSalesListDatasCompliation:(void(^)(MJKClueListViewModel*saleDatasModel))salesDatasBlock{
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list",HTTP_IP] parameters:@{@"C_LOCCODE" : [NewUserSession instance].user.C_LOCCODE} compliation:^(id data, NSError *error) {
  
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            MJKClueListViewModel*saleDatasModel = [MJKClueListViewModel yy_modelWithDictionary:data[@"data"]];
            salesDatasBlock(saleDatasModel);
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
    
    
}


//上传一张照片
-(void)HttpPostOneImageToJiekouWith:(NSData*)data success:(void(^)(NSString*imageStr))successBlock{
    NSString*urlStr=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:data compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            NSString*imageStr=data[@"show_url"];
            successBlock(imageStr);
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
        
    }];
    
    
    
    
}



//修改数据
-(void)httpPostUpdateOrderDetailWithSignImageStr:(NSString*)signImage  andServiceOrderSubModel:(ServiceOrderSubModel*)detailModel andComplete:(void(^)(id data))completeBlock{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_OrderUpdate];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    [contentDict setObject:detailModel.C_ID forKey:@"C_ID"];
    [contentDict setObject:signImage forKey:@"C_SIGPICTURE"];
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            completeBlock(data);
            
            
        }else{
            
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];
    
    
    
}

//完成订单
-(void)httpPostCompleteSignOrderWithServiceOrderSubModel:(ServiceOrderSubModel*)detailModel Success:(void(^)(id data))completeBlock{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_CompleteOrder];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    [contentDict setObject:detailModel.C_ID forKey:@"C_ID"];
    [contentDict setObject:@"1" forKey:@"STATUS_TYPE"];
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            completeBlock(data);
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];
    
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark -- set
-(NSMutableArray *)mainDatasArray{
    if (!_mainDatasArray) {
        _mainDatasArray=[NSMutableArray array];
    }
    return _mainDatasArray;
}



-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight-NavStatusHeight-40 - WD_TabBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
    }
    return _tableView;
}


-(NSMutableDictionary *)saveSelTableDict{
    if (!_saveSelTableDict) {
        _saveSelTableDict=[NSMutableDictionary dictionary];
    }
    return _saveSelTableDict;
}

-(NSMutableDictionary*)saveSelTimeDict{
    if (!_saveSelTimeDict) {
        _saveSelTimeDict=[NSMutableDictionary dictionary];
    }
    return _saveSelTimeDict;
}




#pragma mark  --funcation
//电话
- (void)telephoneCall:(NSInteger)index{
    long section=index/100;
    int row=index%100;
    
    
    
    ServiceOrderModel*model=self.mainDatasArray[section];
    ServiceOrderSubModel*detailModel=model.content[row];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:detailModel.C_CONTACTPHONE]]];
}

- (void)closePhone {
    [self alertViewFollow];
}

- (void)alertViewFollow {
    DBSelf(weakSelf);
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"是否新增跟进" message:nil  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        CustomerDetailInfoModel*infoModel=[[CustomerDetailInfoModel alloc]init];
//        infoModel.C_ID=weakSelf.detailModel.C_A41500_C_ID;
//        infoModel.C_HEADIMGURL=weakSelf.detailModel.C_HEADIMGURL;
//        infoModel.C_NAME=weakSelf.detailModel.C_A41500_C_NAME;
//        infoModel.C_LEVEL_DD_NAME=weakSelf.detailModel.C_LEVEL_DD_NAME;
//        infoModel.C_LEVEL_DD_ID=weakSelf.detailModel.C_LEVEL_DD_ID;
//        infoModel.C_STAGE_DD_ID = weakSelf.detailModel.C_STAGE_DD_ID;
//        infoModel.C_STAGE_DD_NAME = weakSelf.detailModel.C_STAGE_DD_NAME;
        //新增跟进
        CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
        vc.Type=CustomerFollowUpAdd;
        vc.infoModel=weakSelf.detailInfoModel;;
        vc.vcSuper=weakSelf;
        vc.followText=nil;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }];
    [alertV addAction:cancelAction];
    [alertV addAction:trueAction];
    
    [self presentViewController:alertV animated:YES completion:nil];
}


//座机
- (void)landLineCall:(NSInteger)index{
    
    long section=index/100;
    int row=index%100;
    
    
    ServiceOrderModel*model=self.mainDatasArray[section];
    ServiceOrderSubModel*detailModel=model.content[row];
    
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=@"用座机拨打";
    myView.nameStr=detailModel.C_A41500_C_NAME;
    myView.callStr=detailModel.C_CONTACTPHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}

//回呼
- (void)callBack:(NSInteger)index{
    long section=index/100;
    int row=index%100;
    
    
    ServiceOrderModel*model=self.mainDatasArray[section];
    ServiceOrderSubModel*detailModel=model.content[row];
    
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=@"回呼到手机";
    myView.nameStr=detailModel.C_A41500_C_NAME;
    myView.callStr=detailModel.C_CONTACTPHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}


@end
