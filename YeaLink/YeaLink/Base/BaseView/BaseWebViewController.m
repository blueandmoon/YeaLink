//
//  BaseWebViewController.m
//  YeaLink
//
//  Created by 李根 on 16/5/6.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "BaseWebViewController.h"
#import "CustomURLCache.h"  //  缓存
#import <JavaScriptCore/JavaScriptCore.h>
#import "UserModel.h"

#import "WebViewJavascriptBridge.h"

@interface BaseWebViewController ()<UIWebViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(nonatomic, strong)WebViewJavascriptBridge *bridge;
@property(nonatomic, strong)void(^exchangeValue)(NSString *); //  传给js的值

@end

@implementation BaseWebViewController
{
//    GifView *_showGifView;
    NSString *_type;
    UIImagePickerController *_imagePickerViewController;
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
//    //  缓存webview
//    CustomURLCache *urlCache = [[CustomURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024 diskCapacity:200 * 1024 * 1024 diskPath:nil cacheTime:0];
//    [CustomURLCache setSharedURLCache:urlCache];
    
    _wv = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.view addSubview:_wv];
    _wv.delegate = self;
    
    _wv.opaque = NO;
    _wv.backgroundColor = [UIColor clearColor];
    
    _imagePickerViewController = [[UIImagePickerController alloc] init];
    _imagePickerViewController.allowsEditing = YES;
    _imagePickerViewController.delegate = self;
    
    
    
}

#pragma mark    - webview
- (void)getHtmlWithstr:(NSString *)str {
    UserModel *model = [[UserModel alloc] init];
    model = [UserInformation userinforSingleton].usermodel;
    NSString *tempStr;
    if ([str hasPrefix:@"http:"]) {
        if ([str isEqualToString:@"http://www.go2family.com"]) {
            tempStr = str;
        } else {
            tempStr = [NSString stringWithFormat:@"%@?UserID=%@&CityID=%@&APPUserRole=%@", str, model.UserID, model.CityID, model.APPUserRole];
        }
    } else {
        tempStr = [NSString stringWithFormat:@"%@%@?UserID=%@&CityID=%@&APPUserRole=%@", COMMONURL, str, model.UserID,model.CityID, model.APPUserRole];
        NSLog(@"tempStr: %@", tempStr);
    }
    NSLog(@"当前加载链接: %@", tempStr);
    [_wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tempStr]]];
    
    [GifView showGifViewWithSuperview:self.view];
    
}

//  传来的字符串链接包含公共部分
- (void)getHtmlWithTotalStr:(NSString *)totalStr {
    UserModel *model = [[UserModel alloc] init];
    model = [UserInformation userinforSingleton].usermodel;
    NSString *tempStr = [NSString stringWithFormat:@"%@?UserID=%@&CityID=%@", totalStr, model.UserID, model.CityID];
    NSLog(@"tempStr: %@", tempStr);
    [_wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tempStr]]];
}

//  传来的url字符串只包含指定部分
- (void)getHtmlWithUrl:(NSString *)url {
    [_wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark    - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.view bringSubviewToFront:_wv];
    
    //  当点击进入次级页面是, 等webview页面加载完毕后再重新载入JSContext, 这样获取的JSContext才是当前最新的, 才会调用block方法, 断点, 或者把这段代码写成一个方法调用会卡死
    JSContext *context = [_wv  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"jakilllog"] = ^() {
        //        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSString *str = [NSString stringWithFormat:@"%@", jsVal];
//            NSLog(@"str: %@", str);
//            NSLog(@"%@", jsVal);
            if ([str isEqualToString:@"Change"]) {
                NSLog(@"小区有无");
            } else if ([str isEqualToString:@"back"]) {
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
        //        JSValue *this = [JSContext currentThis];
        //        NSLog(@"this: %@",this);
        //        NSLog(@"-------End Log-------");
        
    };
    
    _exchangeValue = ^(NSString *tempStr) {
        NSString *jsStr = [_wv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"FormAndriodIOSPhoto('%@');", tempStr]];
        NSLog(@"jsStr: %@", jsStr);
    };
    
    //  h5页面的返回
    __weak BaseWebViewController *blockSelf = self;
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

     
    
//    [self.hud hide:YES];
//    [self.hud setHidden:YES];
    
    //  获取当前页面的标题
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    _takeStr(title);
//    NSLog(@"当前页面标题title:%@", title);
    
    //  获取当前页面的链接
    NSString *currentURL = webView.request.URL.absoluteString;
    NSLog(@"currentURL---url-%@--", currentURL);
    //  把链接转换成小写再判断
    NSString *lowerURL = [currentURL lowercaseString];
    BOOL show = [lowerURL rangeOfString:@"/show/"].location != NSNotFound;
    BOOL find = [lowerURL rangeOfString:@"/find/"].location != NSNotFound;
    BOOL news = [lowerURL rangeOfString:@"/message/"].location != NSNotFound;
    
    if (show || find) {
        self.changeShowLeftButton(currentURL);
    }
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
//    [self.hud hide:YES];
//    [self.hud setHidden:YES];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
//    self.hud = [BaseProgressHUD showHUDAddedTo:self.view animated:YES];
//    [self.hud show:YES];
//    self.hud.labelText = @"loading...";
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.hud hide:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark    - 拍照, 选择图片
- (void)takePhoto {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中选择", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    NSLog(@"%d", buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                _imagePickerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:_imagePickerViewController animated:YES completion:^{
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"selectPhoto"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }];
//                [self presentViewController:_imagePickerViewController animated:YES completion:NULL];
            } else {
                [self showAlertWithMessage:@"Camera is not available in this device or simulator"];
            }
        } break;
        case 1:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                _imagePickerViewController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:_imagePickerViewController animated:YES completion:^{
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"selectPhoto"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }];
//                [self presentViewController:_imagePickerViewController animated:YES completion:NULL];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        //  获取到拍到的image
        image = info[UIImagePickerControllerOriginalImage];
    }
    
//    if (image != nil) {
//        //  获取到图片的名字
//        __block NSString *imageFileName;
//        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
//        ALAssetsLibrary
//    }
    
    //  base64的图片数据
    NSString *imageStr = [Photo image2String:image];
    NSDictionary *dic = @{@"Bin":imageStr,
                          @"Type":_type,
                          @"FileType":@"jpg",
                          @"FileName":@"1.jpg",
                          @"UserID":[UserInformation userinforSingleton].usermodel.UserID};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *tempStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
//    [NetWorkingTool postNetWorkigDoNothing:@"http://qianjiale.doggadatachina.com/UploadImage.aspx" bodyStr:tempStr block:^(id result) {
//        _exchangeValue(result);
////        NSString *jsStr = [_wv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"FormAndriodIOSPhoto('%@');", result]];
////        NSLog(@"jsStr: %@", jsStr);
//    }];
    
    //  ~~~~~~~~~~~~~~测试~~~~~~~~~~~~    http://qianjiale.doggadatachina.com/UploadImage.aspx
    [NetWorkingTool postNetWorkig:[NSString stringWithFormat:@"%@UploadImage.aspx", COMMONURL] bodyStr:tempStr block:^(id result) {
//        NSLog(@"%@", result);
        NSDictionary *dictor = result;
//        NSLog(@"dictor.list: %@", dictor[@"List"]);
        NSLog(@"_________________%@", dictor[@"List"][@"ImageID"]);
        NSString *jsStr = [_wv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"FormAndriodIOSPhoto('%@', '%@', '%@');", dictor[@"List"][@"FileThumbPath"], dictor[@"List"][@"ImageID"], dictor[@"List"][@"FilePath"]]];
        NSLog(@"jsStr: %@", jsStr);
    }];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"selectPhoto"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
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

@end
