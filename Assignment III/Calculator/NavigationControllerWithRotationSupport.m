//
//  NavigationControllerWithRotationSupport.m
//  Calculator
//
//  Created by Piotr Płaneta on 23.09.2012.
//
//

#import "NavigationControllerWithRotationSupport.h"
#import "CalculatorGraphViewController.h"

@interface NavigationControllerWithRotationSupport ()

@end

@implementation NavigationControllerWithRotationSupport

- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
    
}

- (NSInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
