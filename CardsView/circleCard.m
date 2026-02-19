//
//  circleCard.m
//  CircleTableView
//
//  Created by khaled el morabea on 11/5/14.
//  Copyright (c) 2014 Ibtikar. All rights reserved.
//

#import "circleCard.h"

@implementation circleCard


-(id)initWithStartAngle:(CGFloat)startAngle andWidth:(CGFloat)width andLargeRaduis:(CGFloat)largeRaduis andSmallRaduis:(CGFloat)smallRaduis andCardName:(NSString*)cardName andCardIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        self.width_Angle = width;
        self.large_Raduis = largeRaduis;
        self.small_Raduis=smallRaduis;
        self.cardName=cardName;
        self.start_angle=startAngle;
        self.cardIndex=index;
    }
    return self;
}

- (CGFloat)centerAngle {
    return self.start_angle + self.width_Angle / 2.0;
}

- (CGFloat)endAngle {
    return self.start_angle + self.width_Angle;
}

- (BOOL)containsAngle:(CGFloat)angle {
    return angle >= self.start_angle && angle <= [self endAngle];
}

@end
