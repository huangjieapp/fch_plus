//
//  CommonCallViewController.m
//  mcr_s
//
//  Created by bipyun on 16/9/5.
//  Copyright © 2016年 match. All rights reserved.
//

#import "CommonCallViewController.h"
//#import "JSONKit.h"
//#import "MyUtil.h"
//#import "HttpPost.h"


@interface CommonCallViewController ()

@end

@implementation CommonCallViewController

-(void)viewWillDisappear:(BOOL)animated
{
   self.navigationController.navigationBarHidden=NO;
}
-(void)viewWillAppear:(BOOL)animated
{

    self.navigationController.navigationBarHidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *C_U05100_C_ID= [userDefault objectForKey:@"C_U05100_C_ID"];
    [userDefault synchronize];
    self.imgview.layer.cornerRadius=35.0;
    self.imgview.clipsToBounds=YES;
    NSString *telcall;
    [_imgview sd_setImageWithURL:[NSURL URLWithString:_UrlStr] placeholderImage:[UIImage imageNamed:@"logo-头像"]];
    if (self.callStr.length!=11) {
        
        
    }else{
        
      telcall = [self.callStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        
    }
    if ([C_U05100_C_ID isEqualToString:_C_OWNER_ROLEID]) {//自己的
        
        self.callLabel.text=self.callStr;
    }else{
        self.callLabel.text=telcall;
    }
    self.nameLabel.text=self.nameStr;
    
    
    if ([self.typeStr isEqualToString:@"用座机拨打"]) {
        
        self.type.text=@"请接听座机来电，随后将其自动呼叫对方";
        
    }else{
    
        self.type.text=@"请接听手机来电，随后将其自动呼叫对方";
    }
    
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

- (IBAction)callButton:(id)sender {
    
    NSString*C_PHONE=[NewUserSession instance].user.phonenumber;
    NSString*C_INTERNAL=[NewUserSession instance].user.C_INTERNAL;
    
    NSString *urlStr;
   
    
  

     if ([self.typeStr isEqualToString:@"用座机拨打"]) {
         
         urlStr=[NSString stringWithFormat:@"%@C_PHONE=&C_INTERNAL=%@",HTTP_PhoneAddress,C_INTERNAL];
         

     }else{
         
         urlStr=[NSString stringWithFormat:@"%@C_PHONE=%@&C_INTERNAL=%@",HTTP_PhoneAddress,C_PHONE,C_INTERNAL];
     }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        HttpManager*manager=[[HttpManager alloc]init];
        NSString *str1 = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [manager postDataFromNetworkNoHudWithUrl:str1 parameters:nil compliation:^(id data, NSError *error) {
            MyLog(@"%@",data);
            if ([data[@"code"] integerValue]==200) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [JRToast showWithText:data[@"message"]];
            }
            
            
        }];
        
    });

    
}

- (IBAction)cancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
