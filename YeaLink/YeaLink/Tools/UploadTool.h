//
//  UploadTool.h
//  YeaLink
//
//  Created by 李根 on 16/5/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadTool : NSObject

- (void)uploadImageWithImage:(UIImage *)image;

- (void)uploadDataWithData:(NSData *)data;

@end
