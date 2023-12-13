//
//  SetNameViewController.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/20.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "SetNameViewController.h"

@interface SetNameViewController ()

@end

@implementation SetNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.typee) {
        case TypeWriteCustomName:
             self.title=@"客户姓名";
            self.textField.keyboardType=UIKeyboardTypeDefault;
            break;
        case TypeWriteCustomPhoneNUmber:
            self.title=@"联系电话";
            self.textField.keyboardType=UIKeyboardTypeNumberPad;
            break;
        case TypeWriteCarNumber:
            self.title=@"车牌号码";
            self.textField.keyboardType=UIKeyboardTypeDefault;
            break;
        case TypeWriteCarkm:
            self.title=@"行驶里程";
            self.textField.keyboardType=UIKeyboardTypeNumberPad;
            self.textField.placeholder=@"km";
            break;

            
        default:
            break;
    }
    
    
    self.view.backgroundColor=DBColor(244, 244, 244);
    self.textFieldView.layer.borderColor=[UIColor blackColor].CGColor;
    self.textFieldView.layer.borderWidth=0.5;
   
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:DBGetStringWithKeyFromTable(@"取消", nil) style:UIBarButtonItemStylePlain target:self action:@selector(leftItem)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:DBGetStringWithKeyFromTable(@"保存", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightItem)];
    self.textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    self.textField.text=self.textFieldString;
}


#pragma mark  -- touch
-(void)leftItem{
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)rightItem{
    //点击保存
    if (self.typee==TypeWriteCustomName) {
        if (self.textField.text.length<2) {
            [JRToast showWithText:@"请输入正确的名字"];
            return;
        }else{
            if (self.saveBlock) {
                self.saveBlock(self.textField.text);
            }
            [self.navigationController popViewControllerAnimated:YES];

            
        }

    }else if(self.typee==TypeWriteCustomPhoneNUmber){
        if (self.textField.text.length!=11) {
            [JRToast showWithText:@"手机号码输入错误"];
            return;
        }else{
            if (self.saveBlock) {
                self.saveBlock(self.textField.text);
            }
            [self.navigationController popViewControllerAnimated:YES];


        }
        
        
    }else if(self.typee==TypeWriteCarNumber){
        if (self.textField.text.length!=7) {
            [JRToast showWithText:@"请正确输入车牌(带省简称)"];
            return;
        }else{
            if (self.saveBlock) {
                self.saveBlock(self.textField.text);
            }
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
        
        
    }else if(self.typee==TypeWriteCarkm){
        if (self.textField.text.length<3) {
            [JRToast showWithText:@"请正确输入行驶公路(km)"];
            return;
        }else{
            if (self.saveBlock) {
                self.saveBlock(self.textField.text);
            }
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
        
        
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

@end
