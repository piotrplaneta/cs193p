//
//  CalculatorGraphViewController.h
//  Calculator
//
//  Created by Piotr Płaneta on 16.09.2012.
//
//

#import <UIKit/UIKit.h>

@interface CalculatorGraphViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *programDescription;
@property (nonatomic, strong) id program;

@end
