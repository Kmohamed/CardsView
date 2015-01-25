//
//  CircleTableView.m
//  CircleTableView
//
//  Created by khaled El Morabeaa on 11/3/14.
//  Copyright (c) 2014 Ibtikar. All rights reserved.
//
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#import "CircleTableView.h"


@interface CircleTableView ()
{
    int totalAnimFrames;
    int currentFrame;
    BOOL isCollapsed;
    BOOL isCollapsing;
    int selectedIndex;

    circleCard *targetCard;
    
    CGFloat target_Angle;
    BOOL isRotating;
    BOOL isReloadingWithoutanimation;

    CGFloat selectedSmallRaduis;
    CGFloat selectedLargeRaduis;
    CGFloat bouzOffset;
    
    CGFloat target_Start_angle;
    CGFloat target_End_angle;
    CGFloat static_end_target_angle;
    CGFloat target_shadow;
}

@property (nonatomic,strong)  NSMutableArray *array_Of_Cards;
@property (nonatomic,strong)  NSMutableArray *array_Of_Starters;
@property (nonatomic,strong)  NSMutableArray *array_Of_Left_Cards;
@property (nonatomic,strong)  NSMutableArray *array_Of_right_Cards;
@property (nonatomic) CGFloat width_Angle;
@property (nonatomic) int no_Of_Cards;
@property (nonatomic) CGPoint CircleCenter;
@property (nonatomic,strong) NSMutableArray *data_cards;
@property (nonatomic) BOOL allowReloadWithAnimation;
@property (nonatomic) BOOL isCollapsedFromReload;

@end

@implementation CircleTableView

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        totalAnimFrames=8;
        currentFrame=10;
        bouzOffset=2;
       
    }
    return self;
}

-(void)updateValues
{
    if (currentFrame <= totalAnimFrames)
    {
        if (isCollapsed)
        {
            for (int i=0;i<_step_Angles.count;i++)
            {
                CGFloat floatNumber;
                NSNumber *floatValue=[_step_Angles objectAtIndex:i];
                
                if (i==targetCard.cardIndex)
                {
                    floatNumber=[((NSNumber*)[_array_Of_Starters objectAtIndex:i]) floatValue];
                }
                else
                {
                    if (((circleCard*)[_array_Of_Cards objectAtIndex:i]).isLeft)
                    {
                        floatNumber=Easing(currentFrame,target_Angle,(_width_Angle+_offSet_Angle)*(i-selectedIndex),totalAnimFrames);

                    }
                    else
                    {
                        floatNumber=Easing(currentFrame,target_Angle,-(_width_Angle+_offSet_Angle)*(selectedIndex-i),totalAnimFrames);

                    }
                }
                if (floatNumber==360)
                {
                    floatNumber=0.0f;
                }
                if (floatNumber>360)
                {
                    floatNumber-=360;
                }
                else if (floatNumber<0)
                {
                    floatNumber+=360;
                }

                floatValue=[NSNumber numberWithFloat:floatNumber];
                if (!_disableRotating)
                {
                    [_step_Angles replaceObjectAtIndex:i withObject:floatValue];
                }
            }
            if (!_disableRotating)
            {
                selectedSmallRaduis=Easing(currentFrame,(_small_Raduis-bouzOffset),bouzOffset,totalAnimFrames);
                selectedLargeRaduis=Easing(currentFrame,(_large_Raduis+bouzOffset),-bouzOffset,totalAnimFrames);
            }
           
            target_Start_angle=Easing(currentFrame,(target_Angle-bouzOffset),bouzOffset,totalAnimFrames);
            target_End_angle=Easing(currentFrame,(static_end_target_angle+bouzOffset),-bouzOffset,totalAnimFrames);
            target_shadow=Easing(currentFrame,16.0f,-15.0f,totalAnimFrames);

        }
        else
        {
            for (int i=0;i<_step_Angles.count;i++)
            {
                CGFloat floatNumber;
                NSNumber *floatValue=[_step_Angles objectAtIndex:i];
                if (i==targetCard.cardIndex)
                {
                    floatNumber=[((NSNumber*)[_array_Of_Starters objectAtIndex:i]) floatValue];
                }
                else
                {
                    if (((circleCard*)[_array_Of_Cards objectAtIndex:i]).isLeft)
                    {
                        floatNumber=Easing(currentFrame,[((NSNumber*)[_array_Of_Starters objectAtIndex:i]) floatValue],-(_width_Angle+_offSet_Angle)*(i-selectedIndex),totalAnimFrames);
                    }
                    else
                    {
                        floatNumber=Easing(currentFrame,[((NSNumber*)[_array_Of_Starters objectAtIndex:i]) floatValue],(_width_Angle+_offSet_Angle)*(selectedIndex-i),totalAnimFrames);

                    }
                }
                if (floatNumber==360)
                {
                    floatNumber=0.0f;
                }
                if (floatNumber>360)
                {
                    floatNumber-=360;
                }
                else if (floatNumber<0)
                {
                    floatNumber+=360;
                }

                floatValue=[NSNumber numberWithFloat:floatNumber];
                if (!_disableRotating)
                {
                    [_step_Angles replaceObjectAtIndex:i withObject:floatValue];

                }
                
            }
            
            
            if (!_disableRotating)
            {
                selectedSmallRaduis=Easing(currentFrame,_small_Raduis,-bouzOffset,totalAnimFrames);
                selectedLargeRaduis=Easing(currentFrame,_large_Raduis,bouzOffset,totalAnimFrames);

            }
            target_Start_angle=Easing(currentFrame,target_Angle,-bouzOffset,totalAnimFrames);
            target_End_angle=Easing(currentFrame,static_end_target_angle,bouzOffset,totalAnimFrames);
            target_shadow=Easing(currentFrame,1.0f,15.0f,totalAnimFrames);
        }

        if (target_Start_angle>360)
        {
            target_Start_angle-=360;
        }
        else if (target_Start_angle<0)
        {
            target_Start_angle+=360;
        }
        
        if (target_End_angle>360)
        {
            target_End_angle-=360;
        }
        else if (target_End_angle<0)
        {
            target_End_angle+=360;
        }
        
        if (currentFrame>=totalAnimFrames)
        {
            isRotating=NO;
            isCollapsed=!isCollapsed;
            isCollapsing=NO;
            if (_allowReloadWithAnimation&&_isCollapsedFromReload)
            {
                [self expanCards];
            }
            if (_allowReloadWithAnimation==NO) {
                if (isReloadingWithoutanimation) {
                   // isCollapsed=NO;
                    isReloadingWithoutanimation=NO;

                }
            }
        }

    }
    currentFrame++;
}


double absFloat(double value)
{
    if (value>0)
    {
        return value;
    }
    else
    {
      return  value=value*-1;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_large_Raduis==0)
    {
        _large_Raduis=140;
    }
    if (_small_Raduis==0)
    {
        _small_Raduis=50;
    }
    if (_offSet_Angle==0)
    {
        _offSet_Angle=10;
    }
    
    if (_original_color==nil)
    {
        _original_color=[UIColor lightGrayColor];
    }
    if (_selected_color==nil)
    {
        _original_color=[UIColor grayColor];

    }
    if (_remaining_distance==0)
    {
        _remaining_distance=150;
    }
    _no_Of_Cards=[self.delegate noOfCardOfCircleTableView];

    _data_cards=[[NSMutableArray alloc] init];
   // _array_Of_Selected_Cards=[[NSMutableArray alloc] init];

    for (int i=0; i<_no_Of_Cards; i++)
    {
        [_data_cards addObject:[self.delegate cardForRowAtIndex:i]];
    }
    _cornerRaduis=13.0;
    _width_Angle=((360-_remaining_distance)-(_offSet_Angle*(_no_Of_Cards-1)))/_no_Of_Cards;
    _CircleCenter=[self.delegate centerOfCircleTableView];
    _array_Of_Cards=[[NSMutableArray alloc] init];
    CGFloat rotating_Angle=_start_Angle;
    for ( int i=0; i<_no_Of_Cards; i++)
    {
        if (rotating_Angle>360)
        {
            rotating_Angle=rotating_Angle-360;
        }
        if (rotating_Angle==360)
        {
            rotating_Angle=0;
        }
        circleCard *card1=[[circleCard alloc] initWithStartAngle:rotating_Angle andWidth:_width_Angle andLargeRaduis:_large_Raduis andSmallRaduis:_small_Raduis andCardName:[NSString stringWithFormat:@"card %d",i] andCardIndex:i];
        rotating_Angle=rotating_Angle+card1.width_Angle+_offSet_Angle;
        [_array_Of_Cards addObject:card1];
        
    }
    _array_Of_Starters=[[NSMutableArray alloc] init];
    for (circleCard *card in _array_Of_Cards)
    {
        CGFloat tempValue=card.start_angle;
        [_array_Of_Starters addObject:[NSNumber numberWithFloat:tempValue]];
    }
    
    _step_Angles=[[NSMutableArray alloc] init];
    for (circleCard *card in _array_Of_Cards)
    {
        CGFloat tempValue=card.start_angle;
        [_step_Angles addObject:[NSNumber numberWithFloat:tempValue]];
    }

}
-(void)sortCardsArray
{
    NSMutableArray *newCardsArray=[[NSMutableArray alloc] init];
    
    for (circleCard *card in _array_Of_Cards)
    {
        [newCardsArray insertObject:card atIndex:card.cardIndex];
    }
    _array_Of_Cards=newCardsArray;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    for (circleCard *card in _array_Of_Cards)
    {
        if (targetCard)
        {
            if (card.cardIndex!=targetCard.cardIndex)
            {
                [self drawSlice:context andRect:rect andCard:card];
            }
        }
        else
        {
            [self drawSlice:context andRect:rect andCard:card];
        }
       
        
    }
    if (targetCard)
    {
        [self drawSlice:context andRect:rect andCard:targetCard];
    }
    
}

-(void)expanCards
{
    if (isCollapsed)
    {
        if (targetCard)
        {
            currentFrame=1;
            isRotating=YES;
            isCollapsing=YES;
            _isCollapsedFromReload=NO;
        }
    }
}

-(BOOL)checkIsCollapsed
{
    circleCard *firstCard=[_array_Of_Cards firstObject];
    for (circleCard *card in _array_Of_Cards ) {
    
        if (!(firstCard.start_angle==card.start_angle)) {
            return NO;
        }
        
    }
    
    return YES;
}

-(void)collaps
{
    targetCard=[_array_Of_Cards objectAtIndex:0];
    if (targetCard)
    {
        isRotating=YES;
        _isCollapsedFromReload=YES;
        currentFrame=1;
        selectedIndex=(int)targetCard.cardIndex;
        targetCard=[_array_Of_Cards objectAtIndex:selectedIndex];
        target_Angle=[((NSNumber*)[_array_Of_Starters objectAtIndex:targetCard.cardIndex]) floatValue];
        
        _step_Angles=[[NSMutableArray alloc] init];
        
        selectedSmallRaduis=targetCard.small_Raduis;
        selectedLargeRaduis=targetCard.large_Raduis;
        target_Start_angle=[((NSNumber*)[_array_Of_Starters objectAtIndex:targetCard.cardIndex]) floatValue];
        target_End_angle=target_Start_angle+_width_Angle;
        static_end_target_angle=target_End_angle;
        target_shadow=0.2;
        if (target_End_angle>360)
        {
            target_End_angle-=360;
        }
        else if (target_End_angle<0)
        {
            target_End_angle+=360;
        }
        
        _step_Angles=[[NSMutableArray alloc] init];
        for (circleCard *card in _array_Of_Cards)
        {
            CGFloat tempValue=card.start_angle;
            [_step_Angles addObject:[NSNumber numberWithFloat:tempValue]];
        }
        _array_Of_right_Cards=[[NSMutableArray alloc] init];
        _array_Of_Left_Cards=[[NSMutableArray alloc] init];
        
        if ((0-selectedIndex)<0)
        {
            for ( int j=0; j<selectedIndex; j++)
            {
                circleCard *tempRightCard=[_array_Of_Cards objectAtIndex:j];
                tempRightCard.isLeft=NO;
                circleCard *rightCard=[[circleCard alloc] init];
                rightCard.cardIndex=tempRightCard.cardIndex;
                rightCard.cardName=tempRightCard.cardName;
                rightCard.start_angle=tempRightCard.start_angle;
                rightCard.small_Raduis=tempRightCard.small_Raduis;
                rightCard.large_Raduis=tempRightCard.large_Raduis;
                rightCard.isLeft=tempRightCard.isLeft;
                rightCard.width_Angle=tempRightCard.width_Angle;
                [_array_Of_right_Cards addObject:rightCard];
            }
        }
        
        if (((_array_Of_Cards.count-1)-selectedIndex)>0)
        {
            for ( int j=(int)_array_Of_Cards.count-1; j>selectedIndex; j--)
            {
                circleCard *templeftCard=[_array_Of_Cards objectAtIndex:j];
                templeftCard.isLeft=YES;
                circleCard *leftCard=[[circleCard alloc] init];
                leftCard.cardIndex=templeftCard.cardIndex;
                leftCard.cardName=templeftCard.cardName;
                leftCard.start_angle=templeftCard.start_angle;
                leftCard.small_Raduis=templeftCard.small_Raduis;
                leftCard.large_Raduis=templeftCard.large_Raduis;
                leftCard.isLeft=templeftCard.isLeft;
                leftCard.width_Angle=templeftCard.width_Angle;
                [_array_Of_Left_Cards addObject:leftCard];
            }
            
        }
        isCollapsing=YES;
        
    }
}

//-(BOOL)checkSelectionOfIndexIndex:(int)checkedIndex
//{
//    for (NSNumber *index in _array_Of_Selected_Cards)
//    {
//        if ([index intValue]==checkedIndex)
//        {
//            return YES;
//        }
//    }
//    return NO;
//}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    if (!isRotating)
    {
        if (_AllowMultipleSelection)
        {
            [self sortCardsArray];
            float a  = [self getAngleFromPoint:touchLocation];
            circleCard *selectedCard=[self getCardByAngle:a];
            if (selectedCard)
            {
                CardData *selectedData=(CardData*)[_data_cards objectAtIndex:selectedCard.cardIndex];
                if (selectedData.isSelected)
                {
                    //                if ([self checkSelectionOfIndexIndex:(int)selectedCard.cardIndex])
                    //                {
                    //                    //No highlighted and Remove From Array
                    //
                    //                    NSMutableArray *deletedcards=[[NSMutableArray alloc] init];
                    //
                    //                    for (NSNumber *index  in _array_Of_Selected_Cards)
                    //                    {
                    //                        if ([index intValue]==(int)selectedCard.cardIndex)
                    //                        {
                    //                            [deletedcards addObject:index];
                    //                        }
                    //                    }
                    //
                    //                    if (deletedcards.count>0)
                    //                    {
                    //                        [_array_Of_Selected_Cards removeObjectsInArray:deletedcards];
                    //                    }
                    //                    [self.delegate cardDidUnSelectAtIndex:(int)selectedCard.cardIndex];
                    //
                    //                }
                    //                else
                    //                {
                    //                    //highlighted and Add to Array
                    //                    [_array_Of_Selected_Cards addObject:[NSNumber numberWithInt:(int)selectedCard.cardIndex]];
                    //                    [self.delegate cardDidSelectAtIndex:(int)selectedCard.cardIndex];
                    //
                    //                }
                    [self.delegate cardDidUnSelectAtIndex:(int)selectedCard.cardIndex];
                }
                else
                {
                    [self.delegate cardDidSelectAtIndex:(int)selectedCard.cardIndex];
                }
                selectedData.isSelected=!selectedData.isSelected;
                

            }
            
        }
        else
        {
            
            if ([self checkIsCollapsed])
            {
                if (targetCard)
                {
                    currentFrame=1;
                    isRotating=YES;
                    isCollapsing=YES;
                }
            }
            else
            {
                [self sortCardsArray];
                float a  = [self getAngleFromPoint:touchLocation];
                
                targetCard=[self getCardByAngle:a];
                
                if (targetCard)
                {
                    isRotating=YES;
                    currentFrame=1;
                    selectedIndex=(int)targetCard.cardIndex;
                    [self.delegate cardDidSelectAtIndex:selectedIndex];
                    targetCard=[_array_Of_Cards objectAtIndex:selectedIndex];
                    target_Angle=[((NSNumber*)[_array_Of_Starters objectAtIndex:targetCard.cardIndex]) floatValue];
                    
                    _step_Angles=[[NSMutableArray alloc] init];
                    
                    selectedSmallRaduis=targetCard.small_Raduis;
                    selectedLargeRaduis=targetCard.large_Raduis;
                    target_Start_angle=[((NSNumber*)[_array_Of_Starters objectAtIndex:targetCard.cardIndex]) floatValue];
                    target_End_angle=target_Start_angle+_width_Angle;
                    static_end_target_angle=target_End_angle;
                    target_shadow=0.2;
                    if (target_End_angle>360)
                    {
                        target_End_angle-=360;
                    }
                    else if (target_End_angle<0)
                    {
                        target_End_angle+=360;
                    }
                    
                    _step_Angles=[[NSMutableArray alloc] init];
                    for (circleCard *card in _array_Of_Cards)
                    {
                        CGFloat tempValue=card.start_angle;
                        [_step_Angles addObject:[NSNumber numberWithFloat:tempValue]];
                    }
                    _array_Of_right_Cards=[[NSMutableArray alloc] init];
                    _array_Of_Left_Cards=[[NSMutableArray alloc] init];
                    
                    if ((0-selectedIndex)<0)
                    {
                        for ( int j=0; j<selectedIndex; j++)
                        {
                            circleCard *tempRightCard=[_array_Of_Cards objectAtIndex:j];
                            tempRightCard.isLeft=NO;
                            circleCard *rightCard=[[circleCard alloc] init];
                            rightCard.cardIndex=tempRightCard.cardIndex;
                            rightCard.cardName=tempRightCard.cardName;
                            rightCard.start_angle=tempRightCard.start_angle;
                            rightCard.small_Raduis=tempRightCard.small_Raduis;
                            rightCard.large_Raduis=tempRightCard.large_Raduis;
                            rightCard.isLeft=tempRightCard.isLeft;
                            rightCard.width_Angle=tempRightCard.width_Angle;
                            [_array_Of_right_Cards addObject:rightCard];
                        }
                    }
                    
                    if (((_array_Of_Cards.count-1)-selectedIndex)>0)
                    {
                        for ( int j=(int)_array_Of_Cards.count-1; j>selectedIndex; j--)
                        {
                            circleCard *templeftCard=[_array_Of_Cards objectAtIndex:j];
                            templeftCard.isLeft=YES;
                            circleCard *leftCard=[[circleCard alloc] init];
                            leftCard.cardIndex=templeftCard.cardIndex;
                            leftCard.cardName=templeftCard.cardName;
                            leftCard.start_angle=templeftCard.start_angle;
                            leftCard.small_Raduis=templeftCard.small_Raduis;
                            leftCard.large_Raduis=templeftCard.large_Raduis;
                            leftCard.isLeft=templeftCard.isLeft;
                            leftCard.width_Angle=templeftCard.width_Angle;
                            [_array_Of_Left_Cards addObject:leftCard];
                        }
                        
                    }
                    isCollapsing=YES;
                    
                }
            }
        }
        
    }
}

-(circleCard*)getCardByAngle:(CGFloat)angle
{
    if (angle==-111111)
    {
        targetCard=nil;
        return nil;
    }
    else
    {
        for (circleCard *card in _array_Of_Cards)
        {
            CGFloat card_startAngle=[[_array_Of_Starters objectAtIndex:card.cardIndex] floatValue];
            CGFloat card_endAngle=card_startAngle+card.width_Angle;
            if (card_endAngle>360)
            {
                card_endAngle=card_endAngle-360;
            }
            if (card_startAngle>card_endAngle)
            {
                if (card_startAngle<=angle && angle>=0)
                {
                    return card;
                }else if (angle>=0&&angle<card_endAngle)
                {
                    return card;
                }
                else
                {
                    continue;
                }
            }
            else
            {
                if (card_startAngle<=angle && card_endAngle>=angle)
                {
                    return card;
                }
            }
           
        }
        targetCard=nil;
        return nil;
    }
    
}
-(void)selectCardAtIndex:(int)index andSelection:(BOOL)isSelected
{
    CardData *selectedData=(CardData*)[_data_cards objectAtIndex:index];
    selectedData.isSelected=isSelected;
    [_data_cards replaceObjectAtIndex:index withObject:selectedData];

}
-(void)drawSlice:(CGContextRef)context andRect:(CGRect)rect andCard:(circleCard*)card
{
    CGFloat start_angle2=[((NSNumber*)[_step_Angles objectAtIndex:card.cardIndex]) floatValue];
    if (targetCard)
    {
        if (card.cardIndex==targetCard.cardIndex)
        {
            start_angle2=start_angle2-2.0f;
        }
    }
    CGFloat start;
    if (start_angle2>360)
    {
        start_angle2-=360;
    }
    else if (start_angle2<0)
    {
        start_angle2+=360;
    }

    
    if (start_angle2==360)
    {
        start=[self convertFromAngleToRadian:0];
    }
    else
    {
        start=[self convertFromAngleToRadian:start_angle2];

    }
    CGFloat end_Angle=start_angle2+_width_Angle;
    
    if (targetCard)
    {
        if (card.cardIndex==targetCard.cardIndex)
        {
            end_Angle=end_Angle+2.5f;
        }
    }

    if (end_Angle>360)
    {
        end_Angle-=360;
    }
    else if (end_Angle<0)
    {
        end_Angle+=360;
    }
    if (end_Angle==360)
    {
        end_Angle=0;
    }

    CGFloat end_Angle3;

    CGPoint center=_CircleCenter;
    
    
    CGFloat start_angle3=start_angle2+8;
    CGFloat start_angle4=start_angle2+8;
    if(IS_IPAD)
    {
        end_Angle3=end_Angle-6;
        _cornerRaduis=13.0;
    }
    else
    {
        end_Angle3=end_Angle-8;
        _cornerRaduis=12.0;
    }


    CGFloat end_Angle2=end_Angle-5;
    
    if (start_angle3>360)
    {
        start_angle3-=360;
    }
    else if (start_angle3<0)
    {
        start_angle3+=360;
    }
    if (start_angle3==360)
    {
        start_angle3=0;
    }
    
    if (start_angle4>360)
    {
        start_angle4-=360;
    }
    else if (start_angle4<0)
    {
        start_angle4+=360;
    }
    if (start_angle4==360)
    {
        start_angle4=0;
    }

    if (end_Angle3>360)
    {
        end_Angle3-=360;
    }
    else if (end_Angle3<0)
    {
        end_Angle3+=360;
    }
    if (end_Angle3==360)
    {
        end_Angle3=0;
    }
    
    
    CGFloat end2=[self convertFromAngleToRadian:end_Angle2];

    CGFloat start3=[self convertFromAngleToRadian:start_angle3];
    CGFloat start4=[self convertFromAngleToRadian:start_angle4];

    CGFloat end3=[self convertFromAngleToRadian:(end_Angle3-5)];
    
    if (targetCard&&(isCollapsing||isCollapsed))
    {
        if ([card.cardName isEqualToString:targetCard.cardName])
        {
            CGContextSetFillColorWithColor(context, _selected_color.CGColor);

        }
        else
        {
            CGContextSetFillColorWithColor(context, _original_color.CGColor);

        }
    }
    else
    {
        CGContextSetFillColorWithColor(context, _original_color.CGColor);

    }
   
    
    //CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
   
    
    if (_AllowMultipleSelection)
    {
        if (((CardData*)[_data_cards objectAtIndex:card.cardIndex]).isSelected)
        {
            CGContextSetFillColorWithColor(context, _selected_color.CGColor);
        }
        else
        {
            CGContextSetFillColorWithColor(context, _original_color.CGColor);

        }
    }
    
    if (targetCard)
    {
        if (card.cardIndex==targetCard.cardIndex)
        {
            CGPoint p1=[self checkAngleQuarter:start_angle2 andRaduis:card.small_Raduis+(_cornerRaduis+bouzOffset) andCenter:center];
            CGContextMoveToPoint(context, p1.x, p1.y);
            CGPoint p2=[self getPointFromAngle:start_angle2 andCenter:center andRaduis:selectedLargeRaduis];
            CGPoint p3=[self getPointFromAngle:start_angle2 andCenter:center andRaduis:selectedLargeRaduis-(_cornerRaduis+bouzOffset)];
            CGPoint p4=[self getPointFromAngle:start_angle3 andCenter:center andRaduis:selectedLargeRaduis];
            
            CGContextAddLineToPoint(context, p3.x, p3.y);
            CGContextAddArcToPoint(context, p2.x, p2.y, p4.x, p4.y, (_cornerRaduis+bouzOffset));

            CGPoint p6=[self getPointFromAngle:end_Angle andCenter:center andRaduis:selectedLargeRaduis];
            CGPoint p7=[self getPointFromAngle:end_Angle andCenter:center andRaduis:selectedLargeRaduis-(_cornerRaduis+bouzOffset)];
            CGContextAddArc(context,center.x, center.y, selectedLargeRaduis, start3, end2,0);

            CGContextAddArcToPoint(context, p6.x, p6.y, p7.x, p7.y,(_cornerRaduis+bouzOffset));

            CGPoint p5=[self getPointFromAngle:end_Angle andCenter:center andRaduis:selectedSmallRaduis+(_cornerRaduis+bouzOffset)];
            
            CGPoint p8=[self getPointFromAngle:end_Angle andCenter:center andRaduis:selectedSmallRaduis];
            CGPoint p9=[self getPointFromAngle:end_Angle3 andCenter:center andRaduis:selectedSmallRaduis];
            CGPoint p10=[self getPointFromAngle:start_angle2 andCenter:center andRaduis:selectedSmallRaduis];
            
            CGContextAddLineToPoint(context, p5.x, p5.y);
            CGContextAddArcToPoint(context, p8.x, p8.y, p9.x, p9.y, (_cornerRaduis+bouzOffset));

            CGContextAddArc(context,center.x, center.y,selectedSmallRaduis, end3, start4,1);
            CGContextAddArcToPoint(context, p10.x, p10.y, p1.x, p1.y, (_cornerRaduis+bouzOffset));
            CGContextClosePath(context);
            
            
//            CGPoint p1=[self checkAngleQuarter:start_angle2 andRaduis:card.small_Raduis+_cornerRaduis andCenter:center];
//            CGContextMoveToPoint(context, p1.x, p1.y);
//            CGPoint p2=[self getPointFromAngle:start_angle2 andCenter:center andRaduis:_large_Raduis];
//            CGPoint p3=[self getPointFromAngle:start_angle2 andCenter:center andRaduis:_large_Raduis-_cornerRaduis];
//            CGPoint p4=[self getPointFromAngle:start_angle3 andCenter:center andRaduis:_large_Raduis];
//            
//            CGContextAddLineToPoint(context, p3.x, p3.y);
//            CGContextAddArcToPoint(context, p2.x, p2.y, p4.x, p4.y, _cornerRaduis);
//            
//            CGPoint p6=[self getPointFromAngle:end_Angle andCenter:center andRaduis:_large_Raduis];
//            CGPoint p7=[self getPointFromAngle:end_Angle andCenter:center andRaduis:_large_Raduis-_cornerRaduis];
//            CGContextAddArc(context,center.x, center.y, card.large_Raduis, start3, end2,0);
//            
//            CGContextAddArcToPoint(context, p6.x, p6.y, p7.x, p7.y,_cornerRaduis);
//            
//            CGPoint p5=[self getPointFromAngle:end_Angle andCenter:center andRaduis:_small_Raduis+_cornerRaduis];
//            CGPoint p8=[self getPointFromAngle:end_Angle andCenter:center andRaduis:_small_Raduis];
//            CGPoint p9=[self getPointFromAngle:end_Angle3 andCenter:center andRaduis:_small_Raduis];
//            CGPoint p10=[self getPointFromAngle:start_angle2 andCenter:center andRaduis:_small_Raduis];
//            
//            CGContextAddLineToPoint(context, p5.x, p5.y);
//            CGContextAddArcToPoint(context, p8.x, p8.y, p9.x, p9.y, _cornerRaduis);
//            
//            CGContextAddArc(context,center.x, center.y,_small_Raduis, end3, start4,1);
//            CGContextAddArcToPoint(context, p10.x, p10.y, p1.x, p1.y, _cornerRaduis);
//            CGContextClosePath(context);


        }
        else
        {
            CGPoint p1=[self checkAngleQuarter:start_angle2 andRaduis:card.small_Raduis+_cornerRaduis andCenter:center];
            CGContextMoveToPoint(context, p1.x, p1.y);
            CGPoint p2=[self getPointFromAngle:start_angle2 andCenter:center andRaduis:_large_Raduis];
            CGPoint p3=[self getPointFromAngle:start_angle2 andCenter:center andRaduis:_large_Raduis-_cornerRaduis];
            CGPoint p4=[self getPointFromAngle:start_angle3 andCenter:center andRaduis:_large_Raduis];
            
            CGContextAddLineToPoint(context, p3.x, p3.y);
            CGContextAddArcToPoint(context, p2.x, p2.y, p4.x, p4.y, _cornerRaduis);

            CGPoint p6=[self getPointFromAngle:end_Angle andCenter:center andRaduis:_large_Raduis];
            CGPoint p7=[self getPointFromAngle:end_Angle andCenter:center andRaduis:_large_Raduis-_cornerRaduis];
            CGContextAddArc(context,center.x, center.y, card.large_Raduis, start3, end2,0);

            CGContextAddArcToPoint(context, p6.x, p6.y, p7.x, p7.y,_cornerRaduis);

            CGPoint p5=[self getPointFromAngle:end_Angle andCenter:center andRaduis:_small_Raduis+_cornerRaduis];
            CGPoint p8=[self getPointFromAngle:end_Angle andCenter:center andRaduis:_small_Raduis];
            CGPoint p9=[self getPointFromAngle:end_Angle3 andCenter:center andRaduis:_small_Raduis];
            CGPoint p10=[self getPointFromAngle:start_angle2 andCenter:center andRaduis:_small_Raduis];
            
            CGContextAddLineToPoint(context, p5.x, p5.y);
            CGContextAddArcToPoint(context, p8.x, p8.y, p9.x, p9.y, _cornerRaduis);
            
            CGContextAddArc(context,center.x, center.y,_small_Raduis, end3, start4,1);
            CGContextAddArcToPoint(context, p10.x, p10.y, p1.x, p1.y, _cornerRaduis);
            CGContextClosePath(context);

        }
    }
    else
    {
        CGPoint p1=[self checkAngleQuarter:start_angle2 andRaduis:card.small_Raduis+_cornerRaduis andCenter:center];
        CGContextMoveToPoint(context, p1.x, p1.y);
        CGPoint p2=[self getPointFromAngle:start_angle2 andCenter:center andRaduis:_large_Raduis];
        CGPoint p3=[self getPointFromAngle:start_angle2 andCenter:center andRaduis:_large_Raduis-_cornerRaduis];
        CGPoint p4=[self getPointFromAngle:start_angle3 andCenter:center andRaduis:_large_Raduis];
        
        CGContextAddLineToPoint(context, p3.x, p3.y);
        CGContextAddArcToPoint(context, p2.x, p2.y, p4.x, p4.y, _cornerRaduis);

        CGPoint p6=[self getPointFromAngle:end_Angle andCenter:center andRaduis:_large_Raduis];
        CGPoint p7=[self getPointFromAngle:end_Angle andCenter:center andRaduis:_large_Raduis-_cornerRaduis];
        CGContextAddArc(context,center.x, center.y, card.large_Raduis, start3, end2,0);

        CGContextAddArcToPoint(context, p6.x, p6.y, p7.x, p7.y,_cornerRaduis);

        CGPoint p5=[self getPointFromAngle:end_Angle andCenter:center andRaduis:_small_Raduis+_cornerRaduis];
        CGPoint p8=[self getPointFromAngle:end_Angle andCenter:center andRaduis:_small_Raduis];
        CGPoint p9=[self getPointFromAngle:end_Angle3 andCenter:center andRaduis:_small_Raduis];
        CGPoint p10=[self getPointFromAngle:start_angle2 andCenter:center andRaduis:_small_Raduis];
        
        CGContextAddLineToPoint(context, p5.x, p5.y);
        CGContextAddArcToPoint(context, p8.x, p8.y, p9.x, p9.y, _cornerRaduis);
        
        CGContextAddArc(context,center.x, center.y,_small_Raduis, end3, start4,1);
        CGContextAddArcToPoint(context, p10.x, p10.y, p1.x, p1.y, _cornerRaduis);
        CGContextClosePath(context);
    }
//    if (targetCard)
//    {
//        if (card.cardIndex==targetCard.cardIndex)
//        {
//            CGContextSetShadowWithColor(context, CGSizeMake(target_shadow,target_shadow), 10.0, [UIColor colorWithRed:(0.0f/255.0f) green:(0.0f/255.0f) blue:(0.0f/255.0f) alpha:0.2].CGColor);
//                CGContextSetBlendMode (context, kCGBlendModeNormal);
//            
//            
//        }
//        else
//        {
//            CGContextSetShadowWithColor(context, CGSizeMake(1.0,1.0), 1.0, [UIColor colorWithRed:(0.0f/255.0f) green:(0.0f/255.0f) blue:(0.0f/255.0f) alpha:0.5].CGColor);
//            CGContextSetBlendMode (context, kCGBlendModeNormal);
//        }
//    }
//    else
//    {
//        CGContextSetShadowWithColor(context, CGSizeMake(1.0,1.0), 1.0, [UIColor colorWithRed:(0.0f/255.0f) green:(0.0f/255.0f) blue:(0.0f/255.0f) alpha:0.5].CGColor);
//        CGContextSetBlendMode (context, kCGBlendModeNormal);
//    }
    
    CGContextDrawPath(context, kCGPathFill);
    CGContextSetTextMatrix(context, CGAffineTransformMake(1, 0, 0, -1, 0, 0));
    CGContextSetTextDrawingMode(context, kCGTextFill);
    NSString *data=[((CardData*)[_data_cards objectAtIndex:(int)card.cardIndex]) cardName];
    
  //  float r = _large_Raduis - 36;
    
//    float tx = center.x + sinf( M_PI/2 + start +[self convertFromAngleToRadian:_width_Angle]/2.0f) * r - 40;
//    float ty = center.y + cosf( M_PI/2 + start + [self convertFromAngleToRadian:_width_Angle]/2.0f) * -r-20;
//    
//    float ty2 = center.y + cosf( M_PI/2 + start + [self convertFromAngleToRadian:_width_Angle]/2.0f) * -r+10;
    
    CGFloat centerAngleImage=(start_angle2+(_width_Angle/2.0f));
    
    if (centerAngleImage>360)
    {
        centerAngleImage-=360;
    }
    else if (centerAngleImage<0)
    {
        centerAngleImage+=360;
    }
    if (centerAngleImage==360)
    {
        centerAngleImage=0;
    }

    
    
    CGFloat centerImageDictsance=(_small_Raduis)+((_large_Raduis-_small_Raduis)/2.0f);
   
    CGPoint CenterPOsition=[self getPointFromAngle:centerAngleImage andCenter:_CircleCenter andRaduis:(centerImageDictsance)];
    CGPoint ImagePosition=CGPointMake(CenterPOsition.x, CenterPOsition.y-((_large_Raduis-_small_Raduis)/5.4));
    CGPoint lblPOsition=CGPointMake(CenterPOsition.x, CenterPOsition.y+((_large_Raduis-_small_Raduis)/4.2f));
    CGPoint lblPOsitionWithOutImag=CenterPOsition;


    
//
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode =NSLineBreakByWordWrapping;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    CGFloat fontSize=13.0f;
    if (IS_IPAD)
    {
        fontSize=18.0;
    }

    NSDictionary *dictionary;
              dictionary = @{ NSFontAttributeName: [UIFont fontWithName:@"Arial" size:fontSize],
                            NSParagraphStyleAttributeName: paragraphStyle,
                            NSForegroundColorAttributeName: [UIColor whiteColor]};
        
  // CGSize lblSize=[data sizeWithAttributes:dictionary];
    

   // [data drawAtPoint:CGPointMake((lblPOsition.x-(lblSize.width/2.0f)), (lblPOsition.y-(lblSize.height/2.0f))) withAttributes:dictionary];
    
    UIImage *pen=[((CardData*)[_data_cards objectAtIndex:(int)card.cardIndex]) cardImage];
    if (IS_IPAD) {
        [pen drawInRect:CGRectMake((ImagePosition.x-(80.0f/2.0f)), (ImagePosition.y-(80.0f/2.0f)), 80, 80)];
    }
    else
    {
        [pen drawInRect:CGRectMake((ImagePosition.x-(60.0f/2.0f)), (ImagePosition.y-(60.0f/2.0f)), 60, 60)];

    }

    if (IS_IPAD)
    {
        if (pen)
        {
            [data drawInRect:CGRectMake((lblPOsition.x-(115.0f/2.0f)), (lblPOsition.y-(30.0f/2.0f)), 115.0f, 150) withAttributes:dictionary];
            
        }
        else
        {
            [data drawInRect:CGRectMake((lblPOsitionWithOutImag.x-(115.0f/2.0f)), (lblPOsitionWithOutImag.y-(30.0f/2.0f)), 115.0f, 150) withAttributes:dictionary];
            
        }

    }
    else
    {
        if (pen)
        {
            [data drawInRect:CGRectMake((lblPOsition.x-(90.0f/2.0f)), (lblPOsition.y-(30.0f/2.0f)), 90, 150) withAttributes:dictionary];
            
        }
        else
        {
            [data drawInRect:CGRectMake((lblPOsitionWithOutImag.x-(90.0f/2.0f)), (lblPOsitionWithOutImag.y-(30.0f/2.0f)), 90, 150) withAttributes:dictionary];
            
        }

    }
   
        //  [self drawStringAtContext:context string:@"Khaleeed" atAngle:start_angle2 withRadius:(_large_Raduis-_small_Raduis)/2 andFont:[UIFont fontWithName:@"Arial" size:12.0]];}}

}

-(void)reloadDataWithAnimation:(BOOL)isAnimated
{
   // _array_Of_Selected_Cards=[[NSMutableArray alloc] init];
    selectedLargeRaduis=_large_Raduis;
    selectedSmallRaduis=_small_Raduis;
    targetCard=nil;
    _no_Of_Cards=[self.delegate noOfCardOfCircleTableView];
    
    _data_cards=[[NSMutableArray alloc] init];
    
    for (int i=0; i<_no_Of_Cards; i++)
    {
        [_data_cards addObject:[self.delegate cardForRowAtIndex:i]];
    }
    _width_Angle=((360-_remaining_distance)-(_offSet_Angle*(_no_Of_Cards-1)))/_no_Of_Cards;
    _array_Of_Cards=[[NSMutableArray alloc] init];
    CGFloat rotating_Angle=_start_Angle;
    for ( int i=0; i<_no_Of_Cards; i++)
    {
        if (rotating_Angle>360)
        {
            rotating_Angle=rotating_Angle-360;
        }
        if (rotating_Angle==360)
        {
            rotating_Angle=0;
        }
        circleCard *card1=[[circleCard alloc] initWithStartAngle:rotating_Angle andWidth:_width_Angle andLargeRaduis:_large_Raduis andSmallRaduis:_small_Raduis andCardName:[NSString stringWithFormat:@"card %d",i] andCardIndex:i];
        rotating_Angle=rotating_Angle+card1.width_Angle+_offSet_Angle;
        [_array_Of_Cards addObject:card1];
        
    }
    _array_Of_Starters=[[NSMutableArray alloc] init];
    for (circleCard *card in _array_Of_Cards)
    {
        CGFloat tempValue=card.start_angle;
        [_array_Of_Starters addObject:[NSNumber numberWithFloat:tempValue]];
    }
    
    _step_Angles=[[NSMutableArray alloc] init];
    for (circleCard *card in _array_Of_Cards)
    {
        CGFloat tempValue=card.start_angle;
        [_step_Angles addObject:[NSNumber numberWithFloat:tempValue]];
    }
    if (isAnimated)
    {
        _allowReloadWithAnimation=YES;
        _CircleCenter=[self.delegate centerOfCircleTableView];
       
        [self collaps];
    }
    else
    {
        isReloadingWithoutanimation=YES;
        _allowReloadWithAnimation=NO;
        [self expanCards];
        _CircleCenter=[self.delegate centerOfCircleTableView];
        
    }
   // isCollapsed=NO;
}
- (NSMutableAttributedString *) getStringWithString:(NSString*)aliceString
{
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:aliceString];
    NSRange fullRange = NSMakeRange(0, string.length);
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Futura" size:14.0f] range:fullRange];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    [string addAttribute:NSParagraphStyleAttributeName value:style range:fullRange];
    return string;
}


-(int)checkStartAngleLeft:(CGFloat)startAngle
{
    for (circleCard *card in _array_Of_Left_Cards)
    {
        if (card.start_angle ==startAngle)
        {
            return 1;
        }
    }
    
    for (circleCard *card in _array_Of_right_Cards)
    {
        if (card.start_angle ==startAngle)
        {
            return 2;
        }
    }
    
    
    return 3;
    
}

-(CGPoint)getPointFromAngle:(CGFloat)seta andCenter:(CGPoint)center andRaduis:(CGFloat)raduis
{
    if ((seta>=0 &&seta<90))
    {
        CGFloat newAngle=seta;
        int y=(sin([self convertFromAngleToRadian:newAngle])*raduis);
        int x=(sin([self convertFromAngleToRadian:90-newAngle])*raduis);
        return CGPointMake(center.x+x, center.y+y);
    }
    else if ((seta>=90 &&seta<180))
    {
        CGFloat newAngle=90-(180-seta);
        int x=(sin([self convertFromAngleToRadian:newAngle])*raduis);
        int y=(sin([self convertFromAngleToRadian:90-newAngle])*raduis);
        
        return CGPointMake(center.x-x, center.y+y);
    }
    else if ((seta>=180 &&seta<270))
    {
        CGFloat newAngle=seta-180;
        int y=(sin([self convertFromAngleToRadian:newAngle])*raduis);
        int x=(sin([self convertFromAngleToRadian:90-newAngle])*raduis);
        
        return CGPointMake(center.x-x, center.y-y);
    }
    else if ((seta>=270 &&seta<360))
    {
        CGFloat newAngle=360-seta;
        int y=(sin([self convertFromAngleToRadian:newAngle])*raduis);
        int x=(sin([self convertFromAngleToRadian:90-newAngle])*raduis);
        
        return CGPointMake(center.x+x, center.y-y);
    }
    else
    {
        return CGPointZero;
    }
}

-(void)startanimation:(CGMutablePathRef)path
{
    
    CAShapeLayer *pathShape = [CAShapeLayer layer];
    pathShape.path=path;
    pathShape.lineWidth=3.0;
    pathShape.lineJoin=kCALineJoinBevel;
    pathShape.fillColor=nil;
    pathShape.strokeColor=[UIColor brownColor].CGColor;
    pathShape.lineJoin=kCALineJoinRound;
    pathShape.lineCap=kCALineCapRound;
    
    [self.layer addSublayer:pathShape];
    
    
    CABasicAnimation *animateStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animateStrokeEnd.duration  = 2.0;
    animateStrokeEnd.fromValue = [NSNumber numberWithFloat:0.0f];
    animateStrokeEnd.toValue   = [NSNumber numberWithFloat:1.0f];
    [pathShape addAnimation:animateStrokeEnd forKey:@"strokeEndAnimation"];
}
-(CGPoint)checkAngleQuarter:(CGFloat)angle andRaduis:(int)raduis andCenter:(CGPoint)center
{
    if ((angle>=0 &&angle<90))
    {
       CGFloat newAngle=angle;
       int y=(sin([self convertFromAngleToRadian:newAngle])*raduis);
       int x=(sin([self convertFromAngleToRadian:90-newAngle])*raduis);
        return CGPointMake(center.x+x, center.y+y);
    }
    else if ((angle>=90 &&angle<180))
    {
        CGFloat newAngle=90-(180-angle);
        int x=(sin([self convertFromAngleToRadian:newAngle])*raduis);
        int y=(sin([self convertFromAngleToRadian:90-newAngle])*raduis);

        return CGPointMake(center.x-x, center.y+y);
    }
    else if ((angle>=180 &&angle<270))
    {
        CGFloat newAngle=angle-180;
        int y=(sin([self convertFromAngleToRadian:newAngle])*raduis);
        int x=(sin([self convertFromAngleToRadian:90-newAngle])*raduis);

        return CGPointMake(center.x-x, center.y-y);
    }
    else if ((angle>=270 &&angle<360))
    {
        CGFloat newAngle=360-angle;
        int y=(sin([self convertFromAngleToRadian:newAngle])*raduis);
        int x=(sin([self convertFromAngleToRadian:90-newAngle])*raduis);

        return CGPointMake(center.x+x, center.y-y);
    }
    else
    {
        return CGPointZero;
    }
}

-(int)getAngleQuarter:(CGFloat)angle
{
    if ((angle>=0 &&angle<90))
    {
        return 1;
    }
    else if ((angle>=90 &&angle<180))
    {
        return 2;
    }
    else if ((angle>=180 &&angle<270))
    {
        return 3;
    }
    else if ((angle>=270 &&angle<360))
    {
        return 4;
    }
    else
    {
        return 1;
    }
}


-(CGFloat)convertFromAngleToRadian:(CGFloat)angle
{
    
   return (angle*M_PI)/180.0f;
}

-(CGFloat)convertFromRadianToAngle:(CGFloat)angle
{
    
    return (angle*180.0f)/M_PI;
}


float easeInOutBack(float t, float b, float c, float d) {
    // t: current time, b: begInnIng value, c: change In value, d: duration
    float s = 2.234;
    if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
    return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
}

float easeOutBounce(float t, float b, float c, float d) {
    if ((t/=d) < (1/2.75)) {
        return c*(7.5625*t*t) + b;
    } else if (t < (2/2.75)) {
        return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
    } else if (t < (2.5/2.75)) {
        return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
    } else {
        return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
    }
}

float Easing (float t , float b , float c ,float d)
{
    t /= d/2;
    if (t < 1) return c/2*t*t + b;
    t--;
    return -c/2 * (t*(t-2) - 1) + b;}
float Linear (float t ,float b , float c ,float d)
{
   return c*t/d + b;
}

- (CGFloat) getAngleFromPoint: (CGPoint) point
{
    CGPoint center=_CircleCenter;
    CGFloat xSide=point.x-center.x;
    CGFloat ySide=point.y-center.y;
    CGFloat raduis=sqrt((xSide*xSide)+(ySide*ySide));
    CGFloat SinAngle=abs(ySide)/raduis;
    CGFloat Angle=asin(SinAngle);
    if (raduis>self.large_Raduis||raduis<self.small_Raduis)
    {
        return -111111;
    }

    Angle=[self convertFromRadianToAngle:Angle];
    if (xSide>0&&ySide>0)
    {
        Angle=Angle;
    }
   else if (xSide>0&&ySide<0)
    {
        Angle=360-Angle;
    }
    else if (xSide<0&&ySide<0)
    {
        Angle=270-(90-Angle);
    }
    else if (xSide<0&&ySide>0)
    {
        Angle=180-Angle;
    }

    return Angle;

  //  return  atan2(ySide, xSide);

}

@end
