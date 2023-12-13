//
//  MJKPKShowView.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/16.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKPKShowView.h"
#import "MJKSetLabel.h"
#import "MJKImageView.h"

#import "MJKPKSheetModel.h"
#import "MJKPKSheetSubModel.h"

#import "ExcelView.h"

@interface MJKPKShowView ()<UIScrollViewDelegate>
@property (nonatomic, strong) MJKSetLabel *leftGroupLabel;
@property (nonatomic, strong) MJKSetLabel *rightGroupLabel;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *PKView;
@property (nonatomic, strong) NSMutableArray *PKLabelArray;
@property (nonatomic, strong) UIView *leftfrom;
@property (nonatomic, strong) UIView *rightfrom;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) MJKSetLabel *leftSourceLabel;
@property (nonatomic, strong) MJKSetLabel *rightSourceLabel;
@property (nonatomic, strong) ExcelView *excelView;
@property (nonatomic, strong) ExcelView *rightExcelView;
@property (nonatomic, strong) UIView *sepView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *allArray;
/** <#注释#>*/
@property (nonatomic, strong) NSString *dataType;
/** 第几组*/
@property (nonatomic, assign) NSInteger index;
/** <#注释#>*/
@property (nonatomic, strong) UIButton *timeButton;
@end


@implementation MJKPKShowView
- (instancetype)initWithFrame:(CGRect)frame andDateType:(NSString *)dateType {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initUIWithDateType:dateType];
    }
    return self;
}

#define labelHeight 40.f

- (void)initUIWithDateType:(NSString *)dateType {
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
	titleView.backgroundColor = kBackgroundColor;
    [self addSubview:titleView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
    label.text = @"绩效PK榜";
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor blackColor];
    [titleView addSubview:label];
    
//    for (int i = 0; i < 2; i++) {
//        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - (50 * (i + 1)), 0, 40, 20)];
//        [button setTitleNormal:@[@"今日",@"本月"][i] forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:12.f];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
//        int j = 1;
//        if ([dateType isEqualToString:@"3"]) {
//            j = 1;
//        } else {
//            j = 0;
//        }
//        if (i == j) {
//            self.sepView = [[UIView alloc]initWithFrame:CGRectMake(button.frame.origin.x, button.frame.size.height, button.frame.size.width, 1)];
//            self.sepView.backgroundColor = KNaviColor;
//            [titleView addSubview:self.sepView];
//        }
//        [titleView addSubview:button];
//    }
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 50 , 0, 40, 20)];
    [button setTitle:@"本月>" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
    self.timeButton = button;
    [titleView addSubview:button];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), KScreenWidth, self.frame.size.height - 30)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    
    
    
    self.titleView = titleView;
    
}

- (void)setJxChooseType:(NSString *)jxChooseType {
    _jxChooseType = jxChooseType;
    [self.timeButton setTitleNormal:[NSString stringWithFormat:@"%@>",jxChooseType]];
}

- (void)createViewWithDataArray:(NSMutableArray *)dataArray {
    NSMutableArray *viewArray = [NSMutableArray array];
    CGFloat width = KScreenWidth / 2;
    for (int i = 0; i<dataArray.count; i++) {
        MJKPKSheetModel *model = dataArray[i];
        NSArray *subArray = model.MEMBER;
        NSMutableArray *titleArray = [NSMutableArray array];
        NSMutableArray *sourceArray = [NSMutableArray array];
        for (MJKPKSheetSubModel *subModel in subArray) {
            [titleArray addObject:subModel.C_NAME];
            [self.allArray addObject:titleArray];
            [sourceArray addObject:@[subModel.I_INTERGRAL]];
        }
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i * width, 0, width,   (titleArray.count + 1) * 46 + 100)];
//        view.backgroundColor = [UIColor redColor];
        [self.scrollView addSubview:view];
        [viewArray addObject:view];
        
        //图片
        MJKImageView *leftImageView = [MJKImageView loadImageViewWithFrame:CGRectMake((view.frame.size.width - 50) / 2,5, 50, 50) andcornerRadius:25.f andImage:@"icon_add"];
		leftImageView.tag = i + 100;
//        self.leftImageView = leftImageView;
        [leftImageView sd_setImageWithURL:[NSURL URLWithString:model.C_HEADIMGURL] placeholderImage:[UIImage imageNamed:@"icon_add"]];
		UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeadImage:)];
		[leftImageView addGestureRecognizer:tapGR];
		leftImageView.userInteractionEnabled = YES;
        [view addSubview:leftImageView];
        UIFont *font = [UIFont systemFontOfSize:16.f];
        //左右vs 和得分
        if (i == 0) {
            MJKSetLabel *label = [MJKSetLabel setLabelWithFrame:CGRectMake(view.frame.size.width - 10, CGRectGetMidY(leftImageView.frame) - 10, 10, 20) andColor:[UIColor blackColor] andFont:[UIFont systemFontOfSize:12.f] andText:@"V"];
            label.textAlignment = NSTextAlignmentRight;
            [view addSubview:label];
            
            MJKSetLabel *sourceLabel = [MJKSetLabel setLabelWithFrame:CGRectMake(CGRectGetMinX(label.frame)-60, CGRectGetMidY(leftImageView.frame) - 20, 60, 40) andColor:KNaviColor andFont:font andText:model.I_INTERGRAL];
            [view addSubview:sourceLabel];
            
        } else if (i == dataArray.count - 1) {
            MJKSetLabel *label = [MJKSetLabel setLabelWithFrame:CGRectMake(0, CGRectGetMidY(leftImageView.frame) - 10, 10, 20) andColor:[UIColor blackColor] andFont:[UIFont systemFontOfSize:12.f] andText:@"S"];
            label.textAlignment = NSTextAlignmentLeft;
            [view addSubview:label];
            
            MJKSetLabel *sourceLabel = [MJKSetLabel setLabelWithFrame:CGRectMake(CGRectGetMaxX(label.frame), CGRectGetMidY(leftImageView.frame) - 20, 60, 40) andColor:[UIColor colorWithHexString:@"#16F4C3"] andFont:font andText:model.I_INTERGRAL];
            [view addSubview:sourceLabel];
        } else {
            MJKSetLabel *lLabel = [MJKSetLabel setLabelWithFrame:CGRectMake(0, CGRectGetMidY(leftImageView.frame) - 10, 10, 20) andColor:[UIColor blackColor] andFont:[UIFont systemFontOfSize:12.f] andText:@"S"];
            lLabel.textAlignment = NSTextAlignmentLeft;
            [view addSubview:lLabel];
            
            
            
            MJKSetLabel *lSourceLabel = [MJKSetLabel setLabelWithFrame:CGRectMake(CGRectGetMaxX(lLabel.frame), CGRectGetMidY(leftImageView.frame) - 20, 60, 40) andColor:[UIColor colorWithHexString:@"#16F4C3"] andFont:font andText:model.I_INTERGRAL];
            [view addSubview:lSourceLabel];
        
            MJKSetLabel *rlabel = [MJKSetLabel setLabelWithFrame:CGRectMake(view.frame.size.width - 10, CGRectGetMidY(leftImageView.frame) - 10, 10, 20) andColor:[UIColor blackColor] andFont:[UIFont systemFontOfSize:12.f] andText:@"V"];
            rlabel.textAlignment = NSTextAlignmentRight;
            [view addSubview:rlabel];
            
            MJKSetLabel *rSourceLabel = [MJKSetLabel setLabelWithFrame:CGRectMake(CGRectGetMinX(rlabel.frame)-60, CGRectGetMidY(leftImageView.frame) - 20, 60, 40) andColor:KNaviColor andFont:font andText:model.I_INTERGRAL];
            [view addSubview:rSourceLabel];
        }
        
        MJKSetLabel *teamLabel = [MJKSetLabel setLabelWithFrame:CGRectMake(0, CGRectGetMaxY(leftImageView.frame) + 5, width, 30) andColor:[UIColor blackColor] andFont:[UIFont systemFontOfSize:12.f] andText:model.C_NAME];
        [view addSubview:teamLabel];
        DBSelf(weakSelf);
        self.excelView = [[ExcelView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(teamLabel.frame) + 5, width, (titleArray.count + 1) * 45)];
		self.excelView.selectRowBlock = ^(NSString *name) {
			for (MJKPKSheetSubModel *subModel in subArray) {
				if ([subModel.C_NAME isEqualToString:name]) {
					if (weakSelf.selectSaleBlock) {
						weakSelf.selectSaleBlock(subModel.USER_ID);
					}
				}
			}
			
		};
        self.excelView.topTableHeadDatas=(NSMutableArray *)@[@"得分"];
        self.excelView.leftTabHeadDatas=titleArray;
        self.excelView.tableDatas=sourceArray;
        self.excelView.isLockFristColumn=NO;
        self.excelView.columnMinWidth = (width - 20) / 2;
        self.excelView.textFont = [UIFont systemFontOfSize:12.f];
        self.excelView.isLockFristRow=YES;
        self.excelView.isColumnTitlte=YES;
        self.excelView.columnTitlte=@"组员";
//        self.excelView.mTableView.scrollEnabled = NO;
//        self.excelView.userInteractionEnabled = NO;
        [self.excelView show];
        [view addSubview:self.excelView];
        
    }
    NSArray *moreArray = [NSArray array];
    if (self.allArray.count > 0) {
        NSArray *tarr = self.allArray[0];
        NSInteger count = [tarr count];
        for (int i = 1; i<self.allArray.count; i++) {
            NSArray *arr1 = self.allArray[i];
            if (count <= arr1.count) {
                count = arr1.count;
                moreArray = arr1;
            }
        }
    }
    
    
//    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.titleView.frame), KScreenWidth, (moreArray.count + 1) * 48 + 120);
    self.scrollView.contentSize = CGSizeMake(width * viewArray.count, (moreArray.count + 1) * 50);
}

- (void)clickHeadImage:(UITapGestureRecognizer *)tapGR {
	UIImageView *imageView = (UIImageView *)tapGR.view;
	
	if (self.clickHeadImageBlock) {
		self.clickHeadImageBlock(imageView.tag - 100);
	}
}

- (void)selectDate:(UIButton *)sender {
//    CGRect frame = self.sepView.frame;
//    frame.origin.x = sender.frame.origin.x;
//    self.sepView.frame = frame;
//    if ([sender.titleLabel.text isEqualToString:@"本月"]) {
        if (self.backDateBlock) {
            self.backDateBlock(@"");
        }
//    } else {
//        if (self.backDateBlock) {
//            self.backDateBlock(@"1");
//        }
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    }
}


- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    MJKPKSheetModel *model = dataArray[0];
    NSArray *leftArray = model.MEMBER;
    NSMutableArray *leftTitleArray = [NSMutableArray array];
    NSMutableArray *leftSourceArray = [NSMutableArray array];
    for (MJKPKSheetSubModel *leftSubModel in leftArray) {
        [leftTitleArray addObject:leftSubModel.C_NAME];
        
        [leftSourceArray addObject:@[leftSubModel.I_INTERGRAL]];
    }
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:model.C_HEADIMGURL] placeholderImage:[UIImage imageNamed:@""]];
    self.leftGroupLabel.text = model.C_NAME;
    self.leftSourceLabel.text = model.I_INTERGRAL;
    
    MJKPKSheetModel *rightModel = dataArray[1];
    NSArray *rightArray = rightModel.MEMBER;
    NSMutableArray *rightTitleArray = [NSMutableArray array];
    NSMutableArray *rightSourceArray = [NSMutableArray array];
    for (MJKPKSheetSubModel *rightSubModel in rightArray) {
        [rightTitleArray addObject:rightSubModel.C_NAME];
        [rightSourceArray addObject:@[rightSubModel.I_INTERGRAL]];
    }
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:rightModel.C_HEADIMGURL] placeholderImage:[UIImage imageNamed:@""]];
    self.rightSourceLabel.text = rightModel.I_INTERGRAL;
    self.rightGroupLabel.text = rightModel.C_NAME;
    
    CGFloat height = leftTitleArray.count > rightTitleArray.count ? (leftTitleArray.count + 1) * 45 : (rightTitleArray.count + 1) * 45;
    
    self.excelView.frame = CGRectMake(20, CGRectGetMaxY(self.leftGroupLabel.frame) + 30, KScreenWidth / 2 - 40, height);
    
    self.rightExcelView.frame = CGRectMake(KScreenWidth / 2 + 20, CGRectGetMaxY(self.rightGroupLabel.frame) + 30, KScreenWidth / 2 - 40, height);
    
    self.PKView.frame = CGRectMake(0, CGRectGetMaxY(self.titleView.frame), KScreenHeight, height + 20);
    
    self.excelView.topTableHeadDatas=(NSMutableArray *)@[@"得分"];
    self.excelView.leftTabHeadDatas=leftTitleArray;
    self.excelView.tableDatas=leftSourceArray;
    self.excelView.isLockFristColumn=NO;
    self.excelView.isLockFristRow=YES;
    self.excelView.isColumnTitlte=YES;
    self.excelView.columnTitlte=@"组员";
    [self.excelView show];
    
    self.rightExcelView.topTableHeadDatas=(NSMutableArray *)@[@"得分"];
    self.rightExcelView.leftTabHeadDatas=rightTitleArray;
    self.rightExcelView.tableDatas=rightSourceArray;
    self.rightExcelView.isLockFristColumn=NO;
    self.rightExcelView.isLockFristRow=YES;
    self.rightExcelView.isColumnTitlte=YES;
    self.rightExcelView.columnTitlte=@"组员";
    [self.rightExcelView show];
}

- (NSMutableArray *)allArray {
    if (!_allArray) {
        _allArray = [NSMutableArray array];
    }
    return _allArray;
}

@end
