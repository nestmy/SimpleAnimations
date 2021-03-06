//
//  SecondViewController.m
//  SimpleAnimation
//
//  Created by Michael Patrick Ellard on 5/28/12.
//  Copyright (c) 2012 Michael Patrick Ellard. All rights reserved.
//
//  This work is licensed under the Creative Commons Attribution 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/ or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

#import "SecondViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CAAnimation.h>

@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize starImage;

static float speedSetting = 1.0;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Star", @"Star");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Let's set up the layer's shadow options.  This will help us twinkle when it's time.
    
    self.starImage.layer.shadowOffset = CGSizeMake(0,0);
    self.starImage.layer.shadowColor = [[UIColor orangeColor] CGColor];
    self.starImage.layer.shadowRadius = 30;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}




#pragma mark Move Star

// Like most of the routines here, this is broken up into two parts:  a routine that does the actual view manipulation, and a second routines that includes the changes to the view in an animation block.  In this case, moveStar does the work of moving the star, moveStarAnimated: calls moveStar from within an animation block.  

-(void)moveStar
{
    CGPoint currentCenter = self.starImage.center;
    
    CGPoint destination;
    
    if (currentCenter.x == 150)
    {
        destination = CGPointMake(500, 500);
    }
    else 
    {
        destination = CGPointMake(150, 250);
    }
    
    self.starImage.center = destination;
}



-(IBAction)moveStarAnimated:(id)sender
{
    [UIView animateWithDuration:5.0*speedSetting animations:^
     {
         [self moveStar];
     }];
}


#pragma mark Zoom Star

-(void)zoomStar
{
    CGRect starBounds = self.starImage.bounds;
    
    CGSize newSize;
    
    if (starBounds.size.width == 250)
    {
        newSize = CGSizeMake(1000, 1000);
    }
    else 
    {
        newSize = CGSizeMake(250, 250);
    }
    
    starBounds.size = newSize;
    
    self.starImage.bounds = starBounds;
}



-(IBAction)zoomStarAnimated:(id)sender
{
    [UIView animateWithDuration:3.5*speedSetting animations:^
     {
         [self zoomStar];
     }];
}



#pragma mark - Twinkle Routines

// This routine involves some more complex code.  We're not just altering view properties here, we're actually manipulating the properties of its underlying layer.  

-(void)changeShadow
{
    CGFloat targetOpacity = !self.starImage.layer.shadowOpacity;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:self.starImage.layer.shadowOpacity];
    anim.toValue = [NSNumber numberWithFloat:targetOpacity];
    anim.duration = 1.0 * speedSetting;
    [self.starImage.layer addAnimation:anim forKey:@"shadowOpacity"];
    
    self.starImage.layer.shadowOpacity = targetOpacity;
}

// We could do all of these calls in blocks, but we'll use peformSelector:withObject:afterDelay: to show a different way to do delayed code execution.  

-(IBAction)changeShadowAnimated:(id)sender
{
    [self changeShadow];
    
    [self performSelector:@selector(changeShadow) withObject:nil afterDelay:1.1 * speedSetting];
    
    [self performSelector:@selector(changeShadow) withObject:nil afterDelay:2.2 * speedSetting];
    
    [self performSelector:@selector(changeShadow) withObject:nil afterDelay:3.3 * speedSetting];
    
    [self performSelector:@selector(changeShadow) withObject:nil afterDelay:4.4 * speedSetting];
    
    [self performSelector:@selector(changeShadow) withObject:nil afterDelay:5.5 * speedSetting];
}

#pragma mark Spin

// For reasons that will become clear in the Problem Animations code, we need to do our star rotation as a series of quarter rotations.  Thus, our code looks like the following.  

-(void)spinStar
{
    self.starImage.transform = CGAffineTransformRotate(self.starImage.transform, .5 * M_PI);
}

-(IBAction)spinStarAnimated:(id)sender
{
    static int animationCounter = 0;
    
    [UIView animateWithDuration:1.0 * speedSetting
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^
    {
        [self spinStar];
    }
    completion:^(BOOL finished)
    {
        animationCounter ++;
        
        animationCounter == 8 ? animationCounter = 0 : [self spinStarAnimated:nil];
    }];
}

@end
