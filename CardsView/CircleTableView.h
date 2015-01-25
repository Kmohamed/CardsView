//
//  CircleTableView.h
//  CircleTableView
//
//  Created by khaled El Morabeaa on 11/3/14.
//  Copyright (c) 2014 Ibtikar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "circleCard.h"
#import "CardData.h"

@protocol CircleTableDelegate <NSObject>
@required
-(void)cardDidSelectAtIndex:(int)Index;
-(CardData*)cardForRowAtIndex:(int)index;
-(int)noOfCardOfCircleTableView;
-(CGPoint)centerOfCircleTableView;
@optional
-(void)cardDidUnSelectAtIndex:(int)Index;


@end

@interface CircleTableView : UIView

@property (nonatomic,strong) id<CircleTableDelegate> delegate;
@property (nonatomic)  CGFloat cornerRaduis;
@property (nonatomic) int NoOfCards;
@property (nonatomic) CGFloat start_Angle;
@property (nonatomic) CGFloat offSet_Angle;
@property (nonatomic) CGFloat large_Raduis;
@property (nonatomic) CGFloat small_Raduis;
@property (nonatomic) CGFloat remaining_distance;
@property (nonatomic,strong) UIColor *original_color;
@property (nonatomic,strong) UIColor *selected_color;
@property (nonatomic) BOOL disableRotating;
@property (nonatomic) NSMutableArray *step_Angles;
@property (nonatomic) BOOL AllowMultipleSelection;

-(void)updateValues;
-(void)expanCards;
-(void)reloadDataWithAnimation:(BOOL)isAnimated;
-(void)selectCardAtIndex:(int)index andSelection:(BOOL)isSelected;
@end
