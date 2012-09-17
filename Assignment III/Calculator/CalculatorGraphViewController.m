//
//  CalculatorGraphViewController.m
//  Calculator
//
//  Created by Piotr Płaneta on 16.09.2012.
//
//

#import "CalculatorGraphViewController.h"
#import "CalculatorBrain.h"
#import "GraphView.h"

@interface CalculatorGraphViewController () <GraphViewDataSource>
@property (nonatomic, weak) IBOutlet GraphView *graphView;
@end

@implementation CalculatorGraphViewController

@synthesize programDescription = _programDescription;
@synthesize program = _program;
@synthesize graphView = _graphView;

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    self.graphView.dataSource = self;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tap:)];
    [recognizer setNumberOfTapsRequired:3];
    [self.graphView addGestureRecognizer:recognizer];
}

- (void)setProgram:(id)program
{
    _program = program;
    [self setProgramDescription];
}

- (float)resultOfProgramForXValue:(float)x forGraphView:(GraphView *)sender
{
    return [CalculatorBrain runProgram:self.program usingVariableValues:[[NSDictionary alloc] initWithObjectsAndKeys:[[NSNumber alloc] initWithFloat:x], @"x", nil]];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    CGRect labelFrame = self.programDescription.frame;
    labelFrame.origin.x = self.graphView.frame.size.width - 300;
    labelFrame.origin.y = self.graphView.frame.size.height - 41;
    self.programDescription.frame = labelFrame;
    return YES;
}

- (void) awakeFromNib
{
    [self setProgramDescription];
}

- (void) viewDidLoad
{
    [self setProgramDescription];
}

- (void) setProgramDescription
{
    self.programDescription.text = [CalculatorBrain descriptionOfProgram:self.program];
}

- (void)viewDidUnload {
    [self setProgramDescription:nil];
    [self setProgram:nil];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs synchronize];

    [super viewDidUnload];
}


@end
