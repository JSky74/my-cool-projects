//
//  ShakeLayout.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-05-07.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "ShakeLayout.h"
#import "NoteCell.h"

@implementation ShakeLayout
@synthesize shake = _shake;
-(id) init
{
    self = [super init];
    if (self) {
        [self setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [self setSectionInset:UIEdgeInsetsMake(50, 30, 50, 30)];
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


- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];    
    if (self.shake) {
        [self applyTransformToLayoutAttributes:attributes];
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
//        if ([[self.collectionView cellForItemAtIndexPath:cellAttributes.indexPath] isHighlighted]) {
//            [self enlargeCell:cellAttributes];
//        }
        
    }
 return allAttributesInRect;
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
