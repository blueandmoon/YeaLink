//
//  AppTheme.h
//  YeaLink
//
//  Created by 李根 on 16/4/25.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LINPHONE_MAIN_COLOR       [UIColor colorWithRed:207.0f/255.0f green:76.0f/255.0f blue:41.0f/255.0f alpha:1.0f]
#define LINPHONE_SETTINGS_BG_IOS7 [UIColor colorWithRed:164/255. green:175/255. blue:183/255. alpha:1.0]//[UIColor colorWithWhite:0.88 alpha:1.0]
#define LINPHONE_TABLE_CELL_BACKGROUND_COLOR [UIColor colorWithRed:207.0f/255.0f green:76.0f/255.0f blue:41.0f/255.0f alpha:1.0f]

@interface AppTheme : NSObject
+ (NSDictionary *)navigationTitleAttributes;

@end
