//
//  CGCAlertDateView.m
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/28.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCNewAlertDateView.h"
#import "DBPickerView.h"

@interface CGCNewAlertDateView()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, copy) DATESELECT dateSel;

@property (nonatomic, copy) SURENEWBLOCK sureSel;

@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, copy) NSString *secondDateStr;

@property (nonatomic, copy) NSString *remStr;

@property (nonatomic, strong) UIView *keyBtn;

//选择的数据源
@property(nonatomic,strong)NSArray*chooseArray;
@property(nonatomic,strong)NSArray*secondChooseArray;

@property (nonatomic, strong) NSString *titleText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textTFLeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkLeftLayout;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishTimeLabel;
/** <#注释#>*/
@property (nonatomic, strong) UITextField *tf;
@end

@implementation CGCNewAlertDateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame withSelClick:(DATESELECT)dateSel withSureClick:(SURENEWBLOCK)sureClick withHight:(CGFloat)hight withText:(NSString *)text withDatas:(NSArray*)chooseArray andSecondChooseArray:(NSArray *)secondChooseArray{

    if (self=[super initWithFrame:frame]) {
        self=[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CGCNewAlertDateView class]) owner:self options:nil] lastObject];
        self.dateSel = dateSel;
        self.sureSel = sureClick;
        self.bgHight.constant=hight;
        self.chooseArray=chooseArray;
        self.secondChooseArray = secondChooseArray;
        
        self.titleText = text;
        if (self.chooseArray.count<1) {
            self.dateStr=[DBTools getTimeFomatFromCurrentTimeStamp];
//            self.textfield.text=self.dateStr;
			
            
        }else{
//            self.textfield.text=chooseArray[0];
            self.textfield.text=nil;
            self.dateStr=nil;
            self.secondDateStr = nil;
        }
        
        

        self.desLab.text=text;

        
		
		if (hight == 240) {
			self.startTimeLabel.hidden = NO;
			self.finishTimeLabel.hidden = NO;
			self.textTFLeftLayout.constant = 116;
			self.remarkLeftLayout.constant = 116;
            self.textfield.inputView = [[UIView alloc]init];
            self.textfield1.inputView = [[UIView alloc]init];
            [self.textfield addTarget:self action:@selector(alertSelClick:) forControlEvents:UIControlEventEditingDidBegin];
            [self.textfield1 addTarget:self action:@selector(alertSecondSelClick:) forControlEvents:UIControlEventEditingDidBegin];
        }
		
			
        [self.sureBtn addTarget:self action:@selector(alertSureClick:)];
        
        [self.canelBtn addTarget:self action:@selector(alertCanelClick:)];
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
            if ([self.self.titleText isEqualToString:@"延期信息"]) {
                self.remarkText.text = [DBTools getTimeFomatFromTimeStampAddThreeTime:self.dateStr];
            }
		}
	}];
	[[UIApplication sharedApplication].keyWindow addSubview:pickerView];
	pickerView.cancelBlock = ^{
		[self.textfield resignFirstResponder];
        [self.textfield1 resignFirstResponder];

	};
}

- (void)dismissView{

    [self removeFromSuperview];
}


- (void)alertCanelClick:(UIButton *)btn{
//	if ([self.titleText isEqualToString:@"请选择延期时间"]) {
//		if (self.cancelActionBlock) {
//			self.cancelActionBlock();
//		}
//	} else {
		[self removeFromSuperview];
//	}
	
}

- (void)alertSureClick:(UIButton *)btn{
	if (self.bgHight.constant == 240) {
		if (self.textfield.text.length <= 0) {
			[JRToast showWithText:@"请选择门店"];
			return;
		}
        if (self.textfield1.text.length <= 0) {
            [JRToast showWithText:@"请选择归还理由"];
            return;
        }
		if (self.remarkText.text.length <= 0) {
			[JRToast showWithText:@"请填写归还理由"];
			return;
		}
		if (self.sureSel) {
			self.sureSel(self.textfield.text,self.textfield1.text,self.remarkText.text);
		}
		
	}
    [self removeFromSuperview];
}


//点击了  跳时间选择  还是  数据选择
- (void)alertSelClick:(UITextField *)tf{
    if (self.chooseArray.count<2  && self.bgHight.constant != 240) {
        [self datePickerAndMethod];
        if (self.dateSel) {
            self.dateSel();
        }

    }else{
        
        self.tf = self.textfield;
        [self choosePickView];
        
        if (self.dateSel) {
            self.dateSel();
        }
            self.textfield.text = self.chooseArray[0];
 
    }
   
    
  }
- (void)alertSecondSelClick:(UITextField *)tf{
    if (self.chooseArray.count<2 && self.bgHight.constant != 240) {
        [self datePickerAndMethod];
        if (self.dateSel) {
            self.dateSel();
        }
        
    }else{
        
        self.tf = self.textfield1;
        [self choosePickView];
        
        if (self.dateSel) {
            self.dateSel();
        }
            self.textfield1.text = self.secondChooseArray[0];
        
        
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
    
    if (self.tf == self.textfield) {
        return self.chooseArray.count;
    } else {
        return self.secondChooseArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (self.tf == self.textfield) {
        return _chooseArray[row];
    } else {
        return self.secondChooseArray[row];
    }
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.tf == self.textfield) {
        NSString*outputString=_chooseArray[row];
        self.textfield.text=outputString;
        self.dateStr=outputString;
    } else {
        NSString*outputString=_secondChooseArray[row];
        self.textfield1.text=outputString;
        self.secondDateStr=outputString;
    }
    

    
}


@end
