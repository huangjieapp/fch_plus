//
//  CGCPersonInfoVC.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCPersonInfoVC.h"

#import "CGCPersonInfoCell.h"
#import "CGCPersonalInfoView.h"
#import "ThreeInputView.h"

#import "CGCPersonDetailInfoModel.h"

#import "CommonCallViewController.h"

@interface CGCPersonInfoVC ()
<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dateArray;

@property (nonatomic, strong) CGCPersonalInfoView *headView;

@property (nonatomic, strong) CGCPersonDetailInfoModel * model;

@end

@implementation CGCPersonInfoVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.model=[[CGCPersonDetailInfoModel alloc] init];
    self.title=@"个人资料";
    [self HTTPGetDetail];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGCPersonInfoCell * cell=[CGCPersonInfoCell cellWithTableView:tableView];
    
    [cell reloadCell:self.model withIndex:indexPath.row];
    return cell;

}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 100)];
    mainView.backgroundColor=[UIColor whiteColor];
    
    UIButton*commitButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 50, KScreenWidth-40, 40)];
    [commitButton setTitleNormal:@"重置密码"];
    [commitButton setTitleColor:[UIColor blackColor]];
    [commitButton setBackgroundColor:KNaviColor];
    commitButton.layer.cornerRadius=6;
    commitButton.layer.masksToBounds=YES;
    [commitButton addTarget:self action:@selector(clickChangeCodeButton:)];
    [mainView addSubview:commitButton];
    
    
    return mainView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}


#pragma mark --- HTTPRequest 网络

-(void)httpPostChangeCodeWithCode:(NSString*)codeText{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_changeCode];
    NSDictionary*dict=@{@"C_ID":self.C_ID,@"C_PASSWORD":codeText};
    [mainDict setObject:dict forKey:@"content"];
    NSString*params=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:params parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [JRToast showWithText:data[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];
    
    
}


- (void)HTTPGetDetail{


    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_CGC_getCommunicationDetailInfo];
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    if (self.C_ID.length==0) {
        [JRToast showWithText:@"资料不存在！"];
        return;
    }
    
    [dic setObject:self.C_ID forKey:@"C_ID"];
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        [self.view addSubview:self.tableView];
        if ([data[@"code"] integerValue]==200) {
           
            self.model=[CGCPersonDetailInfoModel yy_modelWithDictionary:data];
            [self reloadHead];
        
        }else{
           
            [JRToast showWithText:data[@"message"]];
        }
        
        [self.tableView reloadData];
       
    }];

}


- (void)reloadHead{

    self.headView.nameLab.text=self.model.C_NAME;
    [self.headView.headImg sd_setImageWithURL:[NSURL URLWithString:self.model.C_HEADIMGURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
}

#pragma mark --- set

- (UITableView *)tableView{

    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        DBSelf(weakSelf);
        self.headView=[[CGCPersonalInfoView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 201) withTel:^{
            [weakSelf selectTelephone:0];
        } withMess:^{
            [self messageClick];
        }];
        _tableView.tableHeaderView=self.headView;
    }
   
    return _tableView;

}


#pragma mark --- touch
-(void)clickChangeCodeButton:(UIButton*)sender{
    NSArray*codeArr=[NewUserSession instance].appcode;
    if ([codeArr containsObject:@"U03100_0000"]) {
        
        
        [self showAlertVC];
        
        
        
    }else{
        [JRToast showWithText:@"您没有修改通讯录密码的权限"];
    }
    
    
    
}

-(void)showAlertVC{
    ThreeInputView*threeView=[ThreeInputView showThreeInputViewAndSuccess:^(NSString *firstText, NSString *secondText, NSString *thirdText) {
        if (firstText.length>0&&secondText.length>0&&[firstText isEqualToString:secondText]) {
            
            [self httpPostChangeCodeWithCode:firstText];
            
        }else{
            [JRToast showWithText:@"密码填写错误"];
        }
        
        
    } andCancel:^{
        
    }];
    
    threeView.thirdTextF.hidden=YES;
    threeView.firstTextF.placeholder=@"新密码";
    threeView.firstTextF.secureTextEntry=YES;
    threeView.secondTextF.placeholder=@"确认密码";
    threeView.secondTextF.secureTextEntry=YES;
    threeView.subLab.text=@"修改密码";
    threeView.canCommitNoAll=YES;
    [[UIApplication sharedApplication].keyWindow addSubview:threeView];
    
}



- (void)messageClick{

    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText])
        {
            [self FirstdisplaySMSComposerSheet:self.model.C_PHONENUMBER];
        }
        else {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""message:@"设备不支持短信功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
          
            [alert show];
            
        }
    }

}

-(void)FirstdisplaySMSComposerSheet:(NSString *)number
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate =self;
    picker.recipients = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",number], nil];
    
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
   
    [controller dismissViewControllerAnimated:NO completion:^{
        
    }];
    switch (result) {
            
        case MessageComposeResultCancelled:
            
            [KVNProgress showSuccessWithStatus:@"发送取消"];
            break;
        case MessageComposeResultFailed:// send failed
            [KVNProgress showErrorWithStatus:@"发送失败"];
            
            break;
        case MessageComposeResultSent:
            
            [KVNProgress showSuccessWithStatus:@"发送成功"];
            
            break;
        default:
            break;
    }
}

#pragma  mark --- 拨打电话
//电话
- (void)telephoneCall:(NSInteger)index{
    
    if (self.model.C_PHONENUMBER.length==0) {
        [JRToast showWithText:@"无号码！"];
        return;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.model.C_PHONENUMBER]]];
}
//座机
- (void)landLineCall:(NSInteger)index{
    
    NSString *buttonTitle = @"用座机拨打";
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=buttonTitle;
    myView.nameStr=self.model.C_NAME;
    myView.callStr=self.model.C_PHONENUMBER;
    [self.navigationController pushViewController:myView animated:YES];

    
}
//回呼
- (void)callBack:(NSInteger)index{
    
    NSString *buttonTitle = @"回呼到手机";
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=buttonTitle;
    myView.nameStr=self.model.C_NAME;
    myView.callStr=self.model.C_PHONENUMBER;
    [self.navigationController pushViewController:myView animated:YES];
    
}




@end
