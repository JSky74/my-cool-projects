//
//  ShakeLayout.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-05-07.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "ShakeLayout.h"
#import "NoteCell.h"

@interface ShakeLayout()
@property int indexOfCellToHide;
@end


@implementation ShakeLayout

@synthesize shake = _shake;
-(id) init
{
    self = [super init];
    if (self) {
        [self setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    }
    return self;
}

-(BOOL)shake
{
    if (!_shake) _shake = NO;
    return _shake;
}
-(void)setShake:(BOOL)shake
{
    _shake = shake;
}

-(void)setLayoutShouldHideCell:(NSNumber *)layoutShouldHideCell
{
    _layoutShouldHideCell = layoutShouldHideCell;
    [self invalidateLayout];
}

-(void)setIndexPathOfMovingCell:(NSIndexPath *)indexPathOfMovingCell
{
    _indexPathOfMovingCell = indexPathOfMovingCell;
    [self invalidateLayout];
}

- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];    
    if (self.shake) {
        [self applyTransformToLayoutAttributes:attributes];
    }
    if ([indexPath isEqual:self.indexPathOfMovingCell])
        [attributes setAlpha:0.1];
    if (self.layoutShouldHideCell) {
       
        if ([[NSNumber numberWithInt:indexPath.item] isEqualToNumber:self.layoutShouldHideCell]) {
        [attributes setAlpha:0.0];
        }
    }
       
    return attributes;
    
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
  NSArray* allAttributesInRect = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *cellAttributes in allAttributesInRect) {
        
        if (self.shake) {
            [self applyTransformToLayoutAttributes:cellAttributes];
        }
        if ([cellAttributes.indexPath isEqual:self.indexPathOfMovingCell])
            [cellAttributes setAlpha:0.1];
        if (self.layoutShouldHideCell){
            
            if ([[NSNumber numberWithInt:cellAttributes.indexPath.item]
                 isEqualToNumber:self.layoutShouldHideCell]) {
               [cellAttributes setAlpha:0.0];
            }
            
            }
        }
 return allAttributesInRect;
}



- (UICollectionViewLayoutAttributes
   *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes* attributes = [self
                                                    layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    //CGSize size = [self collectionView].frame.size;
    //attributes.center = CGPointMake(size.width / 2.0, size.height / 2.0);
    return attributes;
}



-(void)setTransform3D:(CATransform3D)transform
{
    _transform3D = transform;
    [self invalidateLayout];
}


-(void) applyTransformToLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    if (self.shake) {
        [layoutAttributes setTransform3D:self.transform3D];} else
    {
        static dispatch_once_t *once;
        dispatch_once (once, ^{ _originalTransform = layoutAttributes.transform3D;});
    
        [layoutAttributes setTransform3D:self.originalTransform];
    }
 
}

@end
