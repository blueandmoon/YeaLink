//
//  SIPLogin.m
//  YeaLink
//
//  Created by 李根 on 16/5/9.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "SIPLogin.h"
#import "WebUserAPI.h"
#import "WebKeyCaseAPI.h"
#import "WebKeyManager.h"

#import "SIPPhoneHomeViewController.h"

static NSString* const loginServerAddress = @"120.25.212.198:9700";
static NSString* const serviceAddress = @"120.25.212.198:21664";

static NSString* const kUsernameStoreIdentifier = @"username";
static NSString* const kDeveloerCodeStoreIdentifier = @"developerCode";



@implementation SIPLogin

+ (void)loginSIP {
    [[SipCoreManager sharedManager] removeAllAccounts];
    
#pragma mark    - 把开发者账号存到本地了
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    NSString* username = [userDef objectForKey:kUsernameStoreIdentifier];
    NSString* developerCode = [userDef objectForKey:kDeveloerCodeStoreIdentifier];;
    if (username == nil) {
        username = @"testxr3";
        //  A32F265D-6C46-469E-A1DC-74E5E67A523C
        developerCode = @"A32F265D-6C46-469E-A1DC-74E5E67A523C";
        
        //save default value
        [userDef setObject:username forKey:kUsernameStoreIdentifier];
        [userDef setObject:developerCode forKey:kDeveloerCodeStoreIdentifier];
        [userDef synchronize];
    }
    
    WebUserAPI* wuApi = [[WebUserAPI alloc] initWithLoginSeverAddress:loginServerAddress andServiceAddr:serviceAddress developerCode:developerCode];
    
    [wuApi loginWithName:username completionBlock:^(NSError* error, LoginResponse* response) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            //parser from response.scope
            NSString* tenantCode = @"T320508000000001";
            [[WebKeyManager sharedManager] getWebKeys:serviceAddress
                                             username:username
                                           tenantCode:tenantCode
                                            tokenType:response.tokenType
                                          accessToken:response.accessToken
                                      completionBlock:^(NSError* error) {
                                          if (error) {
                                              NSLog(@"%@", error);
                                          } else {
                                              //                                              NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
                                              
                                              //                                              //save default value
                                              //                                              [userDef setObject:_acctTextField.text forKey:kUsernameStoreIdentifier];
                                              //                                              [userDef setObject:_developerCodeTextField.text forKey:kDeveloerCodeStoreIdentifier];
                                              //                                              [userDef synchronize];
                                              //    这行有什么用?
                                              //                                              [self dismissViewControllerAnimated:YES completion:nil];
                                          }
                                          //                                          NSLog(@"-----response.tokenType: %@, -----response.accessToken: %@", response.tokenType, response.accessToken);
                                      }];
            
            
        }
    }];

    
    
}








@end
