//
//  MJKWorkWorldSignViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/26.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKExpandAddViewController.h"

#import "MJKMaterialPhotoView.h"
#import "MJKShootView.h"

#import "MJKWorkWorldSignCell.h"

#import "CGCAddExpandModel.h"

#import "MJKCommunityScreenViewController.h"
#import "MJKSelectSaleViewController.h"

#import "POPRequestManger.h"

#import "MJKExpandLabelViewController.h"

#import "MJKExpandNewAddTableViewCell.h"


@interface MJKExpandAddViewController ()<UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>
/** textView*/
@property (nonatomic, strong) UITextView *textView;
/** url textView*/
@property (nonatomic, strong) UITextView *urlTextView;
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** MJKScratchableLatexPhotoView *photoView*/
@property (nonatomic, strong) MJKMaterialPhotoView *photoView;
@property (nonatomic, strong) MJKShootView *shootView;
/** address*/
@property (nonatomic, strong) NSString *addressStr;
/** customer name*/
@property (nonatomic, strong) NSString *customerName;
/** sale name*/
@property (nonatomic, strong) NSString *saleName;
/** MJKSingleModel*/
@property (nonatomic, strong) CGCAddExpandModel *addModel;
/** <#注释#>*/
@property (nonatomic, strong) NSString *A47800_C_ID;

/** <#注释#>*/
@property (nonatomic, strong) NSData *videoData;

/** header height*/
@property (nonatomic, assign) CGFloat headerHeight;
/** <#注释#>*/
@property (nonatomic, strong) NSData *firstImageData;
@end

@implementation MJKExpandAddViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self initUI];
}

- (void)initUI {
    self.title = @"新增素材";
    self.view.backgroundColor = [UIColor whiteColor];
    self.A47800_C_ID = [DBObjectTools getA47800_C_ID];
    
    self.addModel = [[CGCAddExpandModel alloc]init];
    [self configNavi];
    [self.view addSubview:self.tableView];
    
    
}

- (void)configNavi {
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [button setTitleNormal:@"发表"];
    [button setTitleColor:[UIColor blackColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [button addTarget:self action:@selector(publishedAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
//    MJKWorkWorldSignCell *cell = [MJKWorkWorldSignCell cellWithTableView:tableView];
//    cell.titleLabel.textColor = [UIColor darkGrayColor];
//    if (indexPath.row == 0) {
//        cell.titleImageView.image = [UIImage imageNamed:@"icon_community"];
//        cell.titleLabel.text = self.addModel.communitName.length > 0 ? self.addModel.communitName : @"所属小区";
//        cell.rightArrow.hidden = NO;
//    } else {
//        cell.titleImageView.image = [UIImage imageNamed:@"icon_label"];
//        cell.titleLabel.text = self.addModel.X_BQName.length > 0 ? self.addModel.X_BQName: @"素材标签";
//        cell.rightArrow.hidden = NO;
//    }
//    return cell;
    MJKExpandNewAddTableViewCell *cell = [MJKExpandNewAddTableViewCell cellWithTableView:tableView];
    cell.buttonAcrionBlock = ^(NSString * _Nonnull titleStr, BOOL isSelected) {
        if (isSelected == YES) {
            if ([titleStr isEqualToString:@"更多动态"]) {
                weakSelf.addModel.I_ISMORE = @"1";
            } else if ([titleStr isEqualToString:@"门店简介"]) {
                weakSelf.addModel.I_ISSTORE = @"1";
            } else {
                weakSelf.addModel.I_ISQRCODE = @"1";
            }
        } else {
            if ([titleStr isEqualToString:@"更多动态"]) {
                weakSelf.addModel.I_ISMORE = @"0";
            } else if ([titleStr isEqualToString:@"门店简介"]) {
                weakSelf.addModel.I_ISSTORE = @"0";
            } else {
                weakSelf.addModel.I_ISQRCODE = @"0";
            }
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    DBSelf(weakSelf);
//    if (indexPath.row == 0) {
//        MJKCommunityScreenViewController *vc = [[MJKCommunityScreenViewController alloc]init];
//        vc.isAddExpand = YES;
//        vc.sureBackBlock = ^(NSString * _Nonnull str, NSString * _Nonnull nameStr) {
//            weakSelf.addModel.communitName = nameStr;
//            weakSelf.addModel.communitID = str;
//            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        };
//        [self.navigationController pushViewController:vc animated:YES];
//    } else if (indexPath.row == 1) {
//        MJKExpandLabelViewController *vc = [[MJKExpandLabelViewController alloc]init];
//        vc.selectLabelBackBlock = ^(NSString * _Nonnull idStr, NSString * _Nonnull nameStr) {
//            weakSelf.addModel.X_BQ = idStr;
//            weakSelf.addModel.X_BQName = nameStr;
//            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        };
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.A47800_C_TYPE isEqualToString:@"A47800_C_TYPE_0006"]) {
        return 90;
    } else {
    if (self.headerHeight + 90 > 230) {
        return 90 + self.headerHeight;
    }
    return 230;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 275)];
    bgView.backgroundColor = [UIColor whiteColor];
    if ([self.A47800_C_TYPE isEqualToString:@"A47800_C_TYPE_0006"]) {
        
        [bgView addSubview:self.urlTextView];
    } else {
    [bgView addSubview:self.textView];
    if ([self.A47800_C_TYPE isEqualToString:@"A47800_C_TYPE_0003"]) {
        [bgView addSubview:self.urlTextView];
    }
    if ([self.A47800_C_TYPE isEqualToString:@"A47800_C_TYPE_0002"]) {
        [bgView addSubview:self.shootView];
    } else {
        [bgView addSubview:self.photoView];
    }
    }
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - 发表
- (void)publishedAction:(UIButton *)sender {
    if (![self.A47800_C_TYPE isEqualToString:@"A47800_C_TYPE_0002"]) {
        if (self.addModel.urlList.count <= 0) {
            [JRToast showWithText:@"请选择图片"];
            return;
        }
    }
    [self httpPostMaterial];
}

//接口
-(void)httpPostMaterial {
    DBSelf(weakSelf);
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A47800WebService-insert"];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    contentDict[@"C_ID"] = self.A47800_C_ID;
    contentDict[@"C_TYPE_DD_ID"] = self.A47800_C_TYPE;
    contentDict[@"C_PHONEIMEI"] = [DBTools uuid];
//    contentDict[@"X_URL"] = @"";
    if (self.addModel.communitID.length > 0) {
        contentDict[@"C_A48200_C_ID"] = self.addModel.communitID;
    }
    if (self.addModel.materialDes.length > 0) {
        contentDict[@"C_NAME"] = self.addModel.materialDes;
    }
    if (self.addModel.X_URL.length > 0) {
        contentDict[@"X_URL"] = self.addModel.X_URL;
    }
    if (self.addModel.X_BQ.length > 0) {
        //X_BQ
        contentDict[@"X_BQ"] = self.addModel.X_BQ;
    }
    if (self.addModel.I_ISMORE.length > 0) {
        contentDict[@"I_ISMORE"] = self.addModel.I_ISMORE;
    }
    if (self.addModel.I_ISSTORE.length > 0) {
        contentDict[@"I_ISSTORE"] = self.addModel.I_ISSTORE;
    }
    if (self.addModel.I_ISQRCODE.length > 0) {
        contentDict[@"I_ISQRCODE"] = self.addModel.I_ISQRCODE;
    }
    
    
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
//            [JRToast showWithText:data[@"message"]];
//            [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isRefresh"];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if ([self.A47800_C_TYPE isEqualToString:@"A47800_C_TYPE_0002"]) {
                    [weakSelf uppicAction:[NSArray arrayWithObjects:weakSelf.firstImageData,weakSelf.videoData, nil]  andMimeType:@"mp4"];
                } else {
                    //                NSMutableArray *imageArr = [NSMutableArray array];
//                    for (NSData *data in weakSelf.addModel.urlList) {
                        [weakSelf uppicAction:weakSelf.addModel.urlList andMimeType:@"png"];
//                    }
                }
                
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [KUSERDEFAULT setObject:@"yes" forKey:@"isRefresh"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
            
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

-(void)uppicAction:(NSArray *)dataArr andMimeType:(NSString *)mimeType{
//    DBSelf(weakSelf);
    //http://121.40.174.159:8585/MJK2.0/mobile_user
    NSString *urlStr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"formal"] isEqualToString:@"YES"] ? [NSString stringWithFormat:@"%@/%@/%@/uploadFilesQINIU.bk",[[NSUserDefaults standardUserDefaults]objectForKey:@"ip"],self.A47800_C_ID,[DBTools uuid]] : [NSString stringWithFormat:@"%@/%@/%@/uploadFilesQINIU.bk",[[NSUserDefaults standardUserDefaults]objectForKey:@"ip"],self.A47800_C_ID,[DBTools uuid]];
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postDataUpDataMaterialPhotoWithUrl:urlStr parameters:nil photo:dataArr  andMimeType:mimeType compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue] == 200) {
        } else {
            [JRToast showWithText:data[@"message"]];
        }
    }];

}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.textView) {
        self.addModel.materialDes = textView.text;
    } else {
        self.addModel.X_URL = textView.text;
    }
}

#pragma mark - set
- (UITextView *)textView {
    if (!_textView) {
        CGFloat height = 90;
        if ([self.A47800_C_TYPE isEqualToString:@"A47800_C_TYPE_0003"]) {
            height = 40;
        }
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth-20, height)];
        _textView.delegate = self;
        _textView.backgroundColor = kBackgroundColor;
        // _placeholderLabel
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = @"请填写素材描述...";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        [placeHolderLabel sizeToFit];
        [_textView addSubview:placeHolderLabel];
        
        // same font
        _textView.font = [UIFont systemFontOfSize:14.f];
        placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
        
        [_textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
        
    }
    return _textView;
}

- (UITextView *)urlTextView {
    if (!_urlTextView) {
        CGFloat y = CGRectGetMaxY(self.textView.frame) + 5;
        if ([self.A47800_C_TYPE isEqualToString:@"A47800_C_TYPE_0006"]) {
            y = 10;
        }
        _urlTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, y, KScreenWidth-20, 40)];
        _urlTextView.delegate = self;
        _urlTextView.backgroundColor = kBackgroundColor;
        // _placeholderLabel
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        if ([self.A47800_C_TYPE isEqualToString:@"A47800_C_TYPE_0006"]) {
            placeHolderLabel.text = @"请填写公众号链接...";
        } else {
        placeHolderLabel.text = @"请填写外链地址...";
        }
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        [placeHolderLabel sizeToFit];
        [_urlTextView addSubview:placeHolderLabel];
        
        // same font
        _urlTextView.font = [UIFont systemFontOfSize:14.f];
        placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
        
        [_urlTextView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
        
    }
    return _urlTextView;
}

- (MJKMaterialPhotoView *)photoView {
    DBSelf(weakSelf);
    if (!_photoView) {
        _photoView = [[MJKMaterialPhotoView alloc]initWithFrame:CGRectMake(0, [self.A47800_C_TYPE isEqualToString:@"A47800_C_TYPE_0003"] ? CGRectGetMaxY(self.urlTextView.frame) : CGRectGetMaxY(self.textView.frame), KScreenWidth, (KScreenWidth - 20) / 3)];
        _photoView.rootVC = self;
        _photoView.isChooseMorePhotos = YES;
        _photoView.backUrlArray = ^(NSArray * _Nonnull arr, CGFloat height) {
//            NSLog(@"%@ %f",arr, height);
            weakSelf.addModel.urlList = arr;
            weakSelf.headerHeight = height; 
            [weakSelf.tableView reloadData];
        };
    }
    return _photoView;
}

- (MJKShootView *)shootView {
    DBSelf(weakSelf);
    if (!_shootView) {
        _shootView = [[MJKShootView alloc]initWithFrame:CGRectMake(0, [self.A47800_C_TYPE isEqualToString:@"A47800_C_TYPE_0003"] ? CGRectGetMaxY(self.urlTextView.frame) : CGRectGetMaxY(self.textView.frame), KScreenWidth, (KScreenWidth - 20) / 3) andVC:self];
        _shootView.imageFrameBlock = ^(CGRect frame, NSData *firstImageData) {
            weakSelf.firstImageData = firstImageData;
            weakSelf.headerHeight = frame.size.height + frame.origin.y + 20;
            CGRect shootFrame = weakSelf.shootView.frame;
            shootFrame.size.height = frame.size.height;
            weakSelf.shootView.frame = shootFrame;
            [weakSelf.tableView reloadData];
        };
        
        _shootView.videoDataBlock = ^(NSData * _Nonnull data) {
            weakSelf.videoData = data;
        };
    }
    return _shootView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}
@end
