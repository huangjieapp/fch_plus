//
//  CGCAlertDateView.m
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/28.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCAlertDateView.h"
#import "DBPickerView.h"

@interface CGCAlertDateView()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, copy) DATESELECT dateSel;

@property (nonatomic, copy) SUREBLOCK sureSel;

@property (nonatomic, copy) NSString *dateStr;

@property (nonatomic, copy) NSString *remStr;

@property (nonatomic, strong) UIView *keyBtn;

//选择的数据源
@property(nonatomic,strong)NSArray*chooseArray;

@property (nonatomic, strong) NSString *titleText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textTFLeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkLeftLayout;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishTimeLabel;
@end

@implementation CGCAlertDateView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame withSelClick:(DATESELECT)dateSel withSureClick:(SUREBLOCK)sureClick withHight:(CGFloat)hight withText:(NSString *)text withDatas:(NSArray*)chooseArray{
    
    if (self=[super initWithFrame:frame]) {
        self=[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CGCAlertDateView class]) owner:self options:nil] lastObject];
        self.dateSel = dateSel;
        self.sureSel = sureClick;
        self.bgHight.constant=hight;
        self.chooseArray=chooseArray;
        
        self.titleText = text;
        if (self.chooseArray.count<1) {
            self.dateStr=[DBTools getTimeFomatFromCurrentTimeStamp];
            //            self.textfield.text=self.dateStr;
            
            
        }else{
            //            self.textfield.text=chooseArray[0];
            self.textfield.text=nil;
            self.dateStr=nil;
        }
        
        
        
        self.desLab.text=text;
        
        if (hight==130) {
            self.desLab.text=@"";
            self.remarkText.hidden=YES;
        }
        
        if (hight==140) {
            //            self.desLab.text=@"";
            self.remarkText.hidden=YES;
        }
        if (hight==150) {
            self.textfield.text=self.dateStr;
            self.remarkText.hidden=YES;
        }
        if (hight == 180) {
            self.textfield.hidden = NO;
            self.modelTextField.hidden = YES;
        }
        if (hight == 192) {
            self.textfield.hidden = YES;
            self.modelTextField.hidden = NO;
        }
        
        if (hight == 190) {
            self.startTimeLabel.hidden = NO;
            self.finishTimeLabel.hidden = NO;
            self.textTFLeftLayout.constant = 116;
            self.remarkLeftLayout.constant = 116;
            self.textfield.placeholder = @"请选择期望开始时间";
            self.remarkText.placeholder = @"请选择期望完成时间";
            self.remarkText.inputView = [[UIView alloc]init];
            [self.remarkText addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventEditingDidBegin];
        }
        
        if (hight == 195) {
            self.textfield.text=self.dateStr;
        }
        
        
        
        self.remarkText.delegate=self;
        [self.remarkText addTarget:self action:@selector(textBeign) forControlEvents:UIControlEventEditingDidBegin];
        [self.canelBtn addTarget:self action:@selector(alertCanelClick:)];
        if (hight == 190) {
            self.selbtn.hidden = YES;
            self.textfield.inputView = [[UIView alloc]init];
            [self.textfield addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventEditingDidBegin];
        } else {
            self.selbtn.hidden = NO;
            [self.selbtn addTarget:self action:@selector(alertSelClick:)];
        }
        [self.sureBtn addTarget:self action:@selector(alertSureClick:)];
        
        [self.bgBtn addTarget:self action:@selector(dismissView)];
    }
    return self;
}

- (void)selectTime:(UITextField *)tf {
    DBPickerView *pickerView = [[DBPickerView alloc]initWithFrame:self.frame andCurrentType:PickViewTypeDate andmtArrayDatas:nil andSelectStr:tf.text andTitleStr:nil andBlock:^(NSString *title, NSString *indexStr) {
        if (tf == self.remarkText) {
            
            tf.text = title;
        } else {
            tf.text = title;
            self.dateStr = title;
        }
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:pickerView];
    pickerView.cancelBlock = ^{
        [self.textfield resignFirstResponder];
    };
}

- (void)dismissView{
    
    [self removeFromSuperview];
}


- (void)alertCanelClick:(UIButton *)btn{
    //    if ([self.titleText isEqualToString:@"请选择延期时间"]) {
    //        if (self.cancelActionBlock) {
    //            self.cancelActionBlock();
    //        }
    //    } else {
    [self removeFromSuperview];
    //    }
    
}

- (void)alertSureClick:(UIButton *)btn{
    if (self.bgHight.constant == 190) {
        if (self.textfield.text.length <= 0) {
            [JRToast showWithText:@"请选择期望开始时间"];
            return;
        }
        if (self.remarkText.text.length <= 0) {
            [JRToast showWithText:@"请选择期望完成时间"];
            return;
        }
        if (self.sureSel) {
            self.sureSel(self.textfield.text,self.remarkText.text);
        }
        
    } else
        if (self.bgHight.constant == 192) {
            if (self.modelTextField.text.length <= 0) {
                [JRToast showWithText:@"请输入设备号"];
                return;
            }
            if (self.remarkText.text.length <= 0) {
                [JRToast showWithText:@"请输入位置"];
                return;
            }
            if (self.sureSel) {
                self.sureSel(self.modelTextField.text,self.remarkText.text);
            }
        } else
            if (self.bgHight.constant == 191)/*来电流量的未留档*/ {
                if (self.textfield.text.length <= 0) {
                    [JRToast showWithText:@"请选择原因类型"];
                    return;
                }
                if (self.remarkText.text.length <= 0) {
                    [JRToast showWithText:self.noticeStr.length > 0 ? self.noticeStr :  @"请输入备注"];
                    return;
                }
                if (self.sureSel) {
                    self.sureSel(self.textfield.text,self.remarkText.text);
                }
            } else if (self.bgHight.constant == 180) {
                if (self.sureSel) {
                    self.sureSel(self.modelTextField.text,self.remarkText.text);
                }
            } else {
                //        if (self.dateStr.length <= 0) {
                //            self.dateStr = self.chooseArray[0];
                //        }
                if (self.textfield.text.length <= 0) {
                    [JRToast showWithText:@"请选择原因类型"];
                    return;
                }
                if ([self.VCName isEqualToString:@"必填"]) {
                    if (self.remarkText.text.length <= 0) {
                        [JRToast showWithText:self.noticeStr.length > 0 ? self.noticeStr :  @"请输入备注"];
                        return;
                    }
                }
                
                if (self.sureSel) {
                    
                    self.sureSel(self.textfield.text,[NSString stringWithFormat:@"%@ %@",self.textfield.text, self.remarkText.text]);
                }
            }
    [self removeFromSuperview];
}


//点击了  跳时间选择  还是  数据选择
- (void)alertSelClick:(UIButton *)btn{
    if (self.chooseArray.count<2) {
        [self datePickerAndMethod];
        if (self.dateSel) {
            self.dateSel();
        }
        
    }else{
        [self choosePickView];
        
        if (self.dateSel) {
            self.dateSel();
        }
        self.textfield.text = self.chooseArray[0];
        
    }
    
    
}

- (void)layoutSubviews{
    
    self.width=KScreenWidth;
    self.height=KScreenHeight;
    
}

- (void)datePickerAndMethod
{
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=self.bounds;
    [btn addTarget:self action:@selector(dissmissPicker) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor=CGCBGCOLOR;
    self.pickerBtn=btn;
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-200, KScreenWidth, 200)];
    view.backgroundColor=[UIColor whiteColor];
    
    UIButton * doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame=CGRectMake(KScreenWidth-60, 0, 60, 40);
    [doneBtn addTarget:self action:@selector(dissmissPicker) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setTitleNormal:@"完成"];
    [doneBtn setTitleColor:[UIColor blackColor]];
    [view addSubview:doneBtn];
    
    UIButton * canelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    canelBtn.frame=CGRectMake(0, 0, 60, 40);
    [canelBtn addTarget:self action:@selector(dissmissPicker) forControlEvents:UIControlEventTouchUpInside];
    [canelBtn setTitleNormal:@"取消"];
    [canelBtn setTitleColor:[UIColor blackColor]];
    [view addSubview:canelBtn];
    
    UIDatePicker *Picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, 160)];
    Picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_cn"];
    Picker.datePickerMode = UIDatePickerModeDateAndTime;
    if (@available(iOS 13.4, *)) {
        Picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    } else {
        // Fallback on earlier versions
    }
    NSDate *Date = [NSDate date];
    NSDateFormatter *birthformatter = [[NSDateFormatter alloc] init];
    birthformatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    birthformatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    
    
    [Picker setDate:Date animated:YES];
    
    [Picker addTarget:self action:@selector(showDate:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:Picker];
    [self.pickerBtn addSubview:view];
    [self.window addSubview:self.pickerBtn];
    
    
    
}

- (void)showDate:(UIDatePicker *)datePicker
{
    
    NSDate *date = datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *outputString = [formatter stringFromDate:date];
    self.textfield.text=outputString;
    self.dateStr=outputString;
    
}

//开始编辑
- (void)textBeign{
    
    UIWindow * window=[UIApplication sharedApplication].keyWindow;
    UIView * view=[[UIView alloc] initWithFrame:window.bounds];
    view.backgroundColor=[UIColor clearColor];
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(disView)];
    btn.frame=window.bounds;
    btn.backgroundColor=[UIColor clearColor];
    [view addSubview:btn];
    [window addSubview:view];
    
    self.keyBtn=view;
    
    
}

- (void)disView{
    [self.keyBtn removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.keyBtn removeFromSuperview];
    self.remStr=textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self disView];
    return YES;
}

- (void)dissmissPicker{
    
    [self.pickerBtn removeFromSuperview];
}





#pragma mark  --  选择器
-(void)choosePickView{
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=self.bounds;
    [btn addTarget:self action:@selector(dissmissPicker) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor=CGCBGCOLOR;
    self.pickerBtn=btn;
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-200, KScreenWidth, 200)];
    view.backgroundColor=[UIColor whiteColor];
    
    UIButton * doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame=CGRectMake(KScreenWidth-60, 0, 60, 40);
    [doneBtn addTarget:self action:@selector(dissmissPicker) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setTitleNormal:@"完成"];
    [doneBtn setTitleColor:[UIColor blackColor]];
    [view addSubview:doneBtn];
    
    UIButton * canelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    canelBtn.frame=CGRectMake(0, 0, 60, 40);
    [canelBtn addTarget:self action:@selector(dissmissPicker) forControlEvents:UIControlEventTouchUpInside];
    [canelBtn setTitleNormal:@"取消"];
    [canelBtn setTitleColor:[UIColor blackColor]];
    [view addSubview:canelBtn];
    
    
    //这里写。。
    UIPickerView*pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, KScreenWidth, 160)];
    pickerView.delegate=self;
    pickerView.dataSource=self;
    [view addSubview:pickerView];
    [self.pickerBtn addSubview:view];
    [self.window addSubview:self.pickerBtn];
    
    
}

#pragma mark-----UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerVie{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.chooseArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return _chooseArray[row];
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString*outputString=_chooseArray[row];
    self.textfield.text=outputString;
    self.dateStr=outputString;
    
    
}


@end
