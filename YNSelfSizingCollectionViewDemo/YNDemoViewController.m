//
//  YNDemoViewController.m
//  YNSelfSizingCollectionViewDemo
//
//  Created by wangya on 2018/1/26.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import "YNDemoViewController.h"
#import "YNSelfSizingCollectionView.h"
#import "YNDemoFixedWidthCollectionViewCell.h"
#import "YNDemoFixedWidthAndHeightCollectionViewCell.h"
#import "YNDemoFixedHeightCollectionViewCell.h"
#import "YNDemoTitleCollectionReusableView.h"

@interface YNDemoViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray<NSDictionary*> *data;
@end

@implementation YNDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray<NSDictionary*> *data = [NSMutableArray<NSDictionary*> array];
    for (int i = 0; i < 3; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        switch (i) {
            case 0:{
                [dic setObject:@"fixed width and height" forKey:@"title"];
                break;
            }
            case 1:{
                [dic setObject:@"fixed width" forKey:@"title"];
                break;
            }
            case 2:{
                [dic setObject:@"fixed height" forKey:@"title"];
                break;
            }
            default:
                break;
        }
        NSMutableArray *insideData = [NSMutableArray array];
        for (int j = 0; j < 9; j++) {
            [insideData addObject:({
                NSMutableString *string = [NSMutableString string];
                for (int i=0; i<arc4random_uniform(30) + 1; i++) {
                    [string appendFormat:@"%@",@(i)];
                }
                string;
            })];
        }
        [dic setObject:insideData forKey:@"data"];
        [data addObject:dic];
    }
    self.data = data;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    YNSelfSizingCollectionView *collectionView = [[YNSelfSizingCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [collectionView registerClass:YNDemoTitleCollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[YNDemoTitleCollectionReusableView description]];
    [collectionView registerClass:YNDemoFixedWidthAndHeightCollectionViewCell.class forCellWithReuseIdentifier:[YNDemoFixedWidthAndHeightCollectionViewCell description]];
    [collectionView registerClass:YNDemoFixedWidthCollectionViewCell.class forCellWithReuseIdentifier:[YNDemoFixedWidthCollectionViewCell description]];
    [collectionView registerClass:YNDemoFixedHeightCollectionViewCell.class forCellWithReuseIdentifier:[YNDemoFixedHeightCollectionViewCell description]];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.data.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[[self.data objectAtIndex:section] objectForKey:@"data"] count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YNSelfSizingBaseCollectionViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:{
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YNDemoFixedWidthAndHeightCollectionViewCell description] forIndexPath:indexPath];
            ((YNDemoFixedWidthAndHeightCollectionViewCell*)cell).title = [[[self.data objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
            break;
        }
        case 1:{
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YNDemoFixedWidthCollectionViewCell description] forIndexPath:indexPath];
            ((YNDemoFixedWidthCollectionViewCell*)cell).title = [[[self.data objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
            break;
        }
        case 2:{
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YNDemoFixedHeightCollectionViewCell description] forIndexPath:indexPath];
            ((YNDemoFixedHeightCollectionViewCell*)cell).title = [[[self.data objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
            break;
        }
        default:
            break;
    }
    cell.backgroundColor = ({
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        color;
    });
    return cell;
}

- (CGSize)collectionView:(YNSelfSizingCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeZero;
    switch (indexPath.section) {
        case 0:{
            size = [collectionView sizeForCellWithIdentifier:[YNDemoFixedWidthAndHeightCollectionViewCell description] indexPath:indexPath configuration:^(YNDemoFixedWidthAndHeightCollectionViewCell *cell) {
                cell.title = [[[self.data objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
            }];
            break;
        }
        case 1:{
            size = [collectionView sizeForCellWithIdentifier:[YNDemoFixedWidthCollectionViewCell description] indexPath:indexPath configuration:^(YNDemoFixedWidthCollectionViewCell *cell) {
                cell.title = [[[self.data objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
            }];
            break;
        }
        case 2:{
            size = [collectionView sizeForCellWithIdentifier:[YNDemoFixedHeightCollectionViewCell description] indexPath:indexPath configuration:^(YNDemoFixedHeightCollectionViewCell *cell) {
                cell.title = [[[self.data objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
            }];
            break;
        }
        default:
            break;
    }
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        YNDemoTitleCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[YNDemoTitleCollectionReusableView description] forIndexPath:indexPath];
        headerView.title = [[self.data objectAtIndex:indexPath.section] objectForKey:@"title"];
        return headerView;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.bounds.size.width, 44);
}

@end
