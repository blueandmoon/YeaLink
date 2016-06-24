//
//  CaptureViewController.m
//  YeaLink
//
//  Created by 李根 on 16/6/3.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "CaptureViewController.h"

@interface CaptureViewController ()

@end

@implementation CaptureViewController
{
    QJLBaseImageView *_imageview;
    AGSimpleImageEditorView *editorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageview = [[QJLBaseImageView alloc] initWithFrame:CGRectMake(0, 100, 320, 320)];
    _imageview.image = [UIImage imageNamed:@"transparencyPattern"];
    [self.view addSubview:_imageview];
    
    //  image为上一个界面传过来的图片资源
    editorView = [[AGSimpleImageEditorView alloc] initWithImage:self.image];
    [self.view addSubview:editorView];
    editorView.frame = CGRectMake(0, 64, WIDTH, HEIGHT - 64);
    editorView.center = self.view.center;
    
    //  外边框的宽度及颜色
    editorView.borderColor = [UIColor orangeColor];
    editorView.borderWidth = 1.0f;
    
    //  截取框的宽度及颜色
    editorView.ratioViewBorderColor = [UIColor orangeColor];
    editorView.ratioViewBorderWidth = 5.0f;
    
    //  截取比例
    editorView.ratio = _image.size.width / _image.size.height;
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:btn];
//    [btn setFrame:CGRectMake(100, 100, 100, 30)];
//    [btn setBackgroundColor:[UIColor lightGrayColor]];
//    [btn setTitle:@"done" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(saveButton) forControlEvents:UIControlEventTouchUpInside];

    //  添加导航栏和完成按钮
    UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:naviBar];
    [naviBar setTintColor:[UIColor redColor]];
    naviBar.translucent = NO;
    
    UINavigationItem *naviItem = [[UINavigationItem alloc] initWithTitle:@"图片裁剪"];
    [naviBar pushNavigationItem:naviItem animated:YES];
    
    //  保存按钮
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(saveButton)];
    naviItem.rightBarButtonItem = doneItem;
    
    
}



//  完成截取
- (void)saveButton {
    NSLog(@"截取了吗");
    //  output为截取后的图片, UIImage类型
    UIImage *resultImage = editorView.output;
    //  通过delegate回传给上一个界面
//    [self.delegate passImage:resultImage];
    
    //  返回页面已经在basewebview中写了, 这里就不必了
//    [self dismissModalViewControllerAnimated:YES];
    self.afterSaveImage();
//    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
