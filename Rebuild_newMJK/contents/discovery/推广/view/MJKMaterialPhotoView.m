//
//  MJKScratchableLatexPhotoView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/27.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKMaterialPhotoView.h"

#import "KSPhotoItem.h"
#import "KSPhotoBrowser.h"

#import "RITLPhotosViewController.h"
#import <Photos/Photos.h>
#import <RITLKit/RITLKit.h>


@interface MJKMaterialPhotoView ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,RITLPhotosViewControllerDelegate>
/** add button*/
@property (nonatomic, strong) UIButton *addButton;
/** image url*/
@property (nonatomic, strong) NSMutableArray *urlArray;
/** image view array*/
@property (nonatomic, strong) NSMutableArray *imageViewArray;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *imageArray;
/** <#备注#>*/
@property (nonatomic, copy) void(^saveData)(void);
/** <#注释#>*/
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, assign)  NSInteger*index;
@end

@implementation MJKMaterialPhotoView
- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self initUI:frame];
	}
	return self;
}

- (void)initUI:(CGRect )frame {
	CGFloat width = frame.size.width;
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, (width - 60) / 3, (width - 60) / 3)];
	self.addButton = button;
	[button setBackgroundImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(addImageAction:)];
	[self addSubview:button];
}

- (void)setImageURLArray:(NSArray *)imageURLArray {
	_imageURLArray = imageURLArray;
    [self.imageViewArray removeAllObjects];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
	for (int i = 0; i < imageURLArray.count; i++) {
		UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + ((self.addButton.frame.size.width + 10) * (i % 3)) , 10 + (i / 3) * (self.addButton.frame.size.width + 10), self.addButton.frame.size.width, self.addButton.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
//		[self.scrollView addSubview:imageView];
		[self addSubview:imageView];
		imageView.layer.cornerRadius = 5.f;
		imageView.layer.masksToBounds = YES;
		imageView.tag = i + 100;
		UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigImage:)];
		[imageView addGestureRecognizer:tapGR];
		if (imageURLArray.count > 0) {
//            [imageView sd_setImageWithURL:[NSURL URLWithString:imageURLArray[i]]];
            imageView.image = imageURLArray[i];
		}
		[self.imageViewArray addObject:imageView];
        
		UIButton *delButton = [[UIButton alloc]initWithFrame:CGRectMake(imageView.frame.size.width - 20, 0, 20, 20)];
		[imageView addSubview:delButton];
		imageView.userInteractionEnabled = YES;
		[delButton addTarget:self action:@selector(deleteImage:)];
		delButton.tag = i;
		[delButton setImage:@"icon_delete"];
		if (i == imageURLArray.count - 1 && imageURLArray.count != (self.imageCount != 0 ? self.imageCount : 9)) {
			
			CGRect addFrame = self.addButton.frame;
			if ((i + 1) % 3 == 0) {
				addFrame.origin.x = 10;
				addFrame.origin.y = imageView.frame.origin.y + imageView.frame.size.height + 10;
			} else {
				addFrame.origin.x = imageView.frame.size.width + imageView.frame.origin.x + 10;
				addFrame.origin.y = imageView.frame.origin.y;
			}
			
			self.addButton.frame = addFrame;
			
			CGRect viewFrame = self.frame;
			viewFrame.size.height = self.addButton.frame.origin.y + self.addButton.frame.size.height + 10;
			self.frame = viewFrame;
        } else if (imageURLArray.count == (self.imageCount != 0 ? self.imageCount : 9)) {
            CGRect viewFrame = self.frame;
            viewFrame.size.height = imageView.frame.origin.y + imageView.frame.size.height + 10;
            self.frame = viewFrame;
        }
	}
    
    if (imageURLArray.count <= 0) {
        CGRect addFrame = self.addButton.frame;
        addFrame.origin.x = 10;
        self.addButton.frame = addFrame;
        
        CGRect viewFrame = self.frame;
        viewFrame.size.height = self.addButton.frame.origin.y + self.addButton.frame.size.height + 10;
        self.frame = viewFrame;
    }
    DBSelf(weakSelf);
    self.saveData = ^{
        if ([weakSelf.vcName isEqualToString:@"订单附件"]) {
            if (weakSelf.backUrlDataBlock) {
                weakSelf.backUrlDataBlock(weakSelf.imageData);
            }
        } else {
            if (weakSelf.backUrlArray) {
                weakSelf.backUrlArray(weakSelf.urlArray, weakSelf.frame.size.height);
            }
        }
        
        
    };
    
    if (imageURLArray.count >=(self.imageCount != 0 ? self.imageCount : 9)) {
        self.addButton.hidden = YES;
        return;
    } else {
        self.addButton.hidden = NO;
    }
    
}

- (void)deleteImage:(UIButton *)sender {
    self.index = sender.tag;
	[self.urlArray removeObjectAtIndex:sender.tag];
    [self.imageArray removeObjectAtIndex:sender.tag];
	self.imageURLArray = [self.imageArray copy];
    if ([self.vcName isEqualToString:@"订单附件"]) {
        if (self.backDelDataBlock) {
            self.backDelDataBlock(sender.tag);
        }
    } else {
        if (self.saveData) {
            self.saveData();
        }
    }
}

- (void)showBigImage:(UITapGestureRecognizer *)sender {
	UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
	
	UIImageView *views = (UIImageView*) tap.view;
	NSMutableArray *arr = [NSMutableArray array];
	for (UIImageView *imageView in self.imageViewArray) {
		KSPhotoItem * item=[KSPhotoItem itemWithSourceView:imageView image:imageView.image];
		[arr addObject:item];
		
	}
	KSPhotoBrowser * browser=[KSPhotoBrowser browserWithPhotoItems:arr selectedIndex:views.tag - 100];
	
	
	[browser showFromViewController:self.rootVC];
	
}

- (void)addImageAction:(UIButton *)sender {
    if (self.urlArray.count == (self.imageCount != 0 ? self.imageCount : 9)) {
        [JRToast showWithText:[NSString stringWithFormat:@"最多选择%ld张",(long)(self.imageCount != 0 ? self.imageCount : 9)]];
        return;
    }
    if (self.isChooseMorePhotos == YES) {
        RITLPhotosViewController *photoController = RITLPhotosViewController.photosViewController;
        photoController.configuration.maxCount = self.imageCount != 0 ? self.imageCount : 9;
        photoController.imageArray = self.imageURLArray;
        photoController.configuration.containVideo = false;//选择类型，目前只选择图片不选择视频
        photoController.configuration.hiddenGroupWhenNoPhotos = true;//当相册不存在照片的时候隐藏
        photoController.photo_delegate = self;
        [self.rootVC presentViewController:photoController animated:true completion:^{}];
    } else {
        UIAlertController * alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        
        
        UIAlertAction*sanfdal=[UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.rootVC presentViewController:imagePicker animated:YES completion:nil];
            
        }];
        UIAlertAction*manual=[UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                //设置拍照后的图片可被编辑
                picker.allowsEditing = NO;
                picker.sourceType = sourceType;
                [self.rootVC presentViewController:picker animated:YES completion:nil];
                
            }else
            {
                NSLog(@"模拟其中无法打开照相机,请在真机中使用");
            }
            
            
        }];
    //	if (self.isCamera == NO) {
            [alertVC addAction:sanfdal];
    //	}
        
        [alertVC addAction:manual];
        [alertVC addAction:cancel];
        [self.rootVC presentViewController:alertVC animated:YES completion:nil];
        }
}
#pragma mark -- RITLPhotosViewControllerDelegate
//- (void)photosViewController:(UIViewController *)viewController thumbnailImages:(NSArray<UIImage *> *)thumbnailImages infos:(NSArray<NSDictionary *> *)infos
//{
//
//    DBSelf(weakSelf);
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        for (UIImage *image in thumbnailImages) {
//            NSData *imageData = UIImageJPEGRepresentation(image,0.1);
//            [weakSelf.urlArray addObject:imageData];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (weakSelf.saveData) {
//                weakSelf.saveData();
//            }
//        });
//    });
//
//    for (UIImage *image in thumbnailImages) {
//        [self.imageArray addObject:image];
//    }
//    self.imageURLArray = [self.imageArray copy];
//
//}

- (void)photosViewController:(UIViewController *)viewController
                      images:(NSArray <UIImage *> *)images
                       infos:(NSArray <NSDictionary *> *)infos {
    
    DBSelf(weakSelf);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (UIImage *image in images) {
            NSData *imageData = UIImageJPEGRepresentation(image,0.1);
            [weakSelf.urlArray addObject:imageData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.saveData) {
                weakSelf.saveData();
            }
        });
    });
    
    for (UIImage *image in images) {
        [self.imageArray addObject:image];
    }
    self.imageURLArray = [self.imageArray copy];
    
}

#pragma mark -- 上传图片相关

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    DBSelf(weakSelf);
	NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
	
	
	//当选择的类型是图片
	if ([type isEqualToString:@"public.image"])
	{
		//先把图片转成NSData
		UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
		if (!image) {
			image=[info objectForKey:UIImagePickerControllerEditedImage];
		}
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *imageData = UIImageJPEGRepresentation(image,0.1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.urlArray addObject:imageData];
                weakSelf.imageData = imageData;
                if (weakSelf.saveData) {
                    weakSelf.saveData();
                }
            });
        });
//        image= [UIImage imageWithData:imageData];
		
        [self.imageArray addObject:image];
        self.imageURLArray = [self.imageArray copy];
		
	}else{
		UIImage * image=[info objectForKey:UIImagePickerControllerEditedImage];
		if (!image) {
			image=[info objectForKey:UIImagePickerControllerOriginalImage];
		}
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *imageData = UIImageJPEGRepresentation(image,0.1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.urlArray addObject:imageData];
                weakSelf.imageData = imageData;
                if (weakSelf.saveData) {
                    weakSelf.saveData();
                }
            });
        });
//        image= [UIImage imageWithData:imageData];
		
        
//        [self.urlArray addObject:imageData];
        [self.imageArray addObject:image];
        self.imageURLArray = [self.imageArray copy];
		
	}
	[picker dismissViewControllerAnimated:YES completion:nil];
	
	
}
////对图片尺寸进行压缩--
//-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
//{
//    // Create a graphics image context
//    UIGraphicsBeginImageContext(newSize);
//
//    // Tell the old image to draw in this new context, with the desired
//    // new size
//    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//
//    // Get the new image from the context
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    // End the context
//    UIGraphicsEndImageContext();
//
//    // Return the new image.
//    return newImage;
//}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	NSLog(@"您取消了选择图片");
	[picker dismissViewControllerAnimated:YES completion:nil];
}
//储存图像到本地
- (void)saveimg:(UIImage *) img
{
	NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	[formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss:SSS"];
	NSString *date =  [formatter stringFromDate:[NSDate date]];
	
	NSString *imgname =  [NSString stringWithFormat:@"/image%@.png",date];
	imgname = [imgname stringByReplacingOccurrencesOfString:@" " withString:@""];
	imgname = [imgname stringByReplacingOccurrencesOfString:@":" withString:@""];
	
	//这里将图片放在沙盒的documents文件夹中
	NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	//文件管理器
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	//把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
	[fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
	NSData *dataObj = UIImageJPEGRepresentation(img, 1.0);
	[fileManager createFileAtPath:[DocumentsPath stringByAppendingString:imgname] contents:dataObj attributes:nil];
	//得到选择后沙盒中图片的完整路径
	//	self.patchUrl = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,imgname];
	
}


- (NSMutableArray *)urlArray {
	if (!_urlArray) {
		_urlArray = [NSMutableArray array];
	}
	return _urlArray;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}


- (NSMutableArray *)imageViewArray {
	if (!_imageViewArray) {
		_imageViewArray = [NSMutableArray array];
	}
	return _imageViewArray;
}
@end
