//
//  testScene.m
//  testBox2d
//
//  Created by JiangHuifu on 14-5-28.
//  Copyright (c) 2014年 veger. All rights reserved.
//

#import "testScene.h"
#import "HelloLayer.h"
@interface testScene()
@property(nonatomic,retain) HelloLayer* lay;
@end
@implementation testScene
+(CCScene *)scene{
    return [[testScene alloc] init];
}
-(id)init{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        _lay = [[HelloLayer alloc] init];
        [self addChild:_lay];
    }
    return self;
}
-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    [_lay touchBegan:touch withEvent:event];
}
@end
