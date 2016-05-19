//
//  ServiceView.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "ServiceView.h"
#import "HomepageCell.h"
#import "HomepageCollectionFlowLayout.h"
#import "ServiceModel.h"

@interface ServiceView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation ServiceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createView {
    HomepageCollectionFlowLayout *flowlayout = [[HomepageCollectionFlowLayout alloc] init];
    
    flowlayout.itemSize = CGSizeMake(WIDTH / 4, 80 * HEI);
    flowlayout.sectionInset = UIEdgeInsetsZero;
    flowlayout.minimumInteritemSpacing = 0;
    flowlayout.minimumLineSpacing = 0;
    
    self.collectionview = [[QJLBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowlayout];
    [self addSubview:self.collectionview];
    self.collectionview.backgroundColor = [UIColor whiteColor];
    self.collectionview.scrollEnabled = NO;
    [self.collectionview registerClass:[HomepageCell class] forCellWithReuseIdentifier:@"reuse"];
    
    self.collectionview.dataSource = self;
    self.collectionview.delegate = self;
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tempArr.count - 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomepageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    
    ServiceModel *model = self.tempArr[indexPath.row + 6];
    NSString *tempStr = [model.ServiceLogo substringFromIndex:2];
    tempStr = [NSString stringWithFormat:@"http://qianjiale.doggadatachina.com%@", tempStr];
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:tempStr] placeholderImage:[UIImage imageNamed:@"placeholders"]];
    cell.label.text = model.SeviceName;

    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%lu", indexPath.row);
    
    ServiceModel *model = self.tempArr[indexPath.row + 6];
    if (model.SeviceAddress.length != 0) {
        self.jumpView();
        NSString *str = [NSString stringWithFormat:@"http://%@", model.SeviceAddress];
        [UserInformation userinforSingleton].strURL = str;
        
//        //  要先跳转, 再发通知, 才好使
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"nextUrl" object:nil userInfo:@{@"url":str}];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"当前服务未开通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 4 == 0) {
        return CGSizeMake(WIDTH - WIDTH / 4 * 3, 80 * HEI);
    }
    else {
        return CGSizeMake(WIDTH / 4, 80 * HEI);
    }
}


@end
