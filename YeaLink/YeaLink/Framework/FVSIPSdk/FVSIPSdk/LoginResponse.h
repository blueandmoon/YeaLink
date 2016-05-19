//
//  LoginResponse.h
//  FVSIPSdk
//
//  Created by  Tim Lei on 1/25/16.
//  Copyright © 2016 FreeView. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginResponse : NSObject
@property (nonatomic, copy) NSString*   accessToken; // 访问token
@property (nonatomic, copy) NSString*   tokenType; // token 类型
//@property (nonatomic, copy) NSString*   scope; // 用户所属的租户系统以及其身份  "T440306000000001:Lessee T440309000000001:Lessee,Owner"

+ (instancetype)loginResponseWithJson:(NSDictionary*) jsonData;
@end
