//
//  MQVC.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/21.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MQVC.h"
#import "MQVerCodeInputView.h"

@interface MQVC ()
@property (nonatomic, copy) NSString *numStr;

@end

@implementation MQVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
        DBSelf(weakSelf);
        self.title=@"手动核销";
        MQVerCodeInputView *verView = [[MQVerCodeInputView alloc]initWithFrame:CGRectMake(0,0, WIDE-20, 80)];
        verView.maxLenght = 4;//最大长度
        verView.keyBoardType = UIKeyboardTypeNumberPad;
        [verView mq_verCodeViewWithMaxLenght];
        verView.block = ^(NSString *text){
            weakSelf.numStr=text;
        };
        verView.center = CGPointMake(self.view.centerX, 160+SafeAreaTopHeight);
        [self.view addSubview:verView];
    
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(60, CGRectGetMaxY(verView.frame)+40, WIDE-120, 44);
    btn.layer.cornerRadius=4;
    btn.layer.masksToBounds=YES;
    btn.backgroundColor=KNaviColor;
    [btn setTitleNormal:@"确定"];
    [btn setTitleColor:[UIColor blackColor]];
    [btn addTarget:self action:@selector(keyHiden)];
    [self.view addSubview:btn];
    
}



- (void)keyHiden{
    
    if (self.numStr.length==4) {
                        [self httpRequestQRCodeWithStr:self.numStr];
        
    }else{
                        [JRToast showWithText:@"请输入4位核销码"];
        
    }
}


- (void)httpRequestQRCodeWithStr:(NSString *)codeStr{
   
  
    if (codeStr.length!=4) {
            [JRToast showWithText:@"请输入核销码"];
            return;
    }
    if (self.sid.length==0) {
        [JRToast showWithText:@"核销失败"];
        return;
    }
    if (self.phone.length==0) {
        [JRToast showWithText:@"核销失败"];
        return;
    }
    
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    [dic setObject:self.phone forKey:@"phone"];
    [dic setObject:codeStr forKey:@"takecode"];
    [dic setObject:self.sid forKey:@"id"];
    
    
    [[POPRequestManger defaultManger] requestWithMethod:POST url:HTTP_pointTake dict:dic target:self finished:^(id responsed) {
        if ([responsed[@"code"] intValue]==200) {
            
            [JRToast showWithText:@"核销成功"];
            [self performSelector:@selector(backQR) withObject:self afterDelay:1.0];
        }else{
             [JRToast showWithText:responsed[@"message"]];
        }
        
        
    } failed:^(id error) {
         [JRToast showWithText:@"网络连接失败"];
    }];
}

- (void)backQR{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADLIST" object:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
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
