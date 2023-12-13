//
//  SHUserArchivingViewController.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/11.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHUserArchivingViewController.h"

#import "SetNameViewController.h"
#import "PickerChoiceView.h"
#import "TwoClassChoosePickView.h"

@interface SHUserArchivingViewController ()<UITableViewDelegate,UITableViewDataSource,TFPickerDelegate>

@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)NSArray*localDatas;
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,assign)NSInteger selectedCellIndexRow;   //选中的cell 的row
@end

@implementation SHUserArchivingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"用户建档";
    [self.view addSubview:self.tableView];
   
    [self creatLocalDatas];
    [self falseData];
    
}

#pragma mark  --UI
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.localDatas.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return [self.localDatas[section] count];
    }else{
        return [self.localDatas[section] count];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text=self.localDatas[indexPath.section][indexPath.row];
    cell.detailTextLabel.text=self.dataArray[indexPath.section][indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        //顾客名字
        SetNameViewController*vc=[[SetNameViewController alloc]initWithNibName:@"SetNameViewController" bundle:nil];
        vc.textFieldString=self.dataArray[indexPath.section][indexPath.row];
        vc.typee=TypeWriteCustomName;
        DBSelf(weakSelf);
        [self.navigationController pushViewController:vc animated:YES];
        vc.saveBlock=^(NSString*str){
            MyLog(@"%@",str);

            weakSelf.dataArray[indexPath.section][indexPath.row]=str;

            [weakSelf.tableView reloadData];
            //修改的接口
//            [self changePersonInfo];
            
            
        };

        
        
    }else if (indexPath.section==0&&indexPath.row==1){
        //联系电话
        SetNameViewController*vc=[[SetNameViewController alloc]initWithNibName:@"SetNameViewController" bundle:nil];
        vc.textFieldString=self.dataArray[indexPath.section][indexPath.row];
        vc.typee=TypeWriteCustomPhoneNUmber;
        DBSelf(weakSelf);
        [self.navigationController pushViewController:vc animated:YES];
        vc.saveBlock=^(NSString*str){
            MyLog(@"%@",str);
            
            weakSelf.dataArray[indexPath.section][indexPath.row]=str;
            
            [weakSelf.tableView reloadData];
            //修改的接口
            //            [self changePersonInfo];
            
            
        };

    }else if (indexPath.section==1&&indexPath.row==0){
        //车辆号牌
        SetNameViewController*vc=[[SetNameViewController alloc]initWithNibName:@"SetNameViewController" bundle:nil];
        vc.textFieldString=self.dataArray[indexPath.section][indexPath.row];
        vc.typee=TypeWriteCarNumber;
        DBSelf(weakSelf);
        [self.navigationController pushViewController:vc animated:YES];
        vc.saveBlock=^(NSString*str){
            MyLog(@"%@",str);
            
            weakSelf.dataArray[indexPath.section][indexPath.row]=str;
            
            [weakSelf.tableView reloadData];
            //修改的接口
            //            [self changePersonInfo];
            
            
        };
 
        
        
        
        
    }else if (indexPath.section==1&&indexPath.row==1){
        //行驶里程
        SetNameViewController*vc=[[SetNameViewController alloc]initWithNibName:@"SetNameViewController" bundle:nil];
        vc.textFieldString=self.dataArray[indexPath.section][indexPath.row];
        vc.typee=TypeWriteCarkm;
        DBSelf(weakSelf);
        [self.navigationController pushViewController:vc animated:YES];
        vc.saveBlock=^(NSString*str){
            MyLog(@"%@",str);
            
            weakSelf.dataArray[indexPath.section][indexPath.row]=str;
            
            [weakSelf.tableView reloadData];
            //修改的接口
            //            [self changePersonInfo];
            
            
        };

        
        
        
        
        
        
        
    }else if (indexPath.section==1&&indexPath.row==2){
        //车系
        [TwoClassChoosePickView showTwoClassChoosePickViewWithComplete:^(NSString *firstStr, NSString *secondStr) {
            MyLog(@"%@   %@",firstStr,secondStr);
            
        }];
        
    }else if (indexPath.section==1&&indexPath.row==3){
        //购买时间
        PickerChoiceView*pickVC=[[PickerChoiceView alloc]initWithFrame:self.view.bounds];
        pickVC.delegate=self;
        pickVC.arrayType=DeteArray;
        self.selectedCellIndexRow=indexPath.row;
        [self.view addSubview:pickVC];

        
        
    }else if (indexPath.section==1&&indexPath.row==4){
        //保险到期时间
        PickerChoiceView*pickVC=[[PickerChoiceView alloc]initWithFrame:self.view.bounds];
        pickVC.delegate=self;
        pickVC.arrayType=DeteArray;
        self.selectedCellIndexRow=indexPath.row;
        [self.view addSubview:pickVC];

        
    }else if (indexPath.section==1&&indexPath.row==5){
        //保养到期时间
        PickerChoiceView*pickVC=[[PickerChoiceView alloc]initWithFrame:self.view.bounds];
        pickVC.delegate=self;
        pickVC.arrayType=DeteArray;
        self.selectedCellIndexRow=indexPath.row;
        [self.view addSubview:pickVC];

        
    }else if (indexPath.section==1&&indexPath.row==6){
        //更新时间
        PickerChoiceView*pickVC=[[PickerChoiceView alloc]initWithFrame:self.view.bounds];
        pickVC.delegate=self;
        pickVC.arrayType=DeteArray;
        self.selectedCellIndexRow=indexPath.row;
        [self.view addSubview:pickVC];

        
    }
    
    
}




-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView*topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
        topView.backgroundColor=[UIColor clearColor];
        
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(15, 2.5, KScreenWidth/2, 15)];
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=[UIColor lightGrayColor];
        label.text=@"车主信息";
        [topView addSubview:label];
        
        
        return topView;
    }else if (section==1){
        UIView*topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
        topView.backgroundColor=[UIColor clearColor];
        
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(15, 2.5, KScreenWidth/2, 15)];
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=[UIColor lightGrayColor];
        label.text=@"车辆信息";
        [topView addSubview:label];
        
        
        return topView;

        
        
    }else{
        return nil;
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1) {
        UIView*bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 140)];
        bgView.backgroundColor=[UIColor whiteColor];
        
        UIButton*saveCustom=[[UIButton alloc]initWithFrame:CGRectMake(20, 140-15-50, KScreenWidth/2-20-10, 50)];
        saveCustom.backgroundColor=[UIColor lightGrayColor];
        saveCustom.titleColor=[UIColor blackColor];
        [saveCustom setTitle:@"保存客户"];
        [saveCustom addTarget:self action:@selector(clickSaveCustom)];
        [bgView addSubview:saveCustom];
        
        UIButton*saveAndAttention=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/2+10, 140-15-50, KScreenWidth/2-20-10, 50)];
        saveAndAttention.backgroundColor=[UIColor lightGrayColor];
        saveAndAttention.titleColor=[UIColor blackColor];
        [saveAndAttention setTitle:@"保存并关注微信"];
        [saveAndAttention addTarget:self action:@selector(clickSaveAndAttentionWechat)];
        [bgView addSubview:saveAndAttention];

        
        return bgView;
    }else{
        return nil;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 0.01;
    }else if (section==1){
        return 140;
    }else{
        return 0.01;
    }
}


#pragma mark  --delegate
- (void)PickerSelectorIndixString:(NSString *)str{
    switch (self.selectedCellIndexRow) {
        case 3:{
            self.dataArray[1][self.selectedCellIndexRow]=str;
            [self.tableView reloadData];
            //接口；
            
            break;}
        case 4:{
            self.dataArray[1][self.selectedCellIndexRow]=str;
            [self.tableView reloadData];
            //接口；

            
            break;}
        case 5:{
            self.dataArray[1][self.selectedCellIndexRow]=str;
            [self.tableView reloadData];
            //接口；

            
            break;}
        case 6:{
            self.dataArray[1][self.selectedCellIndexRow]=str;
            [self.tableView reloadData];
            //接口；

            
            break;}
            
        default:
            break;
    }
    
}

#pragma mark  --touch
-(void)clickSaveCustom{
    MyLog(@"1");
    
}

-(void)clickSaveAndAttentionWechat{
    MyLog(@"2");
    
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
-(void)falseData{
    NSMutableArray*array=[NSMutableArray arrayWithObjects:@"bee",@"", nil];
    NSMutableArray*array1=[NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
    self.dataArray=[NSMutableArray arrayWithObjects:array,array1, nil];
    
//    NSArray*array=@[@"bee",@""];
//     NSArray*array1=@[@"",@"",@"",@"",@"",@"",@""];
//    self.dataArray=@[array,array1];
    
}


-(void)creatLocalDatas{
    NSArray*array=@[@"客户姓名",@"联系电话"];
    NSArray*array1=@[@"车辆号牌",@"行驶里程",@"车系",@"购买时间",@"保险到期时间",@"保养到期时间",@"更新时间"];
    self.localDatas=@[array,array1];
    
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

@end
