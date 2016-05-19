//
//  AppTheme.m
//  YeaLink
//
//  Created by 李根 on 16/4/25.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "AppTheme.h"

@implementation AppTheme
+ (NSDictionary *)navigationTitleAttributes {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = NavigationBar_Title_Shadow_Color;
    shadow.shadowOffset = CGSizeMake(0, 1);
    return [NSDictionary dictionaryWithObjectsAndKeys:NavigationBar_Foreground_Color, NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:App_Default_Font_Name size:NavigationBar_Title_Font_Size], NSFontAttributeName, nil];
    
    
}



@end
