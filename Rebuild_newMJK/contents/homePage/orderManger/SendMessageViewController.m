//
//  SendMessageViewController.m
//  Mcr_2
//
//  Created by bipi on 2016/12/30.
//  Copyright © 2016年 bipi. All rights reserved.
//

#import "SendMessageViewController.h"

#import "SendMessageTableViewCell.h"
#import <MessageUI/MessageUI.h>
#import<MessageUI/MFMailComposeViewController.h>
#import "SendMessagePublicTableViewCell.h"

#import "WXApi.h"
#import "ISRDataHelper.h"
#import "IATConfig.h"
typedef enum {
    kShareTool_WeiXinFriends = 0, // 微信好友
    kShareTool_WeiXinCircleFriends, // 微信朋友圈
} ShareToolType;

@interface SendMessageViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate>
{
    enum WXScene _scene;
    UIVisualEffectView* bigvoiceView;

    NSString *PublicImageSelect;
    BOOL IsYuYin;//是否语音
    CGSize size;
    int height;
    NSMutableArray *PublicDataArr;
    NSString *type;
    NSMutableArray *MineDataArr;
    NSString *total;
    NSString *PublicID;
    NSArray *NumberARR;
    NSString *IsSend;
    NSString *MessageID;
    NSMutableArray *NameIDArr;
    NSString *MineID;

}
@end

@implementation SendMessageViewController
-(void)viewWillAppear:(BOOL)animated
{
    
    if ([IsSend isEqualToString:@"send"]) {
        UIAlertView *myView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否新增跟进" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [myView show];
        myView.tag=378;
        IsSend=@"";
    }
    [self initRecognizer];//初始化识别对象

    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhisend) name:@"tongzhisend" object:nil];
}
- (void)tongzhisend{
    

        UIAlertView *myView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否新增跟进" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [myView show];
        myView.tag=378;
        IsSend=@"";
    
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [_iFlySpeechRecognizer cancel]; //取消识别
    [_iFlySpeechRecognizer setDelegate:nil];
    [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    [_pcmRecorder stop];
    _pcmRecorder.delegate = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.BGView.hidden=self.ChangeMesaageView.hidden=YES;

    self.ChangeTextView.delegate=self;
    self.ChangeTitleTF.delegate=self;
    
    NameIDArr=[NSMutableArray new];
    MineDataArr=[NSMutableArray new];
    self.automaticallyAdjustsScrollViewInsets=NO;
    PublicDataArr=[NSMutableArray new];
    self.label1.hidden=YES;
    type=@"";
    self.VoiceTextView.layer.borderWidth=0.5;
    self.VoiceTextView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.VoiceTextView.layer.cornerRadius=3.0;
    self.VoiceTextView.backgroundColor=[UIColor whiteColor];
    self.VoiceTextView.delegate=self;
    self.YuYinGenJinLabel.layer.cornerRadius=4.0;
    self.YuYinGenJinLabel.layer.borderWidth=0.5;
    self.YuYinGenJinLabel.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    
    PublicImageSelect=@"";
    
    if ([_Type isEqualToString:@"weixin"]) {
        self.title=self.TitleLabel.text=@"发送微信";
    }else
    {
        self.title=self.TitleLabel.text=@"发送短信";

    }
    self.PublicTableView.hidden=NO;
    IsYuYin=NO;
    self.VoiceTextView.delegate=self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    
    if (_Name.length>0) {
        
        _MessageName.text=[NSString stringWithFormat:@"收件人： %@",_Name];
    }
//    [self getModelMessage];
    
    if (_PhoneNumber) {
        NumberARR=[[NSArray alloc]initWithObjects:_PhoneNumber, nil];
    }


    self.uploader = [[IFlyDataUploader alloc] init];
    
    //demo录音文件保存路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    _pcmFilePath = [[NSString alloc] initWithFormat:@"%@",[cachePath stringByAppendingPathComponent:@"asr.pcm"]];
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPress.minimumPressDuration = 0.1; //定义按的时间
    [self.YuYinGenJinLabel addGestureRecognizer:longPress];
    
    
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    bigvoiceView = [[UIVisualEffectView alloc]initWithEffect:beffect];
    bigvoiceView.alpha=0.8;
    bigvoiceView.frame =CGRectMake(0, 64,KScreenWidth, KScreenHeight-64-50);
    bigvoiceView.hidden=YES;
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, KScreenHeight/2-100, KScreenWidth, 30)];
    label.text=@"我们正在倾听您的对话...";
    label.font=[UIFont systemFontOfSize:15.0];
    label.textColor=[UIColor blackColor];
    label.textAlignment=NSTextAlignmentCenter;
    [bigvoiceView addSubview:label];
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((KScreenWidth-80)/2, label.frame.size.height+label.frame.origin.y+10, 80, 80)];
    img.image=[UIImage imageNamed:@"语音搜索大按钮"];
    [bigvoiceView addSubview:img];
    [self.view addSubview:bigvoiceView];


}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
     height = keyboardRect.size.height;
    int width = keyboardRect.size.width;
    NSLog(@"键盘高度是  %d",height);

    
    self.VoiveView.frame=CGRectMake(0, KScreenHeight-50-height, KScreenWidth, self.VoiveView.frame.size.height);
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.VoiveView.frame=CGRectMake(0, KScreenHeight-50, KScreenWidth, self.VoiveView.frame.size.height);
}
-(void)textViewDidBeginEditing:(UITextView *)textView{

    self.VoiveView.frame=CGRectMake(0, KScreenHeight-50-height, KScreenWidth, self.VoiveView.frame.size.height);
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([type isEqualToString:@"mine"]) {
        if (MineDataArr.count>0) {
            return 1;
        }else
        {
            return 0;
        }
        
    }else{
    
        return PublicDataArr.count;;
    }
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if ([type isEqualToString:@"mine"]) {
        return MineDataArr.count;

    }else{
        NSMutableDictionary *dic1=PublicDataArr[section];
        NSMutableArray *arr=[dic1 objectForKey:@"array"];
        return arr.count;
    }
    
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSMutableDictionary *dic;
    if([type isEqualToString:@"mine"]){
       dic=MineDataArr[indexPath.row];
//        NSMutableArray *arr=[dic1 objectForKey:@"array"];
//        dic=arr[indexPath.row];
        SendMessageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (!cell) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"SendMessageTableViewCell" owner:self options:nil] lastObject];
        }
        
        cell.NameLabel.text=[dic objectForKey:@"C_NAME"];
        cell.PhoneLabel.text=[dic objectForKey:@"X_PICCONTENT"];
//        cell.contentView.tag=indexPath.section;
//        cell.favBtn.tag=indexPath.row;
//        cell.selectBtn.tag=indexPath.row;
//        cell.imgRight.tag=indexPath.row+1000+1000*indexPath.section;
//        cell.imgLeft.tag=indexPath.row+20000+20000*indexPath.section;
//        NSLog(@"right%ld",cell.imgLeft.tag);
//        NSLog(@"left%ld",cell.imgRight.tag);
//        [cell.favBtn addTarget:self action:@selector(favButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.selectBtn addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        
        if ( _BrandIndexPath && NSOrderedSame == [_BrandIndexPath compare:indexPath])
        {
            cell.imgRight.image=[UIImage imageNamed:@"icon_1_highlight.png"];
        }
        else
        {
            cell.imgRight.image=[UIImage imageNamed:@"未选中.png"];
        }
        
        
        return cell;
        
        
    }else{
        NSMutableDictionary *dic1=PublicDataArr[indexPath.section];
        NSMutableArray *arr=[dic1 objectForKey:@"array"];
       dic=arr[indexPath.row];
        SendMessagePublicTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        if (!cell) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"SendMessagePublicTableViewCell" owner:self options:nil] lastObject];
        }
        
        cell.NameLabel.text=[dic objectForKey:@"C_NAME"];
        cell.PhoneLabel.text=[dic objectForKey:@"X_PICCONTENT"];
//        cell.contentView.tag=indexPath.section;
//        cell.favBtn.tag=indexPath.row;
//        cell.selectBtn.tag=indexPath.row;
//        cell.imgRight.tag=indexPath.row+1000+1000*indexPath.section;
//        cell.imgLeft.tag=indexPath.row+20000+20000*indexPath.section;
//        NSLog(@"right%ld",cell.imgLeft.tag);
//        NSLog(@"left%ld",cell.imgRight.tag);
//        [cell.favBtn addTarget:self action:@selector(favButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.selectBtn addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        
        if ( _BrandIndexPath && NSOrderedSame == [_BrandIndexPath compare:indexPath])
        {
            cell.imgRight.image=[UIImage imageNamed:@"选中.png"];
        }
        else
        {
            cell.imgRight.image=[UIImage imageNamed:@"未选中.png"];
        }
        
        
        return cell;
    }


    
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic;
    if([type isEqualToString:@"mine"]){
        NSMutableDictionary *dic1=MineDataArr[indexPath.row];

        MineID=[dic1 objectForKey:@"C_ID"];
        
        self.ChangeTitleTF.text=[dic1 objectForKey:@"C_NAME"];
        self.ChangeTextView.text=[dic1 objectForKey:@"X_PICCONTENT"];
        
        
    }else{
        NSMutableDictionary *dic1=PublicDataArr[indexPath.section];
        NSMutableArray *arr=[dic1 objectForKey:@"array"];
        dic=arr[indexPath.row];
        PublicID=[dic objectForKey:@"C_ID"];
    }

    
    
    UITableViewRowAction *PubliecAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertView *myView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否新增到个人模板" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        myView.tag=222;
        [myView show];
        
        

    }];
    
    
    UITableViewRowAction *DeleteRowAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertView *myView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否删除此条模版消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        myView.tag=333;
        [myView show];
    }];
    
    
    UITableViewRowAction *EditRowAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        self.ChangeMesaageView.hidden=NO;
        self.BGView.hidden=NO;

        
    }];
    
    
    
    if ([type isEqualToString:@"mine"]) {//我的模板
        return @[EditRowAction,DeleteRowAction];
        
    }else//公共模板
    {
        return @[PubliecAction];
        
    }
    
}

#pragma mark收藏公共模板
-(void)AddMineMessage
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
                [self AddMineMessageHttpValues];
    });
    

}
-(void)AddMineMessageHttpValues
{
    
   
    
  NSMutableDictionary *dic=[DBObjectTools getAddressDicWithAction: HTTP_CGC_saveBeanId];
    NSMutableDictionary *dic1=[NSMutableDictionary new];
    [dic1 setObject:@"" forKey:@"X_PICCONTENT"];
    [dic1 setObject:@"" forKey:@"X_NAME"];
    [dic1 setObject:PublicID forKey:@"C_ID"];
    
    [dic setObject:dic1 forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dic withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
             [JRToast showWithText:data[@"message"]];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


    self.YuYinGenJinLabel.hidden=YES;
    self.VoiceTextView.hidden=NO;
    IsYuYin=YES;
    self.label1.hidden=NO;
    self.imgview1.hidden=YES;
    self.yuyinImage.image=[UIImage imageNamed:@"语音-跟进"];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _BrandIndexPath = indexPath;
    [_PublicTableView reloadData];
    
//    if ([type isEqualToString:@"0"]) {
    
//        NSMutableDictionary *dic=MineDataArr[indexPath.row];
//        self.VoiceTextView.text=[NSString stringWithFormat:@"%@\n%@",[dic objectForKey:@"C_NAME"],[dic objectForKey:@"C_PHONETO"]];
    
        
        
//    }
    
    NSMutableDictionary *dic;

    if([type isEqualToString:@"mine"]){
        dic=MineDataArr[indexPath.row];

    }else{
        NSMutableDictionary *dic1=PublicDataArr[indexPath.section];
        NSMutableArray *arr=[dic1 objectForKey:@"array"];
        dic=arr[indexPath.row];
    }
    MessageID=[dic objectForKey:@"C_ID"];

    self.VoiceTextView.text=[dic objectForKey:@"X_PICCONTENT"];

    
    

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if ([type isEqualToString:@"public"]) {
        return 30.0;

    }else
    {
        return 0;

    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if ([type isEqualToString:@"public"]) {
            NSMutableDictionary *dic1=PublicDataArr[section];
            
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
            view.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
            label.textColor=[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
            NSString *nian=[dic1 objectForKey:@"total"];
            label.text=[NSString stringWithFormat:@"%@",nian];
            label.font=[UIFont systemFontOfSize:13.0];
            [view addSubview:label];
            return view;
 

    }else
    {
        return nil;
    }
}
#pragma mark公共模板
- (IBAction)PublicForm:(id)sender {

    if ([type isEqualToString:@"public"]) {//上一次还是点击的公告模板
        
        
        if ([PublicImageSelect isEqualToString:@"select"]) {
            [self AllHiden];
            PublicImageSelect=@"";
        }else
        {
            [self PublicImageShow];
            PublicImageSelect=@"select";
        }
    }else
    {
        [self PublicImageShow];
        PublicImageSelect=@"select";
    }
    type=@"public";
    [self  getModelMessage];
}
-(void)PublicImageShow{
    self.PublicTableView.hidden=NO;

    self.PublicImageView.image=[UIImage imageNamed:@"三角-下拉"];
    self.PublicImageView.frame=CGRectMake(15, (50-8)/2, 14, 8);
    self.MineImageView.image=[UIImage imageNamed:@"三角"];
    self.MineImageView.frame=CGRectMake(15, (50-14)/2, 8, 14);
    
    CGRect rect=self.PublicView.frame;
    rect.origin.y=165;
    self.PublicView.frame=rect;
    
    
    CGRect rect1=self.PublicTableView.frame;
    rect1.origin.y=215;
    self.PublicTableView.frame=rect1;
    
}
-(void)PublicImageHide{
    self.PublicTableView.hidden=NO;

    self.MineImageView.image=[UIImage imageNamed:@"三角-下拉"];
    self.MineImageView.frame=CGRectMake(15, (50-8)/2, 14, 8);
    self.PublicImageView.image=[UIImage imageNamed:@"三角"];
    self.PublicImageView.frame=CGRectMake(15, (50-14)/2, 8, 14);
    
    CGRect rect=self.PublicView.frame;
    rect.origin.y=KScreenHeight-100;
    self.PublicView.frame=rect;
    
    CGRect rect1=self.PublicTableView.frame;
    rect1.origin.y=165;
    self.PublicTableView.frame=rect1;
    
}
-(void)AllHiden{
    self.PublicTableView.hidden=YES;
    self.MineImageView.image=[UIImage imageNamed:@"三角"];
    self.MineImageView.frame=CGRectMake(15, (50-14)/2, 8, 14);
    self.PublicImageView.image=[UIImage imageNamed:@"三角"];
    self.PublicImageView.frame=CGRectMake(15, (50-8)/2, 8, 14);
    CGRect rect=self.PublicView.frame;
    rect.origin.y=165;
    self.PublicView.frame=rect;
}
#pragma mark我的模板
- (IBAction)MineForm:(id)sender {

    if ([type isEqualToString:@"mine"]) {//上一次还是点击的模板
        
        
        if ([PublicImageSelect isEqualToString:@"select"]) {
            [self AllHiden];
            PublicImageSelect=@"";
        }else
        {
            [self PublicImageHide];
            PublicImageSelect=@"select";
        }
    }else
    {
        
        [self PublicImageHide];
        PublicImageSelect=@"select";
        
    }

    type=@"mine";
    [self  getModelMessage];

    
}

#pragma mark选中
-(void)selectButton:(UIButton *)btn{
    
}
#pragma mark是否语音
- (IBAction)ShiFouYuYin:(id)sender {
    if (IsYuYin==NO) {
        self.YuYinGenJinLabel.hidden=YES;
        self.VoiceTextView.hidden=NO;
        IsYuYin=YES;
        self.label1.hidden=NO;
        self.imgview1.hidden=YES;
        self.yuyinImage.image=[UIImage imageNamed:@"语音-跟进"];
    }else
    {
        IsYuYin=NO;
        self.YuYinGenJinLabel.hidden=NO;
        self.VoiceTextView.hidden=YES;
        self.yuyinImage.image=[UIImage imageNamed:@"键盘-跟进"];
        [self.VoiceTextView resignFirstResponder];
        self.label1.hidden=YES;
        self.imgview1.hidden=NO;

    }

}
#pragma mark发送或设置
- (IBAction)SendOrSettingUp:(id)sender {
    
    if (NumberARR.count==0) {
        UIAlertView *myView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择收件人" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [myView show];
    }else
    {
        if (self.label1.hidden==YES) {
            NSLog(@"qw");
        }else
        {

                if ([_Type isEqualToString:@"duanxin"]) {
                    
                
                    IsSend=@"send";

                    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
                
                    if (messageClass != nil) {
                        // Check whether the current device is configured for sending SMS messages
                        if ([messageClass canSendText]) {

                            if (NumberARR.count==1) {
                                [self FirstdisplaySMSComposerSheet:NumberARR[00]];
                            }else
                            {
                                [self FirstdisplaySMSComposerSheet];

                            }
                            
                
                        }
                        else {
                            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""message:@"设备不支持短信功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                            [UIView appearance].tintColor=UIColorForAlert;
                            [alert show];

                        }
                    }
                    else {
                    }
                
                
                
                
                
                
            }else//微信分享
            {
                IsSend=@"send";

                [[NSUserDefaults standardUserDefaults] setObject:@"send" forKey:@"send"];
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                req.text =self.VoiceTextView.text;
                req.bText = YES;
                req.scene = _scene;
                [WXApi sendReq:req];
            
            }
    
        }
    }
    
}

-(void)onResp:(BaseResp*)resp{
    
    
    
    
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
                
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                //                [self backSuccess];
                NSLog(@"支付成功");
                break;
            default:
                
                //                [self backFailed];
                
                
                
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
    
    
    
    
}
-(void)FirstdisplaySMSComposerSheet:(NSString *)number
{
    NSLog(@"%@",number);
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate =self;
    picker.recipients = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",number], nil];
    picker.body = self.VoiceTextView.text;
 
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

-(void)FirstdisplaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate =self;
    picker.recipients = NumberARR;
    picker.body = self.VoiceTextView.text;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
   //关键的一句   不能为YES
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




#pragma mark新增收件人
- (IBAction)AddPersonButtonClick:(id)sender {
//    SelectCustomerViewController *myView=[[SelectCustomerViewController alloc]initWithNibName:@"SelectCustomerViewController" bundle:nil];
//    myView.type=@"message";
//    myView.delegate=self;
//    [self.navigationController pushViewController:myView animated:YES];
    
    
}
-(void)PassArrNum:(NSMutableArray *)Num PassArrName:(NSMutableArray *)name PassNameID:(NSMutableArray *)ID
{
    NSString *messageName;
    for(int i=0;i<name.count;i++){
        
        if (i==0) {
            messageName=name[0];
        }else
        {
            messageName=[NSString stringWithFormat:@"%@,%@",messageName,name[i]];
        }
        
    }
    
    
    
    _MessageName.text=[NSString stringWithFormat:@"收件人： %@",messageName];
    //    _PhoneNumber=number;
    
    NumberARR=[[NSArray alloc]initWithArray:Num];
    NameIDArr=ID;
    
    if (NameIDArr.count==1) {
        _CustomerID=NameIDArr[0];
    }
}




#pragma mark获取今日待办事项
-(void)getModelMessage
{
    
   
        [self getModelMessageHttpValues];
   
}
#pragma mark获取短信
-(void)getModelMessageHttpValues
{
    
  
    NSMutableDictionary *dic=[DBObjectTools getAddressDicWithAction: HTTP_CGC_getMessageList];
    NSMutableDictionary *dic1=[NSMutableDictionary new];
    [dic1 setObject:@"1" forKey:@"currPage"];
    [dic1 setObject:@"20" forKey:@"pageSize"];
    
    if ([type isEqualToString:@"mine"]) {
        [dic1 setObject:@"0" forKey:@"TYPE"];//1公共  0我的
    }else
    {
        [dic1 setObject:@"1" forKey:@"TYPE"];//1公共  0我的
    }

    [dic setObject:dic1 forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dic withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            NSMutableArray *itemsArray=[[NSMutableArray alloc]init];
            
            itemsArray=[data objectForKey:@"content"];
            if ([type isEqualToString:@"mine"]) {
                [MineDataArr removeAllObjects];
                
                for (NSMutableDictionary *contentDic in itemsArray) {
                    [MineDataArr addObject:contentDic];
                }
                
            }
            else  if ([type isEqualToString:@"public"]) {
                [PublicDataArr removeAllObjects];
                for (NSMutableDictionary *contentDic in itemsArray) {
                    
                    NSString *str=[contentDic objectForKey:@"total"];
                    //防止出现两个相同的section
                    if ([str isEqualToString:total]) {
                        NSMutableDictionary *dic=PublicDataArr[PublicDataArr.count-1];
                        NSMutableArray *arr=[dic objectForKey:@"array"];
                        NSArray *contentArr=[contentDic objectForKey:@"array"];
                        for (NSDictionary *content in contentArr) {
                            [arr addObject:content];
                        }
                    }else
                    {//使原来是数据变为可变的数据
                        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                        NSMutableArray *ARRAY=[[NSMutableArray alloc]initWithArray:[contentDic objectForKey:@"array"]];
                        [dic setObject:ARRAY forKey:@"array"];
                        [dic setObject:str forKey:@"total"];
                        [PublicDataArr addObject:dic];
                    }
                    total=str;
                }
                
            }
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];
    

    
    
    
    [self.PublicTableView reloadData];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView.tag==378) {
        
        if (NumberARR.count==1) {
            if (buttonIndex==1) {
//                AddCustomeFollowViewController *myView=[[AddCustomeFollowViewController alloc]initWithNibName:@"AddCustomeFollowViewController" bundle:nil];
////                myView.liuliangStr=@"";
//                
//                if ([_Type isEqualToString:@"duanxin"]) {
//                    myView.isMessage=@"duanxin";
//                }else
//                {
//                    myView.isMessage=@"weixin";
//
//                }
//                myView.idStr=_CustomerID;
//                myView.contentStr=self.VoiceTextView.text;
//                [self.navigationController pushViewController:myView animated:YES];
            }
        }else
        {
        
            
            [self MorePeopleMessage];
            
        
        }
        

    }else if(alertView.tag==222)//新增消息
    {
        if (buttonIndex==1) {
            [self AddMineMessage];

        }
        
        
    }else if(alertView.tag==333)////删除消息
    {
        if (buttonIndex==1) {
            [self DeleteMineMessage];

        }
        
        
    }
}
#pragma mark多人发送短信的接口
-(void)MorePeopleMessage
{
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self MorePeopleMessageHttpValues];
    });
}
-(void)MorePeopleMessageHttpValues
{
    
    
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_CGC_insertAllTemplateMessageToFollow];
    NSMutableDictionary *dic1=[NSMutableDictionary new];
    
    NSString *a41500id;
    for (int i=0; i<NameIDArr.count; i++) {
        if (i==0) {
            a41500id=NameIDArr[0];
        }else
        {
            a41500id=[NSString stringWithFormat:@"%@,%@",a41500id,NameIDArr[i]];
            
        }
        
    }
    
    [dic1 setObject:a41500id forKey:@"C_A41500_C_ID"];
    if ([_Type isEqualToString:@"duanxin"]) {
        [dic1 setObject:@"1" forKey:@"TYPE"];
    }else
    {
        [dic1 setObject:@"2" forKey:@"TYPE"];
        
    }
    [dic1 setObject:self.VoiceTextView.text forKey:@"X_PICCONTENT"];
    [dic1 setObject:MessageID forKey:@"C_ID"];

    
    
    
    [dict setObject:dic1 forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
      
        if ([data[@"code"] integerValue]==200) {
            
           [JRToast showWithText:data[@"message"]];
            
        }else{
            
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];

    
}





-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan://开始
        {
            bigvoiceView.hidden=NO;
            [self.VoiceTextView setText:@""];
            [self.VoiceTextView resignFirstResponder];
            self.isStreamRec = NO;
            
            if(_iFlySpeechRecognizer == nil)
            {
                [self initRecognizer];
            }
            
            [_iFlySpeechRecognizer cancel];
            
            //设置音频来源为麦克风
            [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
            
            //设置听写结果格式为json
            [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
            
            //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
            [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
            
            [_iFlySpeechRecognizer setDelegate:self];
            
//            BOOL ret = [_iFlySpeechRecognizer startListening];
            
        }
            break;
            
        case UIGestureRecognizerStateEnded://结束
        {
            if(self.isStreamRec && !self.isBeginOfSpeech){
                NSLog(@"停止录音");
                [_pcmRecorder stop];
                
            }
            bigvoiceView.hidden=YES;
            
            [_iFlySpeechRecognizer stopListening];
            [self.VoiceTextView resignFirstResponder];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - IFlySpeechRecognizerDelegate

/**
 音量回调函数
 volume 0－30
 ****/
- (void) onVolumeChanged: (int)volume
{
    
    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
//    self.labelText.text=vol;
}



/**
 开始识别回调
 ****/
- (void) onBeginOfSpeech
{
    NSLog(@"onBeginOfSpeech");
    
    if (self.isStreamRec == NO)
    {
        self.isBeginOfSpeech = YES;
        
    }
}

/**
 停止录音回调
 ****/
- (void) onEndOfSpeech
{
    NSLog(@"onEndOfSpeech");
    
    [_pcmRecorder stop];
    
}


/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *) error
{
    
    if ([IATConfig sharedInstance].haveView == NO ) {
        
        //        if (self.isStreamRec) {
        //            //当音频流识别服务和录音器已打开但未写入音频数据时stop，只会调用onError不会调用onEndOfSpeech，导致录音器未关闭
        //            [_pcmRecorder stop];
        //            self.isStreamRec = NO;
        //            NSLog(@"error录音停止");
        //        }
        
        NSString *text ;
        
        if (self.isCanceled) {
            text = @"识别取消";
            
        } else if (error.errorCode == 0 ) {
            if (_result.length == 0) {
                text = @"无识别结果";
            }else {
                text = @"识别成功";
                //清空识别结果
                _result = nil;
            }
        }else {
            text = [NSString stringWithFormat:@"发生错误：%d %@", error.errorCode,error.errorDesc];
            NSLog(@"%@",text);
        }
        
        
    }else {
        
        NSLog(@"errorCode:%d",[error errorCode]);
    }
    
}

/**
 无界面，听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    NSLog(@"resultFromJson=%@",resultFromJson);
    NSLog(@"resultFromJson=%@",resultFromJson);

    if (!isLast){
        self.VoiceTextView.text=resultFromJson;
    }
    bigvoiceView.hidden=YES;
        
    if (self.VoiceTextView.text.length>0) {
        self.YuYinGenJinLabel.hidden=YES;
        self.VoiceTextView.hidden=NO;
        IsYuYin=YES;
        self.label1.hidden=NO;
        self.imgview1.hidden=YES;
        self.yuyinImage.image=[UIImage imageNamed:@"语音-跟进"];
    }

    
}

/**
 听写取消回调
 ****/
- (void) onCancel
{
    NSLog(@"识别取消");
}


/**
 设置识别参数
 ****/
-(void)initRecognizer
{
    
    //单例模式，无UI的实例
    if (_iFlySpeechRecognizer == nil) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    _iFlySpeechRecognizer.delegate = self;
    
    if (_iFlySpeechRecognizer != nil) {
        IATConfig *instance = [IATConfig sharedInstance];
        
        //设置最长录音时间
        [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        if ([instance.language isEqualToString:[IATConfig chinese]]) {
            //设置语言
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.language isEqualToString:[IATConfig english]]) {
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        }
        //设置是否返回标点符号
        [_iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
        
    }
    
    //初始化录音器
    if (_pcmRecorder == nil)
    {
        _pcmRecorder = [IFlyPcmRecorder sharedInstance];
    }
    
    _pcmRecorder.delegate = self;
    
    [_pcmRecorder setSample:[IATConfig sharedInstance].sampleRate];
    
    [_pcmRecorder setSaveAudioPath:nil];    //不保存录音文件
    
    
}
#pragma mark收藏公共模板
-(void)DeleteMineMessage
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self DeleteMineMessageHttpValues];
    });
    
    
}
-(void)DeleteMineMessageHttpValues
{
    
    

    
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_CGC_templateMessageDeleteByID];
    NSMutableDictionary *dic1=[NSMutableDictionary new];
    [dic1 setObject:MineID forKey:@"C_ID"];
    
    
    
    
    [dict setObject:dic1 forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
      
        if ([data[@"code"] integerValue]==200) {
            [self getModelMessageHttpValues];
           [JRToast showWithText:data[@"message"]];

        }else{
            
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];
    

    
//
//    
//    
//    NSString *str=[dic JSONString];
//    NSString *respone=[HttpPost getPost:str];
//    if (![respone isEqualToString:@""])
//    {
//        NSDictionary *  dataDic1 = [respone objectFromJSONString];
//        
//        NSString *errcode = [dataDic1 objectForKey:@"code"];
//        
//        if ([errcode isEqualToString:@"200"]) {
//            [self getModelMessageHttpValues];
//            [KVNProgress showSuccessWithStatus:[dataDic1 objectForKey:@"message"]];
//            
//        }else{
//            [KVNProgress showErrorWithStatus:[dataDic1 objectForKey:@"message"]];
//            
//        }
//        
//    }else{
//        
//        [KVNProgress showErrorWithStatus:[MyUtil getMessage]];
//        
//    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ChangeMessButtonCancle:(id)sender {
    self.ChangeMesaageView.hidden=YES;
    self.BGView.hidden=YES;
        self.VoiveView.frame=CGRectMake(0, KScreenHeight-50, KScreenWidth, self.VoiveView.height);
}

- (IBAction)ChangeMessageButtonSure:(id)sender {
        self.VoiveView.frame=CGRectMake(0, KScreenHeight-50, KScreenWidth, self.VoiveView.height);
    [self ChangeMineMessage];
}
#pragma mark收藏公共模板
-(void)ChangeMineMessage
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self ChangeMineMessageHttpValues];
    });
    
    
}
-(void)ChangeMineMessageHttpValues
{
    
     NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction: HTTP_CGC_templateMessageUpdate];
    
    
    NSMutableDictionary *dic1=[NSMutableDictionary new];
    [dic1 setObject:MineID forKey:@"C_ID"];
    [dic1 setObject:self.ChangeTitleTF.text forKey:@"C_NAME"];
    [dic1 setObject:self.ChangeTextView.text forKey:@"X_PICCONTENT"];
    [dic1 setObject:@"" forKey:@"C_PHONETO"];
    [dict setObject:dic1 forKey:@"content"];
    
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager * manager=[[HttpManager alloc]init];
    
    
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        
        if ([data[@"code"] integerValue]==200) {
            [self getModelMessageHttpValues];
            
            self.ChangeMesaageView.hidden=self.BGView.hidden=YES;
              [JRToast showWithText:data[@"message"]];

        }else{
            
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];

    
    
}
- (IBAction)GoBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
