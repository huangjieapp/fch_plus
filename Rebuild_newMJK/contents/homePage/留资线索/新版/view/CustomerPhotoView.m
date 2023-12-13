//
//  CustomerPhotoView.m
//  match
//
//  Created by huangjie on 2022/8/2.
//

#import "CustomerPhotoView.h"
#import "VideoAndImageModel.h"

#import "KSPhotoBrowser.h"

@implementation CustomerPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _bgView = [UIView new];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(2);
            make.height.mas_equalTo(30);
        }];
        _bgView.backgroundColor = kBackgroundColor;
        
        _titleLabel = [UILabel new];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17);
            make.top.mas_equalTo(7);
            make.height.mas_equalTo(20);
        }];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
        _titleLabel.text = @"上传图片";
        
        _mustLabel = [UILabel new];
        [self addSubview:_mustLabel];
        [_mustLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right);
            make.top.equalTo(self.titleLabel);
        }];
        _mustLabel.text = @"*";
        _mustLabel.textColor = [UIColor redColor];
        _mustLabel.hidden = YES;

        _scrollView = [UIScrollView new];
        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.bottom.right.equalTo(self);
        }];

        _addButton = [UIButton new];
        [self.scrollView addSubview:_addButton];
        [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(7);
            make.left.mas_equalTo(17);
            make.width.height.mas_equalTo(110);
        }];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
        
        
    }
    return self;
}

- (void)setImageUrlArray:(NSMutableArray *)imageUrlArray {
    _imageUrlArray = imageUrlArray;
    for (UIView *subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    for (int i = 0; i < imageUrlArray.count; i++) {
        VideoAndImageModel *model = imageUrlArray[i];
        UIImageView *imageView = [UIImageView new];
        [self.scrollView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17 + i * 120);
            make.top.mas_equalTo(7);
            make.width.height.mas_equalTo(110);
        }];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
        imageView.layer.cornerRadius = 5.f;
        imageView.layer.masksToBounds = YES;
        imageView.userInteractionEnabled = YES;
        
        imageView.tag = i + 100;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigImage:)];
        [imageView addGestureRecognizer:tapGR];
        
        UIButton *delButton = [UIButton new];
        [imageView addSubview:delButton];
        [delButton  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-5);
            make.top.mas_equalTo(5);
            make.width.height.mas_equalTo(20);
        }];
        delButton.tag = 100 + i;
        [delButton setBackgroundImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
        @weakify(self);
        [[delButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
            @strongify(self);
            [self.imageUrlArray removeObjectAtIndex:x.tag - 100];
            [self.tableView reloadData];
            
        }];
        if (self.isNoEdit == YES) {
            delButton.hidden = YES;
        }
    }
    if (self.isNoEdit == YES) {
        self.addButton.hidden = YES;
    } else {
        [self.addButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageUrlArray.count * 120 + 17);
        }];
    }
    self.scrollView.contentSize = CGSizeMake(imageUrlArray.count * 120 + 154, 110);
    
}

- (void)showBigImage:(UITapGestureRecognizer *)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    
    UIImageView *views = (UIImageView*) tap.view;
    NSMutableArray *arr = [NSMutableArray array];
    for (VideoAndImageModel *model in self.imageUrlArray) {
        UIImageView *imageView = [UIImageView new];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
        KSPhotoItem * item=[KSPhotoItem itemWithSourceView:imageView image:imageView.image];
        [arr addObject:item];
        
    }
    KSPhotoBrowser * browser=[KSPhotoBrowser browserWithPhotoItems:arr selectedIndex:views.tag - 100];
    
    
    [browser showFromViewController:[DBTools getSuperViewWithsubView:self]];
    
}

- (void)dealloc {
    MyLog(@"销毁view----%s", __func__);
}

@end
