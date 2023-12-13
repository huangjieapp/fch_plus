//
//  DBPhoneRecordViewController.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/24.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBPhoneRecordViewController.h"
#import "CFDropDownMenuView.h"
#import "CGCCustomDateView.h"  //选择两个时间弹窗
#import "PhoneRecordTableViewCell.h"
#import "CGCNavSearchTextView.h"
//#import <AVFoundation/AVFoundation.h>
#import "RadioPlayView.h"   //播放器

#import "PhoneRecordHomeModel.h"
#import "MJKClueListViewModel.h"    //销售列表


//#import "PYSearchViewController.h"
#import "PhoneRecordDetailViewController.h"
//#import "SelectCustomerViewController.h"
#import "MJKVoiceCViewController.h"
#import "PotentailCustomerListViewController.h"

#import "VoiceView.h"


#define CELL0    @"PhoneRecordTableViewCell"

@interface DBPhoneRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)CFDropDownMenuView*menuView;   //菜单选择栏
@property(nonatomic,strong)CGCNavSearchTextView*CurrentTitleView;  //不做属性 警告。。
@property(nonatomic,strong)RadioPlayView*radioPlayV;  //播放声音的view
@property(nonatomic,strong)UILabel*allNumberLabel;   //总计


@property(nonatomic,assign)NSInteger pagen;
@property(nonatomic,assign)NSInteger pages;  //1 开始
@property(nonatomic,strong)NSString*searchStr;   //搜索的str
@property(nonatomic,strong)NSString*typeStr;    //0呼入   1呼出
@property(nonatomic,strong)NSString*statusStr;   //全部 已处理  未处理
//拨打时间
@property(nonatomic,strong)NSString*timerStr;   //当这个是  999 的时候  用自定义时间
@property(nonatomic,strong)NSString*SYSTEMTIM_START_TIME;
@property(nonatomic,strong)NSString*SYSTEMTIM_END_TIME;
@property(nonatomic,strong)NSString*saleStr;   //销售 全部和我自己
//漏斗的筛选
@property(nonatomic,strong)NSString*LASTUPDATE_TIME_TYPE;  //处理时间
@property(nonatomic,strong)NSString*LASTUPDATE_START_TIME;
@property(nonatomic,strong)NSString*LASTUPDATE_END_TIME;


@property(nonatomic,strong)NSMutableArray*saveAllDatas;
@property(nonatomic,strong)NSString*countNumber;  //总共有多少条数据  ？

@end

@implementation DBPhoneRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"电话录音";
    
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
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self setUpNaviView];
    //先吊销售接口
    [self getChooseDatas];
    [self setUpRefresh];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     [self.tableView.mj_header beginRefreshing];
}


#pragma mark  --UI
-(void)setUpNaviView{
//    UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-20-40, 30)];
//    BGView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.8];
//    BGView.layer.cornerRadius=15;
//    BGView.layer.masksToBounds=YES;
//    self.navigationItem.titleView=BGView;
//    
//    UIButton*placeholderButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 5, KScreenWidth-20-40-20-60, 20)];
//    [placeholderButton setTitle:@"请输入手机/顾客姓名" forState:UIControlStateNormal];
//    placeholderButton.titleLabel.font=[UIFont systemFontOfSize:14];
//    [placeholderButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [placeholderButton addTarget:self action:@selector(clickSearch)];
//    [BGView addSubview:placeholderButton];
//    
//    UIButton*imageButton=[[UIButton alloc]initWithFrame:CGRectMake(BGView.width-15-15, 7.5, 15, 15)];
//    [imageButton setBackgroundImage:[UIImage imageNamed:@"放大镜"] forState:UIControlStateNormal];
//    [imageButton addTarget:self action:@selector(clickVedio)];
//    [BGView addSubview:imageButton];
    
    
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

    
    
    
    
}


-(void)addChooseViewWithMainDatas:(NSMutableArray*)mainDatas andSelectedStatus:(NSMutableArray*)selectedStatusArray andSelectedSales:(NSMutableArray*)selectedSalesArray{
    
    
    CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth-40, 40)];
    self.menuView=menuView;
    menuView.dataSourceArr=mainDatas;
    menuView.defaulTitleArray=@[@"类型",@"状态",@"拨打时间",@"员工"];
    
    
    menuView.startY=CGRectGetMaxY(menuView.frame);
    [self.view addSubview:menuView];
    
    NSArray *timecode=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
    
#pragma   各种筛选的点击事件
    DBSelf(weakSelf);
    menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
        MyLog(@"%@ %@ %@",selectedSection,selectedRow,title);
        if ([selectedSection isEqualToString:@"0"]) {
            if ([selectedRow isEqualToString:@"1"]) {
                weakSelf.typeStr=@"0";
            }else if ([selectedRow isEqualToString:@"2"]){
                weakSelf.typeStr=@"1";
            }else{
                weakSelf.typeStr=nil;
            }
            
            
            
        }else if ([selectedSection isEqualToString:@"1"]){
//            if ([selectedRow isEqualToString:@"1"]) {
//                weakSelf.statusStr=@"A45000_C_RESULT_0002";  //已处理
//            }else if ([selectedRow isEqualToString:@"2"]){
//                weakSelf.statusStr=@"A45000_C_RESULT_0001";  //未处理
//            }else{
//                weakSelf.statusStr=nil;
//            }
            
            weakSelf.statusStr=selectedStatusArray[[selectedRow integerValue]];
            
            
            
            
        }else if ([selectedSection isEqualToString:@"2"]){
            weakSelf.timerStr = timecode[selectedRow.integerValue];
            if ([weakSelf.timerStr isEqualToString:@"999"]){
                weakSelf.timerStr=@"999";
                
                //跳警告框
                [self presentAlertVC];

                
            }
            
        }else if ([selectedSection isEqualToString:@"3"]){
//            if ([selectedRow isEqualToString:@"0"]) {
//                weakSelf.saleStr=nil;
//            }else if ([selectedRow isEqualToString:@"1"]){
//                weakSelf.saleStr=[NewUserSession instance].user.u051Id;
//            }
            
            weakSelf.saleStr=selectedSalesArray[[selectedRow integerValue]];
            
        }
        
        
        if ([selectedSection isEqualToString:@"2"]&&[selectedRow isEqualToString:@"6"]) {
            
        }else{
           [weakSelf.tableView.mj_header beginRefreshing];
        }
        
        
        
        
    };
    
    
    
    //漏斗部分
    //这个是筛选的view
    
    NSArray * array16=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
    NSArray * arraySel16=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
    NSMutableArray*mtArr16=[NSMutableArray array];
    for (int i=0; i<array16.count; i++) {
        MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
        funnelModel.name=array16[i];
        funnelModel.c_id=arraySel16[i];
        [mtArr16 addObject:funnelModel];
        
    }
    NSDictionary*dic16=@{@"title":@"处理时间",@"content":mtArr16};
    
    NSMutableArray*FunnelDatas=[NSMutableArray arrayWithObjects:dic16, nil];

    
    
    FunnelShowView*funnelView=[FunnelShowView funnelShowView];
    __weak typeof(funnelView)weakFunnelView=funnelView;
    //赋值
    funnelView.allDatas=FunnelDatas;
    
    //c_id 是999 的时候  是选择时间
    funnelView.viewCustomTimeBlock = ^(NSInteger selectedSection) {
        MyLog(@"%ld",(long)selectedSection);
        if (selectedSection==0) {
            CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
                
            } withEnd:^{
                
                
            } withSure:^(NSString *start, NSString *end) {
                MyLog(@"11--%@   22--%@",start,end);
                

                self.LASTUPDATE_START_TIME=start;
                self.LASTUPDATE_END_TIME=end;
                
                
                
                
            }];
            
            
            dateView.clickCancelBlock = ^{
                NSIndexPath*indexPath=[NSIndexPath indexPathForRow:6 inSection:0];
                [weakFunnelView unselectedDetailRow:indexPath];
                
                self.LASTUPDATE_START_TIME=nil;
                self.LASTUPDATE_END_TIME=nil;
                self.LASTUPDATE_TIME_TYPE=nil;

                
            };
            
            
            
            [[UIApplication sharedApplication].keyWindow addSubview:dateView];

            
        }
        
        
    };
    
    
    
    //点击的回调
    funnelView.sureBlock = ^(NSMutableArray *array) {
        MyLog(@"%@",array);
         DBSelf(weakSelf);
        for (NSDictionary*dict in array) {
            NSString*indexStr=dict[@"index"];
            MJKFunnelChooseModel*model=dict[@"model"];
            if ([indexStr isEqualToString:@"0"]) {
                //只有0
                self.LASTUPDATE_TIME_TYPE=model.c_id;
                
                
                
            }
            
        
        
        }
        
        
        [weakSelf.tableView.mj_header beginRefreshing];
        
    };
     [[UIApplication sharedApplication].keyWindow addSubview:funnelView];
    
    
    
    //这个是漏斗按钮
    CFRightButton*funnelButton=[[CFRightButton alloc]initWithFrame:CGRectMake( KScreenWidth-40,NavStatusHeight, 40, 40)];
    [self.view addSubview:funnelButton];
    funnelButton.clickFunnelBlock = ^(BOOL isSelected) {
        //tablieView
        [menuView hide];
        //显示 左边的view
        [funnelView show];
    };

    
    
    
  
    //总计view
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


//-(void)presentAlertVC{
//    DBSelf(weakSelf);
//    UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"自定义时间" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder=@"请选择开始时间";
//        UIDatePicker*picker=[[UIDatePicker alloc]init];
//        picker.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_cn"];
//        picker.datePickerMode=UIDatePickerModeDate;
//        [picker addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
//        textField.inputView=picker;
//        self.start_TextField=textField;
//        
//    }];
//    
//    
//    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder=@"请选择结束时间";
//        UIDatePicker*picker=[[UIDatePicker alloc]init];
//        picker.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_cn"];
//        picker.datePickerMode=UIDatePickerModeDate;
//        [picker addTarget:self action:@selector(chooseCompleteDate:) forControlEvents:UIControlEventValueChanged];
//        textField.inputView=picker;
//        self.end_TextField=textField;
//        
//        
//    }];
//    UIAlertAction*sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        UITextField*startTextField= alertVC.textFields[0];
//        UITextField*endTextField=alertVC.textFields[1];
//        
//        if (startTextField.text.length<1||endTextField.text.length<1) {
//            [JRToast showWithText:@"请选择两个时间"];
//            return ;
//        }
//        
//        weakSelf.SYSTEMTIM_START_TIME=startTextField.text;
//        weakSelf.SYSTEMTIM_END_TIME=endTextField.text;
//        
//        
//        [self.tableView.mj_header beginRefreshing];
//        
//    }];
//    UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//        weakSelf.timerStr=@"1";
//        
//    }];
//    [alertVC addAction:cancel];
//    [alertVC addAction:sure];
//    [self presentViewController:alertVC animated:YES completion:nil];
//
//    
//}


#pragma mark  --tableView
-(void)setUpRefresh{
    self.pagen=10;
    self.pages=1;
    DBSelf(weakSelf);
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pages=1;
        [weakSelf getDatas];
        
    }];
    
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pages++;
        [weakSelf getDatas];
        
        
    }];
    
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.saveAllDatas.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    PhoneRecordHomeModel*sectionModel=self.saveAllDatas[section];
    return sectionModel.content.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PhoneRecordTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
   PhoneRecordHomeModel*sectionModel=self.saveAllDatas[indexPath.section];
   PhoneRecordHomeSubModel*subModel=sectionModel.content[indexPath.row];
   [cell getValue:subModel];
    
    DBSelf(weakSelf);
    cell.clickPlayBlock = ^(NSString *playUrl) {
        MyLog(@"%@",playUrl);
//        [weakSelf.radioPlayV removeFromSuperview];
//        weakSelf.radioPlayV=nil;
        
//        [weakSelf.radioPlayV PlayRadioWithStr:playUrl andSuperVC:self];

        [weakSelf.radioPlayV PlayAudioWithUrl:playUrl];
        
        
        
    };
    
    
    if (indexPath.row==sectionModel.content.count-1) {
        cell.bottomViewLeftValue.constant=0;
    }else{
        cell.bottomViewLeftValue.constant=15;
    }
    
    return cell;
    
}






-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PhoneRecordHomeModel*sectionModel=self.saveAllDatas[indexPath.section];
    PhoneRecordHomeSubModel*subModel=sectionModel.content[indexPath.row];
    DBSelf(weakSelf);

    
    PhoneRecordDetailViewController*vc=[[PhoneRecordDetailViewController alloc]init];
    vc.C_ID=subModel.C_ID;
    vc.superVC=weakSelf;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PhoneRecordHomeModel*sectionModel=self.saveAllDatas[section];

    
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 25)];
    mainView.backgroundColor=[UIColor clearColor];
    
    UILabel*leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 2.5, KScreenWidth/2, 20)];
    leftLabel.font=[UIFont systemFontOfSize:14];
    leftLabel.textColor=[UIColor grayColor];
    leftLabel.text=sectionModel.total;
    [mainView addSubview:leftLabel];
    
//    //总计多少个
//    if (section==0) {
//        UILabel*rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth-60,0 , 60, 15)];
//        rightLabel.backgroundColor=[UIColor whiteColor];
//        rightLabel.font=[UIFont systemFontOfSize:10];
//        rightLabel.textColor=[UIColor grayColor];
//        rightLabel.textAlignment=NSTextAlignmentCenter;
//        [mainView addSubview:rightLabel];
//        
//        NSString*number=self.countNumber;
//        rightLabel.text=[NSString stringWithFormat:@"总计%@",number];
//        
//    }
    
    
    
    
    
    return mainView;
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    PhoneRecordHomeModel*sectionModel=self.saveAllDatas[indexPath.section];
    PhoneRecordHomeSubModel*subModel=sectionModel.content[indexPath.row];
    if ([subModel.C_RESULT_DD_NAME isEqualToString:@"未分配"]) {
        
        return YES;
    }
    
    
    return NO;
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    PhoneRecordHomeModel*sectionModel=self.saveAllDatas[indexPath.section];
    PhoneRecordHomeSubModel*subModel=sectionModel.content[indexPath.row];
    DBSelf(weakSelf);
    
    if (![subModel.C_RESULT_DD_NAME isEqualToString:@"未分配"]) {
        
        return nil;
    }

    
    
    
    UITableViewRowAction*FollowUpAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"转跟进" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf transFormFollow:subModel.C_ID];
        
        
        
       
        
        
    }];
    FollowUpAction.backgroundColor=[UIColor colorWithHexString:@"#FFC300"];
    
    
    UITableViewRowAction*FlowAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"转来电" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [weakSelf transFlowStream:subModel.C_ID andModel:subModel];
        
   
        
        
    }];
    FlowAction.backgroundColor=[UIColor colorWithHexString:@"#FFC300"];

    
    
    
    
    UITableViewRowAction*invalidAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"无效" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf phoneRecordInvailWithStr:@"0" andC_id:subModel.C_ID];

        
    }];
    invalidAction.backgroundColor=[UIColor colorWithHexString:@"#999999"];
   
    
    UITableViewRowAction*employeeAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"员工" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [weakSelf phoneRecordInvailWithStr:@"3" andC_id:subModel.C_ID];
    }];
    employeeAction.backgroundColor=[UIColor colorWithHexString:@"#3297EA"];
    
    
    if ([subModel.I_DIRECTION isEqualToString:@"0"]) {
        return @[employeeAction,invalidAction,FlowAction];
        
    }else if ([subModel.I_DIRECTION isEqualToString:@"1"]){
        return @[employeeAction,invalidAction,FollowUpAction];
    }
    
    
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


-(void)transFormFollow:(NSString*)callRecord_ID{
//    SelectCustomerViewController *myView=[[SelectCustomerViewController alloc]initWithNibName:@"SelectCustomerViewController" bundle:nil];
//    myView.type=@"callRecord";
//    myView.callRecord_ID=callRecord_ID;
//    [self.navigationController pushViewController:myView animated:YES];
    DBSelf(weakSelf);
    
    //转跟进
    PotentailCustomerListViewController*vc=[[PotentailCustomerListViewController alloc]init];
    vc.timerType=customerListTimeTypeRecordToFollow;
    vc.recordID=callRecord_ID;
    vc.followVC=weakSelf;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

//转来电
-(void)transFlowStream:(NSString*)callRecord_ID andModel:(PhoneRecordHomeSubModel*)subModel{
    DBSelf(weakSelf);
    //新增来电
    //呼入号码  来电时间   录音id
    
}


#pragma mark  -- touch
//-(void)clickSearch{
//    PYSearchViewController*searchVC=[PYSearchViewController searchViewControllerWithHotSearches:@[@"tim",@"sam",@"jam",@"tom"] searchBarPlaceholder:@"请输入搜索关键字" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
//        
//    }];
//    [self.navigationController pushViewController:searchVC animated:YES];
//    
//    
//}


//-(void)chooseDate:(UIDatePicker*)picker{
//      MyLog(@"1");
//    NSDate*date=picker.date;
//    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
//    formatter.dateFormat=@"yyyy-MM-dd";
//    NSString*time=[formatter stringFromDate:date];
//    self.start_TextField.text=time;
//    
//    
//}


//-(void)chooseCompleteDate:(UIDatePicker*)picker{
//    NSDate*date=picker.date;
//    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
//    formatter.dateFormat=@"yyyy-MM-dd";
//    NSString*time=[formatter stringFromDate:date];
//    self.end_TextField.text=time;
//
//    
//}

-(void)clickVedio{
    MyLog(@"语音");
    
    
}


#pragma mark  -- datas
-(void)getDatas{
    NSMutableDictionary*MainDic=[DBObjectTools getAddressDicWithAction:HTTP_recordSound];
    NSMutableDictionary*mtDict=[NSMutableDictionary new];
    [mtDict setObject:@(self.pages) forKey:@"currPage"];
    [mtDict setObject:@(self.pagen) forKey:@"pageSize"];
    
    //搜索
    if (self.searchStr&&![self.searchStr isEqualToString:@""]) {
        [mtDict setObject:self.searchStr forKey:@"SEARCH_CALL"];
    }

    
    
    if (self.typeStr) {
        [mtDict setObject:self.typeStr forKey:@"I_CHANNEL"];
    }
    
    //拨打时间
    if (self.timerStr) {
        if ([self.timerStr isEqualToString:@"999"]) {
            if (self.SYSTEMTIM_START_TIME) {
                 [mtDict setObject:self.SYSTEMTIM_START_TIME forKey:@"SYSTEMTIM_START_TIME"];
            }
           
            if (self.SYSTEMTIM_END_TIME) {
                 [mtDict setObject:self.SYSTEMTIM_END_TIME forKey:@"SYSTEMTIM_END_TIME"];
            }
            
           
            
        }else{
            [mtDict setObject:self.timerStr forKey:@"SYSTEMTIM_TIME_TYPE"];
            
        }
    }
    
    
    if (self.statusStr) {
        [mtDict setObject:self.statusStr forKey:@"C_RESULT_DD_ID"];
    }
    
    
    if (self.saleStr) {
        [mtDict setObject:self.saleStr forKey:@"USER_ID"];
    }
    
    
    
    //漏斗的 处理时间
    if (self.LASTUPDATE_TIME_TYPE) {
        if ([self.LASTUPDATE_TIME_TYPE isEqualToString:@"999"]) {
            if (self.LASTUPDATE_START_TIME) {
                [mtDict setObject:self.LASTUPDATE_START_TIME forKey:@"LASTUPDATE_START_TIME"];
            }
            
            if (self.LASTUPDATE_END_TIME) {
                [mtDict setObject:self.LASTUPDATE_END_TIME forKey:@"LASTUPDATE_END_TIME"];
            }
            
            
            
        }else{
            [mtDict setObject:self.LASTUPDATE_TIME_TYPE forKey:@"LASTUPDATE_TIME_TYPE"];
            
        }
    }

    
    
    
    
    
    [MainDic setObject:mtDict forKey:@"content"];
    NSString*params=[DBObjectTools getPostStringAddressWithMainDict:MainDic withtype:@"3"];
    
    DBSelf(weakSelf);
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:params parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if (self.pages==1) {
                [self.saveAllDatas removeAllObjects];
            }
            
           
            NSArray*array=data[@"content"];
            for (NSDictionary*dict in array) {
                PhoneRecordHomeModel*model=[PhoneRecordHomeModel yy_modelWithDictionary:dict];
                [self.saveAllDatas addObject:model];
                
            }
            NSNumber*number=data[@"countNumber"];
            self.allNumberLabel.text=[NSString stringWithFormat:@"总计:%@",number];
            
            [self.tableView reloadData];
            
            
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    }];
    
    
    
    
    
    
    
    
}


//跳弹窗
-(void)presentAlertVC{
    //创建时间
    CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
        
    } withEnd:^{
        
    } withSure:^(NSString *start, NSString *end) {
        MyLog(@"11--%@   22--%@",start,end);
        self.SYSTEMTIM_START_TIME=start;
        self.SYSTEMTIM_END_TIME=end;
        [self.tableView.mj_header beginRefreshing];
        
    }];
    
    dateView.clickCancelBlock = ^{
        [self.menuView.dropDownMenuTableView.delegate tableView:self.menuView.dropDownMenuTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        
    };
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:dateView];
    
    
}




//无效和员工
-(void)phoneRecordInvailWithStr:(NSString*)str andC_id:(NSString*)c_id{
//    0无效 3员工
    if (![str isEqualToString:@"0"]&&![str isEqualToString:@"3"]) {
        [JRToast showWithText:@"代码写错"];
        return;
    }
    
    
    
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_RecordInvail];
    NSDictionary*dict=@{@"C_ID":c_id,@"TYPE":str};
    [mainDict setObject:dict forKey:@"content"];
    NSString*paramStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:paramStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
             [JRToast showWithText:data[@"message"]];
            [self.tableView.mj_header beginRefreshing];
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];
    
    
    
}

//得到销售列表
-(void)getSalesListDatasCompliation:(void(^)(MJKClueListViewModel*saleDatasModel))salesDatasBlock{
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list",HTTP_IP] parameters:@{@"C_LOCCODE" : [NewUserSession instance].user.C_LOCCODE} compliation:^(id data, NSError *error) {
    
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            MJKClueListViewModel*saleDatasModel = [MJKClueListViewModel yy_modelWithDictionary:data];
            salesDatasBlock(saleDatasModel);
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
    
    
}



-(void)getChooseDatas{
     [self getSalesListDatasCompliation:^(MJKClueListViewModel *saleDatasModel) {
         MyLog(@"%@",saleDatasModel);
         //类型
         NSMutableArray*typeArray=[NSMutableArray arrayWithObjects:@"全部",@"呼入",@"呼出", nil];
         
         //状态
         NSMutableArray*statusArr=[NSMutableArray arrayWithObjects:@"全部", nil];
         NSMutableArray*statusSelectedArr=[NSMutableArray arrayWithObjects:@"", nil];
         for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A45000_C_RESULT"]) {
             [statusArr addObject:model.C_NAME];
             [statusSelectedArr addObject:model.C_VOUCHERID];
             
         }

         //拨打时间
         NSMutableArray*callTimeArray=[NSMutableArray arrayWithObjects:@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义", nil];
         
         
         //销售
         NSMutableArray*saleArr=[NSMutableArray arrayWithObjects:@"全部",@"我的", nil];
         NSMutableArray*saleSelectedArr=[NSMutableArray arrayWithObjects:@"",[NewUserSession instance].user.u051Id, nil];
         for (MJKClueListSubModel *clueListSubModel in saleDatasModel.data) {
             [saleArr addObject:clueListSubModel.nickName];
             [saleSelectedArr addObject:clueListSubModel.u051Id];
         }

         
         
         NSMutableArray*dataSourceArr=[NSMutableArray arrayWithObjects:typeArray,statusArr,callTimeArray,saleArr, nil];
         
         
       [self addChooseViewWithMainDatas:dataSourceArr andSelectedStatus:statusSelectedArr andSelectedSales:saleSelectedArr];
         
         
         
         
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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight+40, KScreenWidth, KScreenHeight-NavStatusHeight-40-WD_TabBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
    }
    return _tableView;
}

-(NSMutableArray *)saveAllDatas{
    if (!_saveAllDatas) {
        _saveAllDatas=[NSMutableArray array];
    }
    return _saveAllDatas;
}

-(RadioPlayView *)radioPlayV{
    if (!_radioPlayV) {
        _radioPlayV=[[RadioPlayView alloc]initWithFrame:CGRectMake(0, KScreenHeight-70, KScreenWidth, 70)];
        [self.view addSubview:_radioPlayV];
    }
    
    return _radioPlayV;
}


@end
