//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Piotr Płaneta on 22.07.2012.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *userInput;
@property (weak, nonatomic) IBOutlet UILabel *variablesDisplay;
@property (nonatomic) NSDictionary *testVariableValues;

@end
