To make your class always return a single instance of itself, use this init routine.

See also General/SingletonDesignPattern, General/SingletonAlternatives, 
    


SINGLETON CLASSES

- (id) init {
    static General/YourClass *sharedInstance = nil;

    if (sharedInstance) {
        [self autorelease];
        self = [sharedInstance retain];
    } else {
        self = [super init];
        if (self) {
            sharedInstance = [self retain];

            // initialize
        }
    }

    return self;
}
 