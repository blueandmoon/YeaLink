//
//  BaseWebViewController.m
//  YeaLink
//
//  Created by 李根 on 16/5/6.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "BaseWebViewController.h"
#import "CaptureViewController.h"

#import "CustomURLCache.h"  //  缓存
#import <JavaScriptCore/JavaScriptCore.h>
#import "UserModel.h"

#import "WebViewJavascriptBridge.h"
#import "ObserverKeyboard.h"

#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

@interface BaseWebViewController ()<UIWebViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(nonatomic, strong)WebViewJavascriptBridge *bridge;
@property(nonatomic, strong)void(^exchangeValue)(NSString *); //  传给js的值

@end

@implementation BaseWebViewController
{
    GifView *_gifview;
    CaptureViewController *_captureVC;
//    ObserverKeyboard *_observer;
    NSString *_type;
    UIImagePickerController *_imagePickerViewController;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

#pragma mark    - viewWillAppear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"selectPhoto"] isEqualToString:@"1"]) {
        _wv = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64 - 49)];
        [self.view addSubview:_wv];
        _wv.delegate = self;
        
    }
    
    //  打印当前内存
    [ReportMemory reportCurrentMemory];
}

- (void)viewWillDisappear:(BOOL)animated {
    //  这样在加载新的webview链接时, 就不会出现旧的页面, 闪一下了  so ~  ~   ~
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"selectPhoto"] isEqualToString:@"1"]) {   //  如果是跳到相册页面, 就不移除webview
//        NSLog(@"____%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"selectPhoto"]);
        [_wv removeFromSuperview];
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //  加载时的动图
    _gifview = [[GifView alloc] init];
    [self.view addSubview:_gifview];
    [_gifview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [_gifview showGifView];
    
    //  定位
    [UserLocation shareGpsManager];
    
    
//    _observer = [[ObserverKeyboard alloc] init];
//    [self.view addSubview:_observer];
    //  监听键盘
    [[ObserverKeyboard shareKeyboard] addObserver];
    
//    //  缓存webview
//    CustomURLCache *urlCache = [[CustomURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024 diskCapacity:200 * 1024 * 1024 diskPath:nil cacheTime:0];
//    [CustomURLCache setSharedURLCache:urlCache];
    
    
    
    _wv.opaque = NO;
    _wv.backgroundColor = [UIColor clearColor];
    
    _imagePickerViewController = [[UIImagePickerController alloc] init];
    _imagePickerViewController.allowsEditing = YES;
    _imagePickerViewController.delegate = self;
    
    
    
}

#pragma mark    - webview
- (void)getHtmlWithstr:(NSString *)str {
    //  加载动图
    [self.view bringSubviewToFront:_gifview];
    
    UserModel *model = [[UserModel alloc] init];
    model = [UserInformation userinforSingleton].usermodel;
    NSString *tempStr;
    NSString *cityID = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityID"]; //  用户所选城市, 非其所在城市
    if ([str hasPrefix:@"http:"]) {
        if ([str isEqualToString:@"http://www.go2family.com"]) {
            tempStr = str;
        } else {
            tempStr = [NSString stringWithFormat:@"%@?UserID=%@&CityID=%@&APPUserRole=%@", str, model.UserID,cityID, model.APPUserRole];
        }
    } else {
        tempStr = [NSString stringWithFormat:@"%@%@?UserID=%@&CityID=%@&APPUserRole=%@", COMMONURL, str, model.UserID,cityID, model.APPUserRole];
        NSLog(@"tempStr: %@", tempStr);
    }
    NSLog(@"当前加载链接: %@", tempStr);
    [_wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tempStr]]];
    
    
}


#pragma mark    - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.view bringSubviewToFront:_wv];
    
    __weak BaseWebViewController *blockSelf = self;
    //  当点击进入次级页面是, 等webview页面加载完毕后再重新载入JSContext, 这样获取的JSContext才是当前最新的, 才会调用block方法, 断点, 或者把这段代码写成一个方法调用会卡死
    JSContext *context = [_wv  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"jakilllog"] = ^() {
        //        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSString *str = [NSString stringWithFormat:@"%@", jsVal];
            NSLog(@"str: %@", str);
//            NSLog(@"%@", jsVal);
            
            if ([str hasPrefix:@"share"]) {
//                [self goToShare];
                //  获取当前页面的链接, 向发现和秀场
                NSString *currentURL = webView.request.URL.absoluteString;
                NSString *text = [str substringFromIndex:5];
//                NSLog(@"currentURL: %@", currentURL);
                
                
//                [SSUIShareActionSheetStyle setCancelButtonBackgroundColor:CUSTOMBLUE];
//                // 设置分享菜单－取消按钮背景颜色
//                [SSUIShareActionSheetStyle setCancelButtonBackgroundColor:[UIColor redColor]];
//                // 设置分享菜单－取消按钮的文本颜色
//                [SSUIShareActionSheetStyle setCancelButtonLabelColor:[UIColor redColor]];
//                // 设置分享菜单－社交平台文本颜色
//                [SSUIShareActionSheetStyle setItemNameColor:CUSTOMBLUE];
//                
//                [SSUIShareActionSheetStyle setCurrentPageIndicatorTintColor:[UIColor redColor]];
                
                //按钮的颜色
//                [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
                //标题颜色
//                [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];

                [ShareTools goToShareWithText:text url:[NSURL URLWithString:currentURL]];
            } else if ([str isEqualToString:@"Change"]) {
                NSLog(@"业主变成个人用户");
                self.refreshDataWhenchangeCell(0);
            } else {
                if ([str isEqualToString:@"back"]) {
                //  执行返回操作
                NSLog(@"返回");
                _back();
            } else if ([str isEqualToString:@"photo"]) {    //  上传图片的识别字符
                NSLog(@"商家!");
                _type = @"M";
            } else if ([str isEqualToString:@"sendshowword"]) {
                NSLog(@"秀场");
                _type = @"X";
            } else if ([str isEqualToString:@"SendMyShow"]) {
                NSLog(@"个人中心.我的个人秀");
                _type = @"X";
            } else if ([str isEqualToString:@"HeadImg"]) {
                NSLog(@"头像");
                _type = @"U";
            } else if ([str isEqualToString:@"Maintance"]) {
                NSLog(@"维护报修");
                _type = @"MN";
            } else {
                NSLog(@"什么类型");
            }

            [self takePhoto];
            }
        }
        
    };

    
    _exchangeValue = ^(NSString *tempStr) {
        NSString *jsStr = [blockSelf.wv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"FormAndriodIOSPhoto('%@');", tempStr]];
        NSLog(@"jsStr: %@", jsStr);
    };
    
    //  h5页面的返回
    self.backforH5 = ^(UIWebView *webview) {
        NSString *Str = [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"gotoPre();"]];
        NSLog(@"jsStr: %@", Str);
        if ([Str isEqualToString:@"a"] || [Str isEqualToString:@"b"]) {
//            NSLog(@"我该怎么返回!");
        } else {
            //  返回native
            blockSelf.backNative();
        }
    };
    
    //  获取当前页面的标题
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    _takeStr(title);
//    NSLog(@"当前页面标题title:%@", title);
    
    //  获取当前页面的链接, 向发现和秀场
    NSString *currentURL = webView.request.URL.absoluteString;
    NSLog(@"currentURL---url-%@--", currentURL);
    //  把链接转换成小写再判断
    NSString *lowerURL = [currentURL lowercaseString];
    BOOL show = [lowerURL rangeOfString:@"/show/"].location != NSNotFound;
    BOOL find = [lowerURL rangeOfString:@"/find/"].location != NSNotFound;
//    BOOL news = [lowerURL rangeOfString:@"/message/"].location != NSNotFound;
    
    if (show || find) {
        self.changeShowLeftButton(currentURL);
    }
    
    //  向js传递键盘的高度
    [ObserverKeyboard shareKeyboard].takeKeyboardValue = ^(CGFloat keyboardHeight) {
        NSString *jsStr = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"keyboardHeight('%f');", keyboardHeight]];
        NSLog(@"键盘返回值: %@", jsStr);
//        NSLog(@"keyboardRect.size.height: %f", keyboardRect.size.height);
        [(UIScrollView *)[[webView subviews] objectAtIndex:0] setScrollEnabled:NO];
    };
    
    [ObserverKeyboard shareKeyboard].keyboardWillHide = ^() {
        [(UIScrollView *)[[webView subviews] objectAtIndex:0] setScrollEnabled:YES];
    };
    
    self.takeUserLocation = ^() {
        NSString *jsStr = [blockSelf.wv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"MapPoint('%f', '%f')", [UserInformation userinforSingleton].longitude, [UserInformation userinforSingleton].latitude]];
        NSLog(@"位置返回值: %@", jsStr);
        NSLog(@"%f", [UserInformation userinforSingleton].longitude);
    };
    self.takeUserLocation();
    
    //  秀场右上角按钮
    NSString *userSelect = [[NSUserDefaults standardUserDefaults] objectForKey:@"rightShowTitle"];
    NSString *takeStr;
    if ([userSelect isEqualToString:@"默认城市"]) {
        takeStr = @"C";
    } else {
        takeStr = @"V";
    }
    NSString *jsStr = [self.wv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"SearchShow('%@');", takeStr]];
    NSLog(@"秀场右上角按钮jsStr: %@", jsStr);
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    //  定位
    [[UserLocation shareGpsManager] UpdatingLocation];
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark    - 拍照, 选择图片
- (void)takePhoto {
    dispatch_async(dispatch_get_main_queue(), ^{
    });
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中选择", nil];
        [actionSheet showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    NSLog(@"%d", buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"selectPhoto"];
                [[NSUserDefaults standardUserDefaults] synchronize];

                _imagePickerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:_imagePickerViewController animated:YES completion:nil];
            } else {
                [self showAlertWithMessage:@"Camera is not available in this device or simulator"];
            }
        } break;
        case 1:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"selectPhoto"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                _imagePickerViewController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

                [self presentViewController:_imagePickerViewController animated:YES completion:nil];
            }
        } break;
        default:
            break;
    }
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"warning" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark    - 上传base64图片数据
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (!image) {
        //  获取到拍到的image
        image = info[UIImagePickerControllerMediaType];
    }
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    NSData *data;
    NSLog(@"%@", mediaType);
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //图片压缩，因为原图都是很大的，不必要传原图
//        UIImage *scaleImage = [self scaleImage:originImage toScale:0.3];
        
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        if (UIImagePNGRepresentation(originImage) == nil) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(originImage, 1);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(originImage);
        }
        
        //将二进制数据生成UIImage
        UIImage *image = [UIImage imageWithData:data scale:0.3];
//        UIImage *image = [UIImage imageWithData:data];
        NSLog(@"所选图片的: width: %f, height: %f", image.size.width, image.size.height);
    
        //  异步上传数据
        dispatch_queue_t queue = dispatch_queue_create("upload image", NULL);
        dispatch_async(queue, ^{
            //  base64的图片数据
            NSString *imageStr = [Photo image2String:image];
            NSDictionary *dic = @{@"Bin":imageStr,
                                  @"Type":_type,
                                  @"FileType":@"jpg",
                                  @"FileName":@"1.jpg",
                                  @"UserID":[UserInformation userinforSingleton].usermodel.UserID};
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *tempStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            [NetWorkingTool postNetWorkig:[NSString stringWithFormat:@"%@UploadImage.aspx", COMMONURL] bodyStr:tempStr block:^(id result) {
                NSDictionary *dictor = result;
                NSString *jsStr = [_wv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"FormAndriodIOSPhoto('%@', '%@', '%@');", dictor[@"List"][@"FileThumbPath"], dictor[@"List"][@"ImageID"], dictor[@"List"][@"FilePath"]]];
                NSLog(@"jsStr: %@", jsStr);
                NSLog(@"上传图片完成!");
            }];
            
        });
        
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"selectPhoto"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];

    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"selectPhoto"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark    - 多参数方法
+ (void)functionName:(NSObject *)string,...NS_REQUIRES_NIL_TERMINATION {
    va_list args;
    va_start(args, string);
    if(string) {
        NSString *otherString;
        while((otherString = va_arg(args, NSString *))) {
            NSLog(@"hahaha%@", otherString);
        }
    }
}

@end
