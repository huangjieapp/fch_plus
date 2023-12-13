//
//  DBPickerView.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/18.
//  Copyright © 2017年 月见黑. All rights reserved.
//



//RGB
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// 缩放比
#define kScale ([UIScreen mainScreen].bounds.size.width) / 375

#define hScale ([UIScreen mainScreen].bounds.size.height) / 667

//字体大小
#define kfont 15


#import "DBPickerView.h"

@interface DBPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong)UIView *bgV;
@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong)UILabel *selectLb;
@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIButton *conpleteBtn;
@property (nonatomic,strong)UIPickerView *pickerV;
@property (nonatomic,strong)UIDatePicker *datePickeV;


@property(nonatomic,strong)NSMutableArray*allDatas;
@property(nonatomic,assign)NSInteger selectedcomponent;
@property(nonatomic,assign)NSInteger selectedRow;

@end

@implementation DBPickerView

-(instancetype)initWithFrame:(CGRect)frame andCurrentType:(PickViewType)currentType andmtArrayDatas:(NSMutableArray*)mtArrayDatas andSelectStr:(NSString*)selectedStr andTitleStr:(NSString*)titleStr andBlock:(chosePickViewBlock)choseBock{
    self=[super initWithFrame:frame];
    if (self) {
         [self creatUIFrame:frame];
       
        self.currentType=currentType;
        self.mtArrayDatas=mtArrayDatas;
        self.selectStr=selectedStr;
        self.titleStr=titleStr;
        self.choseBlock=choseBock;
     
        
    }
    return self;
    
    
}



#pragma mark  --UI
-(void)creatUIFrame:(CGRect)frame{
    self.frame=frame;
    self.backgroundColor = RGBA(51, 51, 51, 0.8);
    self.bgV = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, KScreenWidth, 270*hScale)];
    self.bgV.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgV];
    [self showAnimation];

    
    
    //取消
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bgV addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
                make.width.mas_equalTo(100);
        make.height.mas_equalTo(54);
        
    }];
    self.cancelBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:kfont];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn setTitleColor:RGBA(0, 122, 255, 1) forState:UIControlStateNormal];
    //完成
    self.conpleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bgV addSubview:self.conpleteBtn];
    [self.conpleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
                make.width.mas_equalTo(100);
        make.height.mas_equalTo(54);
        
    }];
    
    self.conpleteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -40);
    self.conpleteBtn.titleLabel.font = [UIFont systemFontOfSize:kfont];
    [self.conpleteBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.conpleteBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.conpleteBtn setTitleColor:RGBA(0, 122, 255, 1) forState:UIControlStateNormal];

    
    //选择titi
    self.selectLb = [UILabel new];
    [self.bgV addSubview:self.selectLb];
    [self.selectLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgV.mas_centerX).offset(0);
        make.centerY.mas_equalTo(self.conpleteBtn.mas_centerY).offset(0);
    }];
    self.selectLb.font = [UIFont systemFontOfSize:kfont];
    self.selectLb.textAlignment = NSTextAlignmentCenter;
 
    
    //线
    UIView *line = [UIView new];
    self.line = line;
    [self.bgV addSubview:self.line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.cancelBtn.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(KScreenWidth);
        make.height.mas_equalTo(0.5);
        
    }];
    line.backgroundColor = RGBA(224, 224, 224, 1);

    
    
    //选择器
    self.pickerV = [UIPickerView new];
    [self.bgV addSubview:self.pickerV];
    [self.pickerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).offset(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        
    }];
    self.pickerV.delegate = self;
    self.pickerV.dataSource = self;

    
    
    
}


- (void)creatDate:(UIDatePickerMode)DatePickerMode{
    
    [self.pickerV removeFromSuperview];
    //选择器
    self.datePickeV = [UIDatePicker new];
    self.datePickeV.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_cn"];
    if (@available(iOS 13.4, *)) {
        self.datePickeV.preferredDatePickerStyle = UIDatePickerStyleWheels;
    } else {
        // Fallback on earlier versions
    }
    [self.bgV addSubview:self.datePickeV];
    [self.datePickeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line.mas_bottom).offset(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        
    }];
    
    self.datePickeV.datePickerMode = DatePickerMode;
}



#pragma mark-----UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerVie{
    if (self.currentType==PickViewTypeArray || self.currentType == PickViewTypeMimute) {
        return 1;
    }else if (self.currentType==PickViewTypeAddress){
        return 2;
    }else if (self.currentType==PickViewTypeNewAddress){
        return 2;
    }else{
        return 0;
    }
   
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.currentType==PickViewTypeArray || self.currentType == PickViewTypeMimute) {
        return self.allDatas.count;
    }else if (self.currentType==PickViewTypeAddress){
        if (component==0) {
            return self.allDatas.count;
        }else{
            NSDictionary*dict=self.allDatas[self.selectedcomponent];
            NSArray *cities = dict[@"cities"];
            return [cities count];
        }
        
        
    }else if (self.currentType==PickViewTypeNewAddress){
        if (component==0) {
            return self.allDatas.count;
        }else{
            NSDictionary*dict=self.allDatas[self.selectedcomponent];
            NSArray *children = dict[@"children"];
            
            return [children count];
        }
        
        
    }else{
        return 0;
    }
    
  
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    if (self.currentType==PickViewTypeAddress){
        label.font = [UIFont systemFontOfSize:13];
    }
    if (self.currentType==PickViewTypeNewAddress){
        label.font = [UIFont systemFontOfSize:13];
    }
    label.text=[self pickerView:pickerView titleForRow:row forComponent:component];

      return label;

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (self.currentType==PickViewTypeArray || self.currentType == PickViewTypeMimute) {
        return self.allDatas[row];
    }else if (self.currentType==PickViewTypeAddress){
        if (component==0) {
            NSDictionary*dict=self.allDatas[row];
            return dict[@"name"];
        }else{
            NSDictionary*dict=self.allDatas[self.selectedcomponent];
            NSArray*array=dict[@"cities"];
            return array[row];
        }
        
        
       
       

        
    }else if (self.currentType==PickViewTypeNewAddress){
        if (component==0) {
            NSDictionary*dict=self.allDatas[row];
            return dict[@"label"];
        }else{
            NSDictionary*dict=self.allDatas[self.selectedcomponent];
            NSArray*array=dict[@"children"];
            return array[row];
        }
        
        
       
       

        
    }else{
        return nil;
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (self.currentType) {
        case PickViewTypeAddress:{
            if (component==0) {
                self.selectedcomponent=row;
                [self.pickerV reloadComponent:1];
            }else{
                self.selectedRow=row;
            }
         
            break;}
        case PickViewTypeNewAddress:{
            if (component==0) {
                self.selectedcomponent=row;
                [self.pickerV reloadComponent:1];
            }else{
                self.selectedRow=row;
            }
         
            break;}
        default:
            break;
    }
    
    
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 110;
}








#pragma mark  --click
- (void)cancelBtnClick{
	
    [self hideAnimation];
}

- (void)completeBtnClick{
    NSString*selectedValue;
    NSString*selectedIndex;
    
    switch (self.currentType) {
		case PickViewTypeMimute:{
			if (self.allDatas.count<1) {
				return;
			}
			
			NSInteger number=[self.pickerV selectedRowInComponent:0];
			selectedValue=self.allDatas[number];
			selectedIndex=[NSString stringWithFormat:@"%lu",number];
			break;
		}
        case PickViewTypeArray:{
            if (self.allDatas.count<1) {
                return;
            }
            
            NSInteger number=[self.pickerV selectedRowInComponent:0];
            selectedValue=self.allDatas[number];
            selectedIndex=[NSString stringWithFormat:@"%lu",number];
            break;}
        case PickViewTypeAddress:{
            NSInteger SectionNumber=[self.pickerV selectedRowInComponent:0];
            NSInteger RowNumber=[self.pickerV selectedRowInComponent:1];
            
            NSString*sectionStr=self.allDatas[SectionNumber][@"name"];
            NSString*rowStr=self.allDatas[SectionNumber][@"cities"][RowNumber];
            
            selectedValue=[NSString stringWithFormat:@"%@,%@",sectionStr,rowStr];
            selectedIndex=[NSString stringWithFormat:@"%lu,%lu",SectionNumber,RowNumber];
            
            break;}
        case PickViewTypeNewAddress:{
            NSInteger SectionNumber=[self.pickerV selectedRowInComponent:0];
            NSInteger RowNumber=[self.pickerV selectedRowInComponent:1];
            
            NSString*sectionStr=self.allDatas[SectionNumber][@"label"];
            NSString*rowStr=self.allDatas[SectionNumber][@"children"][RowNumber];
            
            selectedValue=[NSString stringWithFormat:@"%@,%@",sectionStr,rowStr];
            selectedIndex=[NSString stringWithFormat:@"%lu,%lu",SectionNumber,RowNumber];
            
            break;}
        case PickViewTypeBirthday:{
            NSDate*date=self.datePickeV.date;
            
            NSInteger dateInteger=[date timeIntervalSince1970];
            NSString*dateIntegerStr=[NSString stringWithFormat:@"%lu",dateInteger];
            
            NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString*dateStr=[formatter stringFromDate:date];
           
            selectedValue=dateStr;
            selectedIndex=dateIntegerStr;
            
            break;}

        case PickViewTypeDate:{
            NSDate*date=self.datePickeV.date;
            //date转成 时间戳
            NSInteger dateInteger=[date timeIntervalSince1970];
            NSString*dateIntegerStr=[NSString stringWithFormat:@"%lu",dateInteger];
            //时间戳到 格式化
            NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSString*dateStr=[formatter stringFromDate:date];
            
            selectedValue=dateStr;
            selectedIndex=dateIntegerStr;

            
            break;}
		case PickViewTypeDateToMimute:{
			NSDate*date=self.datePickeV.date;
			//date转成 时间戳
			NSInteger dateInteger=[date timeIntervalSince1970];
			NSString*dateIntegerStr=[NSString stringWithFormat:@"%lu",dateInteger];
			//时间戳到 格式化
			NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
			[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
			NSString*dateStr=[formatter stringFromDate:date];
			
			selectedValue=dateStr;
			selectedIndex=dateIntegerStr;
			
			
			break;}
		case PickViewTypePickerModeTime: {
			NSDate*date=self.datePickeV.date;
			//date转成 时间戳
			NSInteger dateInteger=[date timeIntervalSince1970];
			NSString*dateIntegerStr=[NSString stringWithFormat:@"%lu",dateInteger];
			//时间戳到 格式化
			NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
			[formatter setDateFormat:@"HH:mm"];
			NSString*dateStr=[formatter stringFromDate:date];
			
			selectedValue=dateStr;
			selectedIndex=dateIntegerStr;
			break;
		}
        default:
            break;
    }
    
   
    if (self.choseBlock) {
        self.choseBlock(selectedValue, selectedIndex);
    }
   
    [self hideAnimation];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self hideAnimation];
    
}


#pragma mark  --set
-(void)setCurrentType:(PickViewType)currentType{
    _currentType=currentType;
    switch (currentType) {
		case PickViewTypeMimute: {
			[self.pickerV reloadAllComponents];
			
			break;
		}
        case PickViewTypeArray:{
            [self.pickerV reloadAllComponents];
            
            break;}
        case PickViewTypeAddress:{
            [self.pickerV reloadAllComponents];
            
            break;}
        case PickViewTypeNewAddress:{
            [self.pickerV reloadAllComponents];
            
            break;}
        case PickViewTypeBirthday:{
             [self creatDate:UIDatePickerModeDate];
            
            break;}

        case PickViewTypeDate:{
             [self creatDate:UIDatePickerModeDateAndTime];
            
            break;}
		case PickViewTypeDateToMimute:{
			[self creatDate:UIDatePickerModeDateAndTime];
			break;
		}
		case PickViewTypePickerModeTime: {
			[self creatDate:UIDatePickerModeTime];
			break;
		}
            
        default:
            break;
    }
    
}



-(void)setMtArrayDatas:(NSMutableArray *)mtArrayDatas{
    _mtArrayDatas=mtArrayDatas;
    self.allDatas=[mtArrayDatas mutableCopy];

}

-(void)setSelectStr:(NSString *)selectStr{
    _selectStr=selectStr;
    if (selectStr.length==0) {
        return;
    }
    
    
    switch (self.currentType) {
		case PickViewTypeMimute: {
			NSUInteger number=[self indexOfNSArray:self.allDatas WithStr:selectStr];
			[self.pickerV selectRow:number inComponent:0 animated:YES];
			
			break;
		}
        case PickViewTypeArray:{
            NSUInteger number=[self indexOfNSArray:self.allDatas WithStr:selectStr];
            [self.pickerV selectRow:number inComponent:0 animated:YES];
            
            break;}
        case PickViewTypeAddress:{
            NSIndexPath*indexPath=[self getAddressNumberWithStr:selectStr];
            
            self.selectedcomponent=indexPath.section;
            self.selectedRow=indexPath.row;
            
            [self.pickerV selectRow:indexPath.section inComponent:0 animated:YES];
            [self.pickerV selectRow:indexPath.row inComponent:1 animated:YES];
            
            break;}
        case PickViewTypeNewAddress:{
            NSIndexPath*indexPath=[self getAddressNumberWithStr:selectStr];
            
            self.selectedcomponent=indexPath.section;
            self.selectedRow=indexPath.row;
            
            [self.pickerV selectRow:indexPath.section inComponent:0 animated:YES];
            [self.pickerV selectRow:indexPath.row inComponent:1 animated:YES];
            
            break;}
        case PickViewTypeBirthday:{
            //string yyyy-MM-dd格式 转换成 date
            NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
           NSDate*date=[dateFormatter dateFromString:selectStr];
            //设置 时间选择器的时间
            if (date) {
                [self.datePickeV setDate:date];
            }
            

            
//            //string 时间戳格式   转化成date
//            NSDate*lastDate=[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[selectStr integerValue]];
            
            break;}
            
        case PickViewTypeDate:{
            NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate*date=[dateFormatter dateFromString:selectStr];
            //设置 时间选择器的时间
            if (date) {
                 [self.datePickeV setDate:date];
            }
            break;}
            
		case PickViewTypeDateToMimute:{
			NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
			[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
			NSDate*date=[dateFormatter dateFromString:selectStr];
			//设置 时间选择器的时间
			if (date) {
				[self.datePickeV setDate:date];
			}
			
			break;
		}
		case PickViewTypePickerModeTime: {
			NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
			[dateFormatter setDateFormat:@"HH:mm"];
			NSDate*date=[dateFormatter dateFromString:selectStr];
			//设置 时间选择器的时间
			if (date) {
				[self.datePickeV setDate:date];
			}
			break;
		}
        default:
            break;
    }
    
}


-(void)setTitleStr:(NSString *)titleStr{
    _titleStr=titleStr;
    self.selectLb.text=titleStr;
    
}



#pragma mark  --funcation

//得到str 在数组中第几个    只适用array
- (NSUInteger)indexOfNSArray:(NSArray *)arr WithStr:(NSString *)str{
    
    NSUInteger chosenDxInt = 0;
    if (str && ![str isEqualToString:@""]) {
        chosenDxInt = [arr indexOfObject:str];
        if (chosenDxInt == NSNotFound)
            chosenDxInt = 0;
    }
    return chosenDxInt;
}

//得到section和row
-(NSIndexPath*)getAddressNumberWithStr:(NSString*)str{
    NSArray*array=[str componentsSeparatedByString:@","];
    NSString*sectionStr=array[0];
    NSString*rowStr=array[1];
    if (!sectionStr||!rowStr) {
        return [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    
    NSMutableArray*sectionArray=[NSMutableArray array];
    for (NSDictionary*dict in self.allDatas) {
        [sectionArray addObject:dict[@"name"]];
    }
    
    NSInteger SectionChosenIndex=[sectionArray indexOfObject:sectionStr];
    
    
    NSArray*rowArray=self.allDatas[SectionChosenIndex][@"cities"];
    NSInteger RowChosenIndex=[rowArray indexOfObject:rowStr];
    
    
    
    return [NSIndexPath indexPathForRow:RowChosenIndex inSection:SectionChosenIndex];
  
}


//显示动画
- (void)showAnimation{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect frame = self.bgV.frame;
        frame.origin.y = self.frame.size.height-260*hScale;
        self.bgV.frame = frame;
    }];
    
}


//隐藏动画
- (void)hideAnimation{
    DBSelf(weakSelf);
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect frame = weakSelf.bgV.frame;
        frame.origin.y = weakSelf.frame.size.height;
        weakSelf.bgV.frame = frame;
        
    } completion:^(BOOL finished) {
		if (weakSelf.cancelBlock) {
			weakSelf.cancelBlock();
		}
        [weakSelf.bgV removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}



@end
