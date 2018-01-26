//
//  YNFullWidthViewController.m
//  YNSelfSizingCollectionViewDemo
//
//  Created by wangya on 2018/1/26.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import "YNFullWidthViewController.h"
#import "YNSelfSizingCollectionView.h"
#import "YNDynamicHeightTextCollectionViewCell.h"

@interface YNFullWidthViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation YNFullWidthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.estimatedItemSize = CGSizeMake(self.view.bounds.size.width, 70);
    
    YNSelfSizingCollectionView *collectionView = [[YNSelfSizingCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [collectionView registerClass:YNDynamicHeightTextCollectionViewCell.class forCellWithReuseIdentifier:[YNDynamicHeightTextCollectionViewCell description]];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YNDynamicHeightTextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YNDynamicHeightTextCollectionViewCell description] forIndexPath:indexPath];
    cell.label.text = ({
        NSMutableString *string = [NSMutableString string];
        for (int i=0; i<arc4random() % 300; i++) {
            [string appendFormat:@"%@",@(i)];
        }
        string;
    });
    cell.backgroundColor = ({
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        color;
    });
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(collectionView.bounds.size.width, 60);
//}

@end
