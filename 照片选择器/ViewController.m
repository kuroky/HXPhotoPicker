//
//  ViewController.m
//  照片选择器
//
//  Created by 洪欣 on 17/2/8.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import "ViewController.h"
#import "Demo1ViewController.h"
#import "Demo2ViewController.h"
#import "Demo3ViewController.h"
#import "Demo4ViewController.h"
#import "Demo5ViewController.h"
#import "Demo6ViewController.h"
#import "Demo7ViewController.h"
#import "Demo8ViewController.h"
#import "Demo9ViewController.h"
#import "Demo10ViewController.h"
#import "YYFPSLabel.h"
#import "HXPhotoPicker.h"
#import "Demo11ViewController.h"
#import "Demo12ViewController.h"
#import "Demo13ViewController.h"
#import "Demo14ViewController.h"

static NSString *const kCellIdentifier = @"cell_identifier";

@interface ListItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, assign) Class viewControllClass;

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle viewControllClass:(Class)class;

@end

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (copy, nonatomic) NSArray *list;

@end

@implementation ViewController

- (NSArray *)list
{
    if (!_list) {
        _list = @[[[ListItem alloc] initWithTitle:@"Demo1"
                                         subTitle:@"只使用照片选择器功能,不带选好后自动布局(可扩展)"
                                viewControllClass: [Demo1ViewController class]],
                  [[ListItem alloc] initWithTitle:@"Demo2"
                                         subTitle:@"使用照片选择器功能并且选好后自动布局"
                                viewControllClass: [Demo2ViewController class]],
                  [[ListItem alloc] initWithTitle:@"Demo3"
                                         subTitle:@"附带网络照片功能"
                                viewControllClass: [Demo3ViewController class]],
                  [[ListItem alloc] initWithTitle:@"Demo4"
                                         subTitle:@"单选样式支持裁剪"
                                viewControllClass: [Demo4ViewController class]],
                  [[ListItem alloc] initWithTitle:@"Demo5"
                                         subTitle:@"同个界面多个选择器"
                                viewControllClass: [Demo5ViewController class]],
                  [[ListItem alloc] initWithTitle:@"Demo6"
                                         subTitle:@"拍照/选择照片完之后跳界面"
                                viewControllClass: [Demo6ViewController class]],
                  [[ListItem alloc] initWithTitle:@"Demo7"
                                         subTitle:@"传入本地image/video并展示"
                                viewControllClass: [Demo7ViewController class]],
                  [[ListItem alloc] initWithTitle:@"Demo8"
                                         subTitle:@"将已选模型(图片和视频)写入临时目录  一键写入^_^"
                                viewControllClass: [Demo8ViewController class]],
                  [[ListItem alloc] initWithTitle:@"Demo9"
                                         subTitle:@"cell上添加photoView(附带3DTouch预览)"
                                viewControllClass: [Demo9ViewController class]],
                  [[ListItem alloc] initWithTitle:@"Demo10"
                                         subTitle:@"保存草稿功能"
                                viewControllClass: [Demo10ViewController class]],
                  [[ListItem alloc] initWithTitle:@"Demo11"
                                         subTitle:@"xib上使用HXPhotoView"
                                viewControllClass: [Demo11ViewController class]],
                  [[ListItem alloc] initWithTitle:@"Demo12"
                                         subTitle:@"混合添加资源"
                                viewControllClass: [Demo12ViewController class]],
                  [[ListItem alloc] initWithTitle:@"Demo13"
                                         subTitle:@"嵌套其他第三方图片/视频编辑库"
                                viewControllClass: [Demo13ViewController class]],
                  [[ListItem alloc] initWithTitle:@"Demo14"
                           subTitle:@"加载网络视频"
                  viewControllClass: [Demo14ViewController class]]
                  
                  ];
    }
    return _list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Demo 1 ~ 12";

    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 70;
    [self.view addSubview:tableView];
    YYFPSLabel *label = [[YYFPSLabel alloc] initWithFrame:CGRectMake(40, hxTopMargin ? hxTopMargin - 10: 10 , 100, 30)];
    [[UIApplication sharedApplication].keyWindow addSubview:label]; 
    
//    NSString *language = [NSLocale preferredLanguages].firstObject;
//    NSSLog(@"%@",language);
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    ListItem *item = self.list[indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListItem *item = self.list[indexPath.row];
    UIViewController *viewController = [[item.viewControllClass alloc] init];
    viewController.title = item.title; 
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];  
    [self.navigationController pushViewController:viewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end

@implementation ListItem

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle viewControllClass:(Class)class
{
    self = [super init];
    if (self) {
        self.title = title;
        self.subTitle = subTitle;
        self.viewControllClass = class;
    }
    return self;
}

@end
