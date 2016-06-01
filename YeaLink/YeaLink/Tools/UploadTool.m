//
//  UploadTool.m
//  YeaLink
//
//  Created by 李根 on 16/5/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "UploadTool.h"

@interface UploadTool ()<NSURLSessionTaskDelegate, NSURLSessionDelegate>
@property(nonatomic, strong)NSURLSession *session;

@end

@implementation UploadTool

- (void)uploadImageWithImage:(UIImage *)image {
    
    NSLog(@"上传图片");
//    {"Bin":"","Type":"U","FileType":"jpg","FileName":"1.jpg","UserID":"13773240761"}
//http://qianjiale.doggadatachina.com/UploadImage.ashx
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    if (image == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error" message:@"Select or take photo first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    //  http://qianjiale.doggadatachina.com/UploadImage.ashx
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@UploadImage.ashx", COMMONURL]]];
    
    [request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:20];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    NSURLSessionUploadTask *uploadTask = [self.session uploadTaskWithRequest:request fromData:imageData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSString *thmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"上传成功, NSURLResponse: %@\nerror: %@", response, error);
        
    }];
    [uploadTask resume];
    
    
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"error.description: %@", error.description);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    NSLog(@"%f", totalBytesSent / (float)totalBytesExpectedToSend);
}

- (void)uploadDataWithData:(NSData *)data {
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest     requestWithURL:[NSURL URLWithString:@"接口地址"]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:20];
//    NSDictionary * dataDic = @{@"key":@"value"};//把要上传的数据存到字典中
//    NSData * data = [NSJSONSerialization dataWithJSONObject:dataDic
//                                                    options:NSJSONWritingPrettyPrinted
//                                                      error:nil];
    NSURLSessionUploadTask * uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            //NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        }else{
            NSLog(@"上传失败");
        }
    }];
    [uploadTask resume];
}



@end
