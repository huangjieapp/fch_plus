//
//  PhoneRecordDetailViewController.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/25.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "PhoneRecordDetailViewController.h"
#import "PhoneRecordDetailModel.h"



#import "PotentailCustomerListViewController.h"

@interface PhoneRecordDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)PhoneRecordDetailModel*MainModel;
@property(nonatomic,strong)NSMutableArray*saveAllDatas;

@end

@implementation PhoneRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self setMJRefreshUp];
    
    
    
}

#pragma mark  --UI
-(void)setMJRefreshUp{
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDatas];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.saveAllDatas.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray*array=self.saveAllDatas[section];
    return array.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    NSArray*array=self.saveAllDatas[indexPath.section];
    NSDictionary*dict=array[indexPath.row];
    
    
    cell.textLabel.text=dict[@"title"];
    cell.detailTextLabel.text=dict[@"detail"];
    
    
    return cell;
    
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        NSString*phoneNumber;
        if ([self.MainModel.I_DIRECTION isEqualToString:@"0"]) {
            phoneNumber=self.MainModel.C_CALLER;
        }else if ([self.MainModel.I_DIRECTION isEqualToString:@"1"]){
            phoneNumber=self.MainModel.C_CALLED;
        }
        NSString*fourNumber=[phoneNumber substringWithRange:NSMakeRange(phoneNumber.length-4, 4)];
        
        
        UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 115)];
        BGView.backgroundColor=DBColor(247, 247, 247);
        
        
        UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 95)];
        mainView.backgroundColor=[UIColor whiteColor];
        [BGView addSubview:mainView];
        
        UIView*sbgView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, 50, 50)];
        sbgView.backgroundColor=DBColor(229, 229, 229);
        sbgView.centerX=mainView.centerX;
        [mainView addSubview:sbgView];
        
        UILabel*bgLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 45, 15)];
        bgLabel.font=[UIFont systemFontOfSize:14];
        bgLabel.center=CGPointMake(25, 25);
        bgLabel.textAlignment=NSTextAlignmentCenter;
        bgLabel.text=@"4190";
        [sbgView addSubview:bgLabel];
        
        
        UILabel*bottomLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, sbgView.bottom+6, KScreenWidth-40, 18)];
        bottomLabel.font=[UIFont systemFontOfSize:14];
        bottomLabel.textAlignment=NSTextAlignmentCenter;
        bottomLabel.text=@"017791654190";
        [mainView addSubview:bottomLabel];
        

        //底部的
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(15, 2+mainView.bottom, KScreenWidth/3*2, 16)];
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=[UIColor grayColor];
        label.text=@"流量信息";
        [BGView addSubview:label];

        
        //赋值
        bgLabel.text=fourNumber;
        bottomLabel.text=phoneNumber;
        
        
         return BGView;
        
    }else{
        UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
        BGView.backgroundColor=DBColor(247, 247, 247);
        
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(15, 2, KScreenWidth/3*2, 16)];
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=[UIColor grayColor];
        label.text=@"处理信息";
        [BGView addSubview:label];
        
        return BGView;
        
    }
    
    return nil;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1) {
        if ([self.MainModel.C_RESULT_DD_NAME isEqualToString:@"未分配"]) {
            
            UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
            BGView.backgroundColor=[UIColor whiteColor];
            
            UIButton*topButton=[[UIButton alloc]initWithFrame:CGRectMake(15, 15, KScreenWidth-30, 50)];
            [topButton setTitleColor:[UIColor whiteColor]];
            [topButton setBackgroundColor:KNaviColor];
            topButton.layer.cornerRadius=10;
            topButton.layer.masksToBounds=YES;
            [topButton addTarget:self action:@selector(clickTopButton:)];
            [BGView addSubview:topButton];
            
            UIButton*employeeButton=[[UIButton alloc]initWithFrame:CGRectMake(15, topButton.bottom+15, (KScreenWidth-60)/2, 50)];
            [employeeButton setBackgroundColor:DBColor(204, 204, 204)];
            [employeeButton setTitleColor:[UIColor blackColor]];
            employeeButton.layer.cornerRadius=10;
            employeeButton.layer.masksToBounds=YES;
            [employeeButton setTitleNormal:@"员工"];
            [employeeButton addTarget:self action:@selector(clickEmployeeButton:)];
            [BGView addSubview:employeeButton];

            UIButton*invalidButton=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/2+15, topButton.bottom+15, (KScreenWidth-60)/2, 50)];
            [invalidButton setBackgroundColor:DBColor(204, 204, 204)];
            [invalidButton setTitleColor:[UIColor blackColor]];
            invalidButton.layer.cornerRadius=10;
            invalidButton.layer.masksToBounds=YES;
            [invalidButton setTitleNormal:@"无效"];
            [invalidButton addTarget:self action:@selector(clickinvalidButton:)];
            [BGView addSubview:invalidButton];

            
            
            
            
            
            //两种情况。   0呼入和 1呼出
            if ([self.MainModel.I_DIRECTION isEqualToString:@"0"]) {
                //转来电
                topButton.tag=111;
                [topButton setTitleNormal:@"转来电"];
                return BGView;
                
            }else if ([self.MainModel.I_DIRECTION isEqualToString:@"1"]){
                //转跟进
                topButton.tag=222;
                [topButton setTitleNormal:@"转跟进"];
                return BGView;
                
            }else{
                return nil;
            }
            
            
         
            
        }else{
            return nil;
        }
        
        
        
    }
    return nil;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 115;
    }else{
        return 20;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        if ([self.MainModel.C_RESULT_DD_NAME isEqualToString:@"未分配"]) {
            return 150;
            
        }else{
            return 0.01;
        }
        
    }
    
    return 0.01;
}


#pragma mark  --touch
-(void)clickTopButton:(UIButton*)sender{
    if ([sender.titleNormal isEqualToString:@"转来电"]) {
          MyLog(@"转来电");
        DBSelf(weakSelf);
       
        
        
    }else if ([sender.titleNormal isEqualToString:@"转跟进"]){
          MyLog(@"转跟进");
        //转跟进
         DBSelf(weakSelf);
        PotentailCustomerListViewController*vc=[[PotentailCustomerListViewController alloc]init];
        vc.timerType=customerListTimeTypeRecordToFollow;
        vc.recordID=self.MainModel.C_ID;
        vc.followVC=weakSelf.superVC;
        [self.navigationController pushViewController:vc animated:YES];

        
    }else{
          MyLog(@"sb");
    }
    
  
    
}

-(void)clickEmployeeButton:(UIButton*)sender{

    
  
    [self phoneRecordInvailWithStr:@"3" andC_id:self.C_ID];
   
}

-(void)clickinvalidButton:(UIButton*)sender{
  
  
    [self phoneRecordInvailWithStr:@"0" andC_id:self.C_ID];
   

    
}



#pragma mark  --getDatas
-(void)getDatas{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_recordDetailInfo];
    NSDictionary*dict=@{@"C_ID":self.C_ID};
    [mainDict setObject:dict forKey:@"content"];
    NSString*paramStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:paramStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        [self.saveAllDatas removeAllObjects];
        if ([data[@"code"] integerValue]==200) {
            NSDictionary*dict=data;
            self.MainModel=[PhoneRecordDetailModel yy_modelWithDictionary:dict];
            
            NSArray*array0=@[@{@"title":@"来店时间",@"detail":self.MainModel.D_SYSTEMTIM},
                             @{@"title":@"处理状态",@"detail":self.MainModel.C_RESULT_DD_NAME},
                             @{@"title":@"来电次数",@"detail":self.MainModel.I_ARRIVAL}
                             ];
            
            NSArray*array1=@[@{@"title":@"上次接待员工",@"detail":self.MainModel.C_LAST_OWNER_NAME},
                             @{@"title":@"上次处理时间",@"detail":self.MainModel.D_LAST_UPDATE_TIME},
                             @{@"title":@"上次处理结果",@"detail":self.MainModel.C_LASTC_RESULT_DD_NAME},
                             @{@"title":@"关联会员",@"detail":self.MainModel.C_LAST_A41500_NAME}
                             ];

            [self.saveAllDatas addObject:array0];
            [self.saveAllDatas addObject:array1];
            [self.tableView reloadData];
            
            
            //C_RESULT_DD_NAME
            if ([self.MainModel.C_RESULT_DD_NAME isEqualToString:@"未分配"]) {
                self.title=@"录音处理";
            }else{
                self.title=@"录音详情";
            }
            
            
            
            
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
        [self.tableView.mj_header endRefreshing];
        
        
        
    }];
    
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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
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


@end
