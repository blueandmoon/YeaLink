//
//  HomepageView.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "HomepageView.h"
#import "HomepageCell.h"
#import "HomepageCollectionFlowLayout.h"
#import "ServiceModel.h"

@interface HomepageView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation HomepageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createView {
    
    
    if (_tempArr.count != 0) {
    }
        HomepageCollectionFlowLayout *flowLayout = [[HomepageCollectionFlowLayout alloc] init];
        
        flowLayout.itemSize = CGSizeMake(WIDTH / 3, 80 * HEI);
        
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0); // 四周边距
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        
        self.collectionView = [[QJLBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
        [self addSubview:self.collectionView];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.scrollEnabled = NO;
        [self.collectionView registerClass:[HomepageCell class] forCellWithReuseIdentifier:@"reuse"];
        
        //  签代理
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        
    
    
    
}

- (void)setTempArr:(NSMutableArray *)tempArr {
    if (_tempArr != tempArr) {
        _tempArr = tempArr;
//        [self createView];
        [self.collectionView reloadData];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([[UserInformation userinforSingleton].usermodel.APPUserRole isEqualToString:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前服务只有业主可用" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.delegate = self;
        [alert show];
    } else {
        ServiceModel *model = self.tempArr[indexPath.row];
        if (model.SeviceAddress.length != 0) {
            if ([model.GUID isEqualToString:@"24"]) {
                self.pushViewToAccessControl(); //  跳转到门禁开门页面
            } else {
                NSString *str = [NSString stringWithFormat:@"http://%@", model.SeviceAddress];
                NSLog(@"-----%@", str);
                [UserInformation userinforSingleton].strURL = str;
                //        //  要先跳转, 再发通知, 才好使
                self.pushview();
                //        [[NSNotificationCenter defaultCenter] postNotificationName:@"nextUrl" object:nil userInfo:@{@"url":str}];
//                NSLog(@"[UserInformation userinforSingleton].strURL: %@", [UserInformation userinforSingleton].strURL);                
            }
            
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"当前服务未开通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    if (buttonIndex == 1) {
        self.pushBindingView();
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//        NSLog(@"%@", self.arr);
    if (_tempArr.count >= 6) {
        return 6;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:
(NSIndexPath *)indexPath {
    HomepageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    
    ServiceModel *model = self.tempArr[indexPath.row];
    NSString *tempStr = [model.ServiceLogo substringFromIndex:2];
    
    NSString *str = [NSString stringWithFormat:@"http://qianjiale.doggadatachina.com%@", tempStr];
//    NSLog(@"___%@", str);
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholders"]];
    cell.label.text = model.SeviceName;
 
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}


@end
