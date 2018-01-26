//
//  YNSelfSizingCollectionView.m
//  YNSelfSizingCollectionView
//
//  Created by wangya on 2018/1/26.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import "YNSelfSizingCollectionView.h"

typedef NS_ENUM(NSUInteger, YNDynamicSizeCaculateType) {
    YNDynamicSizeCaculateTypeSize = 0,
    YNDynamicSizeCaculateTypeHeight,
    YNDynamicSizeCaculateTypeWidth
};

@interface YNSelfSizingCollectionView()
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath*, NSValue*> *sizeCache;
@property (nonatomic, strong) NSMutableDictionary<NSString*, UICollectionViewCell*> *templeCells;
@end

@implementation YNSelfSizingCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
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
    id cell = [[cellClass alloc] initWithFrame:CGRectZero];
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
                      configuration:(void (^)(__kindof UICollectionViewCell *))configuration {
    return [self sizeForCellWithIdentifier:identifier
                                 indexPath:indexPath
                                fixedValue:0
                              caculateType:YNDynamicSizeCaculateTypeSize
                             configuration:configuration];
}

- (CGSize)sizeForCellWithIdentifier:(NSString *)identifier
                          indexPath:(NSIndexPath *)indexPath
                         fixedWidth:(CGFloat)fixedWidth
                      configuration:(void (^)(__kindof UICollectionViewCell *))configuration {
    return [self sizeForCellWithIdentifier:identifier
                                 indexPath:indexPath
                                fixedValue:fixedWidth
                              caculateType:YNDynamicSizeCaculateTypeWidth
                             configuration:configuration];
}

- (CGSize)sizeForCellWithIdentifier:(NSString *)identifier
                          indexPath:(NSIndexPath *)indexPath
                        fixedHeight:(CGFloat)fixedHeight
                      configuration:(void (^)(__kindof UICollectionViewCell *))configuration {
    return [self sizeForCellWithIdentifier:identifier
                                 indexPath:indexPath
                                fixedValue:fixedHeight
                              caculateType:YNDynamicSizeCaculateTypeHeight
                             configuration:configuration];
}

-(void)invalidateCache{
    [[self sizeCache] removeAllObjects];
}

#pragma mark - private

- (CGSize)sizeForCellWithIdentifier:(NSString *)identifier
                          indexPath:(NSIndexPath *)indexPath
                         fixedValue:(CGFloat)fixedValue
                       caculateType:(YNDynamicSizeCaculateType)caculateType
                      configuration:(void (^)(__kindof UICollectionViewCell *))configuration {
    BOOL hasCache = [self hasCacheAtIndexPath:indexPath];
    if (hasCache) {
        return [[self sizeCacheAtIndexPath:indexPath] CGSizeValue];
    }
    
    // has no size chche
    UICollectionViewCell *cell = [self templeCaculateCellWithIdentifier:identifier];
    configuration(cell);
    CGSize size = CGSizeMake(fixedValue, fixedValue);
    if (caculateType != YNDynamicSizeCaculateTypeSize) {
        NSLayoutAttribute attribute = caculateType == YNDynamicSizeCaculateTypeWidth
        ? NSLayoutAttributeWidth
        : NSLayoutAttributeHeight;
        NSLayoutConstraint *tempConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView
                                                                          attribute:attribute
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1
                                                                           constant:fixedValue];
        [cell.contentView addConstraint:tempConstraint];
        size = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        [cell.contentView removeConstraint:tempConstraint];
    } else {
        size = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    }
    
    NSValue *sizeValue = [NSValue valueWithCGSize:size];
    [self.sizeCache setObject:sizeValue forKey:indexPath];
    return size;
}

- (BOOL)hasCacheAtIndexPath:(NSIndexPath *)indexPath {
    return [self.sizeCache.allKeys containsObject:indexPath];
}

- (NSValue *)sizeCacheAtIndexPath:(NSIndexPath *)indexPath {
    return [self.sizeCache objectForKey:indexPath];
}

- (id)templeCaculateCellWithIdentifier:(NSString *)identifier {
    UICollectionViewCell *cell = [self.templeCells objectForKey:identifier];
    NSAssert(cell, @"cell is nil");
    return cell;
}

@end
