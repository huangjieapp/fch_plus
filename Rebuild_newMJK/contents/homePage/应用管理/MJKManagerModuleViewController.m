//
//  ModuleEditViewController.m
//  match
//
//  Created by huangjie on 2022/8/8.
//

#import "MJKManagerModuleViewController.h"

#import "ModuleCollectionViewCell.h"

#import "MJKManagerModuleModel.h"
#import "ModuleModel.h"


@interface MJKManagerModuleViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) UICollectionView *collectionView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *moduleArray;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *saveModuleDatas;
/** <#注释#> */
@property (nonatomic, strong) UIButton *editButton;
/** <#注释#> */
@property (nonatomic, strong)  NSMutableArray *appDefaultArr;
@property (nonatomic, strong)  NSMutableArray *tempDefaultArr;

@end

@implementation MJKManagerModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"应用编辑";
    [self getMyAppDatas];
    
    _editButton = [UIButton new];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editButton];
    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_editButton setTitle:@"完成" forState:UIControlStateSelected];
    [_editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_editButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _editButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    @weakify(self);
    [[_editButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        x.selected = !x.isSelected;
        [self.collectionView reloadData];
    }];
    
    
    CGFloat itemW = KScreenWidth / 4;
    CGFloat itemH = KScreenWidth / 4 - 20;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIHEIGHT);
        make.left.right.bottom.equalTo(self.view);
    }];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ModuleCollectionViewCell class] forCellWithReuseIdentifier:@"ModuleCollectionViewCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];


    
}

#pragma mark-- datas
-(void)getMyAppDatas{
    NSArray *myAppDatas = [[NSUserDefaults standardUserDefaults] objectForKey:@"module"];
    self.tempDefaultArr = [myAppDatas mutableCopy];
    NSMutableArray *defaultArr = self.moduleArray[0][@"content"];
    [defaultArr removeAllObjects];
    for (int i = 1; i < self.moduleArray.count; i++) {
        NSArray *defaultArr1 = self.moduleArray[i][@"content"];
        for (NSString *name in myAppDatas) {
            for (MJKManagerModuleModel *defaultModel in defaultArr1) {
                if ([name isEqualToString:defaultModel.name]) {
                    defaultModel.selected = YES;
                }
                if ([defaultModel.name isEqualToString:name]) {
                    [defaultArr addObject:defaultModel];
                }
            }
        }
    }
    
}

#pragma mark -collectionview 数据源方法
  - (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
 
      return self.moduleArray.count;   //返回section数
  }
  - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
      NSArray *arr = self.moduleArray[section][@"content"];
      return arr.count;
  }

 - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
 {
     ModuleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ModuleCollectionViewCell" forIndexPath:indexPath];
     NSArray *arr = self.moduleArray[indexPath.section][@"content"];
     MJKManagerModuleModel *model = arr[indexPath.row];
     cell.moduleImageView.image = [UIImage imageNamed:model.imageName];
     cell.moduleLabel.text = model.name;
     if (self.editButton.isSelected == YES) {
         if (indexPath.section == 0) {
            cell.moduleSelectImageView.image = [UIImage imageNamed:@"deleteApplication"];
         } else {
             if (model.isSelected == YES) {
                 cell.moduleSelectImageView.image = [UIImage imageNamed:@"selectedApplication"];
             } else {
                 cell.moduleSelectImageView.image = [UIImage imageNamed:@"addApplication"];
             }
         }
         cell.moduleSelectImageView.hidden = NO;
     } else {
         cell.moduleSelectImageView.hidden = YES;
     }
     cell.isCheck = self.editButton.isSelected;
     return cell;

 }

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(KScreenWidth, 30);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class) forIndexPath:indexPath];
        for (UIView *view in headerView.subviews) {
            [view removeFromSuperview];
        }
        headerView.backgroundColor = kBackgroundColor;
        UILabel *label = [UILabel new];
        [headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17);
            make.centerY.equalTo(headerView);
        }];
        label.font = [UIFont systemFontOfSize:14.f];
        label.textColor = [UIColor blackColor];
        NSString *title = self.moduleArray[indexPath.section][@"title"];
        label.text = title;
        return headerView;
    }
    return  nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.moduleArray[indexPath.section][@"content"];
    MJKManagerModuleModel *model = arr[indexPath.row];
    if (self.editButton.isSelected == NO) {
        [DBObjectTools pushVCWithName:model.name andSelf:self];
    } else {
        if (indexPath.section == 0) {
            if (self.tempDefaultArr.count <= 1) {
                [JRToast showWithText:@"至少保留一项应用"];
                return;
            }
            model.selected = NO;
            if ([self.tempDefaultArr containsObject:model.name]) {
                [self.tempDefaultArr removeObject:model.name];
            }
           
        } else {
            model.selected = YES;
            if (![self.tempDefaultArr containsObject:model.name]) {
                [self.tempDefaultArr addObject:model.name];
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:self.tempDefaultArr forKey:@"module"];
        [self getMyAppDatas];
        [collectionView reloadData];
    }
    
}

- (NSMutableArray *)moduleArray {
    if (!_moduleArray) {
        _moduleArray = [NSMutableArray array];
        [_moduleArray addObject:@{@"title": @"我的应用", @"content": self.saveModuleDatas}];
        [_moduleArray addObject:@{@"title": @"基础应用", @"content": self.appDefaultArr}];
    }
    return _moduleArray;
}

- (NSMutableArray *)saveModuleDatas {
    if (!_saveModuleDatas) {
        _saveModuleDatas = [NSMutableArray array];
    }
    return _saveModuleDatas;
}

- (NSMutableArray *)appDefaultArr {
    if (!_appDefaultArr) {
        _appDefaultArr = [NSMutableArray array];
        NSArray *arr = @[@"工作日历",@"绩效进度",@"预约管理",@"审批管理",@"粉丝管理",@"车源管理",@"任务打卡",@"售后管理",@"客服反馈",@"精品管理",@"上牌管理",@"保险管理",@"按揭管理",@"质保管理"];
        for (NSString *str in arr) {
            MJKManagerModuleModel *model = [[MJKManagerModuleModel alloc] init];
            model.name = str;
            model.imageName = [NSString stringWithFormat:@"%@图标应用", str];
            [_appDefaultArr addObject:model];
        }
    }
    return _appDefaultArr;
}

- (NSMutableArray *)tempDefaultArr {
    if (!_tempDefaultArr) {
        _tempDefaultArr = [NSMutableArray array];
        
    }
    return _tempDefaultArr;
}



- (void)dealloc {
    MyLog(@"销毁controller-----%s", __func__);
}


@end
