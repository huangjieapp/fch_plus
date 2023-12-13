//
//  CFDropDownMenuView.m
//  CFDropDownMenuView
//
//  Created by Peak on 16/5/28.
//  Copyright © 2016年 陈峰. All rights reserved.
//

#import "CFDropDownMenuView.h"
#import "CFMacro.h"
#import "UIView+CFFrame.h"
#import "MJKChooseNewBrandSubModel.h"
#import "MJKProductShowModel.h"

#define kViewTagConstant 1000  // 所有tag都加上这个 防止出现为0的tag
#define KNormalColor    [UIColor blackColor]
#define KSelectedColor  KNaviColor


@interface CFDropDownMenuView ()

/* 最上面的view   4个按钮的底 */
@property (nonatomic, strong) UIView *titleBar;
/*ViewBar的高  */
@property(nonatomic,assign)NSInteger titleBarHeight;
//menu 的宽度 不一定要是 定死的宽
@property(nonatomic,assign)NSInteger menuWith;


/* 整个屏幕的 背景 半透明View */
@property (nonatomic, strong) UIView *bgView;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;
@property (nonatomic, strong) NSString *C_A49600_C_ID;




/*
 * 所有的model数组
 */
@property(nonatomic,strong)NSMutableArray*saveAllModel;

/* 分类按钮 数组 保存了 所有的Bar上的button */
@property (nonatomic, strong) NSMutableArray *titleBtnArr;

/** <#注释#> */
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

/** <#注释#> */
@property (nonatomic, strong) NSString *buttonStr;


/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *mainShowArray;




@end


@implementation CFDropDownMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleBarHeight=frame.size.height;
        self.menuWith=frame.size.width;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleBar];
        
    
        UIView*bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-1, KScreenWidth, 1)];
        bottomView.backgroundColor=DBColor(224,224,224);
        [self addSubview:bottomView];
        
        
    }
    return self;
}



#pragma mark - lazy
/* 分类 classifyView */
- (UIView *)titleBar
{
    if (!_titleBar) {
        _titleBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _titleBar.backgroundColor = [UIColor whiteColor];
    }
    return _titleBar;
}

#pragma mark - setter
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr
{    _dataSourceArr = dataSourceArr;
    for (UIView *sub in self.titleBar.subviews) {
        [sub removeFromSuperview];
    }
    self.saveAllModel=[NSMutableArray array];
    for (NSArray*array in dataSourceArr) {
        NSMutableArray*mtArray=[NSMutableArray array];
        for (NSString*str in array) {
            CFDropDownModel*model=[[CFDropDownModel alloc]init];
            model.title=str;
            model.isSelect=NO;
            [mtArray addObject:model];
        }
        
        [self.saveAllModel addObject:mtArray];
    
    }
    
    if ([self.VCName isEqualToString:@"首页收款"]) {
        for (UIView *subView in self.titleBar.subviews) {
//            if ([subView isKindOfClass:[CFLabelOnLeftButton class]]) {
                [subView removeFromSuperview];
//            }
        }
    }
    if ([self.VCName isEqualToString:@"榜单筛选"]) {
        NSArray *tarr = self.saveAllModel[0];
        for (int i = 0; i < [tarr count]; i++) {
            if (i == 3) {
                
                CFDropDownModel*model = self.saveAllModel[0][i];
                model.isSelect = YES;
            }
        }
    }
    
    if ([self.VCName isEqualToString:@"车源管理"]) {
        NSArray *tarr = self.saveAllModel[2];
        for (int i = 0; i < [tarr count]; i++) {
            if (i == 1) {
                
                CFDropDownModel*model = self.saveAllModel[2][i];
                model.isSelect = YES;
            }
        }
    }
    
    self.titleBtnArr = [[NSMutableArray alloc] init];
    
    CGFloat btnW = _menuWith/dataSourceArr.count;
    CGFloat btnH = _titleBarHeight;
    
    for (NSInteger i=0; i<self.saveAllModel.count; i++) {
        
        CFLabelOnLeftButton *titleBtn = nil;
        
        //CF_Color_TextDarkGrayColor       CFDrowMenuViewSrcName(@"橙箭头.png")?:CFDrowMenuViewFrameworkSrcName(@"橙箭头.png")
        if ([self.typeName isEqualToString:@"noImage"]) {
            titleBtn = [CFLabelOnLeftButton createButtonWithImageName:@"" title:@"" titleColor:[UIColor blackColor] frame:CGRectMake(i*btnW, 0, btnW, btnH) target:self action:@selector(titleBtnClicked:)];
        } else {
            titleBtn = [CFLabelOnLeftButton createButtonWithImageName:@"btn-下拉" title:@"" titleColor:[UIColor blackColor] frame:CGRectMake(i*btnW, 0, btnW, btnH) target:self action:@selector(titleBtnClicked:)];
        }
        
        
        titleBtn.tag = i+kViewTagConstant;  // 所有tag都加上这个, 防止出现为0的tag
        
        //偏移量
        CGFloat offsetValue=15;
//        titleBtn.imageEdgeInsets=UIEdgeInsetsMake(0, offsetValue, 0, -offsetValue);
        //        [titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, offsetValue, 0, -offsetValue)];
        [titleBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 6, 10, 15)];
        
        titleBtn.lineBreakMode=NSLineBreakByTruncatingTail;
        
        [self.titleBar addSubview:titleBtn];
        
        [self.titleBtnArr addObject:titleBtn];  // 分类 按钮数组
        
        [titleBtn setTitleColor:KNormalColor forState:UIControlStateNormal];
        [titleBtn setTitleColor:KSelectedColor forState:UIControlStateSelected];
        
        
        
    }
    
    
    
    // 中间分割竖线
    for (NSInteger i=0; i<dataSourceArr.count-1; i++) {
        UIView *line = [UIView viewWithFrame:CGRectMake(btnW*(i+1), 9, 1, btnH-18) backgroundColor:DBColor(224,224,224)];
        [self.titleBar addSubview:line];
    }
    
}




// 设置文字 默认
- (void)setDefaulTitleArray:(NSArray *)defaulTitleArray
{
    _defaulTitleArray = defaulTitleArray;
    
    for (NSInteger i = 0; i < self.titleBtnArr.count; i++) {
        [self.titleBtnArr[i] setTitle:defaulTitleArray[i] forState:UIControlStateNormal];
        
    }
}

#pragma mark - 按钮点击
- (void)titleBtnClicked:(CFLabelOnLeftButton *)btn
{
    
    if (self.buttonStr.length > 0 &&[self.buttonStr isEqualToString:@"车型"]) {
        if (![self.buttonStr isEqualToString:btn.titleLabel.text]) {
            [self hide];
        }
    }
    self.buttonStr = btn.titleLabel.text;
    if ([self.typeName isEqualToString:@"noImage"]) {
        return;
    }
    if (btn.selected) {
        [self hide];
    }else{
    
    
    
    self.selectedButtonIndex=btn.tag-kViewTagConstant;

    for (CFLabelOnLeftButton*button in self.titleBtnArr) {
        if ([btn isEqual:button]) {
            [self selectedStatus:button];
        }else{
            [self normalStatus:button];
            
        }
        
    }
        
    

    [self show];
    }

}






#pragma mark - lazy
/* 蒙层view */
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.startY, CFScreenWidth, CFScreenHeight)];
        _bgView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _bgView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_bgView addGestureRecognizer:tapGest];
        [self.superview addSubview:_bgView];
    }
    return _bgView;
}

/* 分类内容 */
- (UITableView *)dropDownMenuTableView
{
    if (!_dropDownMenuTableView) {
        _dropDownMenuTableView = [[UITableView alloc] init];
        _dropDownMenuTableView.frame = CGRectMake(0, self.startY, CFScreenWidth, 0);
        _dropDownMenuTableView.backgroundColor = [UIColor whiteColor];
        _dropDownMenuTableView.delegate = self;
        _dropDownMenuTableView.dataSource = self;
        _dropDownMenuTableView.scrollEnabled = YES;
        [self.superview insertSubview:_dropDownMenuTableView aboveSubview:self.bgView];
    }
    return _dropDownMenuTableView;
}

- (UITableView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] init];
        _leftTableView.frame = CGRectMake(0, self.startY, 150, KScreenHeight - 300);
        _leftTableView.backgroundColor = [UIColor whiteColor];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.scrollEnabled = YES;
        [self.superview insertSubview:_leftTableView aboveSubview:self.bgView];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView
{
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] init];
        _rightTableView.frame = CGRectMake(150, self.startY, KScreenWidth - 150, KScreenHeight - 300);
        _rightTableView.backgroundColor = [UIColor whiteColor];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.scrollEnabled = YES;
        [self.superview insertSubview:_rightTableView aboveSubview:self.bgView];
    }
    return _rightTableView;
}

#pragma mark - public


//bar 上面button 的状态     按钮相关
-(void)normalStatus:(CFLabelOnLeftButton*)btn{
    [btn setTitleColor:KNormalColor];
//    btn.enabled=YES;
    btn.selected=NO;
    btn.imageView.transform=CGAffineTransformMakeRotation(0.01);
 
}

-(void)selectedStatus:(CFLabelOnLeftButton*)btn{
    [btn setTitleColor:KSelectedColor];
//    btn.enabled=NO;
    btn.selected=YES;
    btn.imageView.transform=CGAffineTransformMakeRotation(M_PI);
}

//所有按钮都能点
- (void)btnEnable
{
    // 所有 分类按钮  都变为 可点击
    for (NSInteger i=0; i<self.saveAllModel.count; i++) {
        UIButton *btn = self.titleBtnArr[i];
        btn.enabled = YES;
    }
}

- (void)setSetNil:(NSString *)setNil {
    _setNil = setNil;
    _selectedButtonIndex = 0;
    if ([self.VCName isEqualToString:@"榜单筛选"]) {
        [self tableView:self.dropDownMenuTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    } else {
    [self tableView:self.dropDownMenuTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

//跳窗 相关
- (void)show {


      [UIView animateWithDuration:0.25 animations:^{
          if ([self.VCName isEqualToString:@"首页收款"])  {
              self.startY = CGRectGetMaxY(self.frame);
          }
          
              NSArray *tarr = self.saveAllModel[_selectedButtonIndex];
        self.dropDownMenuTableView.frame = CGRectMake(0, self.startY, CFScreenWidth, MIN(440, 44 * [tarr count]));
          self.bgView.hidden=NO;
          if ([self.buttonStr isEqualToString:@"车型"] || [self.buttonStr containsString:@","]) {
              self.buttonStr = @"车型";
              _leftTableView.hidden = _rightTableView.hidden = NO;
             
              [self httpBrandList];
          } else {
              [self.dropDownMenuTableView reloadData];
          }
    } completion:^(BOOL finished) {
		
    }];
}

- (void)httpBrandList {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMD706PPLIST parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [NSMutableArray array];
            NSArray *arr = [MJKChooseNewBrandSubModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            if (arr.count > 0) {
                [weakSelf.dataArray addObjectsFromArray:arr];
            }
            MJKChooseNewBrandSubModel *model = [[MJKChooseNewBrandSubModel alloc]init];
            model.C_NAME = @"不限";
            model.C_ID = @"";
            [weakSelf.dataArray insertObject:model atIndex:0];
            
            for (MJKChooseNewBrandSubModel *bmodel in self.dataArray) {
                bmodel.selected = NO;
            }
            for (MJKChooseNewBrandSubModel *bmodel in self.dataArray) {
                if ([bmodel.C_ID isEqualToString:self.C_TYPE_DD_ID]) {
                    bmodel.selected = YES;
                }
            }
            [self.leftTableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (void)HTTPGetProductList {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_TYPE_DD_ID"] = self.C_TYPE_DD_ID;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMD496PPLIST parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.mainShowArray = [NSMutableArray array];
            NSArray *arr = [MJKProductShowModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            if (arr.count > 0) {
                [weakSelf.mainShowArray addObjectsFromArray:arr];
            }
            MJKChooseNewBrandSubModel *model = [[MJKChooseNewBrandSubModel alloc]init];
            model.C_NAME = @"不限";
            model.C_ID = @"";
            [weakSelf.mainShowArray insertObject:model atIndex:0];
            [weakSelf.rightTableView reloadData];
            
        } else {
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

#pragma mark - private
- (void)hide {
    CFLabelOnLeftButton*btn=self.titleBtnArr[_selectedButtonIndex];
    [self normalStatus:btn];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _dropDownMenuTableView.frame = CGRectMake(0, self.startY, CFScreenWidth, 0);
        _bgView.hidden=YES;
        
        _leftTableView.hidden = _rightTableView.hidden = YES;
		  [self btnEnable];
        
    } completion:^(BOOL finished) {

		
    }];
    
}





#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.buttonStr isEqualToString:@"车型"]) {
        if (tableView == self.leftTableView) {
            return self.dataArray.count;
        } else{
            return self.mainShowArray.count;
        }
        
    } else {
        NSArray *tarr = self.saveAllModel[_selectedButtonIndex];
        return [tarr count];
    }
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.buttonStr isEqualToString:@"车型"]) {
        if (tableView == self.leftTableView) {
            MJKChooseNewBrandSubModel *model = self.dataArray[indexPath.row];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.textLabel.textColor = model.isSelected == YES ? KNaviColor : [UIColor blackColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = model.C_NAME;
            cell.textLabel.font = [UIFont systemFontOfSize:14.f];
            return cell;
        } else {
            MJKProductShowModel *model = self.mainShowArray[indexPath.row];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pcell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pcell"];
            }
            cell.textLabel.textColor = model.isSelected == YES ? KNaviColor : [UIColor blackColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = model.C_NAME;
            cell.textLabel.font = [UIFont systemFontOfSize:14.f];
            return cell;
        }
    } else {
        static NSString *cellID = @"cellID";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.textLabel.font = CF_Font_15;
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        CFDropDownModel*model=self.saveAllModel[_selectedButtonIndex][indexPath.row];
        cell.textLabel.text = model.title;
        
        if (model.isSelect) {
            //选中
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.tintColor=KSelectedColor;
            cell.textLabel.textColor=KSelectedColor;
            
        }else{
            //不选中
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = KNormalColor;
            
            
        }
        
        
        
        
        
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.buttonStr isEqualToString:@"车型"]) {
        if (tableView == self.leftTableView) {
            
            
            MJKChooseNewBrandSubModel *model = self.dataArray[indexPath.row];
            self.C_TYPE_DD_ID = model.C_ID;
            self.C_TYPE_DD_NAME = model.C_NAME;
            for (MJKChooseNewBrandSubModel *bmodel in self.dataArray) {
                bmodel.selected = NO;
            }
            for (MJKChooseNewBrandSubModel *bmodel in self.dataArray) {
                if ([bmodel.C_ID isEqualToString:self.C_TYPE_DD_ID]) {
                    bmodel.selected = YES;
                }
            }
            
            if ([model.C_NAME isEqualToString:@"不限"]) {
                self.mainShowArray = [NSMutableArray array];
                MJKChooseNewBrandSubModel *model = [[MJKChooseNewBrandSubModel alloc]init];
                model.C_NAME = @"不限";
                model.C_ID = @"";
                [self.mainShowArray addObject:model];
                UIButton *button = self.titleBtnArr[self.selectedButtonIndex];
                [button setTitle:self.buttonStr forState:UIControlStateNormal];
                self.C_TYPE_DD_ID = @"";
                self.C_A49600_C_ID = @"";
                [self.rightTableView reloadData];
                if (self.C_TYPE_DD_ID != nil) {
                    if(self.chooseCarTypeBlock) {
                        self.chooseCarTypeBlock([NSString stringWithFormat:@"%@,%@", self.C_TYPE_DD_ID, self.C_A49600_C_ID]);
                    }
                }
                [self hide];
            } else {
                [self HTTPGetProductList];
            }
//            [self.leftTableView reloadData];
        }else {
            MJKProductShowModel *model = self.mainShowArray[indexPath.row];
            
            self.C_A49600_C_ID = model.C_ID;
            
            for (MJKProductShowModel *pmodel in self.mainShowArray) {
                pmodel.selected = NO;
            }
            for (MJKProductShowModel *pmodel in self.mainShowArray) {
                if ([pmodel.C_ID isEqualToString:model.C_ID]) {
                    pmodel.selected = YES;
                }
            }
            UIButton *button = self.titleBtnArr[self.selectedButtonIndex];
            [button setTitle:([NSString stringWithFormat:@"%@,%@", self.C_TYPE_DD_NAME, model.C_NAME]) forState:UIControlStateNormal];
            
            [self.rightTableView reloadData];
                if (self.C_TYPE_DD_ID != nil) {
                    if(self.chooseCarTypeBlock) {
                        self.chooseCarTypeBlock([NSString stringWithFormat:@"%@,%@", self.C_TYPE_DD_ID, self.C_A49600_C_ID]);
                    }
                }
            
            [self hide];
            
        }
    } else {
        
        //      CFDropDownModel*model=self.saveAllModel[_selectedButtonIndex][indexPath.row];
        
        NSArray*array=self.saveAllModel[_selectedButtonIndex];
        CFDropDownModel*CurrentModel=array[indexPath.row];
        //选中过得不能再选
        //    if (CurrentModel.isSelect) {
        //        return;
        //    }else{
        for (CFDropDownModel*model in array) {
            model.isSelect=NO;
        }
        
        
        //    }
        
        CurrentModel.isSelect=YES;
        [self.dropDownMenuTableView reloadData];
        
        
        
        
        CFLabelOnLeftButton*button=self.titleBtnArr[_selectedButtonIndex];
        if (indexPath.row==0&&[CurrentModel.title isEqualToString:@"全部"]) {
            [button setTitleNormal:_defaulTitleArray[_selectedButtonIndex]];
            if ([self.VCName isEqualToString:@"流量仪"]) {
                if (_selectedButtonIndex == 0) {
                    [button setTitle:@"到店时间" forState:UIControlStateNormal];
                } else if (_selectedButtonIndex == 1) {
                    [button setTitle:@"处理状态" forState:UIControlStateNormal];
                }
                
            } else if ([self.VCName isEqualToString:@"榜单筛选"]) {
                if (_selectedButtonIndex == 0) {
                    [button setTitle:@"时间" forState:UIControlStateNormal];
                }
            }
            //        else if ([self.VCName isEqualToString:@"客户管理"]) {
            //            if (_selectedButtonIndex == 2) {
            //                [button setTitle:@"全部" forState:UIControlStateNormal];
            //            } else if (_selectedButtonIndex == 3) {
            //                [button setTitle:@"排序" forState:UIControlStateNormal];
            //            }
            //        }
            else if ([self.VCName isEqualToString:@"订单管理"]) {
                if (_selectedButtonIndex == 1) {
                    [button setTitle:@"全部" forState:UIControlStateNormal];
                }
            } else if ([self.VCName isEqualToString:@"AI外呼"]) {
                if (_selectedButtonIndex == 2) {
                    [button setTitle:@"开始时间" forState:UIControlStateNormal];
                }
                
            }else if ([self.VCName isEqualToString:@"首页收款"]) {
                if (_selectedButtonIndex == 0) {
                    [button setTitle:@"时间" forState:UIControlStateNormal];
                }
            } else if ([self.VCName isEqualToString:@"协助客户"]) {
                if (_selectedButtonIndex == 2) {
                    [button setTitle:@"状态" forState:UIControlStateNormal];
                }
            }  else if ([self.VCName isEqualToString:@"积分明细"]) {
                if (_selectedButtonIndex == 1) {
                    [button setTitle:@"时间" forState:UIControlStateNormal];
                }
            } else if ([self.VCName isEqualToString:@"客户管理"]) {
                if (_selectedButtonIndex == 3) {
                    [button setTitle:@"全部" forState:UIControlStateNormal];
                }
            } else if ([self.VCName isEqualToString:@"工作日历"]) {
                if (_selectedButtonIndex == 2) {
                    [button setTitle:@"全部" forState:UIControlStateNormal];
                }
            } else if ([self.VCName isEqualToString:@"车源管理"]) {
                if (_selectedButtonIndex == 2) {
                    [button setTitle:@"全部" forState:UIControlStateNormal];
                }
            }
            
            
            
        }else{
            [button setTitleNormal:CurrentModel.title];
        }
        
        
        
        
        /**
         *  筛选条件后的回调方式 代理/block 二选一
         */
        // 调用代理 传参数(当前选中的分类) --- 走接口 请求数据
        if (self.delegate && [self.delegate respondsToSelector:@selector(dropDownMenuView:clickOnCurrentButtonWithTitle:andCurrentTitleArray:)]) {
            [self.delegate dropDownMenuView:self clickOnCurrentButtonWithTitle:CurrentModel.title andCurrentTitleArray:array];
        }
        
        // 走block  3目运算,有block则执行;否则不执行
        //    !self.chooseConditionBlock?:self.chooseConditionBlock(self.dataSource[indexPath.row],currentTitleArr);
        
        if (self.chooseConditionBlock) {
            NSString*number=[NSString stringWithFormat:@"%lu",_selectedButtonIndex];
            NSString*rowNumber=[NSString stringWithFormat:@"%lu",indexPath.row];
            self.chooseConditionBlock(number, rowNumber, CurrentModel.title);
        }
        
        
        
        [self hide];
        
    }
    
    
}


- (void)tableReload{

    [self.dropDownMenuTableView reloadData];
}

- (void)dealloc
{
    [self hide];
}


@end








@implementation CFRightButton

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-1)];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        //竖线
        UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(5, 9, 1, frame.size.height-18)];
//        CF_Color_SepertLineColor
        lineView.backgroundColor=DBColor(224,224,224);
        [self addSubview:lineView];
        
        
        
        
//        self.backgroundColor=[UIColor blueColor];
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
        [button setImage:[UIImage imageNamed:@"漏斗"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickFunnel:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        
        
        
       
        
        
        
        
    }
    return self;
}


-(void)clickFunnel:(UIButton*)sender{
  
    
    if (self.clickFunnelBlock) {
        sender.selected=!sender.selected;
   //都需要隐藏 另外四个的方法
        self.clickFunnelBlock(sender.selected);
    }
    
    
}

@end
