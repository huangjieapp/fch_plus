//
//  CreatRemindViewController.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CreatRemindViewController.h"
#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "CGCNewAppointTextCell.h"


#define inputCell  @"AddCustomerInputTableViewCell"
#define chooseCell @"AddCustomerChooseTableViewCell"
#define RemarkCell @"CGCNewAppointTextCell"

@interface CreatRemindViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;


@property(nonatomic,assign)BOOL canSave;
@property(nonatomic,strong)NSString*titleStr;
@property(nonatomic,strong)NSString*startStr;
@property(nonatomic,strong)NSString*endStr;
@property(nonatomic,strong)NSString*remarkStr;

@end

@implementation CreatRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type==RemindTypeAdd) {
        self.title=@"添加备忘";
        UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(Clickcomplete)];
        item.tintColor=[UIColor blackColor];
        self.navigationItem.rightBarButtonItem=item;

    }else{
        self.title=@"备忘录详情";
        [self httpPostGetRemindInfo];
    }
    
    
        [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:inputCell bundle:nil] forCellReuseIdentifier:inputCell];
    [self.tableView registerNib:[UINib nibWithNibName:chooseCell bundle:nil] forCellReuseIdentifier:chooseCell];
    [self.tableView registerNib:[UINib nibWithNibName:RemarkCell bundle:nil] forCellReuseIdentifier:RemarkCell];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        AddCustomerInputTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:inputCell];

        cell.nameTitleLabel.text=@"标题";
        cell.inputTextField.placeholder=@"请输入";
        
        cell.inputTextField.text=self.titleStr;
        
        cell.changeTextBlock = ^(NSString *textStr) {
            MyLog(@"%@",textStr);
            self.titleStr=textStr;
            
        };
        
        
        
        if (self.type==RemindTypeShow) {
            cell.inputTextField.userInteractionEnabled=NO;
        }
        
        
        
        return cell;
    }else if (indexPath.row==1){
        AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:chooseCell];
        
        
        cell.taglabel.hidden=YES;
        cell.nameTitleLabel.text=@"开始";
        if (self.startStr.length > 0) {
            cell.textStr=self.startStr;
        } else {
            cell.textStr=[DBTools getTimeFomatFromCurrentTimeStamp];
            self.startStr=cell.textStr;
        }

        

        cell.Type=ChooseTableViewTypeAllTime;
        __weak typeof(cell) weakCell=cell;
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            MyLog(@"str-- %@      post---%@",str,postValue);

            self.startStr=str;
            weakCell.textStr=self.startStr;
            
            
        };

        
        if (self.type==RemindTypeShow) {
            cell.chooseTextField.userInteractionEnabled=NO;
        }
        
        
     
        return cell;
    }else if (indexPath.row==2){
        AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:chooseCell];
        cell.textStr=self.endStr;
        cell.taglabel.hidden=YES;
        cell.nameTitleLabel.text=@"结束";
//        cell.textStr=nil;
        cell.Type=ChooseTableViewTypeAllTime;
         __weak typeof(cell) weakCell=cell;
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            MyLog(@"str-- %@      post---%@",str,postValue);
            self.endStr=str;
            weakCell.textStr=self.endStr;

            
            
        };
        
        
        
        if (self.type==RemindTypeShow) {
            cell.chooseTextField.userInteractionEnabled=NO;
        }
        
        return cell;

        
    }
    
    
    
    
    else if (indexPath.row==3){
		DBSelf(weakSelf);
        CGCNewAppointTextCell*cell=[tableView dequeueReusableCellWithIdentifier:RemarkCell];
        cell.topTitleLabel.text=@"备注";
        cell.textView.text = self.remarkStr;
        cell.changeTextBlock = ^(NSString *textStr) {

            weakSelf.remarkStr=textStr;
        };
        
        
        if (self.type==RemindTypeShow) {
            cell.textView.userInteractionEnabled=NO;
        }
        
        
        return cell;

        
        
        
    }
    
    
    
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==3) {
        return 100;
    }else{
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.type==RemindTypeShow&&[self.C_PROCESS isEqualToString:@"未处理"]) {
        UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 120)];
        mainView.backgroundColor=[UIColor clearColor];
        
        UIButton*sureButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 20, KScreenWidth-40, 40)];
        sureButton.backgroundColor=KNaviColor;
        sureButton.titleColor=[UIColor blackColor];
        sureButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [sureButton addTarget:self action:@selector(clickBottomComp)];
        [sureButton setTitleNormal:@"已完成"];
        sureButton.layer.cornerRadius=6;
        sureButton.layer.masksToBounds=YES;
        [mainView addSubview:sureButton];
        
        UIButton*cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(20, sureButton.bottom+10, KScreenWidth-40, 40)];
        cancelButton.backgroundColor=[UIColor lightGrayColor];
        cancelButton.titleColor=[UIColor blackColor];
        cancelButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [cancelButton addTarget:self action:@selector(clickBottomDelete)];
        [cancelButton setTitleNormal:@"删除"];
        cancelButton.layer.cornerRadius=6;
        cancelButton.layer.masksToBounds=YES;
        [mainView addSubview:cancelButton];
        
        
        
        return mainView;
    }else{
        return nil;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.type==RemindTypeShow) {
        return 120;
    }else{
        return 0.01;
    }

    
}


#pragma mark  --click
-(void)clickBottomComp{
    [self httpPostOperationRemarkWith:@"0"];
    
}

-(void)clickBottomDelete{
    [self httpPostOperationRemarkWith:@"1"];
    
}


-(void)Clickcomplete{

    NSString*judgeStr=[self judegeCanSave];
    if (!_canSave) {
        [JRToast showWithText:judgeStr];
        return;
    }
    
    [self httpPostCompleteAdd];
    
    
    
}

-(NSString*)judegeCanSave{
        _canSave=YES;
   
    
    
    
    if (!self.titleStr) {
        _canSave=NO;
        return @"标题不能为空";
    }else if (!self.startStr){
        _canSave=NO;
        return @"开始时间不能为空";
    }else if (!self.endStr){
        _canSave=NO;
        return @"结束时间不能为空";
    }
    
    
    
//    else if (!self.remarkStr){
//        _canSave=NO;
//        return @"备注不能为空";
//    }
    
    
    
//    NSDate*startDate =[DBTools TimeGetDateStr:self.startStr andFormatterType:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate*endDate=[DBTools TimeGetDateStr:self.endStr andFormatterType:@"yyyy-MM-dd HH:mm:ss"];
    NSInteger aa = [self compareDate:self.startStr withDate:self.endStr];
    if (aa == -1) {
        _canSave=NO;
        return @"开始时间不能大于结束时间";
    }
    
    
    
    return @"";
}

- (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa = 0;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    dateformater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame)
    {
        //        相等
        aa=0;
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else {
        //bDate比aDate小
        aa=-1;
        
    }
    
    return aa;
}


#pragma mark  --Datas
//新增 备忘录
-(void)httpPostCompleteAdd{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_AddRemind];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    NSString*C_id=[DBObjectTools getVustomerFollowC_id];
    [contentDict setObject:C_id forKey:@"C_ID"];
    
    if (self.titleStr) {
        [contentDict setObject:self.titleStr forKey:@"C_NAME"];
    }
    if (self.startStr) {
        [contentDict setObject:self.startStr forKey:@"D_FOLLOW_TIME"];
    }
    if (self.endStr) {
        [contentDict setObject:self.endStr forKey:@"D_END_TIME"];
    }
	if (self.remarkStr) {
		[contentDict setObject:self.remarkStr forKey:@"X_REMARK"];
	}
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
    
    
    
}



-(void)httpPostGetRemindInfo{
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:HTTP_FollowInfo parameters:@{@"C_A41600_C_ID":self.C_A41600_C_ID} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            self.titleStr=data[@"data"][@"C_NAME"];
            self.startStr=data[@"data"][@"D_FOLLOW_TIME"];
            self.endStr=data[@"data"][@"D_END_TIME"];
            self.remarkStr = data[@"data"][@"X_REMARK"];
            
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }

        
    }];
    
  

    
    
}

//0是完成  1是删除
-(void)httpPostOperationRemarkWith:(NSString*)str{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_OperationRemark];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionaryWithDictionary:@{@"C_ID":self.C_A41600_C_ID,@"TYPE":str}];
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
 
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


#pragma mark  --funcation
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[DBTools findFirstResponderBeneathView:self.view] resignFirstResponder];
}

@end
