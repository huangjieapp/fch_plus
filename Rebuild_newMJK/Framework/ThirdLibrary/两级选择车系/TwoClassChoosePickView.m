//
//  TwoClassChoosePickView.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/11.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "TwoClassChoosePickView.h"



#define kHeaderHeight 40
#define kPickViewHeight 220
#define kSureBtnColor [UIColor colorWithRed:147/255.f green:196/255.f blue:246/255.f alpha:1.0]
#define kCancleBtnColor [UIColor colorWithRed:120/255.f green:120/255.f blue:120/255.f alpha:1.0]
#define kHeaderViewColor KNaviColor


@interface TwoClassChoosePickView()<UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIView*mainView;
@property(nonatomic,assign)NSInteger selectedFirstComponent;
@property(nonatomic,assign)NSInteger selectedSecondComponent;
@end

@implementation TwoClassChoosePickView

+(TwoClassChoosePickView*)showTwoClassChoosePickViewWithComplete:(chooseResultBlock)block{
    
    
    TwoClassChoosePickView*pickView=[[TwoClassChoosePickView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:pickView];

    pickView.completeBlock = block;

    
    return pickView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self falseDatas];
        [self setupUI];
    }
    return self;
}


- (void)setupUI{
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissVC)];
    tap.delegate=self;
    [self addGestureRecognizer:tap];
    
    
    CGFloat width = self.frame.size.width;
    
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-(kPickViewHeight+kHeaderHeight),width,kPickViewHeight+kHeaderHeight)];
    [viewBg setBackgroundColor:[UIColor whiteColor]];
    viewBg.layer.cornerRadius = 5;
    viewBg.layer.masksToBounds = YES;
    [self addSubview:viewBg];
    self.mainView=viewBg;
    
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0,0, width,kHeaderHeight)];
    [viewHeader setBackgroundColor:kHeaderViewColor];
    [viewBg addSubview:viewHeader];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0,4, 50, 32)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:kCancleBtnColor forState:UIControlStateNormal];
    cancelButton.titleLabel.font= [UIFont systemFontOfSize:15];
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:cancelButton];
    
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setFrame:CGRectMake(viewHeader.frame.size.width-50,4, 50, 32)];
    [sureButton setTitle:@"完成" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureButton setTitleColor:kSureBtnColor forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureACtion:) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:sureButton];
    
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,kHeaderHeight,width,kPickViewHeight)];
    [self.pickerView setBackgroundColor:[UIColor whiteColor]];
    [viewBg addSubview:self.pickerView];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
}



#pragma mark - PickerView的数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return self.mainDatas.count;
    }else{
       NSArray*array=[self.mainDatas[_selectedFirstComponent] allValues][0];
        
        return array.count;
    }
    
}


-(nullable NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        return [self.mainDatas[row] allKeys][0];
        
    }else{
        NSArray*array=[self.mainDatas[self.selectedFirstComponent] allValues][0];
        return array[row];
        
        
    }
    return nil;
}


-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width - 30) / 2,40)];
    label.textAlignment=NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;

    
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        self.selectedFirstComponent=row;
        self.selectedSecondComponent=0;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
    }else{
        self.selectedSecondComponent=row;
        
    }
    
    
}


#pragma mark -- delegat
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.mainView]) {
        return NO;
    }
    
    return YES;
}
#pragma mark  --touch
-(void)dismissVC{
    [self removeFromSuperview];
}

- (void)cancelAction:(UIButton *)btn{
    [self removeFromSuperview];
}
- (void)sureACtion:(UIButton *)btn{
    //    NSArray *arr = [self getChooseCityArr];
    //    if (self.completeBlcok != nil) {
    //        self.completeBlcok(arr);
    //    }
    
    NSString*FirstStr=[self.mainDatas[_selectedFirstComponent] allKeys][0];
    NSString*SecondStr=[self.mainDatas[_selectedFirstComponent] allValues][0][_selectedSecondComponent];
    
    if (self.completeBlock) {
        self.completeBlock(FirstStr, SecondStr);
    }
    
    
    [self removeFromSuperview];
}


#pragma mark  --set
-(void)falseDatas{
    NSDictionary*dict=@{@"BMW":@[@"3service",@"5 service",@"730Li",@"X7",@"M3"]};
    NSDictionary*dict1=@{@"Benz":@[@"C class",@"E class",@"G 500",@"mabach",@"S 600"]};
    NSDictionary*dict2=@{@"Audi":@[@"A4L",@"A6L",@"R8",@"Q5",@"Q7"]};
    
    self.mainDatas=[NSMutableArray arrayWithObjects:dict,dict1,dict2, nil];
    
//    self.saveAllBrand=[NSMutableArray array];
//    for (NSDictionary*dict in self.mainDatas) {
//        [self.saveAllBrand addObject:dict.allKeys[0]];
//    }
//   
//    MyLog(@"%@",self.saveAllBrand);
    
}

@end
