//
//  Demo14ViewController.m
//  照片选择器
//
//  Created by kuroky on 2019/9/17.
//  Copyright © 2019 洪欣. All rights reserved.
//

#import "Demo14ViewController.h"
#import "HXPhotoPicker.h"

static const CGFloat kPhotoViewMargin = 12.0;

@interface Demo14ViewController () <HXPhotoViewDelegate>

@property (strong, nonatomic) HXPhotoManager *manager;
@property (weak, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;

@end

@implementation Demo14ViewController

- (HXPhotoManager *)manager
{
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        //        _manager.openCamera = NO;
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.photoMaxNum = 9; //
        _manager.configuration.videoMaxNum = 5;  //
        _manager.configuration.maxNum = 14;
        _manager.type = HXPhotoManagerSelectedTypePhotoAndVideo;
        
//        _manager.networkPhotoUrls = [NSMutableArray arrayWithObjects:@"http://tsnrhapp.oss-cn-hangzhou.aliyuncs.com/003d86db-b140-4162-aafa-d38056742181.jpg",@"http://tsnrhapp.oss-cn-hangzhou.aliyuncs.com/0034821a-6815-4d64-b0f2-09103d62630d.jpg",@"http://tsnrhapp.oss-cn-hangzhou.aliyuncs.com/0be5118d-f550-403e-8e5c-6d0badb53648.jpg",@"http://tsnrhapp.oss-cn-hangzhou.aliyuncs.com/1466408576222.jpg", nil];
    }
    return _manager;
}
- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    CGFloat width = scrollView.frame.size.width;
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(kPhotoViewMargin, kPhotoViewMargin, width - kPhotoViewMargin * 2, 0);
    photoView.lineCount = 5;
    photoView.delegate = self;
    photoView.showAddCell = NO;
    photoView.hideDeleteButton = YES;
    photoView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:photoView];
    self.photoView = photoView;
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.mp4", nil];
    NSMutableArray *assets = @[].mutableCopy;
    for (NSString *url in array) {
        HXCustomAssetModel *asset = [HXCustomAssetModel assetWithNetworkVideoURL:[NSURL URLWithString:url] selected:YES];
        [assets addObject:asset];
    }
    [self.manager addCustomAssetModel:assets];
//    [self.manager addNetworkingImageToAlbum:array selected:YES];
    [self.photoView refreshView];
    // 可以在懒加载中赋值 ,  也可以这样赋值
//    self.manager.networkPhotoUrls = ;
    
//    photoView.manager = self.manager;
}

- (void)lookClick {
    [[YYWebImageManager sharedManager].cache.diskCache removeAllObjects];
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
//    [[SDWebImageManager sharedManager] cancelAll];
//    [[SDWebImageManager sharedManager].imageCache clearWithCacheType:SDImageCacheTypeAll completion:^{
//
//    }];
//    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{

//    }];
//    [[SDImageCache sharedImageCache] clearMemory];
//#if SDWebImageEmbed
//#endif
    return;
}

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    NSSLog(@"所有:%ld - 照片:%ld - 视频:%ld",allList.count,photos.count,videos.count);
    
//    [self.toolManager writeSelectModelListToTempPathWithList:allList requestType:0 success:^(NSArray<NSURL *> *allURL, NSArray<NSURL *> *photoURL, NSArray<NSURL *> *videoURL) {
//        NSSLog(@"%@",allURL);
//    } failed:^{
//
//    }];
    
    
//    [self.view showLoadingHUDText:nil];
//    __weak typeof(self) weakSelf = self;
//    [self.toolManager getSelectedImageList:allList success:^(NSArray<UIImage *> *imageList) {
//        [weakSelf.view handleLoading];
//        NSSLog(@"%@",imageList);
//    } failed:^{
//        [weakSelf.view handleLoading];
//    }];
}

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame
{
    NSSLog(@"%@",NSStringFromCGRect(frame));
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
}

@end
