//
//  Demo13ViewController.m
//  照片选择器
//
//  Created by 洪欣 on 2018/10/9.
//  Copyright © 2018年 洪欣. All rights reserved.
//

#import "Demo13ViewController.h"
#import "HXPhotoPicker.h"
#import "LFPhotoEditingController.h"
#import "LFVideoEditingController.h"

static const CGFloat kPhotoViewMargin = 12.0;
@interface Demo13ViewController ()<LFPhotoEditingControllerDelegate, LFVideoEditingControllerDelegate>
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) HXPhotoModel *beforePhotoModel;
@property (strong, nonatomic) HXPhotoModel *beforeVideoModel;
@property (assign, nonatomic) BOOL isOutside;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@end

@implementation Demo13ViewController
- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    //photoView.outerCamera = YES; // 显示相机拍摄
    photoView.frame = CGRectMake(kPhotoViewMargin, hxNavigationBarHeight + kPhotoViewMargin, self.view.hx_w - kPhotoViewMargin * 2, 0);
    
    
    photoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:photoView];
    self.photoView = photoView;
}
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.albumShowMode = HXPhotoAlbumShowModePopup;
        _manager.configuration.openCamera = NO;
        _manager.configuration.photoMaxNum = 9;
        _manager.configuration.videoMaxNum = 1;
        _manager.configuration.maxNum = 18;
        _manager.configuration.minVideoClippingTime = 3; // 编辑视频最小裁剪秒数
        _manager.configuration.videoMaximumDuration = 15;
        _manager.configuration.videoMaximumSelectDuration = 15;
        _manager.configuration.editVideoExportPresetName = AVAssetExportPresetMediumQuality;
        _manager.configuration.sessionPreset = AVCaptureSessionPreset1280x720;
        _manager.type = HXPhotoManagerSelectedTypePhotoAndVideo;
//        _manager.configuration.requestImageAfterFinishingSelection = NO;
        
        _manager.configuration.photoCanEdit = YES;
        _manager.configuration.videoCanEdit = YES;
        _manager.configuration.replacePhotoEditViewController = YES;
        //_manager.configuration.replaceVideoEditViewController = YES;
        
        HXWeakSelf
        _manager.configuration.shouldUseEditAsset = ^(UIViewController *viewController, BOOL isOutside, HXPhotoManager *manager, HXPhotoModel *beforeModel) {
            weakSelf.isOutside = isOutside;
            if (beforeModel.subType == HXPhotoModelMediaSubTypePhoto) {
                weakSelf.beforePhotoModel = beforeModel;
                if (beforeModel.type == HXPhotoModelMediaTypeCameraPhoto) {
                    LFPhotoEditingController *lfPhotoEditVC = [[LFPhotoEditingController alloc] init];
                    lfPhotoEditVC.oKButtonTitleColorNormal = weakSelf.manager.configuration.themeColor;
                    lfPhotoEditVC.cancelButtonTitleColorNormal = weakSelf.manager.configuration.themeColor;
                    
                    lfPhotoEditVC.delegate = weakSelf;
                    if ([beforeModel.tempAsset isKindOfClass:[LFPhotoEdit class]]) {
                        lfPhotoEditVC.photoEdit = beforeModel.tempAsset;
                    }else {
                        lfPhotoEditVC.editImage = beforeModel.previewPhoto;
                    }
                    if (!weakSelf.isOutside) {
                        [viewController.navigationController setNavigationBarHidden:YES];
                        [viewController.navigationController pushViewController:lfPhotoEditVC animated:NO];
                    }else {
                        HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:lfPhotoEditVC];
                        nav.supportRotation = NO;
                        [nav setNavigationBarHidden:YES];
                        nav.modalPresentationStyle = UIModalPresentationFullScreen;
                        [viewController presentViewController:nav animated:NO completion:nil];
                    }
                }else {
                    [viewController.view hx_showLoadingHUDText:nil];
                    [beforeModel requestImageDataStartRequestICloud:nil progressHandler:nil success:^(NSData *imageData, UIImageOrientation orientation, HXPhotoModel *model, NSDictionary *info) {
                        [viewController.view hx_handleLoading];
                        UIImage *image = [UIImage imageWithData:imageData];
                        if (image.imageOrientation != UIImageOrientationUp) {
                            image = [image hx_normalizedImage];
                        }
                        LFPhotoEditingController *lfPhotoEditVC = [[LFPhotoEditingController alloc] init];
                        lfPhotoEditVC.oKButtonTitleColorNormal = weakSelf.manager.configuration.themeColor;
                        lfPhotoEditVC.cancelButtonTitleColorNormal = weakSelf.manager.configuration.themeColor;
                        
                        lfPhotoEditVC.delegate = weakSelf;
                        if ([beforeModel.tempAsset isKindOfClass:[LFPhotoEdit class]]) {
                            lfPhotoEditVC.photoEdit = beforeModel.tempAsset;
                        }else {
                            lfPhotoEditVC.editImage = image;
                        }
                        if (!weakSelf.isOutside) {
                            [viewController.navigationController setNavigationBarHidden:YES];
                            [viewController.navigationController pushViewController:lfPhotoEditVC animated:NO];
                        }else {
                            HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:lfPhotoEditVC];
                            nav.supportRotation = NO;
                            [nav setNavigationBarHidden:YES];
                            nav.modalPresentationStyle = UIModalPresentationFullScreen;
                            [viewController presentViewController:nav animated:NO completion:nil];
                        }
                    } failed:^(NSDictionary *info, HXPhotoModel *model) {
                        [viewController.view hx_handleLoading];
                        [viewController.view hx_showImageHUDText:@"资源获取失败!"];
                    }]; 
                }
            }else {
                weakSelf.beforeVideoModel = beforeModel;
                if (beforeModel.type == HXPhotoModelMediaTypeCameraVideo) {
                    LFVideoEditingController *lfVideoEditVC = [[LFVideoEditingController alloc] init];
                    lfVideoEditVC.delegate = weakSelf;
                    lfVideoEditVC.minClippingDuration = 3.f;
                    if ([beforeModel.tempAsset isKindOfClass:[LFVideoEdit class]]) {
                        lfVideoEditVC.videoEdit = beforeModel.tempAsset;
                    } else {
                        [lfVideoEditVC setVideoURL:beforeModel.videoURL placeholderImage:beforeModel.tempImage];
                    }
                    if (!weakSelf.isOutside) {
                        [viewController.navigationController setNavigationBarHidden:YES];
                        [viewController.navigationController pushViewController:lfVideoEditVC animated:NO];
                    }else {
                        HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:lfVideoEditVC];
                        nav.supportRotation = NO;
                        [nav setNavigationBarHidden:YES];
                        nav.modalPresentationStyle = UIModalPresentationFullScreen;
                        [viewController presentViewController:nav animated:NO completion:nil];
                    }
                }else {
                    [viewController.view hx_showLoadingHUDText:nil];
                    [beforeModel requestAVAssetStartRequestICloud:nil progressHandler:nil success:^(AVAsset *avAsset, AVAudioMix *audioMix, HXPhotoModel *model, NSDictionary *info) {
                        
                        [viewController.view hx_handleLoading];
                        if ([avAsset isKindOfClass:[AVURLAsset class]]) {
                            NSURL *video = [(AVURLAsset *)avAsset URL];
                            
                            LFVideoEditingController *lfVideoEditVC = [[LFVideoEditingController alloc] init];
                            lfVideoEditVC.delegate = weakSelf;
                            lfVideoEditVC.minClippingDuration = 5.f;
                            if ([beforeModel.tempAsset isKindOfClass:[LFVideoEdit class]]) {
                                lfVideoEditVC.videoEdit = beforeModel.tempAsset;
                            } else {
                                [lfVideoEditVC setVideoURL:video placeholderImage:[UIImage hx_thumbnailImageForVideo:video atTime:0.1f]];
                            }
                            if (!weakSelf.isOutside) {
                                [viewController.navigationController setNavigationBarHidden:YES];
                                [viewController.navigationController pushViewController:lfVideoEditVC animated:NO];
                            }else {
                                HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:lfVideoEditVC];
                                nav.supportRotation = NO;
                                [nav setNavigationBarHidden:YES];
                                nav.modalPresentationStyle = UIModalPresentationFullScreen;
                                [viewController presentViewController:nav animated:NO completion:nil];
                            }
                        }else {
                            [weakSelf.toolManager writeSelectModelListToTempPathWithList:@[beforeModel] requestType:1 success:^(NSArray<NSURL *> *allURL, NSArray<NSURL *> *photoURL, NSArray<NSURL *> *videoURL) {
                                [viewController.view hx_handleLoading];
                                NSURL *video = videoURL.firstObject;
                                
                                LFVideoEditingController *lfVideoEditVC = [[LFVideoEditingController alloc] init];
                                lfVideoEditVC.delegate = weakSelf;
                                lfVideoEditVC.minClippingDuration = 5.f;
                                if ([beforeModel.tempAsset isKindOfClass:[LFVideoEdit class]]) {
                                    lfVideoEditVC.videoEdit = beforeModel.tempAsset;
                                } else {
                                    [lfVideoEditVC setVideoURL:video placeholderImage:[UIImage hx_thumbnailImageForVideo:video atTime:0.1f]];
                                }
                                if (!weakSelf.isOutside) {
                                    [viewController.navigationController setNavigationBarHidden:YES];
                                    [viewController.navigationController pushViewController:lfVideoEditVC animated:NO];
                                }else {
                                    HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:lfVideoEditVC];
                                    nav.supportRotation = NO;
                                    [nav setNavigationBarHidden:YES];
                                    nav.modalPresentationStyle = UIModalPresentationFullScreen;
                                    [viewController presentViewController:nav animated:NO completion:nil];
                                }
                            } failed:^{
                                [viewController.view hx_handleLoading];
                                [viewController.view hx_showImageHUDText:@"资源获取失败!"];
                            }];
                        }
                    } failed:^(NSDictionary *info, HXPhotoModel *model) {
                        [viewController.view hx_handleLoading];
                        [viewController.view hx_showImageHUDText:@"资源获取失败!"];
                    }];
                }
            }
        };
    }
    return _manager;
}
- (void)lf_PhotoEditingController:(LFPhotoEditingController *)photoEditingVC didFinishPhotoEdit:(LFPhotoEdit *)photoEdit {
    [photoEditingVC.navigationController setNavigationBarHidden:NO];
    if (photoEdit) {
        HXPhotoModel *model = [HXPhotoModel photoModelWithImage:photoEdit.editPreviewImage];
        //model.tempAsset = photoEdit;
        self.manager.configuration.usePhotoEditComplete(self.beforePhotoModel, model);
        photoEdit = nil;
    }
    
    if (photoEditingVC.navigationController.viewControllers.count > 1) {
        [photoEditingVC.navigationController popViewControllerAnimated:NO];
    }else {
        [photoEditingVC dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)lf_PhotoEditingController:(LFPhotoEditingController *)photoEditingVC didFinishPhoto:(UIImage *)photoImage {
    [photoEditingVC.navigationController setNavigationBarHidden:NO];
    if (photoImage) {
        HXPhotoModel *model = [HXPhotoModel photoModelWithImage:photoImage];
        //model.tempAsset = photoEdit;
        self.manager.configuration.usePhotoEditComplete(self.beforePhotoModel, model);        
    }
    
    if (photoEditingVC.navigationController.viewControllers.count > 1) {
        [photoEditingVC.navigationController popViewControllerAnimated:NO];
    }else {
        [photoEditingVC dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)lf_PhotoEditingController:(LFPhotoEditingController *)photoEditingVC didCancelPhotoEdit:(LFPhotoEdit *)photoEdit {
    [photoEditingVC.navigationController setNavigationBarHidden:NO];
    
    if (photoEditingVC.navigationController.viewControllers.count > 1) {
        [photoEditingVC.navigationController popViewControllerAnimated:NO];
    }else {
        [photoEditingVC dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)lf_VideoEditingController:(LFVideoEditingController *)videoEditingVC didCancelPhotoEdit:(LFVideoEdit *)videoEdit {
    [videoEditingVC.navigationController setNavigationBarHidden:NO];
    
    if (videoEditingVC.navigationController.viewControllers.count > 1) {
        [videoEditingVC.navigationController popViewControllerAnimated:NO];
    }else {
        [videoEditingVC dismissViewControllerAnimated:NO completion:nil];
    }
}
- (void)lf_VideoEditingController:(LFVideoEditingController *)videoEditingVC didFinishPhotoEdit:(LFVideoEdit *)videoEdit {
    [videoEditingVC.navigationController setNavigationBarHidden:NO];
    
    HXPhotoModel *model = [HXPhotoModel photoModelWithVideoURL:videoEdit.editFinalURL];
    model.tempAsset = videoEdit;
    
    if (videoEditingVC.navigationController.viewControllers.count > 1) {
        [videoEditingVC.navigationController popViewControllerAnimated:NO];
    }else {
        [videoEditingVC dismissViewControllerAnimated:NO completion:nil];
    }
    
    self.manager.configuration.useVideoEditComplete(self.beforeVideoModel, model);
}
- (void)dealloc {
    NSSLog(@"dealloc");
}

@end
