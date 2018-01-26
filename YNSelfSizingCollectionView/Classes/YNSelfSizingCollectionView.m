//
//  YNSelfSizingCollectionView.m
//  YNSelfSizingCollectionView
//
//  Created by wangya on 2018/1/26.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import "YNSelfSizingCollectionView.h"

@interface YNSelfSizingCollectionView()
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath*, NSValue*> *sizeCache;
@property (nonatomic, strong) NSMutableDictionary<NSString*, UICollectionViewCell*> *templeCells;
@end

@implementation YNSelfSizingCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    NSAssert(layout && [layout isKindOfClass:UICollectionViewFlowLayout.class], @"layout invalid");
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.sizeCache = [NSMutableDictionary<NSIndexPath*, NSValue*> dictionary];
        self.templeCells = [NSMutableDictionary<NSString*, UICollectionViewCell*> dictionary];
    }
    return self;
}

#pragma mark - overwrite

-(void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier{
    [super registerNib:nib forCellWithReuseIdentifier:identifier];
    id cell = [[nib instantiateWithOwner:nil options:nil] lastObject];
    NSAssert(cell, @"cell is nil");
    [self.templeCells setObject:cell forKey:identifier];
}

-(void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier{
    [super registerClass:cellClass forCellWithReuseIdentifier:identifier];
    UICollectionViewScrollDirection scrollDirection = ((UICollectionViewFlowLayout*)self.collectionViewLayout).scrollDirection;
    CGRect frame;
    if (scrollDirection == UICollectionViewScrollDirectionVertical) {
        frame = CGRectMake(0, 0, self.bounds.size.width, 0);
    }else{
        frame = CGRectMake(0, 0, 0, self.bounds.size.height);
    }
    id cell = [[cellClass alloc] initWithFrame:frame];
    NSAssert(cell, @"cell is nil");
    [self.templeCells setObject:cell forKey:identifier];
}

-(void)reloadData{
    [super reloadData];
    [self invalidateCache];
}



#pragma mark - public

- (CGSize)sizeForCellWithIdentifier:(NSString *)identifier
                          indexPath:(NSIndexPath *)indexPath
                      configuration:(void (^)(__kindof UICollectionViewCell *))configuration{
    if ([self.sizeCache.allKeys containsObject:indexPath]) {
        return [[self.sizeCache objectForKey:indexPath] CGSizeValue];
    }
    
    // has no size chche
    UICollectionViewCell *cell = [self.templeCells objectForKey:identifier];
    NSAssert(cell, @"cell is nil");
    configuration(cell);
    CGSize size = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSValue *sizeValue = [NSValue valueWithCGSize:size];
    [self.sizeCache setObject:sizeValue forKey:indexPath];
    return size;
}

-(void)invalidateCache{
    [[self sizeCache] removeAllObjects];
}

@end
