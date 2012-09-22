//
//  CalculatorGraphViewController.h
//  Calculator
//
//  Created by Piotr Płaneta on 16.09.2012.
//
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

@interface CalculatorGraphViewController : UIViewController <UISplitViewControllerDelegate, SplitViewBarButtonItemPresenter>

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UILabel *programDescription;
@property (nonatomic, strong) id program;

@end
