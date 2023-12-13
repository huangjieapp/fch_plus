//
//  OnlineExhibtionSettingViewController.m
//  mcr_s
//
//  Created by bipyun on 16/11/4.
//  Copyright © 2016年 match. All rights reserved.
//

#import "OnlineExhibtionSettingViewController.h"
#import "MBProgressHUD.h"
#import "KVNProgress.h"
#import "MJRefresh.h"
#import "OnlineExhibtionSettingTableViewCell.h"
#import "MJKThreeAlertView.h"
#import <AVKit/AVKit.h>
@interface OnlineExhibtionSettingViewController ()<MBProgressHUDDelegate,UITextFieldDelegate>
{
    
    int index;
    int currPage;
    MJRefreshNormalHeader *header;
    MJRefreshBackNormalFooter *footer;
    MBProgressHUD *mbprogress;
    NSMutableArray *dateArray;
    NSString *idStr;
}

@property (weak, nonatomic) IBOutlet UIView *titleView;
/** <#注释#>*/
@property (nonatomic, strong) MJKThreeAlertView *alertView;
@end

@implementation OnlineExhibtionSettingViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *isrefersh=[userDefault objectForKey:@"IS_refresh"];
    if ([isrefersh isEqualToString:@"yes"]) {
        [dateArray removeAllObjects];
        currPage=1;
        [self refersh];
    }
    [userDefault setObject:nil forKey:@"IS_refresh"];
    [userDefault synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title=@"在线展厅设置";
    CGRect titleViewFrame =self.titleView.frame;
    titleViewFrame.origin.y = SafeAreaTopHeight;
    self.titleView.frame = titleViewFrame;
    
    CGRect mainTableView = self.mainTab.frame;
    mainTableView.origin.y = CGRectGetMaxY(self.titleView.frame);
    mainTableView.size.height = KScreenHeight - SafeAreaTopHeight;
    self.mainTab.frame = mainTableView;
    
    mbprogress = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:mbprogress];
    mbprogress.delegate = self;
    mbprogress.color=[UIColor whiteColor];
    dateArray=[[NSMutableArray alloc]init];

    self.bgView.backgroundColor=[UIColor blackColor];
    self.bgView.alpha=0.5;
    self.bgView.hidden=YES;
    self.samllView.hidden=YES;
    self.samllView.layer.cornerRadius=5.0;
    self.line1.backgroundColor=[UIColor colorWithRed:175.0/255.0 green:178.0/255.0 blue:184.0/255.0 alpha:1.0];
    self.line2.backgroundColor=[UIColor colorWithRed:175.0/255.0 green:178.0/255.0 blue:184.0/255.0 alpha:1.0];
    self.addressText.delegate=self;
    self.IPaddress.delegate=self;

    self.mainTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        currPage = 1;
        [self refersh];
  }];
    // 马上进入刷新状态
    [self.mainTab.mj_header beginRefreshing];
    //    [self refersh];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）

    self.mainTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
-(void)refersh
{
    [mbprogress show:YES];
    dispatch_after(0.3, dispatch_get_main_queue(), ^{
        [self gethttpValues];
    });
    
}


-(void)loadMoreData

{
    currPage=currPage+1;
    
    [self refersh];
    
}
-(void)gethttpValues
{
    
    NSMutableDictionary *mainDic = [DBObjectTools getAddressDicWithAction:@"A65200WebService-geta652ALLList"];
    NSMutableDictionary *dic1=[NSMutableDictionary dictionary];
    [dic1 setObject:[NSString stringWithFormat:@"%d",currPage] forKey:@"currPage"];
    [dic1 setObject:@"10" forKey:@"pageSize"];
    [dic1 setObject:@"3" forKey:@"TYPE"];
    [mainDic setObject:dic1 forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:@"1"];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if(currPage==1){
            
            [dateArray removeAllObjects];
            
        }
        if ([data[@"code"] isEqualToString:@"200"]) {
            
            NSMutableArray *itemsArray=[[NSMutableArray alloc]init];
            itemsArray=[data objectForKey:@"content"];
            
            for (NSDictionary *contentDic in itemsArray) {
                
                [dateArray addObject:contentDic];
            }
            
        }else
        {
            [JRToast showWithText:[data objectForKey:@"message"]];
            
        }
        [mbprogress hide:YES];
        [self.mainTab reloadData];
        [self.mainTab.mj_footer endRefreshing];
        [self.mainTab.mj_header endRefreshing];
    }];
    
    
   
}
#pragma mark 无数据时cell分割线隐藏
-(void)setExtraCellLineHidden: (UITableView *)tableView

{
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    
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
    
    OnlineExhibtionSettingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"OnlineExhibtionSettingTableViewCell" owner:self options:nil] lastObject];
    }
    
    NSDictionary *dic=[dateArray objectAtIndex:indexPath.row];
    
    cell.Numberlabel.text=[dic objectForKey:@"C_TYPE_DD_NAME"];
    cell.positionLabel.text=[dic objectForKey:@"C_POSITION"];
    cell.caozuoBtn.tag=indexPath.row+1000;
    [cell.caozuoBtn addTarget:self action:@selector(updateButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic=[dateArray objectAtIndex:indexPath.row];
    [self gethttpDetailValues:[dic objectForKey:@"C_ID"]];
//    detailOnlineExhibitionViewController *myView=[[detailOnlineExhibitionViewController alloc]initWithNibName:@"detailOnlineExhibitionViewController" bundle:nil];
//    myView.idStr=[dic objectForKey:@"C_ID"];
//    [self.navigationController pushViewController:myView animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.1;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    NSDictionary *dic=[dateArray objectAtIndex:indexPath.row];
    UITableViewRowAction *delAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf deletehttpDetailValues:[dic objectForKey:@"C_ID"]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [ac addAction:cancelAction];
        [ac addAction:yesAction];
        [weakSelf presentViewController:ac animated:YES completion:nil];
        
    }];
    delAction.backgroundColor = [UIColor redColor];
    return @[delAction];
}



-(void)updateButton:(UIButton *)btn{
    DBSelf(weakSelf);
    NSDictionary *dic=[dateArray objectAtIndex:btn.tag - 1000];
    MJKThreeAlertView *alertView = [[MJKThreeAlertView alloc]initWithFrame:self.view.frame withTitle:@"新增人脸识别" withText:@"请填写设备信息" withTFTextArray:@[dic[@"C_NUMBER"], dic[@"C_POSITION"]] withPlaceholder:@[@"请输入设备号",@"请输入位置信息"] withButtonArray:@[@"取消",@"确定"]];
    self.alertView = alertView;
    alertView.vcName = @"在线展厅";
    alertView.buttonActionBlock = ^(NSString * _Nonnull buttonType, NSString * _Nonnull numberStr, NSString * _Nonnull postionInfoStr, NSString * _Nonnull postionStr) {
        if ([buttonType isEqualToString:@"确定"]) {
            [weakSelf gosubmitValuesWithNumber:numberStr.length > 0 ? numberStr : dic[@"C_NUMBER"] andRemark:postionInfoStr.length > 0 ? postionInfoStr : dic[@"C_POSITION"] andIsAdd:NO];
            
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
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

- (IBAction)addNutton:(id)sender {
    
//    addOnlineExhibitionViewController *myView=[[addOnlineExhibitionViewController alloc]initWithNibName:@"addOnlineExhibitionViewController" bundle:nil];
//    [self.navigationController pushViewController:myView animated:YES];
    DBSelf(weakSelf);
    MJKThreeAlertView *alertView = [[MJKThreeAlertView alloc]initWithFrame:self.view.frame withTitle:@"新增在线展厅" withText:@"请填写设备信息" withTFTextArray:@[] withPlaceholder:@[@"请输入设备号",@"请输入位置信息"] withButtonArray:@[@"取消",@"确定"]];
    self.alertView = alertView;
    alertView.vcName = @"在线展厅";
    alertView.buttonActionBlock = ^(NSString * _Nonnull buttonType, NSString * _Nonnull numberStr, NSString * _Nonnull postionInfoStr, NSString * _Nonnull postionStr) {
        if ([buttonType isEqualToString:@"确定"]) {
            [weakSelf gosubmitValuesWithNumber:numberStr andRemark:postionInfoStr andIsAdd:YES];
           
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
}

-(void)gosubmitValuesWithNumber:(NSString *)number andRemark:(NSString *)remark andIsAdd:(BOOL)isAdd
{
    
    DBSelf(weakSelf);
    NSMutableDictionary *dic=[DBObjectTools getAddressDicWithAction:isAdd == YES ? @"A65200WebService-insert" : @"A65200WebService-updataById"];
    
    NSMutableDictionary *dic1=[NSMutableDictionary new];
    [dic1 setObject:@"3" forKey:@"TYPE"];
    [dic1 setObject:remark forKey:@"C_POSITION"];//备注
    [dic1 setObject:number forKey:@"C_NUMBER"];//设备
    
    [dic setObject:dic1 forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dic withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] isEqualToString:@"200"]) {
            [JRToast showWithText:[data objectForKey:@"message"]];
            [weakSelf.alertView removeFromSuperview];
            
        }else
        {
            
            [JRToast showWithText:[data objectForKey:@"message"]];
            
        }
        
        [weakSelf.mainTab.mj_header beginRefreshing];
    }];
    
    
    
}


-(void)gethttpDetailValues:(NSString *)C_ID
{
    
    NSMutableDictionary *dic=[DBObjectTools getAddressDicWithAction:@"A65200WebService-getBeanById"];
   
    NSMutableDictionary *dic1=[NSMutableDictionary new];
    
    [dic1 setObject:C_ID forKey:@"C_ID"];
    [dic setObject:dic1 forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dic withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] isEqualToString:@"200"]) {
            
            NSString *webVideoPath = data[@"C_LIVEURL"];
            NSURL *webVideoUrl = [NSURL URLWithString:webVideoPath];
            //步骤2：创建AVPlayer
            AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:webVideoUrl];
            //步骤3：使用AVPlayer创建AVPlayerViewController，并跳转播放界面
            AVPlayerViewController *avPlayerVC =[[AVPlayerViewController alloc] init];
            avPlayerVC.player = avPlayer;
            [self presentViewController:avPlayerVC animated:YES completion:nil];
            
            
        }else
        {
            [JRToast showWithText:[data objectForKey:@"message"]];
            
        }
    }];
    
}


-(void)deletehttpDetailValues:(NSString *)C_ID
{
    DBSelf(weakSelf);
    NSMutableDictionary *dic=[DBObjectTools getAddressDicWithAction:@"A65200WebService-DeleteById"];
    
    NSMutableDictionary *dic1=[NSMutableDictionary new];
    
    [dic1 setObject:C_ID forKey:@"C_ID"];
    [dic setObject:dic1 forKey:@"content"];
     NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dic withtype:@"1"];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        NSString *errcode = [data objectForKey:@"code"];
        if ([errcode isEqualToString:@"200"]) {
            [JRToast showWithText:[data objectForKey:@"message"]];
            
        }else
        {
            [JRToast showWithText:[data objectForKey:@"message"]];
            
        }
        [weakSelf.mainTab.mj_header beginRefreshing];
    }];
}


@end
