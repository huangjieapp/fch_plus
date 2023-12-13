//
//  AddCustomerProductTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "AddCustomerProductTableViewCell.h"

#import "MJKProductShowDetailTableViewCell.h"

#import "MJKProductShowModel.h"

#import "AddOrEditlCustomerViewController.h"


#import "MJKClueAddViewController.h"
#import "MJKClueDetailViewController.h"

@interface AddCustomerProductTableViewCell()<UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *TopTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineBGView;
@property (weak, nonatomic) IBOutlet UITableView *productTableView;



@end

@implementation AddCustomerProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lineBGView.backgroundColor=[UIColor whiteColor];
    _lineBGView.layer.cornerRadius=5;
    _lineBGView.layer.borderWidth=0.5;
    _lineBGView.layer.borderColor=[UIColor blackColor].CGColor;
    
    
    self.textView.delegate=self;
    
    self.productTableView.dataSource = self;
    self.productTableView.delegate = self;
    
}


#pragma mark  --delegate
-(void)textViewDidChange:(UITextView *)textView{
    if (self.textViewChangeBlock) {
        self.textViewChangeBlock(textView.text);
    }
    
}



#pragma mark  --click
- (IBAction)clickScanfButton:(id)sender {
    if (self.clickSanfBlock) {
        self.clickSanfBlock();
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

#pragma mark  --set
-(void)setTextViewStr:(NSString *)textViewStr{
    _textViewStr=textViewStr;
    self.textView.text=textViewStr;
    
    if (self.textViewChangeBlock) {
        self.textViewChangeBlock(self.textView.text);
    }
    
}

- (void)setProductArray:(NSArray *)productArray {
    _productArray = productArray;
    if (productArray.count > 0) {
        self.textView.hidden = YES;
        self.productTableView.hidden = NO;
    } else {
        self.textView.hidden = NO;
        self.productTableView.hidden = YES;
    }
    [self.productTableView reloadData];
}

//MARK:-productTableview
#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKProductShowModel *model = self.productArray[indexPath.row];
    MJKProductShowDetailTableViewCell *cell = [MJKProductShowDetailTableViewCell cellWithTableView:tableView];
    cell.rootVC = self.rootVC;
    cell.isNoPrice = self.isNoPrice;
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
   
    return .1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth - 56, 30)];
    bgView.backgroundColor = [UIColor whiteColor];
    //    UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, 1)];
    //    sepView.backgroundColor = kBackgroundColor;
    //    [bgView addSubview:sepView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(bgView.frame.size.width - 100, 0, 100, 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor blackColor];
    NSInteger money = 0;
    for (MJKProductShowModel *model in self.productArray) {
        money += model.B_HDJ.integerValue * model.number;
    }
    label.text = [NSString stringWithFormat:@"总计 %ld",(long)money];
    [bgView addSubview:label];
    
   
    return nil;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"AddCustomerProductTableViewCell";
    AddCustomerProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    return cell;
    
}
@end
