//
//  CFDropDownMenuView.m
//  CFDropDownMenuView
//
//  Created by Peak on 16/5/28.
//  Copyright © 2016年 陈峰. All rights reserved.
//

#import "CFDropDownMenuViewNew.h"
#import "CFMacro.h"
#import "UIView+CFFrame.h"

#import "MJKChooseNewBrandSubModel.h"
#import "MJKProductShowModel.h"

#define kTitleBarHeight 40
#define kViewTagConstant 1  // 所有tag都加上这个 防止出现为0的tag

@interface CFDropDownMenuViewNew ()

/* 分类 classifyView */
@property (nonatomic, strong) UIView *titleBar;

/* 整个屏幕的 背景 半透明View */
@property (nonatomic, strong) UIView *bgView;

/**
 *  cell为筛选的条件
 */
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) UITableView *dropDownMenuTableView;


@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;
@property (nonatomic, strong) NSString *C_A49600_C_ID;
/**
 *  数据源--一维数组 (每一列的条件标题)
 */
@property (nonatomic, strong) NSArray *dataSource;

/* 最后点击的按钮 */
@property (nonatomic, strong) UIButton *lastClickedBtn;
/** <#注释#> */
@property (nonatomic, assign) NSInteger titleButtonTag;


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *mainShowArray;

@end


@implementation CFDropDownMenuViewNew

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.funnelW = 0;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleBar];
    }
    return self;
}



#pragma mark - lazy
/* 分类 classifyView */
- (UIView *)titleBar
{
    if (!_titleBar) {
        _titleBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CFScreenWidth, kTitleBarHeight)];
        _titleBar.backgroundColor = [UIColor whiteColor];
    }
    return _titleBar;
}

#pragma mark - setter
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr
{
    _dataSourceArr = dataSourceArr;
    
    self.titleBtnArr = [[NSMutableArray alloc] init];
    CGFloat btnW = (CFScreenWidth - self.funnelW)/dataSourceArr.count;
    CGFloat btnH = kTitleBarHeight;
    
    for (NSInteger i=0; i<dataSourceArr.count; i++) {
        
        CFLabelOnLeftButton *titleBtn = nil;
        
        titleBtn = [CFLabelOnLeftButton createButtonWithImageName:CFDrowMenuViewSrcName(@"灰箭头.png")?:CFDrowMenuViewFrameworkSrcName(@"灰箭头.png") title:@"" titleColor:CF_Color_TextDarkGrayColor frame:CGRectMake(i*btnW, 0, btnW, btnH) target:self action:@selector(titleBtnClicked:)];
        
        titleBtn.tag = i+kViewTagConstant;  // 所有tag都加上这个, 防止出现为0的tag
        
        [self.titleBar addSubview:titleBtn];
        
        [self.titleBtnArr addObject:titleBtn];  // 分类 按钮数组
    }
    
    // 中间分割竖线
    for (NSInteger i=0; i<dataSourceArr.count-1; i++) {
        UIView *line = [UIView viewWithFrame:CGRectMake(btnW*(i+1), 9, 1, btnH-18) backgroundColor:CF_Color_SepertLineColor];
        [self.titleBar addSubview:line];
    }
}


// 设置文字 默认
- (void)setDefaulTitleArray:(NSArray *)defaulTitleArray
{
    _defaulTitleArray = defaulTitleArray;
    for (NSInteger i = 0; i < self.titleBtnArr.count; i++) {
        UIButton *button = self.titleBtnArr[i];
        [button setTitle:defaulTitleArray[i] forState:UIControlStateNormal];
    }
}

#pragma mark - 按钮点击
- (void)titleBtnClicked:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqualToString:@"车型"]) {
        [self httpBrandList];
    }
    if ([_lastClickedBtn.titleLabel.text isEqualToString:@"车型"] || [_lastClickedBtn.titleLabel.text containsString:@","]) {
        self.leftTableView.frame = CGRectMake(0, self.startY, 150, 0);
        self.rightTableView.frame = CGRectMake(150, self.startY, CFScreenWidth - 150, 0);
    } else {
        self.dropDownMenuTableView.frame = CGRectMake(0, self.startY, CFScreenWidth, 0);
    }
    _lastClickedBtn = btn;
    
    [self removeSubviews];
    self.dataSource = self.dataSourceArr[btn.tag-kViewTagConstant];
    self.titleButtonTag = btn.tag-kViewTagConstant;
    // 加上 选择内容
    [self show];
    // 按钮动画
    [self animationWhenClickTitleBtn:btn];
}


#pragma mark - public
// 点击按钮动画
- (void)animationWhenClickTitleBtn:(UIButton *)btn
{
    /**
     *  0.0.2版本 bug  当没有把当前分类的菜单退出时 就点其他分类  会导致 箭头方向错了
     */
//    [UIView animateWithDuration:0.25 animations:^{
//        btn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
//        btn.enabled = NO;
//    }];
    
    _lastClickedBtn = btn;
    
    /**
     *  0.0.3  箭头方向错了bug解决
     */
    for (UIButton *subBtn in self.titleBtnArr) {
        if (subBtn==btn) {
            [UIView animateWithDuration:0.25 animations:^{
                subBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
                subBtn.enabled = NO;
            }];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                subBtn.imageView.transform = CGAffineTransformMakeRotation(0);
                subBtn.enabled = YES;
            }];
        }
    }
}

#pragma mark - lazy
/* 蒙层view */
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.startY, CFScreenWidth, CFScreenHeight)];
        _bgView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_bgView addGestureRecognizer:tapGest];
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
    }
    return _dropDownMenuTableView;
}

- (UITableView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] init];
        _leftTableView.frame = CGRectMake(0, self.startY, 150, 0);
        _leftTableView.backgroundColor = [UIColor whiteColor];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.scrollEnabled = YES;
    }
    return _leftTableView;
}

- (UITableView *)rightTableView
{
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] init];
        _rightTableView.frame = CGRectMake(150, self.startY, KScreenWidth - 150, 0);
        _rightTableView.backgroundColor = [UIColor whiteColor];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.scrollEnabled = YES;
    }
    return _rightTableView;
}

#pragma mark - public
- (void)show {
    
    [self.superview addSubview:self.bgView];
    if ([_lastClickedBtn.titleLabel.text isEqualToString:@"车型"] || [_lastClickedBtn.titleLabel.text containsString:@","]) {
        [self.superview addSubview:self.leftTableView];
        [self.superview addSubview:self.rightTableView];
    } else {
        [self.superview addSubview:self.dropDownMenuTableView];
    }
    [UIView animateWithDuration:0.25 animations:^{
        if ([_lastClickedBtn.titleLabel.text isEqualToString:@"车型"] || [_lastClickedBtn.titleLabel.text containsString:@","]) {
            self.leftTableView.frame = CGRectMake(0, self.startY, 150, 300);
            self.rightTableView.frame = CGRectMake(150, self.startY, CFScreenWidth - 150, 300);
        } else {
            self.dropDownMenuTableView.frame = CGRectMake(0, self.startY, CFScreenWidth, MIN(44 * 8, 44 * self.dataSource.count));
        }
        
    } completion:^(BOOL finished) {
        if ([_lastClickedBtn.titleLabel.text isEqualToString:@"车型"]  || [_lastClickedBtn.titleLabel.text containsString:@","]) {
            [self.leftTableView reloadData];
            [self.rightTableView reloadData];
        } else {
            [self.dropDownMenuTableView reloadData];
        }
    }];
}

#pragma mark - private
- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        if ([_lastClickedBtn.titleLabel.text isEqualToString:@"车型"] || [_lastClickedBtn.titleLabel.text containsString:@","]) {
            self.leftTableView.frame = CGRectMake(0, self.startY, 150, 0);
            self.rightTableView.frame = CGRectMake(150, self.startY, CFScreenWidth - 150, 0);
        } else {
            self.dropDownMenuTableView.frame = CGRectMake(0, self.startY, CFScreenWidth, 0);
        }
        _lastClickedBtn.imageView.transform = CGAffineTransformMakeRotation(0.01);
    } completion:^(BOOL finished) {
        [self removeSubviews];
        [self btnEnable];
    }];
    
}

- (void)removeSubviews
{
    [UIView animateWithDuration:0.25 animations:^{
        _lastClickedBtn.imageView.transform = CGAffineTransformMakeRotation(0.01);
    }];
    // 此处 千万不能写作 !self.bgView?:[self.bgView removeFromSuperview];  会崩
    !_bgView?:[_bgView removeFromSuperview];
    _bgView=nil;
    
    !_dropDownMenuTableView?:[_dropDownMenuTableView removeFromSuperview];
    _dropDownMenuTableView=nil;
    
    self.dataSource = nil;
    
    [self btnEnable];
}



- (void)btnEnable
{
    // 所有 分类按钮  都变为 可点击
    for (NSInteger i=0; i<self.dataSourceArr.count; i++) {
        UIButton *btn = self.titleBtnArr[i];
        btn.enabled = YES;
    }
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_lastClickedBtn.titleLabel.text isEqualToString:@"车型"] || [_lastClickedBtn.titleLabel.text containsString:@","]) {
        if (tableView == self.leftTableView) {
            return self.dataArray.count;
        } else{
            return self.mainShowArray.count;
        }
        
    } else {
        return self.dataSource.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_lastClickedBtn.titleLabel.text isEqualToString:@"车型"] || [_lastClickedBtn.titleLabel.text containsString:@","]) {
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
            cell.textLabel.font = KSmallFont;
        }
        
        
        cell.textLabel.text = self.dataSource[indexPath.row];
        
        // KVC
        NSArray *textArr = [self.titleBtnArr valueForKeyPath:@"titleLabel.text"];
        
        if (self.stateConfigDict[@"selected"]) {
            if ([textArr containsObject:cell.textLabel.text]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                cell.tintColor = self.stateConfigDict[@"selected"][0];
                cell.textLabel.textColor = self.stateConfigDict[@"selected"][0];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.textColor = CF_Color_TextDarkGrayColor;
            }
        }else {
            if ([textArr containsObject:cell.textLabel.text]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                cell.textLabel.textColor = KNaviColor;
                cell.tintColor = KNaviColor;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.textColor = CF_Color_TextDarkGrayColor;
            }
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_lastClickedBtn.titleLabel.text isEqualToString:@"车型"] || [_lastClickedBtn.titleLabel.text containsString:@","]) {
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
                UIButton *button = self.titleBtnArr[self.titleButtonTag];
                [button setTitle:@"车型" forState:UIControlStateNormal];
                self.C_TYPE_DD_ID = @"";
                self.C_A49600_C_ID = @"";
                [self.rightTableView reloadData];
                [self hide];
                !self.chooseProductConditionBlock?:self.chooseProductConditionBlock(@",");
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
            UIButton *button = self.titleBtnArr[self.titleButtonTag];
            [button setTitle:([NSString stringWithFormat:@"%@,%@", self.C_TYPE_DD_NAME, model.C_NAME]) forState:UIControlStateNormal];
            
            [self.rightTableView reloadData];
            [self hide];
            !self.chooseProductConditionBlock?:self.chooseProductConditionBlock([NSString stringWithFormat:@"%@,%@", self.C_TYPE_DD_ID, model.C_ID]);
            
        }
    } else   {
        // 改变标题展示 及 颜色
        NSMutableArray *currentTitleArr = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.dataSourceArr.count; i++) {
            UIButton *btn = self.titleBtnArr[i];
            if (!btn.enabled) {
                if ([self.dataSource[indexPath.row] isEqualToString:@"全部"]) {
                    [btn setTitle:self.defaulTitleArray[self.titleButtonTag] forState:UIControlStateNormal];
                    if ([self.VCName isEqualToString:@"客户"]) {
                        if (self.titleButtonTag == 3) {
                            [btn setTitle:@"状态" forState:UIControlStateNormal];
                        }
                    }
                } else {
                    [btn setTitle:self.dataSource[indexPath.row] forState:UIControlStateNormal];
                }
                // 改变颜色
                if (self.stateConfigDict[@"selected"]) {
                    UIImage *image = [UIImage imageNamed:self.stateConfigDict[@"selected"][1]];
                    if (image) {  // 使用自己app中的图片
                        [self changTintColorWithTintColor:self.stateConfigDict[@"selected"][0] tintColorImgName:self.stateConfigDict[@"selected"][1] ForButton:self.titleBtnArr[i]];
                    } else {  // 使用CFDropDownMenuView.bundle自带的
                        NSString *str = [NSString stringWithFormat:@"%@.png", self.stateConfigDict[@"selected"][1]];
                        NSString *imgName = CFDrowMenuViewSrcName(str)?:CFDrowMenuViewFrameworkSrcName(str);
                        [self changTintColorWithTintColor:self.stateConfigDict[@"selected"][0] tintColorImgName:imgName ForButton:self.titleBtnArr[i]];
                    }
                } else {  // 未设置样式---选中的时候默认 使用CFDropDownMenuView.bundle自带的
                    [self changTintColorWithTintColor:CF_Color_TextDarkGrayColor tintColorImgName:CFDrowMenuViewSrcName(@"灰箭头.png")?:CFDrowMenuViewFrameworkSrcName(@"灰箭头.png") ForButton:btn];
                }
            }
            [currentTitleArr addObject:btn.titleLabel.text];
        }
        
        
        /**
         *  筛选条件后的回调方式 代理/block 二选一
         */
        // 调用代理 传参数(当前选中的分类) --- 走接口 请求数据
        if (self.delegate && [self.delegate respondsToSelector:@selector(dropDownMenuView:clickOnCurrentButtonWithTitle:andCurrentTitleArray:)]) {
            [self.delegate dropDownMenuView:self clickOnCurrentButtonWithTitle:self.dataSource[indexPath.row] andCurrentTitleArray:currentTitleArr];
        }
        
        // 走block  3目运算,有block则执行;否则不执行
        !self.chooseConditionNewBlock?:self.chooseConditionNewBlock(self.titleButtonTag,indexPath.row,self.dataSource[indexPath.row],currentTitleArr);
        
        // 移除
        [self removeSubviews];
    }
    
}

#pragma mark - 改变(展示颜色)文字颜色及箭头颜色
- (void)changTintColorWithTintColor:(UIColor *)tintColor tintColorImgName:(NSString *)tintColorArrowImgName ForButton:(UIButton *)btn
{
    [btn setTitleColor:tintColor forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:tintColorArrowImgName] forState:UIControlStateNormal];
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


- (void)dealloc
{
    [self removeSubviews];
}


@end
