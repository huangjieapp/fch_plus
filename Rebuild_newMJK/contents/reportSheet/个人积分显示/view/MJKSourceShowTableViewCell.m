//
//  MJKSourceShowTableViewCell.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/17.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKSourceShowTableViewCell.h"
#import "ExcelView.h"
#import "MJKSourceShowModel.h"

@interface MJKSourceShowTableViewCell ()
@property (nonatomic, strong) ExcelView *excelView;
@end

@implementation MJKSourceShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
}

- (void)initUI {
    self.excelView = [[ExcelView alloc]init];
    self.excelView.mTableView.scrollEnabled = NO;
    [self.contentView addSubview:self.excelView];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    NSMutableArray *nameArr = [NSMutableArray array];
    NSMutableArray *dayArr = [NSMutableArray array];
    NSMutableArray *monthArr = [NSMutableArray array];
    for (MJKSourceShowModel *model in dataArray) {
        [nameArr addObject:model.C_NAME];
        [dayArr addObject:@[model.I_INTERGRAL_MONTH, model.I_INTERGRAL_DAY]];
//        [monthArr addObject:@[model.I_INTERGRAL_MONTH]];
    }
    self.excelView.frame = CGRectMake(0, 10, KScreenWidth, (nameArr.count + 1) * 46);
//    self.excelView.mColumeMaxWidths = @[@(KScreenWidth - 10) / 3), @(KScreenWidth - 10) / 3)];
//    self.excelView.columnMaxWidth = (KScreenWidth - 10) / 3;
    self.excelView.columnMinWidth = (KScreenWidth - 25) / 3;
    self.excelView.textFont = [UIFont systemFontOfSize:14.f];
    self.excelView.topTableHeadDatas=(NSMutableArray *)@[@"本月积分", @"今日积分"];
//    self.excelView.
    self.excelView.leftTabHeadDatas=nameArr;
    self.excelView.tableDatas=dayArr;
    self.excelView.isLockFristColumn=NO;
    self.excelView.isLockFristRow=YES;
    self.excelView.isColumnTitlte=YES;
    self.excelView.columnTitlte=@"组员";
    self.excelView.mTableView.scrollEnabled = NO;
    [self.excelView show];
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKSourceShowTableViewCell";
    MJKSourceShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
