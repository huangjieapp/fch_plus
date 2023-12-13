//
//  CommentView.m
//  match5.0
//
//  Created by huangjie on 2023/6/11.
//

#import "CommentView.h"

@interface CommentView ()<UITextViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
/** <#注释#> */
@property (nonatomic, strong) UIView *contentView;
@end

@implementation CommentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [UIView new];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(@0);
        }];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = .5f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
        [bgView addGestureRecognizer:tap];
        
        UIView *contentView = [UIView new];
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-430));
            make.left.right.equalTo(@0);
            make.height.equalTo(@280);
        }];
        contentView.backgroundColor = [UIColor whiteColor];
        self.contentView = contentView;
        _commentTV = [UITextView new];
        [contentView addSubview:_commentTV];
        [_commentTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(@10);
            make.right.equalTo(@(-10));
            make.height.equalTo(@60);
        }];
        _commentTV.font = KNomarlFont;
        _commentTV.layer.cornerRadius = 5.f;
        _commentTV.layer.borderWidth = 1.f;
        _commentTV.layer.borderColor = kBackgroundColor.CGColor;
        _commentTV.delegate = self;
        // _placeholderLabel
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        [_commentTV addSubview:placeHolderLabel];
        placeHolderLabel.text = @"请输入您的评论";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        [placeHolderLabel sizeToFit];
        placeHolderLabel.font = KNomarlFont;
        [_commentTV setValue:placeHolderLabel forKey:@"_placeholderLabel"];
        
        _photoView = [CustomerPhotoView new];
        [contentView addSubview:_photoView];
        [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.commentTV.mas_bottom);
            make.left.right.equalTo(@0);
            make.height.equalTo(@150);
        }];
        _photoView.titleLabel.text = @"";
        [_photoView.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        _photoView.bgView.backgroundColor  = [UIColor whiteColor];
        @weakify(self);
        __weak CustomerPhotoView *wPhotoView = _photoView;
        [[_photoView.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            HXPhotoManager *manager = [HXPhotoManager new];
            manager.configuration.singleJumpEdit = NO;
            manager.configuration.singleSelected = YES;
            [self.rootVC openPhotoLibraryWith:manager success:^(VideoAndImageModel * _Nonnull model) {
                [self.imageUrlArray addObject:model];
                wPhotoView.imageUrlArray = self.imageUrlArray;
                if (self.chooseImageArrrayBlock) {
                    self.chooseImageArrrayBlock(self.imageUrlArray);
                }
            }];
        }];
        
        _noticeButton = [UIButton new];
        [contentView addSubview:_noticeButton];
        [_noticeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.photoView.mas_bottom);
            make.left.equalTo(@10);
        }];
        [_noticeButton setTitle:@"@提醒谁看" forState:UIControlStateNormal];
        [_noticeButton setTitleColor:KNaviColor forState:UIControlStateNormal];
        _noticeButton.titleLabel.font = KNomarlFont;
        [_noticeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        _submitButton = [UIButton new];
        [contentView addSubview:_submitButton];
        [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-10));
            make.size.equalTo(@(CGSizeMake(80, 30)));
            make.top.equalTo(self.photoView.mas_bottom);
            make.left.equalTo(self.noticeButton.mas_right).offset(10);
        }];
        [_submitButton setTitle:@"发表" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_submitButton setBackgroundColor:KNaviColor];
        _submitButton.titleLabel.font = KNomarlFont;
        _submitButton.layer.cornerRadius = 5.f;
        
    }
    return self;
}

- (void)closeView {
    [self removeFromSuperview];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-AdaptSafeBottomHeight));
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-380));
    }];
}

- (NSMutableArray *)imageUrlArray {
    if (!_imageUrlArray) {
        _imageUrlArray = [NSMutableArray array];
    }
    return _imageUrlArray;
}

- (void)dealloc {
    MyLog(@"______%s_______", __func__);
}
@end
