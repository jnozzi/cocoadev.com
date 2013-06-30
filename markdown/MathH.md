This page is to talk about the math library you have access to in Cocoa. Xcode will allow you to use the functions declared in     math.h while in General/ZeroLink mode, but sometimes the runtime will complain about a function for no obvious reason (if someone knows why this is please post here).

Most of your basic trig functions are part of this library (e.g. sin, cos, tan, asin, acos, atan.....). Many floating point number manipulation functions also make up a large percentage of this library. 

Some of the more useful functions for graphics manipulation are:

    
// fdim(x, y) returns the positive difference beween x and y.
// if x > y the value returned is x - y, but if y > x the value returned is zero
double fdim(double, double);����� 
float fdimf(float, float);

// fmax(x, y) returns the greater of the two values
double fmax(double, double);����� 
float fmaxf(float, float);

// fmin(x, y) returns the lesser of the two values
double fmin(double, double);����� 
float fminf(float, float);

// fabs(x) returns the absolute value of x 
double fabs(double);������������������� 
float fabsf(float);

// sqrt(x) returns the square root of x
double sqrt(double);������������������� 
float sqrtf(float);

// cbrt(x) returns the cube root of x
double cbrt(double);������������������� 
float cbrtf(float);

// hypot(x, y) returns the hypotenuse of a right triangle with sides x and y
// hypot(x, y) = sqrt(x * x + y * y)
double hypot(double, double);����������
float hypotf(float, float);

// pow(x, y) returns x raised to the y power
double pow(double, double);������������ 
float powf(float, float);

// ceil(1.5) = 2.0
double ceil(double); 
float ceilf(float);         

// floor(1.5) = 1.0 �������� floor(-1.5) = -2.0
double floor(double);
float floorf(float);     

// trunc(1.5) = 1.0��������� trunc(-1.5) = -1.0
double trunc(double); 
float truncf(float);    



The main reason I decided to write this simple intro into the basic math operators is because there are a couple that seem like they might be useful, but I haven't figured out where they would be needed.

    frexp() is the main function that has my attention. This function must have a use in some discipline, but I can't think of a need for this operation off of the top of my head.     frexp() is used to normalize a floating point representation of a real number "value" into a result that is the fraction of the closest power of two greater than the real number "value" being observed.     value = fraction * 2 ^ n. 

So where does this relationship become useful? Signal processing? Data compression? anyone?